package com.example.quanlyphongtro.event;

import com.example.quanlyphongtro.services.EmailService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class InvoiceEventListener {

    private final EmailService emailService;

    @Async
    @EventListener
    public void handleInvoiceCreatedEvent(InvoiceCreatedEvent event) {
        try {
            log.info("Bắt đầu gửi email thông báo hóa đơn mới: {}", event.getInvoice().getMaHoaDon());
            emailService.sendInvoiceCreatedEmail(event.getInvoice(), event.getInvoice().getKhachThue());
            log.info("Đã gửi email thành công cho hóa đơn: {}", event.getInvoice().getMaHoaDon());
        } catch (Exception e) {
            log.error("Lỗi khi gửi email hóa đơn {}: {}", event.getInvoice().getMaHoaDon(), e.getMessage());
        }
    }
}
