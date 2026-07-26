package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.config.VNPayConfig;
import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.services.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/vnpay")
@RequiredArgsConstructor
@Slf4j
public class VNPayController {

    private final VNPayService vnPayService;

    @Value("${app.frontend.base-url:http://localhost:3000}")
    private String frontendBaseUrl;

    /**
     * API: Tạo link thanh toán VNPAY.
     *
     * Frontend gọi: GET /api/vnpay/create-payment-url?hoaDonId=<UUID>&amount=<long>
     * Response: { success: true, data: "https://sandbox.vnpayment.vn/..." }
     * Frontend redirect window.location.href = data.data
     *
     * Test sandbox: Dùng thẻ test VNPAY (không cần quét QR thật):
     *   - Ngân hàng: NCB (thường hoạt động tốt nhất trên sandbox)
     *   - Số thẻ: 9704198526191432198
     *   - Tên: NGUYEN VAN A
     *   - Ngày phát hành: 07/15
     *   - OTP: 123456
     */
    @GetMapping("/create-payment-url")
    public ApiResponse<String> createPaymentUrl(
            @RequestParam UUID hoaDonId,
            @RequestParam long amount,
            HttpServletRequest request) {

        log.info("Tạo link thanh toán - hoaDonId={}, amount={}", hoaDonId, amount);
        String ipAddress = VNPayConfig.getIpAddress(request);
        String paymentUrl = vnPayService.createPaymentUrl(hoaDonId, amount, ipAddress);
        return ApiResponse.success(paymentUrl, "Tạo link thanh toán thành công");
    }

    /**
     * API: Xử lý IPN từ VNPAY (Instant Payment Notification).
     *
     * - VNPAY server gọi endpoint này ngay khi giao dịch kết thúc
     * - Đây là endpoint TỰ ĐỘNG, không qua browser
     * - Trên localhost: VNPAY KHÔNG THỂ gọi được → phải dùng ngrok
     * - Phải trả về {"RspCode":"00","Message":"Confirm Success"} để VNPAY biết đã nhận
     *
     * Cấu hình trong application.properties:
     *   vnpay.ipn-url=https://your-domain.com/api/vnpay/ipn
     */
    @GetMapping("/ipn")
    public ResponseEntity<Map<String, String>> vnpayIpn(
            @RequestParam Map<String, String> queryParams) {
        log.info("Nhận IPN từ VNPAY: {}", queryParams);
        Map<String, String> result = vnPayService.processIpn(queryParams);
        return ResponseEntity.ok(result);
    }

    /**
     * API: Xử lý returnUrl - trang VNPAY redirect browser người dùng về sau thanh toán.
     *
     * QUAN TRỌNG VỀ LOCALHOST:
     * - Endpoint này NHẬN request từ browser (redirect), khác với IPN (nhận từ server VNPAY)
     * - Vì vậy trên localhost VẪN HOẠT ĐỘNG
     * - VNPAY redirect: https://your-return-url?vnp_ResponseCode=00&vnp_SecureHash=xxx...
     *
     * Luồng:
     *   1. User thanh toán trên trang VNPAY
     *   2. VNPAY redirect browser về: http://localhost:8080/api/vnpay/vnpay-return?...
     *   3. Endpoint này xử lý thanh toán (nếu chưa xử lý qua IPN)
     *   4. Redirect browser về frontend: http://localhost:3000/thanh-toan/vnpay-return?...
     *
     * VÌ SAO KHÔNG REDIRECT ĐƯỢC:
     * - vnp_ReturnUrl bị encode sai → VNPAY không redirect đúng URL
     * - Endpoint /api/payment/vnpay-return không tồn tại → 404 → browser không đi đâu
     * - Security chặn URL này (cần permit trong SecurityConfig)
     */
    @GetMapping("/vnpay-return")
    public void vnpayReturn(
            @RequestParam Map<String, String> queryParams,
            HttpServletResponse response) throws IOException {

        log.info("=== VNPAY Return ===");
        log.info("ResponseCode: {}", queryParams.get("vnp_ResponseCode"));
        log.info("TxnRef: {}", queryParams.get("vnp_TxnRef"));
        log.info("Amount: {}", queryParams.get("vnp_Amount"));

        // Xử lý thanh toán (idempotent - an toàn khi gọi nhiều lần)
        // IPN và returnUrl đều gọi processIpn → sẽ không bị duplicate nhờ check txnRef
        try {
            Map<String, String> result = vnPayService.processIpn(queryParams);
            log.info("Kết quả xử lý thanh toán: {}", result);
        } catch (Exception e) {
            log.error("Lỗi xử lý thanh toán qua returnUrl", e);
            // Vẫn redirect về frontend để hiển thị kết quả
        }

        // Redirect về trang frontend hiển thị kết quả
        // Giữ nguyên tất cả query params của VNPAY để frontend đọc vnp_ResponseCode
        String redirectUrl = frontendBaseUrl + "/thanh-toan/vnpay-return";
        StringBuilder urlBuilder = new StringBuilder(redirectUrl);
        boolean first = true;
        for (Map.Entry<String, String> entry : queryParams.entrySet()) {
            urlBuilder.append(first ? "?" : "&");
            urlBuilder.append(URLEncoder.encode(entry.getKey(),   StandardCharsets.UTF_8));
            urlBuilder.append("=");
            urlBuilder.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
            first = false;
        }

        String finalUrl = urlBuilder.toString();
        log.info("Redirect về frontend: {}", finalUrl);
        response.sendRedirect(finalUrl);
    }
}
