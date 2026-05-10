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
        message.setSubject("[Quản Lý Phòng Trọ] Xác thực tài khoản mới");
        message.setText(buildVerificationContent(hoTen, taiKhoanEmail, matKhau, verifyUrl));
        mailSender.send(message);
    }

    private String buildVerificationContent(String hoTen, String taiKhoanEmail, String matKhau, String verifyUrl) {
        return "Xin chào " + hoTen + ",\n\n"
                + "Tài khoản của bạn đã được tạo thành công trên hệ thống Quản Lý Phòng Trọ.\n\n"
                + "Thông tin đăng nhập:\n"
                + "- Tài khoản: " + taiKhoanEmail + "\n"
                + "- Mật khẩu: " + matKhau + "\n\n"
                + "Vui lòng xác thực email bằng cách truy cập liên kết sau:\n"
                + verifyUrl + "\n\n"
                + "Lưu ý: Liên kết xác thực có hiệu lực trong 24 giờ.\n"
                + "Nếu bạn không yêu cầu tạo tài khoản, vui lòng bỏ qua email này.\n\n"
                + "Trân trọng,\nHệ thống Quản Lý Phòng Trọ";
    }
}
