package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.QuyetToanTraPhongRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class QuyetToanTraPhongService {
    private final QuyetToanTraPhongRepository quyetToanRepository;
    private final HopDongRepository hopDongRepository;
    private final HoaDonRepository hoaDonRepository;
    private final PhongRepository phongRepository;
    private final HoaDonService hoaDonService;
    private final PermissionService permissionService;
    private final ObjectMapper objectMapper;

    @Transactional
    public QuyetToanTraPhongResponse tao(UUID hopDongId, TaoQuyetToanTraPhongRequest request) {
        HopDong hopDong = getWritableContract(hopDongId);
        QuyetToanTraPhong existing = quyetToanRepository.findByHopDongId(hopDongId).orElse(null);
        if (existing != null) {
            return toResponse(existing);
        }
        if (hopDong.getTrangThai() != TrangThaiHopDong.ACTIVE) {
            throw new RuntimeException("Chỉ hợp đồng đang hoạt động mới có thể lập quyết toán trả phòng");
        }

        LocalDate ngayTraPhong = request.getNgayTraPhong() != null ? request.getNgayTraPhong() : LocalDate.now();
        if (hopDong.getNgayBatDau() != null && ngayTraPhong.isBefore(hopDong.getNgayBatDau())) {
            throw new RuntimeException("Ngày trả phòng không được trước ngày bắt đầu hợp đồng");
        }
        List<KhoanKhauTruCocRequest> khoanKhauTru = request.getKhoanKhauTru() != null
                ? request.getKhoanKhauTru() : Collections.emptyList();
        validateDeductions(khoanKhauTru);

        // Chốt ngày thực tế trước khi tính để tiền phòng cuối kỳ được prorate đúng số ngày ở.
        hopDong.setNgayKetThucThucTe(ngayTraPhong);
        hopDongRepository.save(hopDong);

        HoaDonRequest hoaDonRequest = new HoaDonRequest();
        hoaDonRequest.setHopDong(hopDong.getId());
        hoaDonRequest.setKyNam(ngayTraPhong.getYear());
        hoaDonRequest.setKyThang(ngayTraPhong.getMonthValue());
        hoaDonRequest.setTuNgay(ngayTraPhong.withDayOfMonth(1));
        hoaDonRequest.setDenNgay(ngayTraPhong);
        hoaDonRequest.setHanTra(LocalDate.of(ngayTraPhong.getYear(), ngayTraPhong.getMonthValue(), 5));
        hoaDonRequest.setChiSoDienBanDau(request.getChiSoDienBanDau());
        hoaDonRequest.setChiSoDienCuoiKy(request.getChiSoDienCuoiKy());
        hoaDonRequest.setChiSoNuocBanDau(request.getChiSoNuocBanDau());
        hoaDonRequest.setChiSoNuocCuoiKy(request.getChiSoNuocCuoiKy());
        hoaDonRequest.setGhiChu("Hóa đơn quyết toán trả phòng");

        BigDecimal tienCoc = money(hopDong.getTienCoc());
        HoaDonQuyetToanResult ketQuaHoaDon = hoaDonService.createFinalSettlement(hoaDonRequest, khoanKhauTru, tienCoc);
        BigDecimal tienCocDaCanTru = ketQuaHoaDon.getTienCocDaCanTru();
        BigDecimal tienCocCanHoan = tienCoc.subtract(tienCocDaCanTru);
        BigDecimal tienPhaiThuThem = money(ketQuaHoaDon.getHoaDon().getTongTien());
        TrangThaiQuyetToanTraPhong trangThai = tienPhaiThuThem.compareTo(BigDecimal.ZERO) > 0
                ? TrangThaiQuyetToanTraPhong.PENDING_PAYMENT
                : tienCocCanHoan.compareTo(BigDecimal.ZERO) > 0
                ? TrangThaiQuyetToanTraPhong.PENDING_REFUND
                : TrangThaiQuyetToanTraPhong.READY_FOR_HANDOVER;

        QuyetToanTraPhong quyetToan = QuyetToanTraPhong.builder()
                .hopDong(hopDong)
                .hoaDon(hoaDonRepository.findById(ketQuaHoaDon.getHoaDon().getId())
                        .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn quyết toán")))
                .ngayTraPhong(ngayTraPhong)
                .tienCocBanDau(tienCoc)
                .tienCocDaCanTru(tienCocDaCanTru)
                .tienCocCanHoan(tienCocCanHoan)
                .tienPhaiThuThem(tienPhaiThuThem)
                .khoanKhauTru(toJson(khoanKhauTru))
                .trangThai(trangThai)
                .banGiaoDaXacNhan(false)
                .veSinhKiemTraXong(false)
                .ghiChu(request.getGhiChu())
                .build();
        return toResponse(quyetToanRepository.save(quyetToan));
    }

    @Transactional(readOnly = true)
    public QuyetToanTraPhongResponse getByHopDong(UUID hopDongId) {
        getWritableContract(hopDongId);
        QuyetToanTraPhong quyetToan = quyetToanRepository.findByHopDongId(hopDongId)
                .orElseThrow(() -> new RuntimeException("Chưa có quyết toán trả phòng cho hợp đồng này"));
        return toResponse(quyetToan);
    }

    @Transactional
    public HopDongResponse hoanTat(UUID hopDongId, HoanTatQuyetToanTraPhongRequest request) {
        HopDong hopDong = getWritableContract(hopDongId);
        QuyetToanTraPhong quyetToan = quyetToanRepository.findByHopDongId(hopDongId)
                .orElseThrow(() -> new RuntimeException("Cần lập quyết toán trả phòng trước khi kết thúc hợp đồng"));
        if (quyetToan.getTrangThai() == TrangThaiQuyetToanTraPhong.COMPLETED) {
            return HopDongResponse.fromEntity(hopDong);
        }
        HoaDonResponse hoaDon = hoaDonService.getById(quyetToan.getHoaDon().getId());
        if (money(quyetToan.getTienPhaiThuThem()).compareTo(BigDecimal.ZERO) > 0 && !"PAID".equals(hoaDon.getTrangThai())) {
            throw new RuntimeException("Hóa đơn quyết toán phải được thanh toán đủ trước khi hoàn tất trả phòng");
        }
        if (money(quyetToan.getTienCocCanHoan()).compareTo(BigDecimal.ZERO) > 0 && !Boolean.TRUE.equals(request.getDaHoanCoc())) {
            throw new RuntimeException("Cần xác nhận đã hoàn phần cọc dư cho khách thuê");
        }
        if (!Boolean.TRUE.equals(request.getBanGiaoDaXacNhan())) {
            throw new RuntimeException("Cần xác nhận bàn giao phòng");
        }
        if (!Boolean.TRUE.equals(request.getVeSinhKiemTraXong())) {
            throw new RuntimeException("Phòng chỉ được chuyển Trống sau khi vệ sinh và kiểm tra hoàn tất");
        }

        ZonedDateTime now = ZonedDateTime.now();
        if (Boolean.TRUE.equals(request.getDaHoanCoc())) quyetToan.setHoanCocLuc(now);
        quyetToan.setBanGiaoDaXacNhan(true);
        quyetToan.setVeSinhKiemTraXong(true);
        quyetToan.setBanGiaoLuc(now);
        quyetToan.setKiemTraLuc(now);
        quyetToan.setHoanTatLuc(now);
        quyetToan.setTrangThai(TrangThaiQuyetToanTraPhong.COMPLETED);
        if (request.getGhiChu() != null && !request.getGhiChu().isBlank()) quyetToan.setGhiChu(request.getGhiChu().trim());
        quyetToanRepository.save(quyetToan);

        hopDong.setTrangThai(TrangThaiHopDong.TERMINATED);
        hopDong.setTrangThaiCoc(money(quyetToan.getTienCocDaCanTru()).compareTo(BigDecimal.ZERO) > 0
                ? TrangThaiCocHopDong.DEDUCTED : TrangThaiCocHopDong.REFUNDED);
        hopDong.setTienCoc(BigDecimal.ZERO);
        hopDongRepository.save(hopDong);

        Phong phong = hopDong.getPhong();
        if (phong != null && phong.getId() != null) {
            boolean conHopDongChiếmPhong = hopDongRepository.findRoomOccupyingContracts(
                    phong.getId(), List.of(TrangThaiHopDong.PENDING, TrangThaiHopDong.ACTIVE)).stream()
                    .anyMatch(item -> !item.getId().equals(hopDong.getId()));
            if (!conHopDongChiếmPhong && phong.getTrangThai() != TrangThaiPhong.INACTIVE) {
                phong.setTrangThai(TrangThaiPhong.AVAILABLE);
                phongRepository.save(phong);
            }
        }
        return HopDongResponse.fromEntity(hopDong);
    }

    private HopDong getWritableContract(UUID hopDongId) {
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.canWriteHopDong(userId, hopDongId)) {
            throw new RuntimeException("Bạn không có quyền cập nhật hợp đồng này");
        }
        return hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
    }

    private void validateDeductions(List<KhoanKhauTruCocRequest> deductions) {
        for (KhoanKhauTruCocRequest item : deductions) {
            if (item == null || item.getSoTien() == null || item.getSoTien().compareTo(BigDecimal.ZERO) <= 0
                    || item.getMoTa() == null || item.getMoTa().isBlank()
                    || item.getChungTuUrl() == null || item.getChungTuUrl().isBlank()) {
                throw new RuntimeException("Mỗi khoản khấu trừ cọc phải có mô tả, số tiền dương và chứng từ");
            }
        }
    }

    private QuyetToanTraPhongResponse toResponse(QuyetToanTraPhong entity) {
        return QuyetToanTraPhongResponse.fromEntity(entity, hoaDonService.getById(entity.getHoaDon().getId()));
    }

    private String toJson(List<KhoanKhauTruCocRequest> deductions) {
        try {
            return objectMapper.writeValueAsString(deductions);
        } catch (JsonProcessingException exception) {
            throw new RuntimeException("Không thể lưu chứng từ khấu trừ cọc", exception);
        }
    }

    private BigDecimal money(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }
}
