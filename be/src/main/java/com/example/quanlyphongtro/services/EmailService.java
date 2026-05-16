package com.example.quanlyphongtro.services;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
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
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(toEmail);
        message.setSubject("[EasyHouse] Xác thực tài khoản mới");
        message.setText(buildVerificationContent(hoTen, taiKhoanEmail, matKhau, verifyUrl));
        mailSender.send(message);
    }

    public void sendNewPassword(String toEmail, String hoTen, String newPassword) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(toEmail);
        message.setSubject("[EasyHouse] Cấp lại mật khẩu mới");
        message.setText(buildForgotPassContent(hoTen, newPassword));
        mailSender.send(message);
    }

    private String buildVerificationContent(String hoTen, String taiKhoanEmail, String matKhau, String verifyUrl) {
        return "Xin chào " + hoTen + ",\n\n"
                + "Tài khoản của bạn đã được tạo thành công trên hệ thống EasyHouse.\n\n"
                + "Thông tin đăng nhập:\n"
                + "- Tài khoản: " + taiKhoanEmail + "\n"
                + "- Mật khẩu: " + matKhau + "\n\n"
                + "Vui lòng xác thực email bằng cách truy cập liên kết sau:\n"
                + verifyUrl + "\n\n"
                + "Lưu ý: Liên kết xác thực có hiệu lực trong 24 giờ.\n"
                + "Nếu bạn không yêu cầu tạo tài khoản, vui lòng bỏ qua email này.\n\n"
                + "Trân trọng,\nHệ thống EasyHouse";
    }

    private String buildForgotPassContent(String hoTen, String newPassword) {
        return "Xin chào " + hoTen + ",\n\n"
                + "Chúng tôi nhận được yêu cầu cấp lại mật khẩu cho tài khoản của bạn trên hệ thống EasyHouse.\n\n"
                + "Mật khẩu mới của bạn là: " + newPassword + "\n\n"
                + "Vui lòng đăng nhập và đổi mật khẩu ngay để đảm bảo an toàn cho tài khoản.\n\n"
                + "Nếu bạn không yêu cầu hành động này, vui lòng liên hệ với quản trị viên ngay lập tức.\n\n"
                + "Trân trọng,\nHệ thống EasyHouse";
    }
}
