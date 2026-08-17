package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.LoginHistory;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.repository.LoginHistoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;

/**
 * Ghi nhat ky dang nhap trong transaction RIENG BIET.
 *
 * Truoc day viec ghi nam ngay trong AuthService (@Transactional): moi lan dang
 * nhap that bai, code luu lich su roi throw exception — exception cuon nguoc ca
 * transaction nen ban ghi vua luu bi huy. Ket qua la bang login_history khong co
 * lay mot dong that bai nao, mat hoan toan kha nang phat hien do mat khau.
 *
 * Tach ra bean rieng vi Spring proxy bo qua @Transactional khi mot method duoc
 * goi tu chinh bean do (self-invocation).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class LoginHistoryService {

    private final LoginHistoryRepository loginHistoryRepository;

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void ghiNhan(NguoiDung user, String dinhDanh, boolean thanhCong,
                        String ipAddress, String userAgent, String lyDoThatBai) {
        try {
            String safeUserAgent = userAgent != null && userAgent.length() > 255
                    ? userAgent.substring(0, 255) : userAgent;
            String safeLyDo = lyDoThatBai != null && lyDoThatBai.length() > 255
                    ? lyDoThatBai.substring(0, 255) : lyDoThatBai;
            LoginHistory history = LoginHistory.builder()
                    .nguoiDung(user)
                    .email(dinhDanh)
                    .thanhCong(thanhCong)
                    .ipAddress(ipAddress)
                    .userAgent(safeUserAgent)
                    .lyDoThatBai(safeLyDo)
                    .taoLuc(ZonedDateTime.now())
                    .build();
            loginHistoryRepository.save(history);
        } catch (Exception e) {
            // Khong bao gio de viec ghi log lam hong luong dang nhap.
            log.warn("Khong ghi duoc login_history: {}", e.getMessage());
        }
    }
}
