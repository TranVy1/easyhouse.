package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.services.TinNhanService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.util.UUID;

/**
 * Cac su kien phu di theo chieu client -> server qua WebSocket.
 *
 * Chi nhung thu PHU DU moi di duong nay. Viec gui tin nhan van qua REST POST vi
 * REST da co san validate, chong gui trung bang maClient, va tra ve so_thu_tu
 * cho
 * client dung cho optimistic UI. Cang it duong ghi du lieu thi cang it cho sai.
 */
@Controller
@RequiredArgsConstructor
public class ChatWebSocketController {

    private final TinNhanService tinNhanService;

    /**
     * Bao "dang go" cho nhung nguoi con lai. Khong ghi DB, mat khi restart la binh
     * thuong.
     */
    @MessageMapping("/hoi-thoai/{hoiThoaiId}/dang-go")
    public void dangGo(@DestinationVariable UUID hoiThoaiId,
            @Payload DangGoPayload payload,
            Principal principal) {
        UUID nguoiDungId = layNguoiDungId(principal);
        if (nguoiDungId == null)
            return;
        tinNhanService.baoDangGo(hoiThoaiId, nguoiDungId, payload != null && payload.dangGo());
    }

    /**
     * Principal duoc StompAuthChannelInterceptor dat luc CONNECT, ben trong la UUID
     * — dung nhu cach JwtAuthenticationFilter lam cho REST.
     */
    private UUID layNguoiDungId(Principal principal) {
        if (principal instanceof Authentication auth && auth.getPrincipal() instanceof UUID nguoiDungId) {
            return nguoiDungId;
        }
        return null;
    }

    public record DangGoPayload(boolean dangGo) {
    }
}
