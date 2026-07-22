package com.example.quanlyphongtro.services;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.UUID;

/**
 * Day du lieu realtime xuong client qua WebSocket.
 *
 * BAO MAT — chi dung "user destination", khong dung topic theo hoi thoai:
 * cach pho bien la cho client SUBSCRIBE /topic/hoi-thoai/{id}, nhung khi do bat ky
 * ai da dang nhap cung co the subscribe id cua nguoi khac va doc trom toan bo tin
 * nhan. Voi convertAndSendToUser, Spring gan kenh vao principal da xac thuc nen
 * khong co cach nao nghe kenh cua nguoi khac.
 *
 * Doi lai la phai gui N lan cho nhom N nguoi. Voi broker in-memory thi chi phi nay
 * khong dang ke, va no giu cho chat 1-1 va chat nhom dung chung mot duong code.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatRealtimeService {

    /** Client subscribe /user/queue/tin-nhan de nhan tin moi. */
    public static final String KENH_TIN_NHAN = "/queue/tin-nhan";

    /** Client subscribe /user/queue/trang-thai de nhan "dang go", "da doc". */
    public static final String KENH_TRANG_THAI = "/queue/trang-thai";

    private final SimpMessagingTemplate messagingTemplate;

    public void guiToiNhieuNguoi(Collection<UUID> nguoiNhanIds, String kenh, Object noiDung) {
        if (nguoiNhanIds == null || nguoiNhanIds.isEmpty()) return;

        for (UUID nguoiNhanId : nguoiNhanIds) {
            try {
                // Ten principal la UUID dang chuoi — xem StompAuthChannelInterceptor.
                messagingTemplate.convertAndSendToUser(nguoiNhanId.toString(), kenh, noiDung);
            } catch (RuntimeException ex) {
                // Mot nguoi nhan mat ket noi khong duoc lam hong viec gui cho nhung
                // nguoi con lai. DB moi la nguon su that; ho se nhan bu qua REST delta
                // khi noi lai.
                log.warn("Khong day duoc du lieu realtime toi {}: {}", nguoiNhanId, ex.getMessage());
            }
        }
    }
}
