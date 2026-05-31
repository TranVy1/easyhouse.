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

    /**
     * Chạy mỗi ngày lúc 7:00 AM để quét các hợp đồng sắp hết hạn và nhắc nợ quá hạn.
     */
    @Scheduled(cron = "0 0 7 * * ?")
    @Transactional
    public void runDailyChecks() {
        log.info("Bắt đầu chạy quét kiểm tra hợp đồng và hóa đơn hàng ngày...");
        checkExpiringContracts();
        checkOverdueInvoices();
        checkUpcomingInvoices();
        log.info("Hoàn thành quét kiểm tra hàng ngày.");
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

                } catch (Exception e) {
                    log.error("Lỗi gửi thông báo cho hợp đồng {}: {}", hd.getMaHopDong(), e.getMessage());
                }
            }
        }
    }

    /**
     * Kiểm tra hóa đơn quá hạn.
     */
    @Transactional
    public void checkOverdueInvoices() {
        log.info("Đang kiểm tra hóa đơn quá hạn thanh toán...");
        LocalDate today = LocalDate.now();
        List<HoaDon> unpaidInvoices = hoaDonRepository.findOverdueInvoices(
                List.of(TrangThaiHoaDon.UNPAID, TrangThaiHoaDon.PARTIAL), today);

        for (HoaDon hd : unpaidInvoices) {
            log.info("Hóa đơn {} (hạn trả {}) đã quá hạn. Đang cập nhật trạng thái...", hd.getMaHoaDon(), hd.getHanTra());
            hd.setTrangThai(TrangThaiHoaDon.OVERDUE);
            hoaDonRepository.save(hd);

            try {
                // 1. Gửi thông báo In-app cho Chủ trọ
                if (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null) {
                    thongBaoService.createSystemNotification(
                            "Cảnh báo quá hạn: Hóa đơn phòng " + hd.getPhong().getTen(),
                            "Hóa đơn kỳ " + hd.getKyThang() + "/" + hd.getKyNam() + " (Mã: " + hd.getMaHoaDon() + 
                            ") của phòng " + hd.getPhong().getTen() + " (" + hd.getKhachThue().getHoTen() + 
                            ") đã quá hạn thanh toán (hạn trả: " + hd.getHanTra() + ").",
                            com.example.quanlyphongtro.entity.LoaiThongBao.INVOICE,
                            List.of(hd.getPhong().getNhaTro().getChuTro().getId())
                    );
                }

                // 2. Gửi thông báo In-app cho Khách thuê
                thongBaoService.createSystemNotification(
                        "Cảnh báo: Hóa đơn tiền phòng quá hạn thanh toán",
                        "Hóa đơn kỳ " + hd.getKyThang() + "/" + hd.getKyNam() + " (Mã: " + hd.getMaHoaDon() + 
                        ") của bạn đã quá hạn thanh toán từ ngày " + hd.getHanTra() + ". Vui lòng hoàn thành thanh toán sớm nhất.",
                        com.example.quanlyphongtro.entity.LoaiThongBao.INVOICE,
                        List.of(hd.getKhachThue().getId())
                );

                // 3. Gửi Email nhắc nhở cho Khách thuê
                emailService.sendInvoiceOverdueEmail(hd, hd.getKhachThue());

            } catch (Exception e) {
                log.error("Lỗi xử lý hóa đơn quá hạn {}: {}", hd.getMaHoaDon(), e.getMessage());
            }
        }
    }

    /**
     * Kiểm tra và nhắc nhở hóa đơn sắp đến hạn thanh toán (còn 2 ngày).
     */
    @Transactional
    public void checkUpcomingInvoices() {
        log.info("Đang kiểm tra hóa đơn sắp đến hạn thanh toán...");
        LocalDate targetDate = LocalDate.now().plusDays(2);
        List<HoaDon> upcomingInvoices = hoaDonRepository.findUnpaidInvoicesDueOn(
                List.of(TrangThaiHoaDon.UNPAID, TrangThaiHoaDon.PARTIAL), targetDate);

        for (HoaDon hd : upcomingInvoices) {
            log.info("Hóa đơn {} (hạn trả {}) sắp đến hạn. Đang gửi thông báo...", hd.getMaHoaDon(), hd.getHanTra());
            try {
                // 1. Gửi thông báo In-app cho Khách thuê
                thongBaoService.createSystemNotification(
                        "Thông báo: Hóa đơn tiền phòng sắp đến hạn thanh toán",
                        "Hóa đơn kỳ " + hd.getKyThang() + "/" + hd.getKyNam() + " (Mã: " + hd.getMaHoaDon() + 
                        ") của bạn sắp đến hạn thanh toán vào ngày " + hd.getHanTra() + " (còn 2 ngày). Vui lòng hoàn thành thanh toán đúng hạn.",
                        com.example.quanlyphongtro.entity.LoaiThongBao.INVOICE,
                        List.of(hd.getKhachThue().getId())
                );

                // 2. Gửi Email nhắc nhở cho Khách thuê
                emailService.sendInvoiceUpcomingReminderEmail(hd, hd.getKhachThue(), 2);

            } catch (Exception e) {
                log.error("Lỗi xử lý nhắc nhở hóa đơn sắp đến hạn {}: {}", hd.getMaHoaDon(), e.getMessage());
            }
        }
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
