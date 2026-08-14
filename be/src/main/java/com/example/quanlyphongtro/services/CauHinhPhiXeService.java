package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.CauHinhPhiXeRequest;
import com.example.quanlyphongtro.dto.CauHinhPhiXeResponse;
import com.example.quanlyphongtro.entity.AuditLog;
import com.example.quanlyphongtro.entity.CauHinhPhiXe;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.CauHinhPhiXeRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CauHinhPhiXeService {
    private final CauHinhPhiXeRepository repository;
    private final NhaTroRepository nhaTroRepository;
    private final PermissionService permissionService;
    private final AuditLogRepository auditLogRepository;

    public List<CauHinhPhiXeResponse> getAll(UUID nhaTroId, String loaiXe) {
        if (nhaTroId == null) throw new RuntimeException("Vui lòng chọn nhà trọ để xem biểu phí xe");
        NhaTro nhaTro = getNhaTro(nhaTroId);
        checkRead(nhaTro);
        return repository.findAllForNhaTro(nhaTroId, blankToNull(loaiXe)).stream()
                .map(CauHinhPhiXeResponse::fromEntity).toList();
    }

    public CauHinhPhiXeResponse getById(UUID id) {
        CauHinhPhiXe entity = find(id);
        checkRead(entity.getNhaTro());
        return CauHinhPhiXeResponse.fromEntity(entity);
    }

    @Transactional
    public CauHinhPhiXeResponse create(CauHinhPhiXeRequest request) {
        NhaTro nhaTro = getNhaTro(request.getNhaTroId());
        checkWrite(nhaTro);
        CauHinhPhiXe entity = CauHinhPhiXe.builder().nhaTro(nhaTro).loaiXe(normalizeType(request.getLoaiXe()))
                .donGia(requireMoney(request.getDonGia())).hieuLucTu(request.getHieuLucTu())
                .hieuLucDen(request.getHieuLucDen()).dangApDung(request.getDangApDung() != null ? request.getDangApDung() : true)
                .ghiChu(blankToNull(request.getGhiChu())).build();
        validateRange(entity.getHieuLucTu(), entity.getHieuLucDen());
        validateNoOverlap(entity, null);
        CauHinhPhiXe saved = repository.save(entity);
        audit(saved, "CREATE", null);
        return CauHinhPhiXeResponse.fromEntity(saved);
    }

    @Transactional
    public CauHinhPhiXeResponse update(UUID id, CauHinhPhiXeRequest request) {
        CauHinhPhiXe entity = find(id);
        checkWrite(entity.getNhaTro());
        if (!entity.getNhaTro().getId().equals(request.getNhaTroId())) throw new RuntimeException("Không được đổi nhà trọ của phiên bản biểu phí");
        String before = snapshot(entity);
        entity.setLoaiXe(normalizeType(request.getLoaiXe()));
        entity.setDonGia(requireMoney(request.getDonGia()));
        entity.setHieuLucTu(request.getHieuLucTu());
        entity.setHieuLucDen(request.getHieuLucDen());
        entity.setDangApDung(request.getDangApDung() != null ? request.getDangApDung() : true);
        entity.setGhiChu(blankToNull(request.getGhiChu()));
        validateRange(entity.getHieuLucTu(), entity.getHieuLucDen());
        validateNoOverlap(entity, id);
        CauHinhPhiXe saved = repository.save(entity);
        audit(saved, "UPDATE", before);
        return CauHinhPhiXeResponse.fromEntity(saved);
    }

    @Transactional
    public void deactivate(UUID id, LocalDate hieuLucDen) {
        CauHinhPhiXe entity = find(id);
        checkWrite(entity.getNhaTro());
        String before = snapshot(entity);
        LocalDate end = hieuLucDen != null ? hieuLucDen : LocalDate.now();
        if (end.isBefore(entity.getHieuLucTu())) throw new RuntimeException("Ngày ngừng hiệu lực không được trước ngày bắt đầu");
        entity.setHieuLucDen(end);
        entity.setDangApDung(false);
        CauHinhPhiXe saved = repository.save(entity);
        audit(saved, "DEACTIVATE", before);
    }

    private void validateNoOverlap(CauHinhPhiXe candidate, UUID excludeId) {
        if (!Boolean.TRUE.equals(candidate.getDangApDung())) return;
        LocalDate start = candidate.getHieuLucTu(), end = candidate.getHieuLucDen() == null ? LocalDate.MAX : candidate.getHieuLucDen();
        for (CauHinhPhiXe other : repository.findAllForNhaTro(candidate.getNhaTro().getId(), candidate.getLoaiXe())) {
            if (other.getId().equals(excludeId) || !Boolean.TRUE.equals(other.getDangApDung())) continue;
            LocalDate otherEnd = other.getHieuLucDen() == null ? LocalDate.MAX : other.getHieuLucDen();
            if (!start.isAfter(otherEnd) && !other.getHieuLucTu().isAfter(end))
                throw new RuntimeException("Biểu phí xe cùng loại đang chồng lấp thời gian hiệu lực");
        }
    }

    private NhaTro getNhaTro(UUID id) { return nhaTroRepository.findByIdAndXoaLucIsNull(id).orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ")); }
    private CauHinhPhiXe find(UUID id) { return repository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy biểu phí xe")); }
    private void checkRead(NhaTro nhaTro) { UUID userId = permissionService.requireCurrentUserId(); if (!permissionService.canReadNhaTro(userId, nhaTro.getId(), ownerId(nhaTro))) throw new RuntimeException("Bạn không có quyền xem biểu phí xe"); }
    private void checkWrite(NhaTro nhaTro) { UUID userId = permissionService.requireCurrentUserId(); if (!permissionService.canWriteNhaTro(userId, nhaTro.getId(), ownerId(nhaTro))) throw new RuntimeException("Bạn không có quyền thay đổi biểu phí xe"); }
    private UUID ownerId(NhaTro nhaTro) { return nhaTro.getChuTro() == null ? null : nhaTro.getChuTro().getId(); }
    private BigDecimal requireMoney(BigDecimal value) { if (value == null || value.compareTo(BigDecimal.ZERO) < 0) throw new RuntimeException("Đơn giá không được âm"); return value; }
    private void validateRange(LocalDate from, LocalDate to) { if (from == null) throw new RuntimeException("Ngày hiệu lực là bắt buộc"); if (to != null && to.isBefore(from)) throw new RuntimeException("Ngày hết hiệu lực không hợp lệ"); }
    private String normalizeType(String value) { String type = blankToNull(value); if (type == null) throw new RuntimeException("Loại xe là bắt buộc"); return type; }
    private String blankToNull(String value) { return value == null || value.isBlank() ? null : value.trim(); }
    private String snapshot(CauHinhPhiXe entity) { return "{\"loaiXe\":\"" + entity.getLoaiXe() + "\",\"donGia\":\"" + entity.getDonGia() + "\"}"; }
    private void audit(CauHinhPhiXe entity, String action, String before) { auditLogRepository.save(AuditLog.builder().nguoiDung(NguoiDung.builder().id(permissionService.requireCurrentUserId()).build()).hanhDong(action).bangTacDong("cau_hinh_phi_xe").banGhiId(entity.getId()).duLieuCu(before).duLieuMoi(snapshot(entity)).build()); }
}
