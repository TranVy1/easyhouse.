package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.EmailVerificationToken;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.repository.EmailVerificationTokenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
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

    public void sendAppointmentCreatedEmail(com.example.quanlyphongtro.entity.LichHen lh) {
        if (lh == null || lh.getEmail() == null || lh.getEmail().isBlank()) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(lh.getEmail());
            message.setSubject("[EasyHouse] Xác nhận đăng ký đặt lịch xem phòng thành công");
            
            String thoiGian = lh.getNgayHen() != null ? lh.getNgayHen().toString() : "";
            
            message.setText(
                "Xin chào " + lh.getHoTen() + ",\n\n" +
                "EasyHouse xác nhận bạn đã đăng ký đặt lịch xem phòng thành công.\n" +
                "Thông tin chi tiết:\n" +
                "- Phòng: " + (lh.getPhong() != null ? lh.getPhong().getTen() : "N/A") + "\n" +
                "- Địa chỉ: " + (lh.getPhong() != null && lh.getPhong().getNhaTro() != null ? lh.getPhong().getNhaTro().getDiaChi() : "N/A") + "\n" +
                "- Thời gian hẹn: " + thoiGian + "\n" +
                "- Ghi chú: " + (lh.getGhiChu() != null ? lh.getGhiChu() : "") + "\n\n" +
                "Người quản lý sẽ liên hệ với bạn qua số điện thoại " + lh.getSoDienThoai() + " để xác nhận lại lịch hẹn.\n" +
                "Cảm ơn bạn đã quan tâm đến dịch vụ của EasyHouse.\n\n" +
                "Trân trọng,\nĐội ngũ EasyHouse"
            );
            mailSender.send(message);
            log.info("Appointment confirmation email sent to customer {}", lh.getEmail());
        } catch (Exception e) {
            log.error("Failed to send appointment confirmation email to {}: {}", lh.getEmail(), e.getMessage());
        }
    }
}
