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
                        ThongBaoRequest landlordNotification = new ThongBaoRequest();
                        landlordNotification.setTieuDe("Cảnh báo: Hợp đồng phòng " + hd.getPhong().getTen() + " sắp hết hạn");
                        landlordNotification.setNoiDung("Hợp đồng mã " + hd.getMaHopDong() + " của phòng " + hd.getPhong().getTen() + 
                                " (" + hd.getKhachThue().getHoTen() + ") sẽ hết hạn sau " + daysRemaining + " ngày (ngày " + hd.getNgayKetThuc() + ").");
                        landlordNotification.setLoai("hopDong");
                        landlordNotification.setNguoiNhan(List.of(hd.getPhong().getNhaTro().getChuTro().getId()));
                        thongBaoService.create(landlordNotification);
                    }

                    // 2. Gửi thông báo In-app cho Khách thuê
                    ThongBaoRequest tenantNotification = new ThongBaoRequest();
                    tenantNotification.setTieuDe("Thông báo: Hợp đồng thuê phòng sắp hết hạn");
                    tenantNotification.setNoiDung("Hợp đồng thuê phòng của bạn (Mã: " + hd.getMaHopDong() + ", Phòng: " + 
                            (hd.getPhong() != null ? hd.getPhong().getTen() : "N/A") + ") sẽ hết hạn sau " + daysRemaining + 
                            " ngày (ngày " + hd.getNgayKetThuc() + "). Vui lòng liên hệ chủ trọ để tiến hành gia hạn hoặc thanh lý phòng.");
                    tenantNotification.setLoai("hopDong");
                    tenantNotification.setNguoiNhan(List.of(hd.getKhachThue().getId()));
                    thongBaoService.create(tenantNotification);

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
                    ThongBaoRequest landlordNotification = new ThongBaoRequest();
                    landlordNotification.setTieuDe("Cảnh báo quá hạn: Hóa đơn phòng " + hd.getPhong().getTen());
                    landlordNotification.setNoiDung("Hóa đơn kỳ " + hd.getKyThang() + "/" + hd.getKyNam() + " (Mã: " + hd.getMaHoaDon() + 
                            ") của phòng " + hd.getPhong().getTen() + " (" + hd.getKhachThue().getHoTen() + 
                            ") đã quá hạn thanh toán (hạn trả: " + hd.getHanTra() + ").");
                    landlordNotification.setLoai("hoaDon");
                    landlordNotification.setNguoiNhan(List.of(hd.getPhong().getNhaTro().getChuTro().getId()));
                    thongBaoService.create(landlordNotification);
                }

                // 2. Gửi thông báo In-app cho Khách thuê
                ThongBaoRequest tenantNotification = new ThongBaoRequest();
                tenantNotification.setTieuDe("Cảnh báo: Hóa đơn tiền phòng quá hạn thanh toán");
                tenantNotification.setNoiDung("Hóa đơn kỳ " + hd.getKyThang() + "/" + hd.getKyNam() + " (Mã: " + hd.getMaHoaDon() + 
                        ") của bạn đã quá hạn thanh toán từ ngày " + hd.getHanTra() + ". Vui lòng hoàn thành thanh toán sớm nhất.");
                tenantNotification.setLoai("hoaDon");
                tenantNotification.setNguoiNhan(List.of(hd.getKhachThue().getId()));
                thongBaoService.create(tenantNotification);

                // 3. Gửi Email nhắc nhở cho Khách thuê
                emailService.sendInvoiceOverdueEmail(hd, hd.getKhachThue());

            } catch (Exception e) {
                log.error("Lỗi xử lý hóa đơn quá hạn {}: {}", hd.getMaHoaDon(), e.getMessage());
            }
        }
    }
}
