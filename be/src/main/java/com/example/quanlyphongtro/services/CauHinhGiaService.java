package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.CauHinhGiaRequest;
import com.example.quanlyphongtro.dto.CauHinhGiaResponse;
import com.example.quanlyphongtro.entity.CauHinhGia;
import com.example.quanlyphongtro.entity.LoaiMucHoaDon;
import com.example.quanlyphongtro.entity.LoaiTinhPhi;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.repository.CauHinhGiaRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CauHinhGiaService {

    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final NhaTroRepository nhaTroRepository;

    public List<CauHinhGiaResponse> getAll(UUID nhaTroId, String loaiRaw, Boolean dangApDung) {
        LoaiMucHoaDon loai = parseLoai(loaiRaw, false);
        List<CauHinhGia> list;
        if (nhaTroId != null) {
            list = cauHinhGiaRepository.findByNhaTroIdOrderByHieuLucTuDesc(nhaTroId);
        } else {
            list = cauHinhGiaRepository.findAll();
        }

        return list.stream()
                .filter(c -> loai == null || c.getLoai() == loai)
                .filter(c -> dangApDung == null || c.getDangApDung().equals(dangApDung))
                .sorted(Comparator.comparing((CauHinhGia c) -> c.getNhaTro() != null ? c.getNhaTro().getTen() : "", Comparator.nullsLast(String::compareTo))
                        .thenComparing(c -> c.getLoai() != null ? c.getLoai().name() : "", Comparator.nullsLast(String::compareTo))
                        .thenComparing(CauHinhGia::getHieuLucTu, Comparator.nullsLast(Comparator.reverseOrder())))
                .map(CauHinhGiaResponse::fromEntity)
                .toList();
    }

    public CauHinhGiaResponse getById(UUID id) {
        return CauHinhGiaResponse.fromEntity(findById(id));
    }

    public CauHinhGiaResponse getApplicable(UUID nhaTroId, String loaiRaw, LocalDate ngayApDung) {
        LoaiMucHoaDon loai = parseLoai(loaiRaw, true);
        LocalDate effectiveDate = ngayApDung != null ? ngayApDung : LocalDate.now();
        return cauHinhGiaRepository.findApplicable(nhaTroId, loai, effectiveDate).stream()
                .findFirst()
                .map(CauHinhGiaResponse::fromEntity)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy cấu hình giá đang áp dụng"));
    }

    @Transactional
    public CauHinhGiaResponse create(CauHinhGiaRequest request) {
        validateDateRange(request.getHieuLucTu(), request.getHieuLucDen());
        NhaTro nhaTro = nhaTroRepository.findById(request.getNhaTroId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));

        CauHinhGia entity = CauHinhGia.builder()
                .nhaTro(nhaTro)
                .dichVuId(request.getDichVuId())
                .loai(parseLoai(request.getLoai(), true))
                .tenHienThi(request.getTenHienThi().trim())
                .loaiTinhPhi(parseLoaiTinhPhi(request.getLoaiTinhPhi()))
                .donGia(request.getDonGia())
                .hieuLucTu(request.getHieuLucTu() != null ? request.getHieuLucTu() : LocalDate.now())
                .hieuLucDen(request.getHieuLucDen())
                .dangApDung(request.getDangApDung() != null ? request.getDangApDung() : true)
                .build();

        validateMoney(entity.getDonGia());
        return CauHinhGiaResponse.fromEntity(cauHinhGiaRepository.save(entity));
    }

    @Transactional
    public CauHinhGiaResponse update(UUID id, CauHinhGiaRequest request) {
        CauHinhGia entity = findById(id);

        if (request.getNhaTroId() != null) {
            entity.setNhaTro(nhaTroRepository.findById(request.getNhaTroId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ")));
        }
        if (request.getDichVuId() != null) entity.setDichVuId(request.getDichVuId());
        if (request.getLoai() != null) entity.setLoai(parseLoai(request.getLoai(), true));
        if (request.getTenHienThi() != null && !request.getTenHienThi().isBlank()) {
            entity.setTenHienThi(request.getTenHienThi().trim());
        }
        if (request.getLoaiTinhPhi() != null) entity.setLoaiTinhPhi(parseLoaiTinhPhi(request.getLoaiTinhPhi()));
        if (request.getDonGia() != null) {
            validateMoney(request.getDonGia());
            entity.setDonGia(request.getDonGia());
        }
        if (request.getHieuLucTu() != null) entity.setHieuLucTu(request.getHieuLucTu());
        if (request.getHieuLucDen() != null) entity.setHieuLucDen(request.getHieuLucDen());
        if (request.getDangApDung() != null) entity.setDangApDung(request.getDangApDung());

        validateDateRange(entity.getHieuLucTu(), entity.getHieuLucDen());
        return CauHinhGiaResponse.fromEntity(cauHinhGiaRepository.save(entity));
    }

    @Transactional
    public void deactivate(UUID id) {
        CauHinhGia entity = findById(id);
        entity.setDangApDung(false);
        if (entity.getHieuLucDen() == null) {
            entity.setHieuLucDen(LocalDate.now());
        }
        cauHinhGiaRepository.save(entity);
    }

    private CauHinhGia findById(UUID id) {
        return cauHinhGiaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy cấu hình giá"));
    }

    private LoaiMucHoaDon parseLoai(String value, boolean required) {
        if (value == null || value.isBlank() || "all".equalsIgnoreCase(value)) {
            if (required) throw new RuntimeException("Loại cấu hình giá không hợp lệ");
            return null;
        }
        try {
            return LoaiMucHoaDon.valueOf(value.trim().toUpperCase());
        } catch (Exception e) {
            throw new RuntimeException("Loại cấu hình giá không hợp lệ: " + value);
        }
    }

    private LoaiTinhPhi parseLoaiTinhPhi(String value) {
        if (value == null || value.isBlank()) {
            return LoaiTinhPhi.FIXED;
        }
        try {
            return LoaiTinhPhi.valueOf(value.trim().toUpperCase());
        } catch (Exception e) {
            throw new RuntimeException("Loại tính phí không hợp lệ: " + value);
        }
    }

    private void validateMoney(BigDecimal value) {
        if (value == null || value.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Đơn giá phải lớn hơn hoặc bằng 0");
        }
    }

    private void validateDateRange(LocalDate from, LocalDate to) {
        if (from != null && to != null && to.isBefore(from)) {
            throw new RuntimeException("Ngày hết hiệu lực phải sau hoặc bằng ngày hiệu lực");
        }
    }
}
