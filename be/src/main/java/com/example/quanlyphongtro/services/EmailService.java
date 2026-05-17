package com.example.quanlyphongtro.services;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:no-reply@qlyphongtro.local}")
    private String fromEmail;

    public void sendEmailVerification(
            String toEmail,
            String hoTen,
            String taiKhoanEmail,
            String matKhau,
            String verifyUrl
    ) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("[EasyHouse] Xác thực tài khoản mới");
            
            String htmlContent = buildVerificationContent(hoTen, taiKhoanEmail, matKhau, verifyUrl);
            helper.setText(htmlContent, true);
            
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            throw new RuntimeException("Lỗi khi tạo và gửi email xác thực: " + e.getMessage());
        }
    }

    public void sendNewPassword(String toEmail, String hoTen, String newPassword) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("[EasyHouse] Cấp lại mật khẩu mới");
            
            String htmlContent = buildForgotPassContent(hoTen, newPassword);
            helper.setText(htmlContent, true);
            
            mailSender.send(message);
        } catch (MessagingException | MailException e) {
            throw new RuntimeException("Lỗi khi tạo và gửi email cấp lại mật khẩu: " + e.getMessage());
        }
    }

    private String buildVerificationContent(String hoTen, String taiKhoanEmail, String matKhau, String verifyUrl) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "    <meta charset=\"utf-8\">"
                + "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
                + "    <title>Xác thực tài khoản EasyHouse</title>"
                + "</head>"
                + "<body style=\"font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f4f6f8; margin: 0; padding: 0; -webkit-font-smoothing: antialiased;\">"
                + "    <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); border: 1px solid #e1e8ed;\">"
                + "        <!-- Header -->"
                + "        <tr>"
                + "            <td align=\"center\" style=\"background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); padding: 35px 20px;\">"
                + "                <h1 style=\"color: #ffffff; margin: 0; font-size: 28px; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase;\">EasyHouse</h1>"
                + "                <p style=\"color: #cbd5e1; margin: 8px 0 0 0; font-size: 14px;\">Hệ thống Quản lý Phòng trọ Thông minh</p>"
                + "            </td>"
                + "        </tr>"
                + "        <!-- Content -->"
                + "        <tr>"
                + "            <td style=\"padding: 40px 30px;\">"
                + "                <p style=\"font-size: 16px; line-height: 24px; color: #334155; margin: 0;\">Xin chào <strong>" + hoTen + "</strong>,</p>"
                + "                <p style=\"font-size: 15px; line-height: 24px; color: #475569; margin: 16px 0 24px 0;\">Chào mừng bạn đến với <strong>EasyHouse</strong>. Tài khoản của bạn đã được khởi tạo thành công trên hệ thống quản lý thuê nhà của chúng tôi. Dưới đây là thông tin đăng nhập của bạn:</p>"
                + "                "
                + "                <!-- Info Table -->"
                + "                <table width=\"100%\" style=\"background-color: #f8fafc; border-radius: 8px; margin-bottom: 28px; border-collapse: collapse; border: 1px solid #f1f5f9;\">"
                + "                    <tr>"
                + "                        <td style=\"padding: 16px 20px; border-bottom: 1px solid #f1f5f9;\">"
                + "                            <span style=\"font-size: 13px; color: #64748b; display: block; text-transform: uppercase; font-weight: 600;\">Tài khoản đăng nhập</span>"
                + "                            <span style=\"font-size: 16px; color: #0f172a; font-weight: 600; font-family: monospace; display: block; margin-top: 4px;\">" + taiKhoanEmail + "</span>"
                + "                        </td>"
                + "                    </tr>"
                + "                    <tr>"
                + "                        <td style=\"padding: 16px 20px;\">"
                + "                            <span style=\"font-size: 13px; color: #64748b; display: block; text-transform: uppercase; font-weight: 600;\">Mật khẩu mặc định</span>"
                + "                            <span style=\"font-size: 16px; color: #0f172a; font-weight: 600; font-family: monospace; display: block; margin-top: 4px;\">" + matKhau + "</span>"
                + "                        </td>"
                + "                    </tr>"
                + "                </table>"
                + "                "
                + "                <p style=\"font-size: 15px; line-height: 24px; color: #475569; margin: 0 0 28px 0;\">Để bắt đầu sử dụng và bảo mật tài khoản của bạn, vui lòng click nút bên dưới để xác thực địa chỉ email:</p>"
                + "                "
                + "                <!-- CTA Button -->"
                + "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin: 0 auto 28px auto;\">"
                + "                    <tr>"
                + "                        <td align=\"center\" style=\"border-radius: 8px; background-color: #2563eb;\">"
                + "                            <a href=\"" + verifyUrl + "\" target=\"_blank\" style=\"display: inline-block; padding: 14px 32px; font-family: inherit; font-size: 15px; color: #ffffff; text-decoration: none; font-weight: 600; border-radius: 8px; border: 1px solid #2563eb;\">Xác thực tài khoản</a>"
                + "                        </td>"
                + "                    </tr>"
                + "                </table>"
                + "                "
                + "                <!-- Security Warning -->"
                + "                <p style=\"font-size: 13px; line-height: 20px; color: #94a3b8; margin: 24px 0 0 0; padding-top: 20px; border-top: 1px dashed #e2e8f0; text-align: center;\">"
                + "                    Liên kết xác thực này chỉ có hiệu lực trong vòng <strong>24 giờ</strong>.<br>"
                + "                    Nếu bạn không thực hiện đăng ký tài khoản trên EasyHouse, vui lòng an tâm bỏ qua email này."
                + "                </p>"
                + "            </td>"
                + "        </tr>"
                + "        <!-- Footer -->"
                + "        <tr>"
                + "            <td style=\"background-color: #f8fafc; padding: 24px 30px; border-top: 1px solid #e2e8f0; text-align: center;\">"
                + "                <p style=\"font-size: 12px; color: #94a3b8; margin: 0;\">© 2026 EasyHouse Team. All rights reserved.</p>"
                + "                <p style=\"font-size: 11px; color: #cbd5e1; margin: 6px 0 0 0;\">Email này được gửi tự động từ hệ thống quản lý EasyHouse. Vui lòng không trả lời trực tiếp email này.</p>"
                + "            </td>"
                + "        </tr>"
                + "    </table>"
                + "</body>"
                + "</html>";
    }

    private String buildForgotPassContent(String hoTen, String newPassword) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "    <meta charset=\"utf-8\">"
                + "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
                + "    <title>Cấp lại mật khẩu EasyHouse</title>"
                + "</head>"
                + "<body style=\"font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f4f6f8; margin: 0; padding: 0; -webkit-font-smoothing: antialiased;\">"
                + "    <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); border: 1px solid #e1e8ed;\">"
                + "        <!-- Header -->"
                + "        <tr>"
                + "            <td align=\"center\" style=\"background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); padding: 35px 20px;\">"
                + "                <h1 style=\"color: #ffffff; margin: 0; font-size: 28px; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase;\">EasyHouse</h1>"
                + "                <p style=\"color: #cbd5e1; margin: 8px 0 0 0; font-size: 14px;\">Hệ thống Quản lý Phòng trọ Thông minh</p>"
                + "            </td>"
                + "        </tr>"
                + "        <!-- Content -->"
                + "        <tr>"
                + "            <td style=\"padding: 40px 30px;\">"
                + "                <p style=\"font-size: 16px; line-height: 24px; color: #334155; margin: 0;\">Xin chào <strong>" + hoTen + "</strong>,</p>"
                + "                <p style=\"font-size: 15px; line-height: 24px; color: #475569; margin: 16px 0 24px 0;\">Chúng tôi đã nhận được yêu cầu cấp lại mật khẩu cho tài khoản của bạn trên hệ thống <strong>EasyHouse</strong>. Mật khẩu của bạn đã được đặt lại thành công.</p>"
                + "                "
                + "                <!-- Password Display Area -->"
                + "                <div style=\"background-color: #fffbeb; border: 1px solid #fef3c7; border-radius: 8px; padding: 20px; text-align: center; margin-bottom: 28px;\">"
                + "                    <span style=\"font-size: 13px; color: #d97706; display: block; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px;\">Mật khẩu mới của bạn</span>"
                + "                    <span style=\"font-size: 22px; color: #b45309; font-weight: 700; font-family: monospace; display: block; margin-top: 8px; letter-spacing: 1px;\">" + newPassword + "</span>"
                + "                </div>"
                + "                "
                + "                <p style=\"font-size: 15px; line-height: 24px; color: #475569; margin: 0 0 28px 0;\">Vui lòng nhấn nút bên dưới để tiến hành đăng nhập vào trang quản trị và thay đổi mật khẩu ngay lập tức nhằm bảo vệ an toàn tối đa cho tài khoản của bạn.</p>"
                + "                "
                + "                <!-- CTA Button -->"
                + "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin: 0 auto 28px auto;\">"
                + "                    <tr>"
                + "                        <td align=\"center\" style=\"border-radius: 8px; background-color: #2563eb;\">"
                + "                            <a href=\"http://localhost:3000/dang-nhap\" target=\"_blank\" style=\"display: inline-block; padding: 14px 32px; font-family: inherit; font-size: 15px; color: #ffffff; text-decoration: none; font-weight: 600; border-radius: 8px; border: 1px solid #2563eb;\">Đăng nhập ngay</a>"
                + "                        </td>"
                + "                    </tr>"
                + "                </table>"
                + "                "
                + "                <!-- Security Warning -->"
                + "                <p style=\"font-size: 13px; line-height: 20px; color: #94a3b8; margin: 24px 0 0 0; padding-top: 20px; border-top: 1px dashed #e2e8f0; text-align: center;\">"
                + "                    Nếu bạn không thực hiện yêu cầu này, xin hãy liên hệ ngay với Bộ phận Hỗ trợ hoặc Quản trị viên để kịp thời khóa tài khoản."
                + "                </p>"
                + "            </td>"
                + "        </tr>"
                + "        <!-- Footer -->"
                + "        <tr>"
                + "            <td style=\"background-color: #f8fafc; padding: 24px 30px; border-top: 1px solid #e2e8f0; text-align: center;\">"
                + "                <p style=\"font-size: 12px; color: #94a3b8; margin: 0;\">© 2026 EasyHouse Team. All rights reserved.</p>"
                + "                <p style=\"font-size: 11px; color: #cbd5e1; margin: 6px 0 0 0;\">Email này được gửi tự động từ hệ thống quản lý EasyHouse. Vui lòng không trả lời trực tiếp email này.</p>"
                + "            </td>"
                + "        </tr>"
                + "    </table>"
                + "</body>"
                + "</html>";
    }
}
