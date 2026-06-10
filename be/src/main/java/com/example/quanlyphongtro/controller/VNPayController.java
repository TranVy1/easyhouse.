package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.config.VNPayConfig;
import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.services.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/vnpay")
@RequiredArgsConstructor
@Slf4j
public class VNPayController {

    private final VNPayService vnPayService;

    @GetMapping("/create-payment-url")
    public ApiResponse<String> createPaymentUrl(
            @RequestParam UUID hoaDonId, 
            @RequestParam long amount, 
            HttpServletRequest request) {
        
        String ipAddress = VNPayConfig.getIpAddress(request);
        String paymentUrl = vnPayService.createPaymentUrl(hoaDonId, amount, ipAddress);
        return ApiResponse.success(paymentUrl);
    }

    @GetMapping("/ipn")
    public ResponseEntity<Map<String, String>> vnpayIpn(@RequestParam Map<String, String> queryParams) {
        log.info("Received VNPay IPN: {}", queryParams);
        Map<String, String> result = vnPayService.processIpn(queryParams);
        return ResponseEntity.ok(result);
    }
}
