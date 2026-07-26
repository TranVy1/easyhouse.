package com.example.quanlyphongtro.config;

import com.example.quanlyphongtro.services.ChatPresenceService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.security.Principal;
import java.util.UUID;

/**
 * Cap nhat trang thai online tu su kien vong doi cua Spring WebSocket.
 *
 * Dung SessionConnectedEvent chu KHONG phai SessionConnectEvent:
 *   - SessionConnectEvent   ban khi frame CONNECT vua toi, CHUA qua xac thuc
 *   - SessionConnectedEvent ban sau khi da bat tay xong, principal chac chan da co
 * Bat nham su kien dau thi se ghi nhan ca nhung ket noi bi tu choi.
 */
@Component
@RequiredArgsConstructor
public class WebSocketPresenceListener {

    private final ChatPresenceService chatPresenceService;

    @EventListener
    public void khiKetNoi(SessionConnectedEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        chatPresenceService.ghiNhanKetNoi(accessor.getSessionId(), layNguoiDungId(event.getUser()));
    }

    @EventListener
    public void khiNgatKetNoi(SessionDisconnectEvent event) {
        // Chi can phienId: ChatPresenceService tu tra nguoc ra nguoi dung.
        chatPresenceService.ghiNhanNgatKetNoi(event.getSessionId());
    }

    /** Principal do StompAuthChannelInterceptor dat, ben trong la UUID. */
    private UUID layNguoiDungId(Principal principal) {
        if (principal instanceof Authentication auth && auth.getPrincipal() instanceof UUID id) {
            return id;
        }
        return null;
    }
}
