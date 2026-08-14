package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.GiaoDichTienCocRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class GiaoDichTienCocService {
    private final GiaoDichTienCocRepository giaoDichRepository;
    private final HopDongRepository hopDongRepository;
    private final AuditLogRepository auditLogRepository;

    @Transactional
    public void ghiNhanThuCoc(ThanhToan thanhToan) {
        if (thanhToan == null || thanhToan.getId() == null || thanhToan.getTrangThai() != TrangThaiThanhToan.SUCCESS
                || thanhToan.getHoaDon() == null || thanhToan.getHoaDon().getLoaiHoaDon() != LoaiHoaDon.DEPOSIT_REQUEST) {
            return;
        }
        if (giaoDichRepository.findByThanhToanId(thanhToan.getId()).isPresent()) return;
        HopDong hopDong = thanhToan.getHoaDon().getHopDong();
        if (hopDong == null) throw new RuntimeException("Hóa đơn cọc không có hợp đồng");
        BigDecimal amount = money(thanhToan.getSoTien());
        if (amount.compareTo(BigDecimal.ZERO) <= 0) throw new RuntimeException("Số tiền thu cọc phải lớn hơn 0");

        GiaoDichTienCoc movement = giaoDichRepository.save(GiaoDichTienCoc.builder()
                .hopDong(hopDong).thanhToan(thanhToan).loai(LoaiGiaoDichTienCoc.HELD)
                .soTien(amount).thoiDiem(thanhToan.getNgayThanhToan() != null ? thanhToan.getNgayThanhToan() : ZonedDateTime.now())
                .dienGiai("Thu tiền cọc theo hóa đơn " + thanhToan.getHoaDon().getMaHoaDon())
                .maThamChieu(thanhToan.getMaThamChieu()).build());
        logAudit(movement, "DEPOSIT_HELD");
        hopDong.setTrangThaiCoc(TrangThaiCocHopDong.KEPT);
        hopDongRepository.save(hopDong);
    }

    @Transactional(readOnly = true)
    public BigDecimal soDu(UUID hopDongId) {
        return giaoDichRepository.findByHopDongIdOrderByThoiDiemAsc(hopDongId).stream()
                .map(item -> isIncrease(item.getLoai()) ? money(item.getSoTien()) : money(item.getSoTien()).negate())
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Transactional
    public void ghiNhanQuyetToan(QuyetToanTraPhong quyetToan, String chungTuHoanCoc, String maThamChieuHoanCoc) {
        UUID hopDongId = quyetToan.getHopDong().getId();
        BigDecimal balance = soDu(hopDongId);
        BigDecimal deduction = money(quyetToan.getTienCocDaCanTru());
        BigDecimal refund = money(quyetToan.getTienCocCanHoan());
        if (deduction.add(refund).compareTo(balance) != 0) {
            throw new RuntimeException("Số dư sổ cọc không khớp với quyết toán trả phòng; hãy kiểm tra lịch sử cọc trước khi hoàn tất");
        }
        if (deduction.compareTo(BigDecimal.ZERO) > 0) {
            saveOnce(quyetToan, LoaiGiaoDichTienCoc.DEDUCTION, deduction, "Khấu trừ cọc theo quyết toán trả phòng", null, null);
        }
        if (refund.compareTo(BigDecimal.ZERO) > 0) {
            if (chungTuHoanCoc == null || chungTuHoanCoc.isBlank()) {
                throw new RuntimeException("Hoàn cọc phải có chứng từ hoặc mã biên nhận");
            }
            saveOnce(quyetToan, LoaiGiaoDichTienCoc.REFUND, refund, "Hoàn cọc còn dư cho khách thuê", chungTuHoanCoc.trim(), maThamChieuHoanCoc);
        }
    }

    private void saveOnce(QuyetToanTraPhong quyetToan, LoaiGiaoDichTienCoc loai, BigDecimal soTien,
                          String dienGiai, String chungTuUrl, String maThamChieu) {
        if (giaoDichRepository.findByQuyetToanTraPhongIdAndLoai(quyetToan.getId(), loai).isPresent()) return;
        GiaoDichTienCoc movement = giaoDichRepository.save(GiaoDichTienCoc.builder()
                .hopDong(quyetToan.getHopDong()).quyetToanTraPhong(quyetToan).loai(loai).soTien(soTien)
                .thoiDiem(ZonedDateTime.now()).dienGiai(dienGiai).chungTuUrl(chungTuUrl).maThamChieu(maThamChieu).build());
        logAudit(movement, "DEPOSIT_" + loai.name());
    }

    private boolean isIncrease(LoaiGiaoDichTienCoc loai) {
        return loai == LoaiGiaoDichTienCoc.HELD || loai == LoaiGiaoDichTienCoc.LEGACY_OPENING;
    }

    private BigDecimal money(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }

    private void logAudit(GiaoDichTienCoc movement, String hanhDong) {
        auditLogRepository.save(AuditLog.builder()
                .hanhDong(hanhDong).bangTacDong("giao_dich_tien_coc").banGhiId(movement.getId())
                .duLieuMoi("{\"hopDongId\":\"" + movement.getHopDong().getId() + "\",\"loai\":\""
                        + movement.getLoai() + "\",\"soTien\":\"" + movement.getSoTien() + "\"}")
                .taoLuc(ZonedDateTime.now()).build());
    }
}
