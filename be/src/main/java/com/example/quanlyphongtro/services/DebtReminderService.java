package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.DebtReminderLogRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class DebtReminderService {

    private final HoaDonRepository hoaDonRepository;
    private final DebtReminderLogRepository logRepository;
    private final EmailService emailService;
    private final ThongBaoService thongBaoService;

    @Transactional
    public void runDailyDebtReminders() {
        log.info("Bắt đầu chạy luồng nhắc nợ tự động nhiều cấp...");
        List<HoaDon> invoices = hoaDonRepository.findByTrangThaiIn(List.of(
                TrangThaiHoaDon.ISSUED, TrangThaiHoaDon.UNPAID, TrangThaiHoaDon.OVERDUE));
        LocalDate today = LocalDate.now();

        for (HoaDon hd : invoices) {
            if (hd.getHanTra() == null) continue;

            long daysDiff = ChronoUnit.DAYS.between(hd.getHanTra(), today);

            // Update to OVERDUE if needed
            if (daysDiff > 0 && hd.getTrangThai() != TrangThaiHoaDon.OVERDUE) {
                hd.setTrangThai(TrangThaiHoaDon.OVERDUE);
                hoaDonRepository.save(hd);
            }

            ReminderType typeToTrigger = null;

            if (daysDiff == -3) {
                typeToTrigger = ReminderType.DUE_IN_3_DAYS;
            } else if (daysDiff == -1) {
                typeToTrigger = ReminderType.DUE_TOMORROW;
            } else if (daysDiff == 0) {
                typeToTrigger = ReminderType.DUE_TODAY;
            } else if (daysDiff == 1) {
                typeToTrigger = ReminderType.OVERDUE_1_DAY;
            } else if (daysDiff == 3) {
                typeToTrigger = ReminderType.OVERDUE_3_DAYS;
            } else if (daysDiff == 7) {
                typeToTrigger = ReminderType.OVERDUE_7_DAYS;
            } else if (daysDiff == 15) {
                typeToTrigger = ReminderType.OVERDUE_15_DAYS;
            } else if (daysDiff == 30) {
                typeToTrigger = ReminderType.OVERDUE_30_DAYS;
            }

            if (typeToTrigger != null) {
                processReminder(hd, typeToTrigger);
            }
        }
        log.info("Hoàn thành luồng nhắc nợ tự động.");
    }

    public void processReminder(HoaDon hd, ReminderType type) {
        KhachThue khachThue = hd.getKhachThue();
        if (khachThue == null) return;

        // 1. Gửi Email (nếu chưa gửi)
        String email = khachThue.getEmail();
        if (email != null && !email.isBlank()) {
            DebtReminderLog delivery = reserveDelivery(hd, type, ReminderChannel.EMAIL, null, email);
            if (delivery != null) {
                try {
                    sendReminderEmail(hd, type, email);
                    finishDelivery(delivery, "SENT", null);
                } catch (Exception e) {
                    finishDelivery(delivery, "FAILED", e.getMessage());
                }
            }
        }

        // 2. Gửi In-app Notification (nếu chưa gửi)
        if (khachThue.getNguoiDung() != null) {
            String contact = khachThue.getNguoiDung().getId().toString();
            DebtReminderLog delivery = reserveDelivery(hd, type, ReminderChannel.SYSTEM_NOTIFICATION,
                    khachThue.getNguoiDung(), contact);
            if (delivery != null) {
                try {
                    sendReminderNotification(hd, type, khachThue.getNguoiDung().getId());
                    finishDelivery(delivery, "SENT", null);
                } catch (Exception e) {
                    finishDelivery(delivery, "FAILED", e.getMessage());
                }
            }
        }

        // 3. Thông báo cho chủ trọ nếu nợ quá hạn >= 7 ngày
        if (type == ReminderType.OVERDUE_7_DAYS || type == ReminderType.OVERDUE_15_DAYS || type == ReminderType.OVERDUE_30_DAYS) {
            if (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null) {
                NguoiDung chuTroUser = hd.getPhong().getNhaTro().getChuTro();
                if (chuTroUser != null) {
                    String contact = chuTroUser.getId().toString();
                    DebtReminderLog delivery = reserveDelivery(hd, type, ReminderChannel.SYSTEM_NOTIFICATION,
                            chuTroUser, contact);
                    if (delivery != null) {
                        try {
                            thongBaoService.createSystemNotification(
                                    "Cảnh báo nợ nghiêm trọng: Hóa đơn phòng " + hd.getPhong().getTen(),
                                    "Hóa đơn " + hd.getMaHoaDon() + " đã quá hạn " + type.name() + ". Khách thuê: " + khachThue.getHoTen(),
                                    LoaiThongBao.INVOICE,
                                    List.of(chuTroUser.getId())
                            );
                            finishDelivery(delivery, "SENT", null);
                        } catch (Exception e) {
                            finishDelivery(delivery, "FAILED", e.getMessage());
                        }
                    }
                }
            }
        }
    }

    private void sendReminderEmail(HoaDon hd, ReminderType type, String email) {
        // Có thể gọi emailService.sendInvoiceUpcomingReminderEmail hoặc overdue, 
        // tùy theo Type. Ở đây tận dụng lại các hàm trong EmailService.
        if (type == ReminderType.DUE_IN_3_DAYS || type == ReminderType.DUE_TOMORROW
                || type == ReminderType.DUE_TODAY) {
            int days = type == ReminderType.DUE_IN_3_DAYS ? 3
                    : type == ReminderType.DUE_TOMORROW ? 1 : 0;
            emailService.sendInvoiceUpcomingReminderEmail(hd, hd.getKhachThue(), days);
        } else {
            emailService.sendInvoiceOverdueEmail(hd, hd.getKhachThue());
        }
    }

    private void sendReminderNotification(HoaDon hd, ReminderType type, UUID recipientId) {
        String title = "Nhắc nợ hóa đơn " + hd.getMaHoaDon();
        String body = "Hóa đơn của bạn có trạng thái: " + type.name() + ". Vui lòng thanh toán.";
        
        if (type == ReminderType.DUE_IN_3_DAYS || type == ReminderType.DUE_TOMORROW
                || type == ReminderType.DUE_TODAY) {
            title = "Hóa đơn sắp đến hạn " + hd.getMaHoaDon();
            body = type == ReminderType.DUE_TODAY
                    ? "Hóa đơn của bạn đến hạn thanh toán hôm nay. Vui lòng thanh toán đúng hạn."
                    : "Hóa đơn của bạn sắp đến hạn thanh toán. Vui lòng kiểm tra.";
        } else if (type == ReminderType.OVERDUE_1_DAY) {
            title = "Cảnh báo: Hóa đơn quá hạn " + hd.getMaHoaDon();
            body = "Hóa đơn của bạn đã quá hạn thanh toán 1 ngày.";
        } else {
            title = "Cảnh báo khẩn: Hóa đơn quá hạn " + hd.getMaHoaDon();
            body = "Hóa đơn đã quá hạn dài ngày (" + type.name() + "). Vui lòng thanh toán ngay để tránh bị phạt hoặc ảnh hưởng hợp đồng.";
        }
        thongBaoService.createSystemNotification(title, body, LoaiThongBao.INVOICE, List.of(recipientId));
    }

    private DebtReminderLog reserveDelivery(HoaDon hd, ReminderType type, ReminderChannel channel, NguoiDung recipient, String contact) {
        java.util.Optional<DebtReminderLog> existing = logRepository
                .findFirstByHoaDonIdAndReminderTypeAndChannelAndRecipientContactOrderBySentAtDesc(hd.getId(), type, channel, contact);
        if (existing.isPresent()) {
            DebtReminderLog delivery = existing.get();
            if ("SENT".equals(delivery.getStatus()) || "PENDING".equals(delivery.getStatus())) return null;
            delivery.setStatus("PENDING");
            delivery.setErrorMessage(null);
            return logRepository.save(delivery);
        }
        return logRepository.save(DebtReminderLog.builder()
                .hoaDon(hd).reminderType(type).channel(channel).recipient(recipient)
                .recipientContact(contact).status("PENDING").build());
    }

    private void finishDelivery(DebtReminderLog delivery, String status, String error) {
        delivery.setStatus(status);
        delivery.setErrorMessage(error);
        logRepository.save(delivery);
    }

    @Transactional
    public void processManualReminder(UUID hoaDonId) {
        HoaDon hd = hoaDonRepository.findById(hoaDonId).orElseThrow();
        if (hd.getTrangThai() == TrangThaiHoaDon.PAID) {
            throw new RuntimeException("Hóa đơn đã thanh toán");
        }
        processReminder(hd, ReminderType.MANUAL);
    }
}
