package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.NhaTroRequest;
import com.example.quanlyphongtro.dto.NhaTroResponse;
import com.example.quanlyphongtro.dto.PublicNhaTroSummaryResponse;
import com.example.quanlyphongtro.dto.CloneToaNhaRequest;
import com.example.quanlyphongtro.dto.GenerateRoomsRequest;
import com.example.quanlyphongtro.dto.GenerateRoomsResponse;
import com.example.quanlyphongtro.dto.SoDoToaNhaResponse;
import com.example.quanlyphongtro.dto.TangResponse;
import com.example.quanlyphongtro.dto.ThongKeToaNhaResponse;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.TangRepository;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NhaTroService {

    private final NhaTroRepository nhaTroRepository;
    private final PhongRepository phongRepository;
    private final TangRepository tangRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final PermissionService permissionService;
    private final TienIchService tienIchService;
    private final JdbcTemplate jdbcTemplate;

    public PaginatedResponse<NhaTroResponse> getAllNhaTro(String search, int page, int limit) {
        UUID userId = permissionService.currentUserId().orElse(null);
        boolean isAdmin = userId != null && permissionService.isAdmin(userId);
        List<UUID> nhaTroIds = List.of(UUID.randomUUID());
        if (!isAdmin && userId != null) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (!accessibleIds.isEmpty()) {
                nhaTroIds = accessibleIds;
            }
        }

        String normalizedSearch = search != null && !search.isBlank() ? search.trim() : null;
        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<NhaTro> pageResult = nhaTroRepository.findAllAccessible(isAdmin, nhaTroIds, normalizedSearch, pageable);
        
        List<NhaTroResponse> mappedList = pageResult.getContent().stream().map(this::mapToResponse).toList();
        return PaginatedResponse.of(pageResult, mappedList);
    }

    public NhaTroResponse getNhaTroById(UUID id) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        permissionService.currentUserId().ifPresent(userId -> assertCanRead(nt, userId));
        return mapToResponse(nt);
    }

    public List<PublicNhaTroSummaryResponse> getPublicAllNhaTro() {
        List<NhaTro> nhaTroList = nhaTroRepository.findByXoaLucIsNullOrderByTaoLucDesc();
        return nhaTroList.stream().map(PublicNhaTroSummaryResponse::fromEntity).toList();
    }

    public PublicNhaTroSummaryResponse getPublicNhaTroById(UUID id) {
        NhaTro nt = nhaTroRepository.findByIdAndXoaLucIsNull(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        return PublicNhaTroSummaryResponse.fromEntity(nt);
    }

    @Transactional
    public NhaTroResponse createNhaTro(NhaTroRequest request) {
        UUID userId = permissionService.requireCurrentUserId();
        NguoiDung currentUser = nguoiDungRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai"));

        NhaTro nt = new NhaTro();
        nt.setChuTro(currentUser);
        mapRequestToEntity(request, nt);
        NhaTro saved = nhaTroRepository.saveAndFlush(nt);
        generateRoomsFromCreateRequest(saved, request);
        return mapToResponse(saved);
    }

    @Transactional
    public NhaTroResponse updateNhaTro(UUID id, NhaTroRequest request) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        assertCanWrite(nt, permissionService.requireCurrentUserId());
        mapRequestToEntity(request, nt);
        return mapToResponse(nhaTroRepository.save(nt));
    }

    @Transactional
    public void deleteNhaTro(UUID id) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        assertCanWrite(nt, permissionService.requireCurrentUserId());
        if (phongRepository.countByNhaTroIdAndXoaLucIsNull(id) > 0) {
            throw new RuntimeException("Khong the xoa nha tro dang co phong hoat dong");
        }
        nt.setXoaLuc(ZonedDateTime.now());
        nhaTroRepository.save(nt);
    }

    public List<TangResponse> getTangByNhaTro(UUID id) {
        NhaTro nt = nhaTroRepository.findByIdAndXoaLucIsNull(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        permissionService.currentUserId().ifPresent(userId -> assertCanRead(nt, userId));
        return tangRepository.findByNhaTroIdAndXoaLucIsNullOrderBySoTangAsc(id).stream()
                .map(TangResponse::fromEntity)
                .toList();
    }

    public ThongKeToaNhaResponse getThongKeToaNha(UUID id) {
        NhaTro nt = nhaTroRepository.findByIdAndXoaLucIsNull(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        permissionService.currentUserId().ifPresent(userId -> assertCanRead(nt, userId));

        List<ThongKeToaNhaResponse> rows = jdbcTemplate.query("""
                SELECT nha_tro_id, ten_toa_nha, tong_so_tang, tong_so_phong, phong_trong,
                       phong_dang_thue, phong_bao_tri, hop_dong_sap_het_han, doanh_thu_du_kien_thang
                FROM public.v_thong_ke_toa_nha
                WHERE nha_tro_id = ?
                """, this::mapThongKe, id);
        if (!rows.isEmpty()) return rows.get(0);
        return ThongKeToaNhaResponse.builder()
                .nhaTroId(nt.getId())
                .tenToaNha(nt.getTen())
                .tongSoTang(0)
                .tongSoPhong(0)
                .phongTrong(0)
                .phongDangThue(0)
                .phongBaoTri(0)
                .hopDongSapHetHan(0)
                .doanhThuDuKienThang(BigDecimal.ZERO)
                .build();
    }

    public SoDoToaNhaResponse getSoDoToaNha(UUID id) {
        ThongKeToaNhaResponse thongKe = getThongKeToaNha(id);
        Map<Integer, SoDoToaNhaResponse.TangSoDo> tangMap = new LinkedHashMap<>();

        jdbcTemplate.query("""
                SELECT so_tang, ten_tang, phong_id, ma_phong, dien_tich, gia_hien_tai,
                       trang_thai_vat_ly, trang_thai_hien_thi, hop_dong_id, ma_hop_dong,
                       ngay_bat_dau, ngay_ket_thuc, khach_thue_id, khach_thue_hien_tai
                FROM public.v_so_do_toa_nha
                WHERE nha_tro_id = ?
                  AND phong_id IS NOT NULL
                ORDER BY so_tang DESC NULLS LAST, ma_phong ASC
                """, rs -> {
                    while (rs.next()) {
                        Integer soTang = getInteger(rs, "so_tang");
                        SoDoToaNhaResponse.TangSoDo tang = tangMap.get(soTang);
                        if (tang == null) {
                            tang = SoDoToaNhaResponse.TangSoDo.builder()
                                    .soTang(soTang)
                                    .tenTang(rs.getString("ten_tang"))
                                    .phong(new ArrayList<>())
                                    .build();
                            tangMap.put(soTang, tang);
                        }
                        tang.getPhong().add(mapPhongSoDo(rs));
                    }
                    return null;
                }, id);

        return SoDoToaNhaResponse.builder()
                .id(thongKe.getNhaTroId())
                .tenToaNha(thongKe.getTenToaNha())
                .tongSoTang(thongKe.getTongSoTang())
                .tongSoPhong(thongKe.getTongSoPhong())
                .phongTrong(thongKe.getPhongTrong())
                .phongDangThue(thongKe.getPhongDangThue())
                .phongBaoTri(thongKe.getPhongBaoTri())
                .hopDongSapHetHan(thongKe.getHopDongSapHetHan())
                .doanhThuDuKienThang(thongKe.getDoanhThuDuKienThang())
                .tang(new ArrayList<>(tangMap.values()))
                .build();
    }

    @Transactional
    public GenerateRoomsResponse generateRooms(UUID id, GenerateRoomsRequest request) {
        NhaTro nt = nhaTroRepository.findByIdAndXoaLucIsNull(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        assertCanWrite(nt, permissionService.requireCurrentUserId());
        return generateRoomsInternal(id, request);
    }

    @Transactional
    public NhaTroResponse cloneNhaTro(UUID sourceId, CloneToaNhaRequest request) {
        NhaTro source = nhaTroRepository.findByIdAndXoaLucIsNull(sourceId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro nguon"));
        UUID userId = permissionService.requireCurrentUserId();
        assertCanRead(source, userId);
        NguoiDung currentUser = nguoiDungRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai"));

        NhaTro target = new NhaTro();
        target.setChuTro(currentUser);
        target.setTen(request.getTenToaNha() != null && !request.getTenToaNha().isBlank()
                ? request.getTenToaNha().trim()
                : source.getTen() + " - Copy");
        if (request.getDiaChi() != null) {
            NhaTroRequest tmp = new NhaTroRequest();
            tmp.setDiaChi(request.getDiaChi());
            mapRequestToEntity(tmp, target);
        } else {
            target.setDiaChi(source.getDiaChi());
            target.setSoNha(source.getSoNha());
            target.setDuong(source.getDuong());
            target.setPhuong(source.getPhuong());
            target.setQuan(source.getQuan());
            target.setThanhPho(source.getThanhPho());
        }
        target.setMoTa(request.getMoTa() != null ? request.getMoTa() : source.getMoTa());
        if (Boolean.TRUE.equals(request.getCloneTienNghiChung())) target.setTienNghiChung(source.getTienNghiChung());
        if (Boolean.TRUE.equals(request.getCloneNoiQuy())) target.setNoiQuy(source.getNoiQuy());

        NhaTro saved = nhaTroRepository.saveAndFlush(target);
        jdbcTemplate.queryForObject(
                "SELECT * FROM public.clone_cau_truc_toa_nha(?::uuid, ?::uuid)",
                (rs, rowNum) -> GenerateRoomsResponse.builder()
                        .tangDuocTao(rs.getInt("tang_duoc_tao"))
                        .phongDuocTao(rs.getInt("phong_duoc_tao"))
                        .build(),
                source.getId(), saved.getId());
        return mapToResponse(saved);
    }

    private void mapRequestToEntity(NhaTroRequest request, NhaTro nt) {
        if (request.getTenToaNha() != null) nt.setTen(request.getTenToaNha());
        if (request.getMoTa() != null) nt.setMoTa(request.getMoTa());
        if (request.getTienNghiChung() != null) {
            nt.setTienNghiChung(String.join(",", request.getTienNghiChung()));
        }
        if (request.getDiaChi() != null) {
            String soNha = request.getDiaChi().getSoNha() != null ? request.getDiaChi().getSoNha() : "";
            String duong = request.getDiaChi().getDuong() != null ? request.getDiaChi().getDuong() : "";
            String fullDiaChi = (soNha + " " + duong).trim();
            nt.setDiaChi(fullDiaChi.isEmpty() ? null : fullDiaChi);
            nt.setSoNha(request.getDiaChi().getSoNha());
            nt.setDuong(request.getDiaChi().getDuong());
            nt.setPhuong(request.getDiaChi().getPhuong());
            nt.setQuan(request.getDiaChi().getQuan());
            nt.setThanhPho(request.getDiaChi().getThanhPho());
        }
    }

    private void generateRoomsFromCreateRequest(NhaTro nhaTro, NhaTroRequest request) {
        if (request == null || request.getCheDoTaoPhong() == null || request.getCheDoTaoPhong().isBlank()) return;
        String mode = request.getCheDoTaoPhong().trim().toUpperCase();
        if (mode.equals("NONE")) return;

        GenerateRoomsRequest generateRequest = new GenerateRoomsRequest();
        generateRequest.setSoTang(request.getSoTang());
        generateRequest.setSoPhongMoiTang(request.getSoPhongMoiTang());
        generateRequest.setDienTichMacDinh(request.getDienTichMacDinh());
        generateRequest.setGiaThueMacDinh(request.getGiaThueMacDinh());
        generateRequest.setTienCocMacDinh(request.getTienCocMacDinh());
        generateRequest.setSoNguoiToiDa(request.getSoNguoiToiDa());
        generateRequest.setCauTrucTang(request.getCauTrucTang());
        generateRequest.setTienNghiMacDinh(request.getTienNghiMacDinh());
        generateRoomsInternal(nhaTro.getId(), generateRequest);
    }

    private GenerateRoomsResponse generateRoomsInternal(UUID nhaTroId, GenerateRoomsRequest request) {
        if (request == null) throw new RuntimeException("Thieu cau hinh tao phong");
        
        List<UUID> existingRoomIds = phongRepository.findByNhaTroIdAndXoaLucIsNull(nhaTroId)
                .stream().map(Phong::getId).toList();

        GenerateRoomsResponse response;
        if (request.getCauTrucTang() != null && !request.getCauTrucTang().isEmpty()) {
            response = generateCustomRooms(nhaTroId, request);
        } else {
            int soTang = positive(request.getSoTang(), "So tang phai lon hon 0");
            int soPhongMoiTang = positive(request.getSoPhongMoiTang(), "So phong moi tang phai lon hon 0");
            response = jdbcTemplate.queryForObject(
                    "SELECT * FROM public.sinh_phong_toa_nha(?::uuid, ?, ?, ?, ?, ?, ?)",
                    (rs, rowNum) -> GenerateRoomsResponse.builder()
                            .tangDuocTao(rs.getInt("tang_duoc_tao"))
                            .phongDuocTao(rs.getInt("phong_duoc_tao"))
                            .build(),
                    nhaTroId,
                    soTang,
                    soPhongMoiTang,
                    defaultBigDecimal(request.getDienTichMacDinh(), BigDecimal.valueOf(20)),
                    defaultBigDecimal(request.getGiaThueMacDinh(), BigDecimal.ZERO),
                    defaultBigDecimal(request.getTienCocMacDinh(), BigDecimal.ZERO),
                    request.getSoNguoiToiDa() != null ? request.getSoNguoiToiDa() : 2);
        }

        if (request.getTienNghiMacDinh() != null && !request.getTienNghiMacDinh().isEmpty()) {
            List<Phong> rooms = phongRepository.findByNhaTroIdAndXoaLucIsNull(nhaTroId);
            for (Phong p : rooms) {
                if (!existingRoomIds.contains(p.getId())) {
                    tienIchService.replacePhongTienIch(p.getId(), request.getTienNghiMacDinh());
                }
            }
        }

        return response;
    }

    private GenerateRoomsResponse generateCustomRooms(UUID nhaTroId, GenerateRoomsRequest request) {
        int tangCount = 0;
        int phongCount = 0;
        for (GenerateRoomsRequest.CauTrucTangRequest tangReq : request.getCauTrucTang()) {
            int soTang = positive(tangReq.getSoTang(), "So tang phai lon hon 0");
            int soPhong = positive(tangReq.getSoPhong(), "So phong moi tang phai lon hon 0");
            UUID tangId = jdbcTemplate.queryForObject("""
                    INSERT INTO public.tang (nha_tro_id, so_tang, ten_tang, thu_tu_hien_thi, so_phong_du_kien)
                    VALUES (?::uuid, ?, ?, ?, ?)
                    ON CONFLICT (nha_tro_id, so_tang) DO UPDATE
                    SET so_phong_du_kien = EXCLUDED.so_phong_du_kien,
                        cap_nhat_luc = now()
                    RETURNING id
                    """, UUID.class, nhaTroId, soTang, "Tang " + soTang, soTang, soPhong);
            tangCount++;

            BigDecimal dienTich = defaultBigDecimal(tangReq.getDienTichMacDinh(), defaultBigDecimal(request.getDienTichMacDinh(), BigDecimal.valueOf(20)));
            BigDecimal gia = defaultBigDecimal(tangReq.getGiaThueMacDinh(), defaultBigDecimal(request.getGiaThueMacDinh(), BigDecimal.ZERO));
            BigDecimal tienCoc = defaultBigDecimal(tangReq.getTienCocMacDinh(), defaultBigDecimal(request.getTienCocMacDinh(), BigDecimal.ZERO));
            int soNguoi = tangReq.getSoNguoiToiDa() != null ? tangReq.getSoNguoiToiDa() : (request.getSoNguoiToiDa() != null ? request.getSoNguoiToiDa() : 2);

            for (int i = 1; i <= soPhong; i++) {
                int updated = jdbcTemplate.update("""
                        INSERT INTO public.phong (nha_tro_id, tang_id, ten, tang, dien_tich, so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh)
                        VALUES (?::uuid, ?::uuid, ?, ?, ?, ?, 'AVAILABLE'::public.trang_thai_phong, ?, ?)
                        ON CONFLICT (nha_tro_id, ten) DO NOTHING
                        """, nhaTroId, tangId, "Phòng " + (soTang * 100 + i), soTang, dienTich, soNguoi, gia, tienCoc);
                phongCount += updated;
            }
        }
        return GenerateRoomsResponse.builder().tangDuocTao(tangCount).phongDuocTao(phongCount).build();
    }

    private ThongKeToaNhaResponse mapThongKe(ResultSet rs, int rowNum) throws SQLException {
        return ThongKeToaNhaResponse.builder()
                .nhaTroId(rs.getObject("nha_tro_id", UUID.class))
                .tenToaNha(rs.getString("ten_toa_nha"))
                .tongSoTang(getInteger(rs, "tong_so_tang"))
                .tongSoPhong(getInteger(rs, "tong_so_phong"))
                .phongTrong(getInteger(rs, "phong_trong"))
                .phongDangThue(getInteger(rs, "phong_dang_thue"))
                .phongBaoTri(getInteger(rs, "phong_bao_tri"))
                .hopDongSapHetHan(getInteger(rs, "hop_dong_sap_het_han"))
                .doanhThuDuKienThang(rs.getBigDecimal("doanh_thu_du_kien_thang"))
                .build();
    }

    private SoDoToaNhaResponse.PhongSoDo mapPhongSoDo(ResultSet rs) throws SQLException {
        return SoDoToaNhaResponse.PhongSoDo.builder()
                .id(rs.getObject("phong_id", UUID.class))
                .maPhong(rs.getString("ma_phong"))
                .dienTich(rs.getBigDecimal("dien_tich"))
                .giaHienTai(rs.getBigDecimal("gia_hien_tai"))
                .trangThaiVatLy(rs.getString("trang_thai_vat_ly"))
                .trangThaiHienThi(rs.getString("trang_thai_hien_thi"))
                .hopDongId(rs.getObject("hop_dong_id", UUID.class))
                .maHopDong(rs.getString("ma_hop_dong"))
                .ngayBatDau(rs.getDate("ngay_bat_dau") != null ? rs.getDate("ngay_bat_dau").toLocalDate() : null)
                .ngayKetThuc(rs.getDate("ngay_ket_thuc") != null ? rs.getDate("ngay_ket_thuc").toLocalDate() : null)
                .khachThueId(rs.getObject("khach_thue_id", UUID.class))
                .khachThueHienTai(rs.getString("khach_thue_hien_tai"))
                .build();
    }

    private int positive(Integer value, String message) {
        if (value == null || value <= 0) throw new RuntimeException(message);
        return value;
    }

    private BigDecimal defaultBigDecimal(BigDecimal value, BigDecimal fallback) {
        return value != null ? value : fallback;
    }

    private Integer getInteger(ResultSet rs, String column) throws SQLException {
        int value = rs.getInt(column);
        return rs.wasNull() ? null : value;
    }

    private NhaTroResponse mapToResponse(NhaTro nt) {
        int tong = (int) phongRepository.countByNhaTroIdAndXoaLucIsNull(nt.getId());
        int trong = (int) phongRepository.countByNhaTroIdAndTrangThaiAndXoaLucIsNull(nt.getId(), TrangThaiPhong.AVAILABLE);
        int thue = (int) phongRepository.countByNhaTroIdAndTrangThaiAndXoaLucIsNull(nt.getId(), TrangThaiPhong.RENTED);
        return NhaTroResponse.fromEntity(nt, tong, trong, thue);
    }

    private void assertCanRead(NhaTro nhaTro, UUID userId) {
        if (!permissionService.canReadNhaTro(userId, nhaTro.getId(), ownerId(nhaTro))) {
            throw new RuntimeException("Ban khong co quyen xem nha tro nay");
        }
    }

    private void assertCanWrite(NhaTro nhaTro, UUID userId) {
        if (!permissionService.canWriteNhaTro(userId, nhaTro.getId(), ownerId(nhaTro))) {
            throw new RuntimeException("Ban khong co quyen sua nha tro nay");
        }
    }

    private boolean isOwnedBy(NhaTro nhaTro, UUID userId) {
        UUID ownerId = ownerId(nhaTro);
        return ownerId != null && ownerId.equals(userId);
    }

    private UUID ownerId(NhaTro nhaTro) {
        return nhaTro.getChuTro() != null ? nhaTro.getChuTro().getId() : null;
    }
}
