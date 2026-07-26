package com.example.quanlyphongtro.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketTransportRegistration;

import java.util.Arrays;

/**
 * Cau hinh WebSocket + STOMP cho chat realtime.
 *
 * @Order(HIGHEST_PRECEDENCE + 99) la BAT BUOC theo tai lieu Spring: interceptor
 * xac thuc phai chay TRUOC interceptor cua Spring Security, neu khong Security se
 * xu ly message khi chua co principal.
 *
 * Luu y trien khai: trinh duyet noi THANG toi backend (vd wss://api.mc4vn.net/ws),
 * khong di qua rewrite cua Next.js — rewrite cua Next chi xu ly HTTP, khong nang cap
 * duoc ket noi WebSocket. Cloudflare Tunnel thi proxy WebSocket duoc, khong can
 * cau hinh them.
 */
@Configuration
@EnableWebSocketMessageBroker
@Order(Ordered.HIGHEST_PRECEDENCE + 99)
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    /**
     * Cloudflare goi Free/Pro dong WebSocket sau khoang 100 giay khong co du lieu
     * di qua. Heartbeat 25 giay nam an toan duoi nguong do.
     *
     * Neu doi sang ha tang khac, van nen giu heartbeat: no con dung de phat hien
     * ket noi da chet ma TCP chua kip bao.
     */
    private static final long[] NHIP_TIM_MS = {25_000, 25_000};

    private static final int GIOI_HAN_KICH_THUOC_MSG = 64 * 1024;
    private static final int GIOI_HAN_BUFFER_GUI = 512 * 1024;
    private static final int GIOI_HAN_THOI_GIAN_GUI_MS = 20_000;

    private final StompAuthChannelInterceptor stompAuthChannelInterceptor;
    private final TaskScheduler messageBrokerTaskScheduler;
    private final String corsAllowedOrigins;

    public WebSocketConfig(
            StompAuthChannelInterceptor stompAuthChannelInterceptor,
            // @Lazy de tranh phu thuoc vong: bean nay do chinh @EnableWebSocketMessageBroker tao ra.
            @Lazy @Qualifier("messageBrokerTaskScheduler") TaskScheduler messageBrokerTaskScheduler,
            @Value("${cors.allowed-origins:http://localhost:3000,http://localhost:8080}") String corsAllowedOrigins) {
        this.stompAuthChannelInterceptor = stompAuthChannelInterceptor;
        this.messageBrokerTaskScheduler = messageBrokerTaskScheduler;
        this.corsAllowedOrigins = corsAllowedOrigins;
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // Khong dung SockJS: moi trinh duyet hien nay deu ho tro WebSocket, Cloudflare
        // proxy duoc, va React Native khong chay SockJS. Bo di thi web va mobile dung
        // chung mot client. Neu mang nao do chan WebSocket, client tu lui ve goi REST
        // delta (?sau=<seq>) — duong lui do von da phai co de bu tin khi noi lai.
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns(Arrays.stream(corsAllowedOrigins.split(","))
                        .map(String::trim)
                        .filter(origin -> !origin.isEmpty())
                        .toArray(String[]::new));
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // Broker in-memory: du cho mo hinh trien khai hien tai (dung 1 instance
        // backend, container_name co dinh trong docker-compose nen khong scale ngang).
        // Khi nao chay nhieu instance thi thay bang relay — Redis da co san trong
        // pom va trong compose.
        registry.enableSimpleBroker("/queue")
                .setHeartbeatValue(NHIP_TIM_MS)
                // Khong co TaskScheduler thi setHeartbeatValue BI BO QUA hoan toan.
                .setTaskScheduler(messageBrokerTaskScheduler);

        registry.setApplicationDestinationPrefixes("/app");

        // Cho phep convertAndSendToUser(...) dinh tuyen toi dung phien cua tung nguoi.
        registry.setUserDestinationPrefix("/user");
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(stompAuthChannelInterceptor);
        // Executor rieng: neu dung chung bean "taskExecutor" thi tin nhan phai xep
        // hang sau cac tac vu @Async nang nhu gui email.
        registration.taskExecutor()
                .corePoolSize(4)
                .maxPoolSize(12)
                .queueCapacity(200);
    }

    @Override
    public void configureClientOutboundChannel(ChannelRegistration registration) {
        registration.taskExecutor()
                .corePoolSize(4)
                .maxPoolSize(12)
                .queueCapacity(200);
    }

    @Override
    public void configureWebSocketTransport(WebSocketTransportRegistration registration) {
        // Chan client gui payload khong lo hoac lam nghen buffer khi mang cham.
        registration.setMessageSizeLimit(GIOI_HAN_KICH_THUOC_MSG);
        registration.setSendBufferSizeLimit(GIOI_HAN_BUFFER_GUI);
        registration.setSendTimeLimit(GIOI_HAN_THOI_GIAN_GUI_MS);
    }
}
