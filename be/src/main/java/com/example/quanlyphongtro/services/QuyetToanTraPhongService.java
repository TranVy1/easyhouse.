package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.QuyetToanTraPhongRepository;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.TaiSanPhongRepository;
import com.example.quanlyphongtro.repository.ChiTietBanGiaoTaiSanRepository;
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
    private final GiaoDichTienCocService giaoDichTienCocService;
    private final AuditLogRepository auditLogRepository;
    private final TaiSanPhongRepository taiSanPhongRepository;
    private final ChiTietBanGiaoTaiSanRepository chiTietBanGiaoRepository;

    @Transactional
    public QuyetToanTraPhongResponse tao(UUID hopDongId, TaoQuyetToanTraPhongRequest request) {
        HopDong hopDong = getWritableContract(hopDongId);
        QuyetToanTraPhong existing = quyetToanRepository.findByHopDongId(hopDongId).orElse(null);
        if (existing != null) {
            return toResponse(existing);
        }
        if (hopDong.getTrangThai() != TrangThaiHopDong.ACTIVE && hopDong.getTrangThai() != TrangThaiHopDong.EXPIRED) {
            throw new RuntimeException("Chỉ hợp đồng đang hoạt động hoặc đã hết hạn mới có thể lập quyết toán trả phòng");
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

        BigDecimal tienCoc = giaoDichTienCocService.soDu(hopDong.getId());
        HoaDonQuyetToanResult ketQuaHoaDon = hoaDonService.createFinalSettlement(hoaDonRequest, khoanKhauTru, tienCoc);
        BigDecimal tienCocDaCanTru = ketQuaHoaDon.getTienCocDaCanTru();
        BigDecimal tienCocCanHoan = tienCoc.subtract(tienCocDaCanTru);
        BigDecimal tienPhaiThuThem = money(ketQuaHoaDon.getHoaDon().getTongTien());
        TrangThaiQuyetToanTraPhong trangThai = tienPhaiThuThem.compareTo(BigDecimal.ZERO) > 0
                ? TrangThaiQuyetToanTraPhong.PENDING_PAYMENT
                : tienCocCanHoan.compareTo(BigDecimal.ZERO) > 0
                ? TrangThaiQuyetToanTraPhong.PENDING_REFUND
                : TrangThaiQuyetToanTraPhong.READY_FOR_HANDOVER;

        List<TaiSanPhong> taiSanPhongs = hopDong.getPhong() != null && hopDong.getPhong().getId() != null
                ? taiSanPhongRepository.findByPhongId(hopDong.getPhong().getId()) : Collections.emptyList();
        TrangThaiBienBanBanGiao bienBanTrangThai = taiSanPhongs.isEmpty()
                ? TrangThaiBienBanBanGiao.CHO_KY
                : TrangThaiBienBanBanGiao.CHUA_LAP;

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
                .bienBanTrangThai(bienBanTrangThai)
                .banGiaoDaXacNhan(false)
                .veSinhKiemTraXong(false)
                .ghiChu(request.getGhiChu())
                .build();
        QuyetToanTraPhong saved = quyetToanRepository.save(quyetToan);
        if (!taiSanPhongs.isEmpty()) {
            snapshotTaiSanBanGiao(saved, taiSanPhongs);
        }
        logAudit(saved, "CREATE_SETTLEMENT");
        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public QuyetToanTraPhongResponse getByHopDong(UUID hopDongId) {
        getReadableContract(hopDongId);
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
        if (money(quyetToan.getTienCocCanHoan()).compareTo(BigDecimal.ZERO) > 0
                && (request.getChungTuHoanCoc() == null || request.getChungTuHoanCoc().isBlank())) {
            throw new RuntimeException("Hoàn cọc phải có chứng từ hoặc mã biên nhận");
        }
        if (!Boolean.TRUE.equals(request.getBanGiaoDaXacNhan())) {
            throw new RuntimeException("Cần xác nhận bàn giao phòng");
        }
        if (chiTietBanGiaoRepository.findByQuyetToanTraPhongIdOrderByTaoLucAsc(quyetToan.getId()).stream()
                .anyMatch(item -> !Boolean.TRUE.equals(item.getDaXacNhan()))) {
            throw new RuntimeException("Cần kiểm kê và xác nhận đầy đủ từng tài sản phòng trước khi hoàn tất trả phòng");
        }
        if (!Boolean.TRUE.equals(request.getVeSinhKiemTraXong())) {
            throw new RuntimeException("Phòng chỉ được chuyển Trống sau khi vệ sinh và kiểm tra hoàn tất");
        }
        // Bien ban ban giao co chu ky hai ben la CAN CU phap ly cho viec tru tien
        // coc va boi thuong khau hao tai san. Bat buoc phai co day du chu ky cua ca 2 ben (Ben A va Ben B).
        if (quyetToan.getBienBanTrangThai() != TrangThaiBienBanBanGiao.HOAN_TAT) {
            throw new RuntimeException("Cần lập và ký biên bản bàn giao (đủ chữ ký của cả Chủ trọ và Khách thuê) trước khi hoàn tất trả phòng");
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
        giaoDichTienCocService.ghiNhanQuyetToan(quyetToan, request.getChungTuHoanCoc(), request.getMaThamChieuHoanCoc());
        logAudit(quyetToan, "COMPLETE_CHECKOUT");

        hopDong.setTrangThai(TrangThaiHopDong.TERMINATED);
        hopDong.setTrangThaiCoc(money(quyetToan.getTienCocDaCanTru()).compareTo(BigDecimal.ZERO) > 0
                ? TrangThaiCocHopDong.DEDUCTED : TrangThaiCocHopDong.REFUNDED);
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

    @Transactional
    public QuyetToanTraPhongResponse capNhatBanGiaoTaiSan(UUID hopDongId, BanGiaoTaiSanRequest request) {
        getWritableContract(hopDongId);
        QuyetToanTraPhong quyetToan = quyetToanRepository.findByHopDongId(hopDongId)
                .orElseThrow(() -> new RuntimeException("Cần lập quyết toán trả phòng trước khi kiểm kê tài sản"));
        if (quyetToan.getTrangThai() == TrangThaiQuyetToanTraPhong.COMPLETED) {
            throw new RuntimeException("Biên bản bàn giao đã hoàn tất và không thể sửa");
        }
        List<BanGiaoTaiSanRequest.Item> items = request.getItems() != null ? request.getItems() : Collections.emptyList();
        List<ChiTietBanGiaoTaiSan> snapshots = chiTietBanGiaoRepository.findByQuyetToanTraPhongIdOrderByTaoLucAsc(quyetToan.getId());
        if (items.size() != snapshots.size()) throw new RuntimeException("Cần kiểm kê đầy đủ mọi tài sản trong biên bản");
        for (ChiTietBanGiaoTaiSan snapshot : snapshots) {
            BanGiaoTaiSanRequest.Item item = items.stream().filter(candidate -> snapshot.getId().equals(candidate.getId())).findFirst()
                    .orElseThrow(() -> new RuntimeException("Thiếu kết quả kiểm kê tài sản " + snapshot.getTenTaiSan()));
            if (item.getSoLuongThucTe() == null || item.getSoLuongThucTe() < 0 || item.getSoLuongThucTe() > snapshot.getSoLuongBanDau()
                    || item.getTinhTrangThucTe() == null || item.getTinhTrangThucTe().isBlank()
                    || !Boolean.TRUE.equals(item.getDaXacNhan())) {
                throw new RuntimeException("Mỗi tài sản phải có số lượng thực tế hợp lệ, tình trạng và xác nhận bàn giao");
            }
            boolean hasDifference = !snapshot.getSoLuongBanDau().equals(item.getSoLuongThucTe())
                    || !snapshot.getTinhTrangBanDau().equalsIgnoreCase(item.getTinhTrangThucTe().trim());
            if (hasDifference && (item.getChungTuUrl() == null || item.getChungTuUrl().isBlank())) {
                throw new RuntimeException("Tài sản thiếu hoặc khác tình trạng phải có chứng từ/hình ảnh kèm theo");
            }
            snapshot.setSoLuongThucTe(item.getSoLuongThucTe());
            snapshot.setTinhTrangThucTe(item.getTinhTrangThucTe().trim());
            snapshot.setChungTuUrl(trimToNull(item.getChungTuUrl()));
            snapshot.setGhiChu(trimToNull(item.getGhiChu()));
            snapshot.setDaXacNhan(true);
            snapshot.setXacNhanLuc(ZonedDateTime.now());

            // Muc khau tru la can cu tru tien coc nen bat buoc phai co ly do,
            // neu khong thi khong giai trinh duoc voi khach khi tranh chap.
            BigDecimal khauTru = item.getMucKhauTru() != null ? item.getMucKhauTru() : BigDecimal.ZERO;
            if (khauTru.signum() < 0) {
                throw new RuntimeException("Mức khấu trừ không được âm");
            }
            if (khauTru.signum() > 0 && (item.getLyDoKhauTru() == null || item.getLyDoKhauTru().isBlank())) {
                throw new RuntimeException("Tài sản " + snapshot.getTenTaiSan()
                        + " có khấu trừ thì phải ghi rõ lý do");
            }
            snapshot.setMucKhauTru(khauTru);
            snapshot.setLyDoKhauTru(trimToNull(item.getLyDoKhauTru()));
        }
        chiTietBanGiaoRepository.saveAll(snapshots);

        // Kiem ke xong thi bien ban san sang cho hai ben ky. Khong tu nhay trang
        // thai neu bien ban da co chu ky, tranh xoa mat vet ky truoc do.
        if (quyetToan.getBienBanTrangThai() == TrangThaiBienBanBanGiao.CHUA_LAP) {
            quyetToan.setBienBanTrangThai(TrangThaiBienBanBanGiao.CHO_KY);
            quyetToanRepository.save(quyetToan);
        }

        logAudit(quyetToan, "CONFIRM_ASSET_HANDOVER");
        return toResponse(quyetToan);
    }

    private HopDong getReadableContract(UUID hopDongId) {
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.canReadHopDong(userId, hopDongId)) {
            throw new RuntimeException("Bạn không có quyền xem hợp đồng này");
        }
        return hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
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
        QuyetToanTraPhongResponse response = QuyetToanTraPhongResponse.fromEntity(entity, hoaDonService.getById(entity.getHoaDon().getId()));
        response.setTaiSanBanGiao(chiTietBanGiaoRepository.findByQuyetToanTraPhongIdOrderByTaoLucAsc(entity.getId()).stream()
                .map(ChiTietBanGiaoTaiSanResponse::fromEntity).toList());
        return response;
    }

    private void snapshotTaiSanBanGiao(QuyetToanTraPhong quyetToan, List<TaiSanPhong> taiSans) {
        List<ChiTietBanGiaoTaiSan> snapshots = taiSans.stream().map(asset ->
                ChiTietBanGiaoTaiSan.builder().quyetToanTraPhong(quyetToan).taiSanPhong(asset).tenTaiSan(asset.getTenTaiSan())
                        .soLuongBanDau(asset.getSoLuong()).tinhTrangBanDau(asset.getTinhTrang()).anhTaiSanBanDau(asset.getAnhTaiSan())
                        .mucKhauTru(BigDecimal.ZERO)
                        .daXacNhan(false).build()).toList();
        if (!snapshots.isEmpty()) chiTietBanGiaoRepository.saveAll(snapshots);
    }

    private String trimToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
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

    private void logAudit(QuyetToanTraPhong quyetToan, String hanhDong) {
        auditLogRepository.save(AuditLog.builder()
                .hanhDong(hanhDong)
                .bangTacDong("quyet_toan_tra_phong")
                .banGhiId(quyetToan.getId())
                .duLieuMoi("{\"hopDongId\":\"" + quyetToan.getHopDong().getId()
                        + "\",\"tienCocBanDau\":\"" + money(quyetToan.getTienCocBanDau())
                        + "\",\"tienCocDaCanTru\":\"" + money(quyetToan.getTienCocDaCanTru())
                        + "\",\"tienCocCanHoan\":\"" + money(quyetToan.getTienCocCanHoan()) + "\"}")
                .taoLuc(ZonedDateTime.now()).build());
    }
}
