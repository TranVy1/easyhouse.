package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.TaiSanPhongDto;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TaiSanPhong;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.TaiSanPhongRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.entity.NhaTro;

@Service
@RequiredArgsConstructor
public class TaiSanPhongService {

    private final TaiSanPhongRepository taiSanPhongRepository;
    private final PhongRepository phongRepository;
    private final PermissionService permissionService;

    @Transactional(readOnly = true)
    public PaginatedResponse<TaiSanPhongDto> getAll(String keyword, String nhaTroId, String phongId, String tinhTrang, int page, int limit) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        
        List<TaiSanPhong> all = taiSanPhongRepository.findAll().stream()
                .filter(ts -> ts.getPhong() != null && ts.getPhong().getNhaTro() != null && ts.getPhong().getNhaTro().getChuTro().getId().equals(chuTroId))
                .collect(Collectors.toList());

        if (nhaTroId != null && !nhaTroId.equals("all") && !nhaTroId.isBlank()) {
            all = all.stream().filter(ts -> ts.getPhong().getNhaTro().getId().toString().equals(nhaTroId)).collect(Collectors.toList());
        }

        if (phongId != null && !phongId.equals("all") && !phongId.isBlank()) {
            all = all.stream().filter(ts -> ts.getPhong().getId().toString().equals(phongId)).collect(Collectors.toList());
        }

        if (tinhTrang != null && !tinhTrang.equals("all") && !tinhTrang.isBlank()) {
            all = all.stream().filter(ts -> ts.getTinhTrang() != null && ts.getTinhTrang().equals(tinhTrang)).collect(Collectors.toList());
        }

        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.toLowerCase();
            all = all.stream().filter(ts -> 
                (ts.getTenTaiSan() != null && ts.getTenTaiSan().toLowerCase().contains(kw)) ||
                (ts.getGhiChu() != null && ts.getGhiChu().toLowerCase().contains(kw))
            ).collect(Collectors.toList());
        }

        all.sort((a, b) -> {
            if (a.getTaoLuc() == null && b.getTaoLuc() == null) return 0;
            if (a.getTaoLuc() == null) return 1;
            if (b.getTaoLuc() == null) return -1;
            return b.getTaoLuc().compareTo(a.getTaoLuc());
        });

        int start = Math.max(0, (page - 1) * limit);
        int end = Math.min(start + limit, all.size());
        List<TaiSanPhongDto> content = all.subList(start, end).stream().map(this::mapToDto).collect(Collectors.toList());

        return new PaginatedResponse<>(
                content,
                all.size(),
                page,
                limit,
                (int) Math.ceil((double) all.size() / limit)
        );
    }

    @Transactional(readOnly = true)
    public List<TaiSanPhongDto> getTaiSanByPhong(UUID phongId) {
        return taiSanPhongRepository.findByPhongId(phongId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public TaiSanPhongDto addTaiSanToPhong(UUID phongId, TaiSanPhongDto dto) {
        Phong phong = phongRepository.findById(phongId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        TaiSanPhong taiSan = TaiSanPhong.builder()
                .phong(phong)
                .tenTaiSan(dto.getTenTaiSan())
                .soLuong(dto.getSoLuong())
                .giaTri(dto.getGiaTri())
                .tinhTrang(dto.getTinhTrang())
                .ghiChu(dto.getGhiChu())
                .anhTaiSan(dto.getAnhTaiSan())
                .build();
        taiSan = taiSanPhongRepository.save(taiSan);
        return mapToDto(taiSan);
    }

    @Transactional
    public TaiSanPhongDto updateTaiSan(UUID id, TaiSanPhongDto dto) {
        TaiSanPhong taiSan = taiSanPhongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay tai san"));
        taiSan.setTenTaiSan(dto.getTenTaiSan());
        taiSan.setSoLuong(dto.getSoLuong());
        taiSan.setGiaTri(dto.getGiaTri());
        taiSan.setTinhTrang(dto.getTinhTrang());
        taiSan.setGhiChu(dto.getGhiChu());
        taiSan.setAnhTaiSan(dto.getAnhTaiSan());
        taiSan = taiSanPhongRepository.save(taiSan);
        return mapToDto(taiSan);
    }

    @Transactional
    public void deleteTaiSan(UUID id) {
        TaiSanPhong taiSan = taiSanPhongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay tai san"));
        taiSan.setXoaLuc(java.time.ZonedDateTime.now());
        taiSanPhongRepository.save(taiSan);
    }

    public TaiSanPhongDto mapToDto(TaiSanPhong entity) {
        String tenNhaTro = null;
        UUID nhaTroId = null;
        if (entity.getPhong() != null && entity.getPhong().getNhaTro() != null) {
            tenNhaTro = entity.getPhong().getNhaTro().getTen();
            nhaTroId = entity.getPhong().getNhaTro().getId();
        }
        
        return TaiSanPhongDto.builder()
                .id(entity.getId())
                .phongId(entity.getPhong().getId())
                .tenPhong(entity.getPhong().getTen())
                .nhaTroId(nhaTroId)
                .tenNhaTro(tenNhaTro)
                .tenTaiSan(entity.getTenTaiSan())
                .soLuong(entity.getSoLuong())
                .giaTri(entity.getGiaTri())
                .tinhTrang(entity.getTinhTrang())
                .ghiChu(entity.getGhiChu())
                .anhTaiSan(entity.getAnhTaiSan())
                .build();
    }

    public String getImportTemplate() {
        return "phongId,tenPhong,tenTaiSan,soLuong,giaTri,tinhTrang,ghiChu,anhTaiSan\n";
    }

    @Transactional(readOnly = true)
    public com.example.quanlyphongtro.dto.TaiSanPhongImportPreviewResponse previewImport(org.springframework.web.multipart.MultipartFile file) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        
        List<com.example.quanlyphongtro.dto.TaiSanPhongImportRow> rows = new java.util.ArrayList<>();
        int errorRows = 0;
        int validRows = 0;
        
        try (java.io.BufferedReader fileReader = new java.io.BufferedReader(new java.io.InputStreamReader(file.getInputStream(), "UTF-8"));
             org.apache.commons.csv.CSVParser csvParser = new org.apache.commons.csv.CSVParser(fileReader,
                     org.apache.commons.csv.CSVFormat.DEFAULT.withFirstRecordAsHeader().withIgnoreHeaderCase().withTrim());) {

            Iterable<org.apache.commons.csv.CSVRecord> csvRecords = csvParser.getRecords();

            for (org.apache.commons.csv.CSVRecord csvRecord : csvRecords) {
                com.example.quanlyphongtro.dto.TaiSanPhongImportRow row = new com.example.quanlyphongtro.dto.TaiSanPhongImportRow();
                try {
                    row.setPhongId(csvRecord.isSet("phongId") ? csvRecord.get("phongId") : null);
                    row.setTenPhong(csvRecord.isSet("tenPhong") ? csvRecord.get("tenPhong") : null);
                    row.setTenTaiSan(csvRecord.isSet("tenTaiSan") ? csvRecord.get("tenTaiSan") : null);
                    row.setSoLuong(csvRecord.isSet("soLuong") && !csvRecord.get("soLuong").isBlank() ? Integer.parseInt(csvRecord.get("soLuong")) : 0);
                    row.setGiaTri(csvRecord.isSet("giaTri") && !csvRecord.get("giaTri").isBlank() ? new java.math.BigDecimal(csvRecord.get("giaTri")) : java.math.BigDecimal.ZERO);
                    row.setTinhTrang(csvRecord.isSet("tinhTrang") ? csvRecord.get("tinhTrang") : null);
                    row.setGhiChu(csvRecord.isSet("ghiChu") ? csvRecord.get("ghiChu") : null);
                    row.setAnhTaiSan(csvRecord.isSet("anhTaiSan") ? csvRecord.get("anhTaiSan") : null);
                    
                    // Validate
                    if (row.getPhongId() == null || row.getPhongId().isBlank()) throw new RuntimeException("Mã phòng (phongId) không được để trống");
                    if (row.getTenTaiSan() == null || row.getTenTaiSan().isBlank()) throw new RuntimeException("Tên tài sản không được để trống");
                    if (row.getSoLuong() <= 0) throw new RuntimeException("Số lượng phải lớn hơn 0");
                    if (row.getGiaTri().compareTo(java.math.BigDecimal.ZERO) < 0) throw new RuntimeException("Giá trị không được âm");
                    if (row.getTinhTrang() == null || row.getTinhTrang().isBlank()) throw new RuntimeException("Tình trạng không được để trống");
                    
                    // Verify phongId belongs to chuTro
                    UUID pid;
                    try {
                        pid = UUID.fromString(row.getPhongId());
                    } catch (Exception ex) {
                        throw new RuntimeException("Mã phòng không hợp lệ");
                    }
                    Phong phong = phongRepository.findById(pid).stream().filter(p -> p.getNhaTro() != null && p.getNhaTro().getChuTro().getId().equals(chuTroId)).findFirst().orElseThrow(() -> new RuntimeException("Không tìm thấy phòng " + row.getPhongId() + " hoặc không có quyền truy cập"));
                    
                    row.setTenPhong(phong.getTen());
                    row.setValid(true);
                    validRows++;
                } catch (Exception e) {
                    row.setValid(false);
                    row.setErrorReason(e.getMessage());
                    errorRows++;
                }
                rows.add(row);
            }
        } catch (Exception e) {
            throw new RuntimeException("Lỗi đọc file CSV: " + e.getMessage());
        }
        
        return com.example.quanlyphongtro.dto.TaiSanPhongImportPreviewResponse.builder()
                .rows(rows)
                .totalRows(rows.size())
                .validRows(validRows)
                .errorRows(errorRows)
                .build();
    }

    @Transactional
    public void commitImport(com.example.quanlyphongtro.dto.TaiSanPhongImportCommitRequest request) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        if (request.getRows() == null || request.getRows().isEmpty()) return;
        
        for (com.example.quanlyphongtro.dto.TaiSanPhongImportRow row : request.getRows()) {
            if (!row.isValid()) continue;
            UUID pid = UUID.fromString(row.getPhongId());
            Phong phong = phongRepository.findById(pid).stream().filter(p -> p.getNhaTro() != null && p.getNhaTro().getChuTro().getId().equals(chuTroId)).findFirst().orElseThrow(() -> new RuntimeException("Không tìm thấy phòng " + row.getPhongId()));
            
            TaiSanPhong taiSan = TaiSanPhong.builder()
                    .phong(phong)
                    .tenTaiSan(row.getTenTaiSan())
                    .soLuong(row.getSoLuong())
                    .giaTri(row.getGiaTri())
                    .tinhTrang(row.getTinhTrang())
                    .ghiChu(row.getGhiChu())
                    .anhTaiSan(row.getAnhTaiSan())
                    .build();
            taiSanPhongRepository.save(taiSan);
        }
    }
}
