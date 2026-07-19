package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.SepayWebhookRequest;
import com.example.quanlyphongtro.services.SepayWebhookService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/webhook/sepay")
@RequiredArgsConstructor
@Slf4j
public class SepayWebhookController {

    private final SepayWebhookService sepayWebhookService;
    private final ObjectMapper objectMapper;

    @PostMapping
    public ResponseEntity<ApiResponse<String>> handleSepayWebhook(@RequestBody SepayWebhookRequest request) {
        log.info("Nhận webhook từ Sepay: {}", request);
        try {
            String rawPayload = objectMapper.writeValueAsString(request);
            sepayWebhookService.processWebhook(request, rawPayload);
            return ResponseEntity.ok(ApiResponse.<String>builder()
                    .success(true)
                    .message("Đã xử lý webhook")
                    .data("OK")
                    .build());
        } catch (Exception e) {
            log.error("Lỗi xử lý webhook Sepay: ", e);
            return ResponseEntity.ok(ApiResponse.<String>builder()
                    .success(false)
                    .message("Lỗi xử lý webhook")
                    .build());
        }
    }
}
