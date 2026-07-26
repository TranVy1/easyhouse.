package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.EmailVerificationToken;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.LichHen;
import com.example.quanlyphongtro.repository.EmailVerificationTokenRepository;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.UUID;
import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender mailSender;
    private final EmailVerificationTokenRepository tokenRepository;

    @Value("${app.frontend.base-url:http://localhost:3000}")
    private String frontendBaseUrl;

    @Value("${spring.mail.username:noreply@easyhouse.vn}")
    private String fromEmail;

    /**
     * Create a verification token and send the confirmation email.
     */
    @Transactional
    public void sendVerificationEmail(NguoiDung user) {
        // Delete any existing tokens for this user
        tokenRepository.deleteByNguoiDungId(user.getId());

        // Create a new token valid for 24 hours
        String tokenValue = UUID.randomUUID().toString();
        EmailVerificationToken token = EmailVerificationToken.builder()
                .nguoiDung(user)
                .token(tokenValue)
                .ngayHetHan(ZonedDateTime.now().plusHours(24))
                .build();
        tokenRepository.save(token);

        // Build the verification link
        String verifyUrl = frontendBaseUrl + "/xac-thuc-email?token=" + tokenValue;

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(user.getEmail());
            message.setSubject("[EasyHouse] Xác thực email đăng ký");
            message.setText(
                "Xin chào " + user.getHoTen() + ",\n\n" +
                "Cảm ơn bạn đã đăng ký tài khoản EasyHouse.\n" +
                "Vui lòng nhấn vào link bên dưới để xác thực email:\n\n" +
                verifyUrl + "\n\n" +
                "Link sẽ hết hạn sau 24 giờ.\n\n" +
                "Trân trọng,\nĐội ngũ EasyHouse"
            );
            mailSender.send(message);
            log.info("Verification email sent to {}", user.getEmail());
        } catch (Exception e) {
            log.error("Failed to send verification email to {}: {}", user.getEmail(), e.getMessage());
            // Don't throw – registration should still succeed even if mail fails
        }
    }

    public void sendTemporaryPasswordEmail(NguoiDung user, String temporaryPassword) {
        if (user == null || user.getEmail() == null || temporaryPassword == null || temporaryPassword.isBlank()) {
            return;
        }

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(user.getEmail());
            message.setSubject("[EasyHouse] Dat lai mat khau");
            message.setText(
                    "Xin chao " + user.getHoTen() + ",\n\n" +
                    "Mat khau tam thoi cua ban la:\n\n" +
                    temporaryPassword + "\n\n" +
                    "Vui long dang nhap va doi mat khau ngay sau khi truy cap lai tai khoan.\n" +
                    "Neu ban khong yeu cau dat lai mat khau, vui long lien he quan tri vien.\n\n" +
                    "Tran trong,\nDoi ngu EasyHouse"
            );
            mailSender.send(message);
            log.info("Temporary password email sent to {}", user.getEmail());
        } catch (Exception e) {
            log.error("Failed to send temporary password email to {}: {}", user.getEmail(), e.getMessage());
            throw new RuntimeException("Khong the gui email dat lai mat khau");
        }
    }

    /**
     * Verify the token string and activate the user account.
     * @return the verified user, or null if token is invalid/expired.
     */
    @Transactional
    public NguoiDung verifyToken(String tokenValue) {
        EmailVerificationToken token = tokenRepository.findByToken(tokenValue)
                .orElse(null);
        if (token == null) return null;
        if (token.getNgayHetHan().isBefore(ZonedDateTime.now())) {
            tokenRepository.delete(token);
            return null;
        }

        NguoiDung user = token.getNguoiDung();
        // Mark email as verified by setting trangThai to ACTIVE (if it was PENDING)
        if (user.getTrangThai() == com.example.quanlyphongtro.entity.TrangThaiNguoiDung.INACTIVE) {
            user.setTrangThai(com.example.quanlyphongtro.entity.TrangThaiNguoiDung.ACTIVE);
        }
        tokenRepository.delete(token);
        return user;
    }

    private String formatMoney(BigDecimal amount) {
        if (amount == null) return "0 VNĐ";
        return String.format("%,.0f VNĐ", amount);
    }

    // ── HTML Email Helpers ──────────────────────────────────────────────

    private void sendHtmlEmail(String to, String subject, String htmlContent) throws Exception {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
        helper.setFrom(fromEmail);
        helper.setTo(to);
        helper.setSubject(subject);
        helper.setText(htmlContent, true);
        mailSender.send(mimeMessage);
    }

    private String formatNgayHenVi(ZonedDateTime ngayHen) {
        if (ngayHen == null) return "Chưa xác định";
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("HH:mm - EEEE, dd/MM/yyyy", new Locale("vi", "VN"));
        return ngayHen.format(fmt);
    }

    private String buildAppointmentHtmlTemplate(String title, String statusColor, String statusLabel,
                                                 String greeting, String mainMessage,
                                                 LichHen lh, String adminNote, String footerNote) {
        String phongTen = (lh.getPhong() != null) ? lh.getPhong().getTen() : "N/A";
        String diaChi = (lh.getPhong() != null && lh.getPhong().getNhaTro() != null)
                ? lh.getPhong().getNhaTro().getDiaChi() : "N/A";
        String thoiGian = formatNgayHenVi(lh.getNgayHen());

        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html>");
        sb.append("<html lang='vi'><head><meta charset='UTF-8'>");
        sb.append("<meta name='viewport' content='width=device-width,initial-scale=1'>");
        sb.append("<title>").append(title).append("</title></head>");
        sb.append("<body style='margin:0;padding:0;background-color:#f1f5f9;font-family:Inter,Segoe UI,Roboto,Helvetica,Arial,sans-serif;'>");

        // Wrapper
        sb.append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0' style='background-color:#f1f5f9;padding:32px 16px;'>");
        sb.append("<tr><td align='center'>");

        // Container
        sb.append("<table role='presentation' width='600' cellpadding='0' cellspacing='0' style='max-width:600px;width:100%;background-color:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);'>");

        // Header
        sb.append("<tr><td style='background:linear-gradient(135deg,#0f172a 0%,#1e3a5f 100%);padding:32px 40px;text-align:center;'>");
        sb.append("<h1 style='margin:0;color:#ffffff;font-size:26px;font-weight:700;letter-spacing:-0.5px;'>🏠 EasyHouse</h1>");
        sb.append("<p style='margin:6px 0 0;color:#94a3b8;font-size:13px;'>Hệ thống quản lý phòng trọ thông minh</p>");
        sb.append("</td></tr>");

        // Status badge
        sb.append("<tr><td style='padding:28px 40px 0;text-align:center;'>");
        sb.append("<span style='display:inline-block;padding:8px 20px;background-color:").append(statusColor).append(";color:#ffffff;border-radius:20px;font-size:13px;font-weight:600;letter-spacing:0.5px;'>");
        sb.append(statusLabel).append("</span>");
        sb.append("</td></tr>");

        // Greeting & main message
        sb.append("<tr><td style='padding:24px 40px 0;'>");
        sb.append("<p style='margin:0 0 8px;font-size:16px;color:#1e293b;font-weight:600;'>").append(greeting).append("</p>");
        sb.append("<p style='margin:0;font-size:14px;color:#475569;line-height:1.7;'>").append(mainMessage).append("</p>");
        sb.append("</td></tr>");

        // Info box
        sb.append("<tr><td style='padding:20px 40px;'>");
        sb.append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0' style='background-color:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;'>");

        sb.append("<tr><td style='padding:20px 24px 12px;border-bottom:1px solid #e2e8f0;'>");
        sb.append("<p style='margin:0 0 4px;font-size:11px;color:#94a3b8;text-transform:uppercase;letter-spacing:1px;font-weight:600;'>Phòng xem</p>");
        sb.append("<p style='margin:0;font-size:15px;color:#1e293b;font-weight:600;'>").append(phongTen).append("</p>");
        sb.append("</td></tr>");

        sb.append("<tr><td style='padding:12px 24px;border-bottom:1px solid #e2e8f0;'>");
        sb.append("<p style='margin:0 0 4px;font-size:11px;color:#94a3b8;text-transform:uppercase;letter-spacing:1px;font-weight:600;'>Địa chỉ</p>");
        sb.append("<p style='margin:0;font-size:14px;color:#334155;'>").append(diaChi).append("</p>");
        sb.append("</td></tr>");

        sb.append("<tr><td style='padding:12px 24px;'>");
        sb.append("<p style='margin:0 0 4px;font-size:11px;color:#94a3b8;text-transform:uppercase;letter-spacing:1px;font-weight:600;'>Thời gian hẹn</p>");
        sb.append("<p style='margin:0;font-size:15px;color:#1e293b;font-weight:600;'>").append(thoiGian).append("</p>");
        sb.append("</td></tr>");

        sb.append("</table>");
        sb.append("</td></tr>");

        // Admin note (optional)
        if (adminNote != null && !adminNote.isBlank()) {
            sb.append("<tr><td style='padding:0 40px 20px;'>");
            sb.append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0' style='background-color:#eff6ff;border-left:4px solid #3b82f6;border-radius:0 8px 8px 0;'>");
            sb.append("<tr><td style='padding:16px 20px;'>");
            sb.append("<p style='margin:0 0 4px;font-size:11px;color:#3b82f6;text-transform:uppercase;letter-spacing:1px;font-weight:700;'>💬 Phản hồi từ quản lý</p>");
            sb.append("<p style='margin:0;font-size:14px;color:#1e40af;line-height:1.6;font-style:italic;'>\"").append(adminNote).append("\"</p>");
            sb.append("</td></tr></table>");
            sb.append("</td></tr>");
        }

        // Footer note
        if (footerNote != null && !footerNote.isBlank()) {
            sb.append("<tr><td style='padding:0 40px 24px;'>");
            sb.append("<p style='margin:0;font-size:13px;color:#64748b;line-height:1.6;'>").append(footerNote).append("</p>");
            sb.append("</td></tr>");
        }

        // Divider
        sb.append("<tr><td style='padding:0 40px;'><hr style='border:none;border-top:1px solid #e2e8f0;margin:0;'></td></tr>");

        // Footer
        sb.append("<tr><td style='padding:24px 40px 32px;text-align:center;'>");
        sb.append("<p style='margin:0 0 4px;font-size:13px;color:#94a3b8;'>Cần hỗ trợ? Liên hệ chúng tôi</p>");
        sb.append("<p style='margin:0;font-size:13px;color:#64748b;'>📧 support@easyhouse.vn &nbsp;|&nbsp; 📞 1900 8888</p>");
        sb.append("<p style='margin:12px 0 0;font-size:11px;color:#cbd5e1;'>© 2026 EasyHouse. Mọi quyền được bảo lưu.</p>");
        sb.append("</td></tr>");

        sb.append("</table>"); // container
        sb.append("</td></tr></table>"); // wrapper
        sb.append("</body></html>");
        return sb.toString();
    }

    public void sendInvoiceCreatedEmail(HoaDon hoaDon, KhachThue tenant) {
        if (tenant == null || tenant.getEmail() == null || tenant.getEmail().isBlank()) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(tenant.getEmail());
            message.setSubject("[EasyHouse] Thông báo hóa đơn tiền phòng kỳ mới - " + hoaDon.getKyThang() + "/" + hoaDon.getKyNam());
            message.setText(
                "Xin chào " + tenant.getHoTen() + ",\n\n" +
                "EasyHouse xin thông báo hóa đơn tiền phòng kỳ tháng " + hoaDon.getKyThang() + "/" + hoaDon.getKyNam() + " đã được lập.\n" +
                "Chi tiết hóa đơn:\n" +
                "- Mã hóa đơn: " + hoaDon.getMaHoaDon() + "\n" +
                "- Phòng: " + (hoaDon.getPhong() != null ? hoaDon.getPhong().getTen() : "N/A") + "\n" +
                "- Tổng tiền cần thanh toán: " + formatMoney(hoaDon.getTongTien()) + "\n" +
                "- Hạn thanh toán: " + (hoaDon.getHanTra() != null ? hoaDon.getHanTra() : "N/A") + "\n\n" +
                "Vui lòng đăng nhập vào cổng thông tin khách thuê tại " + frontendBaseUrl + "/khach-thue/dang-nhap để kiểm tra chi tiết bảng kê và thực hiện thanh toán.\n\n" +
                "Trân trọng,\nBan quản lý EasyHouse"
            );
            mailSender.send(message);
            log.info("Invoice created email sent to tenant {}", tenant.getEmail());
        } catch (Exception e) {
            log.error("Failed to send invoice created email to {}: {}", tenant.getEmail(), e.getMessage());
        }
    }

    public void sendPaymentReceivedEmail(ThanhToan payment, HoaDon hoaDon, KhachThue tenant) {
        if (tenant == null || tenant.getEmail() == null || tenant.getEmail().isBlank()) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(tenant.getEmail());
            message.setSubject("[EasyHouse] Xác nhận thanh toán hóa đơn thành công - " + hoaDon.getKyThang() + "/" + hoaDon.getKyNam());
            
            BigDecimal conLai = hoaDon.getTongTien().subtract(hoaDon.getDaTra());
            if (conLai.compareTo(BigDecimal.ZERO) < 0) conLai = BigDecimal.ZERO;

            message.setText(
                "Xin chào " + tenant.getHoTen() + ",\n\n" +
                "Chúng tôi đã ghi nhận giao dịch thanh toán của bạn cho hóa đơn kỳ tháng " + hoaDon.getKyThang() + "/" + hoaDon.getKyNam() + ".\n" +
                "Chi tiết giao dịch:\n" +
                "- Mã hóa đơn: " + hoaDon.getMaHoaDon() + "\n" +
                "- Số tiền thanh toán: " + formatMoney(payment.getSoTien()) + "\n" +
                "- Phương thức: " + (payment.getPhuongThucThanhToan() != null ? payment.getPhuongThucThanhToan() : "N/A") + "\n" +
                "- Số tiền đã đóng (Tổng cộng): " + formatMoney(hoaDon.getDaTra()) + "\n" +
                "- Số tiền còn lại: " + formatMoney(conLai) + "\n" +
                "- Trạng thái hóa đơn hiện tại: " + (hoaDon.getTrangThai() != null ? hoaDon.getTrangThai() : "N/A") + "\n\n" +
                "Cảm ơn bạn đã sử dụng dịch vụ của EasyHouse.\n\n" +
                "Trân trọng,\nBan quản lý EasyHouse"
            );
            mailSender.send(message);
            log.info("Payment confirmation email sent to tenant {}", tenant.getEmail());
        } catch (Exception e) {
            log.error("Failed to send payment confirmation email to {}: {}", tenant.getEmail(), e.getMessage());
        }
    }

    public void sendContractExpiringEmail(HopDong contract, KhachThue tenant, int daysRemaining) {
        if (tenant == null || tenant.getEmail() == null || tenant.getEmail().isBlank()) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(tenant.getEmail());
            message.setSubject("[EasyHouse] Thông báo: Hợp đồng thuê phòng sắp hết hạn sau " + daysRemaining + " ngày");
            message.setText(
                "Xin chào " + tenant.getHoTen() + ",\n\n" +
                "Hợp đồng thuê phòng của bạn sắp hết hạn.\n" +
                "Thông tin chi tiết:\n" +
                "- Mã hợp đồng: " + contract.getMaHopDong() + "\n" +
                "- Phòng: " + (contract.getPhong() != null ? contract.getPhong().getTen() : "N/A") + "\n" +
                "- Ngày hết hạn: " + (contract.getNgayKetThuc() != null ? contract.getNgayKetThuc() : "N/A") + "\n" +
                "- Thời gian còn lại: " + daysRemaining + " ngày\n\n" +
                "Vui lòng liên hệ với chủ trọ để tiến hành làm thủ tục gia hạn hợp đồng hoặc chuẩn bị các thủ tục thanh lý hợp đồng bàn giao phòng.\n\n" +
                "Trân trọng,\nBan quản lý EasyHouse"
            );
            mailSender.send(message);
            log.info("Contract expiring email sent to tenant {} ({} days remaining)", tenant.getEmail(), daysRemaining);
        } catch (Exception e) {
            log.error("Failed to send contract expiring email to {}: {}", tenant.getEmail(), e.getMessage());
        }
    }

    public void sendInvoiceOverdueEmail(HoaDon hoaDon, KhachThue tenant) {
        if (tenant == null || tenant.getEmail() == null || tenant.getEmail().isBlank()) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(tenant.getEmail());
            message.setSubject("[EasyHouse] Cảnh báo: Hóa đơn tiền phòng quá hạn thanh toán!");
            
            BigDecimal no = hoaDon.getTongTien().subtract(hoaDon.getDaTra());
            if (no.compareTo(BigDecimal.ZERO) < 0) no = BigDecimal.ZERO;

            message.setText(
                "Xin chào " + tenant.getHoTen() + ",\n\n" +
                "Chúng tôi ghi nhận hóa đơn tiền phòng kỳ tháng " + hoaDon.getKyThang() + "/" + hoaDon.getKyNam() + " của bạn đã quá hạn thanh toán.\n" +
                "Thông tin chi tiết:\n" +
                "- Mã hóa đơn: " + hoaDon.getMaHoaDon() + "\n" +
                "- Phòng: " + (hoaDon.getPhong() != null ? hoaDon.getPhong().getTen() : "N/A") + "\n" +
                "- Tổng tiền hóa đơn: " + formatMoney(hoaDon.getTongTien()) + "\n" +
                "- Số tiền chưa đóng: " + formatMoney(no) + "\n" +
                "- Hạn thanh toán: " + (hoaDon.getHanTra() != null ? hoaDon.getHanTra() : "N/A") + "\n\n" +
                "Vui lòng thanh toán hóa đơn sớm nhất có thể để tránh phát sinh phí phạt hoặc ảnh hưởng đến hợp đồng thuê.\n" +
                "Bạn có thể xem thông tin chi tiết và thanh toán tại cổng thông tin: " + frontendBaseUrl + "/khach-thue/dang-nhap .\n\n" +
                "Trân trọng,\nBan quản lý EasyHouse"
            );
            mailSender.send(message);
            log.info("Invoice overdue email sent to tenant {}", tenant.getEmail());
        } catch (Exception e) {
            log.error("Failed to send invoice overdue email to {}: {}", tenant.getEmail(), e.getMessage());
        }
    }

    public void sendAppointmentReminderEmail(com.example.quanlyphongtro.entity.LichHen lh) {
        if (lh == null || lh.getEmail() == null || lh.getEmail().isBlank()) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(lh.getEmail());
            message.setSubject("[EasyHouse] Nhac nho lich hen xem phong " + (lh.getPhong() != null ? lh.getPhong().getTen() : ""));
            
            String thoiGian = lh.getNgayHen() != null ? lh.getNgayHen().toString() : "";
            
            message.setText(
                "Xin chao " + lh.getHoTen() + ",\n\n" +
                "EasyHouse xin nhac nho ban co mot lich hen xem phong sap dien ra.\n" +
                "Thong tin chi tiet:\n" +
                "- Phong: " + (lh.getPhong() != null ? lh.getPhong().getTen() : "N/A") + "\n" +
                "- Thoi gian: " + thoiGian + "\n\n" +
                "Vui long den dung gio de duoc ho tro tot nhat.\n" +
                "Tran trong,\nBan quan ly EasyHouse"
            );
            mailSender.send(message);
            log.info("Appointment reminder email sent to {}", lh.getEmail());
        } catch (Exception e) {
            log.error("Failed to send appointment reminder email to {}: {}", lh.getEmail(), e.getMessage());
        }
    }

    public void sendInvoiceUpcomingReminderEmail(HoaDon hoaDon, KhachThue tenant, int daysRemaining) {
        if (tenant == null || tenant.getEmail() == null || tenant.getEmail().isBlank()) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(tenant.getEmail());
            message.setSubject("[EasyHouse] Thông báo: Hóa đơn tiền phòng sắp đến hạn thanh toán");
            
            BigDecimal conLai = hoaDon.getTongTien().subtract(hoaDon.getDaTra());
            if (conLai.compareTo(BigDecimal.ZERO) < 0) conLai = BigDecimal.ZERO;

            message.setText(
                "Xin chào " + tenant.getHoTen() + ",\n\n" +
                "Hóa đơn tiền phòng kỳ tháng " + hoaDon.getKyThang() + "/" + hoaDon.getKyNam() + " của bạn sắp đến hạn thanh toán.\n" +
                "Thông tin chi tiết:\n" +
                "- Mã hóa đơn: " + hoaDon.getMaHoaDon() + "\n" +
                "- Phòng: " + (hoaDon.getPhong() != null ? hoaDon.getPhong().getTen() : "N/A") + "\n" +
                "- Tổng tiền hóa đơn: " + formatMoney(hoaDon.getTongTien()) + "\n" +
                "- Số tiền còn lại: " + formatMoney(conLai) + "\n" +
                "- Hạn thanh toán: " + (hoaDon.getHanTra() != null ? hoaDon.getHanTra() : "N/A") + " (còn " + daysRemaining + " ngày)\n\n" +
                "Vui lòng thanh toán hóa đơn đúng hạn để tránh phát sinh nợ quá hạn.\n" +
                "Bạn có thể xem thông tin chi tiết và thanh toán tại cổng thông tin: " + frontendBaseUrl + "/khach-thue/dang-nhap .\n\n" +
                "Trân trọng,\nBan quản lý EasyHouse"
            );
            mailSender.send(message);
            log.info("Invoice upcoming reminder email sent to tenant {}", tenant.getEmail());
        } catch (Exception e) {
            log.error("Failed to send invoice upcoming reminder email to {}: {}", tenant.getEmail(), e.getMessage());
        }
    }

    // ── Appointment HTML Emails ─────────────────────────────────────────

    public void sendAppointmentCreatedEmail(LichHen lh) {
        if (lh == null || lh.getEmail() == null || lh.getEmail().isBlank()) return;
        try {
            String sdtNhanVien = (lh.getNguoiDung() != null && lh.getNguoiDung().getSoDienThoai() != null) 
                                 ? lh.getNguoiDung().getSoDienThoai() : "1900 8888";
            String html = buildAppointmentHtmlTemplate(
                "Đăng ký lịch hẹn thành công",
                "#f59e0b", "⏳ CHỜ DUYỆT",
                "Xin chào " + lh.getHoTen() + ",",
                "Chúng tôi đã nhận được yêu cầu đặt lịch xem phòng của bạn. Quản lý sẽ xem xét và phản hồi trong thời gian sớm nhất.",
                lh, null,
                "Quản lý tòa nhà sẽ liên hệ qua số điện thoại <strong>" + lh.getSoDienThoai() + "</strong> để xác nhận lịch hẹn. Số điện thoại liên hệ của người quản lý là: <strong>" + sdtNhanVien + "</strong>. Cảm ơn bạn đã tin tưởng EasyHouse!"
            );
            sendHtmlEmail(lh.getEmail(), "[EasyHouse] Xác nhận đăng ký đặt lịch xem phòng thành công", html);
            log.info("Appointment created HTML email sent to {}", lh.getEmail());
        } catch (Exception e) {
            log.error("Failed to send appointment created email to {}: {}", lh.getEmail(), e.getMessage());
        }
    }

    public void sendAppointmentConfirmedEmail(LichHen lh) {
        if (lh == null || lh.getEmail() == null || lh.getEmail().isBlank()) return;
        try {
            String sdtNhanVien = (lh.getNguoiDung() != null && lh.getNguoiDung().getSoDienThoai() != null) 
                                 ? lh.getNguoiDung().getSoDienThoai() : "1900 8888";
            String html = buildAppointmentHtmlTemplate(
                "Lịch hẹn đã được xác nhận",
                "#22c55e", "✅ ĐÃ XÁC NHẬN",
                "Xin chào " + lh.getHoTen() + ",",
                "Tin vui! Lịch hẹn xem phòng của bạn đã được quản lý xác nhận thành công. Vui lòng đến đúng giờ hẹn bên dưới.",
                lh, lh.getGhiChuAdmin(),
                "Nếu bạn cần thay đổi lịch hẹn, vui lòng liên hệ hotline <strong>" + sdtNhanVien + "</strong> hoặc phản hồi trực tiếp email này."
            );
            sendHtmlEmail(lh.getEmail(), "[EasyHouse] ✅ Lịch hẹn xem phòng đã được xác nhận!", html);
            log.info("Appointment confirmed HTML email sent to {}", lh.getEmail());
        } catch (Exception e) {
            log.error("Failed to send appointment confirmed email to {}: {}", lh.getEmail(), e.getMessage());
        }
    }

    public void sendAppointmentCancelledEmail(LichHen lh) {
        if (lh == null || lh.getEmail() == null || lh.getEmail().isBlank()) return;
        try {
            String html = buildAppointmentHtmlTemplate(
                "Lịch hẹn đã bị hủy",
                "#ef4444", "❌ ĐÃ HỦY",
                "Xin chào " + lh.getHoTen() + ",",
                "Rất tiếc, lịch hẹn xem phòng của bạn đã bị hủy. Dưới đây là thông tin chi tiết lịch hẹn đã hủy.",
                lh, lh.getGhiChuAdmin(),
                "Nếu bạn vẫn quan tâm, bạn có thể đặt lại lịch hẹn mới tại <a href='" + frontendBaseUrl + "' style='color:#3b82f6;text-decoration:underline;'>EasyHouse</a>. Chúng tôi luôn sẵn sàng hỗ trợ bạn."
            );
            sendHtmlEmail(lh.getEmail(), "[EasyHouse] Thông báo hủy lịch hẹn xem phòng", html);
            log.info("Appointment cancelled HTML email sent to {}", lh.getEmail());
        } catch (Exception e) {
            log.error("Failed to send appointment cancelled email to {}: {}", lh.getEmail(), e.getMessage());
        }
    }
}
