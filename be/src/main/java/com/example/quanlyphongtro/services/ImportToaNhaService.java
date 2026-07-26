package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ImportToaNhaRequest;
import com.example.quanlyphongtro.dto.ImportToaNhaResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ImportToaNhaService {
    private final JdbcTemplate jdbcTemplate;
    private final PermissionService permissionService;

    public ImportToaNhaResponse preview(ImportToaNhaRequest request) {
        return validateAndMaybeImport(request, false);
    }

    @Transactional
    public ImportToaNhaResponse confirm(ImportToaNhaRequest request) {
        return validateAndMaybeImport(request, true);
    }

    private ImportToaNhaResponse validateAndMaybeImport(ImportToaNhaRequest request, boolean commit) {
        UUID ownerId = permissionService.requireCurrentUserId();
        List<ImportToaNhaRequest.Row> inputRows = request != null && request.getRows() != null ? request.getRows() : List.of();
        List<ImportToaNhaResponse.RowResult> results = new ArrayList<>();
        int valid = 0;
        int buildingsCreated = 0;
        int floorsCreated = 0;
        int roomsCreated = 0;

        for (int i = 0; i < inputRows.size(); i++) {
            ImportToaNhaRequest.Row row = inputRows.get(i);
            String error = validate(row);
            if (error != null) {
                results.add(result(i + 1, row, false, error, "SKIP"));
                continue;
            }

            valid++;
            if (!commit) {
                results.add(result(i + 1, row, true, null, "PREVIEW"));
                continue;
            }

            BuildingLookup building = findOrCreateBuilding(ownerId, row.getTenToaNha().trim(), row.getDiaChi().trim());
            UUID nhaTroId = building.id();
            if (building.created()) {
                buildingsCreated++;
            }

            FloorLookup floor = findOrCreateFloor(nhaTroId, row.getTang());
            UUID tangId = floor.id();
            if (floor.created()) {
                floorsCreated++;
            }
            int inserted = jdbcTemplate.update("""
                    INSERT INTO public.phong (
                        nha_tro_id, tang_id, ten, tang, dien_tich, so_nguoi_toi_da,
                        trang_thai, gia_hien_tai, tien_coc_mac_dinh
                    )
                    VALUES (?::uuid, ?::uuid, ?, ?, ?, ?, 'AVAILABLE'::public.trang_thai_phong, ?, ?)
                    ON CONFLICT (nha_tro_id, ten) DO NOTHING
                    """,
                    nhaTroId,
                    tangId,
                    row.getMaPhong().trim(),
                    row.getTang(),
                    row.getDienTich(),
                    row.getSoNguoiToiDa() != null ? row.getSoNguoiToiDa() : 2,
                    row.getGiaThue(),
                    row.getTienCoc() != null ? row.getTienCoc() : BigDecimal.ZERO);
            roomsCreated += inserted;
            results.add(result(i + 1, row, true, null, inserted > 0 ? "CREATED" : "DUPLICATE_ROOM_SKIPPED"));
        }

        return ImportToaNhaResponse.builder()
                .tongDong(inputRows.size())
                .dongHopLe(valid)
                .dongLoi(inputRows.size() - valid)
                .toaNhaTaoMoi(buildingsCreated)
                .tangTaoMoi(floorsCreated)
                .phongTaoMoi(roomsCreated)
                .rows(results)
                .build();
    }

    private String validate(ImportToaNhaRequest.Row row) {
        if (row == null) return "Dong trong";
        if (row.getTenToaNha() == null || row.getTenToaNha().isBlank()) return "Thieu ten toa nha";
        if (row.getDiaChi() == null || row.getDiaChi().isBlank()) return "Thieu dia chi";
        if (row.getTang() == null || row.getTang() < 0) return "Tang khong hop le";
        if (row.getMaPhong() == null || row.getMaPhong().isBlank()) return "Thieu ma phong";
        if (row.getDienTich() == null || row.getDienTich().compareTo(BigDecimal.ZERO) <= 0) return "Dien tich khong hop le";
        if (row.getGiaThue() == null || row.getGiaThue().compareTo(BigDecimal.ZERO) < 0) return "Gia thue khong hop le";
        if (row.getTienCoc() != null && row.getTienCoc().compareTo(BigDecimal.ZERO) < 0) return "Tien coc khong hop le";
        if (row.getSoNguoiToiDa() != null && row.getSoNguoiToiDa() <= 0) return "So nguoi toi da khong hop le";
        return null;
    }

    private BuildingLookup findOrCreateBuilding(UUID ownerId, String name, String address) {
        List<UUID> existing = jdbcTemplate.queryForList("""
                SELECT id
                FROM public.nha_tro
                WHERE chu_tro_id = ?::uuid
                  AND lower(ten) = lower(?)
                  AND xoa_luc IS NULL
                ORDER BY tao_luc ASC
                LIMIT 1
                """, UUID.class, ownerId, name);
        if (!existing.isEmpty()) return new BuildingLookup(existing.get(0), false);

        UUID id = jdbcTemplate.queryForObject("""
                INSERT INTO public.nha_tro (chu_tro_id, ten, dia_chi, trang_thai)
                VALUES (?::uuid, ?, ?, 'ACTIVE')
                RETURNING id
                """, UUID.class, ownerId, name, address);
        return new BuildingLookup(id, true);
    }

    private FloorLookup findOrCreateFloor(UUID nhaTroId, Integer soTang) {
        List<UUID> existing = jdbcTemplate.queryForList("""
                SELECT id
                FROM public.tang
                WHERE nha_tro_id = ?::uuid
                  AND so_tang = ?
                  AND xoa_luc IS NULL
                LIMIT 1
                """, UUID.class, nhaTroId, soTang);
        if (!existing.isEmpty()) return new FloorLookup(existing.get(0), false);

        UUID id = jdbcTemplate.queryForObject("""
                INSERT INTO public.tang (nha_tro_id, so_tang, ten_tang, thu_tu_hien_thi, so_phong_du_kien)
                VALUES (?::uuid, ?, ?, ?, 0)
                RETURNING id
                """, UUID.class, nhaTroId, soTang, "Tang " + soTang, soTang);
        return new FloorLookup(id, true);
    }

    private ImportToaNhaResponse.RowResult result(int rowNumber, ImportToaNhaRequest.Row row, boolean valid, String error, String action) {
        return ImportToaNhaResponse.RowResult.builder()
                .dong(rowNumber)
                .hopLe(valid)
                .tenToaNha(row != null ? row.getTenToaNha() : null)
                .tang(row != null ? row.getTang() : null)
                .maPhong(row != null ? row.getMaPhong() : null)
                .loi(error)
                .hanhDong(action)
                .build();
    }

    private record BuildingLookup(UUID id, boolean created) {
    }

    private record FloorLookup(UUID id, boolean created) {
    }
}
