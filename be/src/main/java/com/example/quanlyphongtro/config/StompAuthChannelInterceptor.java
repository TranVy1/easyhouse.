package com.example.quanlyphongtro.config;

import com.example.quanlyphongtro.services.JwtService;
import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageDeliveryException;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;

/**
 * Xac thuc va phan quyen o tang STOMP.
 *
 * VI SAO KHONG XAC THUC O TANG HTTP:
 * trinh duyet khong cho dat header Authorization khi bat tay WebSocket. Vi vay
 * /ws duoc mo permitAll trong SecurityConfig, con viec kiem tra token chuyen xuong
 * frame CONNECT — noi STOMP cho phep gui header tuy y.
 *
 * KHONG dat token vao query string (?token=...): query string bi ghi vao access log
 * cua Cloudflare, cua proxy va cua chinh server.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class StompAuthChannelInterceptor implements ChannelInterceptor {

    private static final String HEADER_XAC_THUC = "Authorization";
    private static final String TIEN_TO_BEARER = "Bearer ";

    /**
     * Client chi duoc subscribe kenh rieng cua chinh minh.
     * Spring tu gan /user/** vao principal da xac thuc, nen khong the nghe kenh
     * cua nguoi khac. Day la lop phong thu thu hai — lop thu nhat la viec server
     * khong he mo topic cong khai nao (xem ChatRealtimeService).
     */
    private static final String TIEN_TO_KENH_RIENG = "/user/";

    private final JwtService jwtService;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
        if (accessor == null || accessor.getCommand() == null) {
            return message;
        }

        switch (accessor.getCommand()) {
            case CONNECT -> xacThucConnect(accessor);
            case SUBSCRIBE -> chanKenhLa(accessor);
            default -> { /* SEND / DISCONNECT / ACK: da co principal tu luc CONNECT */ }
        }
        return message;
    }

    private void xacThucConnect(StompHeaderAccessor accessor) {
        String token = layToken(accessor);
        if (token == null) {
            throw new MessageDeliveryException("Thieu token xac thuc");
        }

        Claims claims = jwtService.parseToken(token);
        if (claims == null) {
            // parseToken tra null khi token sai chu ky hoac het han.
            throw new MessageDeliveryException("Token khong hop le hoac da het han");
        }

        UUID nguoiDungId = jwtService.getUserId(claims);
        String vaiTro = jwtService.getRole(claims);

        List<GrantedAuthority> quyen = List.of(
                new SimpleGrantedAuthority("ROLE_" + (vaiTro != null ? vaiTro : "USER")));

        // Dung y het JwtAuthenticationFilter: principal la UUID (khong phai chuoi,
        // khong phai UserDetails). Nho vay getName() tra ve uuid dang chuoi va
        // convertAndSendToUser(userId.toString(), ...) tim dung phien.
        UsernamePasswordAuthenticationToken xacThuc =
                new UsernamePasswordAuthenticationToken(nguoiDungId, null, quyen);

        accessor.setUser(xacThuc);
        log.debug("WebSocket CONNECT: nguoi dung {}", nguoiDungId);
    }

    private void chanKenhLa(StompHeaderAccessor accessor) {
        String kenh = accessor.getDestination();
        if (kenh == null || !kenh.startsWith(TIEN_TO_KENH_RIENG)) {
            log.warn("Chan SUBSCRIBE toi kenh khong hop le: {}", kenh);
            throw new MessageDeliveryException("Chi duoc subscribe kenh rieng /user/**");
        }
    }

    private String layToken(StompHeaderAccessor accessor) {
        String header = accessor.getFirstNativeHeader(HEADER_XAC_THUC);
        if (header == null || !header.startsWith(TIEN_TO_BEARER)) {
            return null;
        }
        String token = header.substring(TIEN_TO_BEARER.length()).trim();
        return token.isEmpty() ? null : token;
    }
}
