package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.EmailVerificationToken;
import com.example.quanlyphongtro.entity.NguoiDung;
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
}
