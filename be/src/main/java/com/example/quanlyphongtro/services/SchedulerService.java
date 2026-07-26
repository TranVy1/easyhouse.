package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThongBaoRequest;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.TrangThaiHoaDon;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class SchedulerService {

    private final HopDongRepository hopDongRepository;
    private final HoaDonRepository hoaDonRepository;
    private final com.example.quanlyphongtro.repository.LichHenRepository lichHenRepository;
    private final ThongBaoService thongBaoService;
    private final EmailService emailService;
    @org.springframework.context.annotation.Lazy
    @org.springframework.beans.factory.annotation.Autowired
    private HopDongService hopDongService;

    @org.springframework.context.annotation.Lazy
    @org.springframework.beans.factory.annotation.Autowired
    private ChatMembershipService chatMembershipService;

    /**
     * Doi soat thanh vien nhom chat tu dong (nhom theo nha tro / theo tang).
     *
     * Chay 3:30 sang, tach hoan toan khoi runDailyChecks luc 7:00:
     *   - khong dung chung transaction, nen dong bo chat hong khong lam quay lui
     *     viec nhac no va gia han hop dong
     *   - moi nguoi dung la mot transaction rieng, tranh giu ket noi DB qua lau
     *
     * Lop nay chi de bat nhung truong hop lop dong bo lazy khong cham toi (nguoi
     * khong bao gio mo trang tin nhan).
     */
    @Scheduled(cron = "0 30 3 * * ?")
    public void doiSoatNhomChat() {
        List<java.util.UUID> nguoiDungIds = chatMembershipService.danhSachNguoiDungDangThue();
        log.info("Bat dau doi soat nhom chat cho {} nguoi dung...", nguoiDungIds.size());

        int loi = 0;
        for (java.util.UUID nguoiDungId : nguoiDungIds) {
            try {
                chatMembershipService.dongBoChoNguoiDung(nguoiDungId);
            } catch (RuntimeException ex) {
                loi++;
                log.warn("Doi soat nhom chat that bai cho {}: {}", nguoiDungId, ex.getMessage());
            }
        }
        log.info("Hoan thanh doi soat nhom chat. Loi: {}/{}", loi, nguoiDungIds.size());
    }

    /**
     * Chạy mỗi ngày lúc 7:00 AM để quét các hợp đồng sắp hết hạn và nhắc nợ quá hạn.
     */
    @Scheduled(cron = "0 0 7 * * ?")
    @Transactional
    public void runDailyChecks() {
        log.info("Bắt đầu chạy quét kiểm tra hợp đồng và hóa đơn hàng ngày...");
        checkExpiringContracts();
        checkInvoices();
        checkPendingContracts();
        log.info("Hoàn thành quét kiểm tra hàng ngày.");
    }

    /**
     * Kiểm tra và hủy các hợp đồng treo (PENDING) chưa đóng cọc sau 24h.
     */
    @Transactional
    public void checkPendingContracts() {
        log.info("Đang kiểm tra các hợp đồng treo chưa đóng cọc...");
        java.time.ZonedDateTime limitDate = java.time.ZonedDateTime.now().minusHours(24);
        List<HopDong> pendingContracts = hopDongRepository.findPendingContractsBefore(
                TrangThaiHopDong.PENDING, 
                com.example.quanlyphongtro.entity.TrangThaiCocHopDong.NOT_PAID, 
                limitDate
        );

        for (HopDong hd : pendingContracts) {
            log.info("Hủy hợp đồng {} do quá 24h chưa thanh toán cọc.", hd.getMaHopDong());
            hd.setTrangThai(TrangThaiHopDong.CANCELLED);
            hd.setGhiChu((hd.getGhiChu() == null ? "" : hd.getGhiChu() + "\n") + "Tự động hủy do quá hạn thanh toán cọc 24h.");
            hopDongRepository.save(hd);
            
            // Gửi thông báo cho khách thuê
            if (hd.getKhachThue() != null) {
                thongBaoService.createSystemNotification(
                        "Hủy hợp đồng do quá hạn cọc",
                        "Hợp đồng " + hd.getMaHopDong() + " của bạn đã bị hủy do quá 24h không thanh toán tiền cọc.",
                        com.example.quanlyphongtro.entity.LoaiThongBao.CONTRACT,
                        List.of(hd.getKhachThue().getId())
                );
            }
        }
    }

    /**
     * Kiểm tra hợp đồng sắp hết hạn.
     */
    @Transactional
    public void checkExpiringContracts() {
        log.info("Đang kiểm tra hợp đồng sắp hết hạn...");
        List<HopDong> activeContracts = hopDongRepository.findAllActive();
        LocalDate today = LocalDate.now();

        for (HopDong hd : activeContracts) {
            if (hd.getNgayBatDau() == null || hd.getNgayKetThuc() == null || hd.getKhachThue() == null) {
                continue;
            }

            long totalDurationDays = ChronoUnit.DAYS.between(hd.getNgayBatDau(), hd.getNgayKetThuc());
            long daysRemaining = ChronoUnit.DAYS.between(today, hd.getNgayKetThuc());

            boolean shouldAlert = false;
            if (totalDurationDays < 180) { // Ngắn hạn (< 6 tháng): Báo trước 7 ngày
                shouldAlert = (daysRemaining == 7);
            } else if (totalDurationDays < 365) { // Trung hạn (6-12 tháng): Báo trước 15 ngày
                shouldAlert = (daysRemaining == 15);
            } else { // Dài hạn (>= 12 tháng): Báo trước 30 ngày
                shouldAlert = (daysRemaining == 30);
            }

            if (shouldAlert) {
                log.info("Hợp đồng {} hết hạn sau {} ngày. Tiến hành gửi thông báo.", hd.getMaHopDong(), daysRemaining);
                try {
                    // 1. Gửi thông báo In-app cho Chủ trọ
                    if (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null) {
                        thongBaoService.createSystemNotification(
                                "Cảnh báo: Hợp đồng phòng " + hd.getPhong().getTen() + " sắp hết hạn",
                                "Hợp đồng mã " + hd.getMaHopDong() + " của phòng " + hd.getPhong().getTen() + 
                                " (" + hd.getKhachThue().getHoTen() + ") sẽ hết hạn sau " + daysRemaining + " ngày (ngày " + hd.getNgayKetThuc() + ").",
                                com.example.quanlyphongtro.entity.LoaiThongBao.CONTRACT,
                                List.of(hd.getPhong().getNhaTro().getChuTro().getId())
                        );
                    }

                    // 2. Gửi thông báo In-app cho Khách thuê
                    thongBaoService.createSystemNotification(
                            "Thông báo: Hợp đồng thuê phòng sắp hết hạn",
                            "Hợp đồng thuê phòng của bạn (Mã: " + hd.getMaHopDong() + ", Phòng: " + 
                            (hd.getPhong() != null ? hd.getPhong().getTen() : "N/A") + ") sẽ hết hạn sau " + daysRemaining + 
                            " ngày (ngày " + hd.getNgayKetThuc() + "). Vui lòng liên hệ chủ trọ để tiến hành gia hạn hoặc thanh lý phòng.",
                            com.example.quanlyphongtro.entity.LoaiThongBao.CONTRACT,
                            List.of(hd.getKhachThue().getId())
                    );

                    // 3. Gửi Email cho Khách thuê
                    emailService.sendContractExpiringEmail(hd, hd.getKhachThue(), (int) daysRemaining);

                    // 4. Gia hạn tự động nếu được bật
                    if (Boolean.TRUE.equals(hd.getTuDongGiaHan()) && daysRemaining <= 7) {
                        // Kiểm tra xem đã gia hạn chưa (dựa vào contract DRAFT mới nhất của phòng này)
                        boolean alreadyRenewed = hopDongRepository.existsByPhongAndKhachThueAndNgayBatDauAfter(
                            hd.getPhong(), hd.getKhachThue(), hd.getNgayKetThuc().minusDays(1));
                        
                        if (!alreadyRenewed) {
                            log.info("Tự động gia hạn hợp đồng {}...", hd.getMaHopDong());
                            hopDongService.renewContract(hd.getId());
                            
                            // Gửi thông báo cho Chủ trọ về việc đã tạo hợp đồng gia hạn (DRAFT)
                            if (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null) {
                                thongBaoService.createSystemNotification(
                                        "Hệ thống: Đã tự động tạo bản nháp gia hạn hợp đồng",
                                        "Hợp đồng phòng " + hd.getPhong().getTen() + " đã được hệ thống tự động tạo bản nháp gia hạn. Vui lòng vào kiểm tra và xác nhận.",
                                        com.example.quanlyphongtro.entity.LoaiThongBao.CONTRACT,
                                        List.of(hd.getPhong().getNhaTro().getChuTro().getId())
                                );
                            }
                        }
                    }

                } catch (Exception e) {
                    log.error("Lỗi gửi thông báo hoặc gia hạn cho hợp đồng {}: {}", hd.getMaHopDong(), e.getMessage());
                }
            }
        }
    }

    @org.springframework.beans.factory.annotation.Autowired
    private DebtReminderService debtReminderService;

    /**
     * Kiểm tra hóa đơn quá hạn và sắp đến hạn bằng DebtReminderService mới.
     */
    @Transactional
    public void checkInvoices() {
        debtReminderService.runDailyDebtReminders();
    }

    /**
     * Chay moi gio de quet lich hen trong vong 24h toi de gui email nhac nho.
     */
    @Scheduled(cron = "0 0 * * * ?")
    @Transactional
    public void checkUpcomingAppointments() {
        log.info("Dang kiem tra lich hen sap dien ra...");
        java.time.ZonedDateTime now = java.time.ZonedDateTime.now();
        java.time.ZonedDateTime next24h = now.plusHours(24);
        
        List<com.example.quanlyphongtro.entity.LichHen> upcoming = lichHenRepository.findUpcomingAppointments(
            List.of(com.example.quanlyphongtro.entity.TrangThaiLichHen.PENDING, com.example.quanlyphongtro.entity.TrangThaiLichHen.CONFIRMED),
            now, next24h
        );
        
        for (com.example.quanlyphongtro.entity.LichHen lh : upcoming) {
            log.info("Gui nhac nho lich hen {} vao luc {}", lh.getId(), lh.getNgayHen());
            emailService.sendAppointmentReminderEmail(lh);
            lh.setDaGuiNhacNho(true);
            lichHenRepository.save(lh);
        }
    }
}
