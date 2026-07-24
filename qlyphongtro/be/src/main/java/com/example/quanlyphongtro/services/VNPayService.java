package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.config.VNPayConfig;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.ZonedDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class VNPayService {

    private final HoaDonRepository hoaDonRepository;
    private final ThanhToanRepository thanhToanRepository;
    // Inject BankTransactionLogService (REQUIRES_NEW) thay vì repository trực tiếp
    // → đảm bảo lỗi lưu log KHÔNG ảnh hưởng transaction thanh toán chính
    private final BankTransactionLogService bankTransactionLogService;

    @Value("${vnpay.tmn-code}")
    private String vnp_TmnCode;

    @Value("${vnpay.hash-secret}")
    private String vnp_HashSecret;

    @Value("${vnpay.pay-url}")
    private String vnp_PayUrl;

    @Value("${vnpay.return-url}")
    private String vnp_ReturnUrl;

    /**
     * Tạo URL thanh toán VNPAY.
     */
    public String createPaymentUrl(UUID hoaDonId, long amount, String ipAddress) {
        String vnp_Version   = "2.1.0";
        String vnp_Command   = "pay";
        String vnp_OrderInfo = "Thanh toan hoa don " + hoaDonId.toString();
        String vnp_OrderType = "other";
        String vnp_TxnRef    = VNPayConfig.getRandomNumber(8)
                + hoaDonId.toString().replace("-", "").substring(0, 8);

        long amountVnp = amount * 100; // VNPAY yêu cầu nhân 100

        // QUAN TRỌNG: Dùng "Asia/Ho_Chi_Minh" (UTC+7) KHÔNG dùng "Etc/GMT+7"
        // Vì trong Java/POSIX: "Etc/GMT+7" = UTC TRỪ 7 giờ (ngược chiều!)
        // → nếu dùng Etc/GMT+7, vnp_CreateDate sẽ lệch 14 tiếng so với server VNPAY
        // → VNPAY thấy giao dịch đã tạo từ 14 tiếng trước → báo hết hạn ngay lập tức
        TimeZone vnpayTZ = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
        Calendar cld = Calendar.getInstance(vnpayTZ);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        formatter.setTimeZone(vnpayTZ);

        String vnp_CreateDate = formatter.format(cld.getTime());
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());

        // TreeMap để tự sort theo key alphabet (bắt buộc theo chuẩn VNPAY)
        Map<String, String> vnp_Params = new TreeMap<>();
        vnp_Params.put("vnp_Version",    vnp_Version);
        vnp_Params.put("vnp_Command",    vnp_Command);
        vnp_Params.put("vnp_TmnCode",    vnp_TmnCode);
        vnp_Params.put("vnp_Amount",     String.valueOf(amountVnp));
        vnp_Params.put("vnp_CurrCode",   "VND");
        vnp_Params.put("vnp_TxnRef",     vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo",  vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType",  vnp_OrderType);
        vnp_Params.put("vnp_Locale",     "vn");
        vnp_Params.put("vnp_ReturnUrl",  vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr",     ipAddress);
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        // Build hashData và query - encode UTF-8 đúng chuẩn
        StringBuilder hashData = new StringBuilder();
        StringBuilder query    = new StringBuilder();
        boolean first = true;

        for (Map.Entry<String, String> entry : vnp_Params.entrySet()) {
            String fieldName  = entry.getKey();
            String fieldValue = entry.getValue();
            if (fieldValue == null || fieldValue.isEmpty()) continue;

            String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.UTF_8);
            if (!first) {
                hashData.append('&');
                query.append('&');
            }
            hashData.append(fieldName).append('=').append(encodedValue);
            query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8))
                 .append('=').append(encodedValue);
            first = false;
        }

        String vnp_SecureHash = VNPayConfig.hmacSHA512(vnp_HashSecret, hashData.toString());
        String paymentUrl = vnp_PayUrl + "?" + query + "&vnp_SecureHash=" + vnp_SecureHash;

        log.info("VNPay createPaymentUrl - hoaDonId={}, txnRef={}, amount={}", hoaDonId, vnp_TxnRef, amount);
        return paymentUrl;
    }

    /**
     * Xử lý callback từ VNPAY (IPN hoặc returnUrl).
     *
     * FIX CHÍNH: Không truy cập LAZY relation (hopDong.getKhachThue()) trong transaction
     * → dùng hoaDon.getKhachThue() trực tiếp vì HoaDon đã có sẵn khach_thue_id.
     *
     * Thứ tự các lỗi phổ biến dẫn đến không lưu DB:
     * 1. LazyInitializationException khi truy cập hopDong.getKhachThue() với LAZY fetch
     *    → Transaction bị rollback do exception, không lưu gì cả
     * 2. HoaDon không có field conLai trực tiếp (là generated column soDuCuoiKy)
     *    → Phải tính thủ công: tongTien - daTra
     * 3. Signature verify sai do hashData không dùng UTF-8
     */
    @Transactional
    public Map<String, String> processIpn(Map<String, String> rawParams) {
        Map<String, String> response = new HashMap<>();
        try {
            // Dùng TreeMap copy để không mutate params gốc
            Map<String, String> params = new TreeMap<>(rawParams);

            String receivedHash = params.remove("vnp_SecureHash");
            params.remove("vnp_SecureHashType");

            if (receivedHash == null || receivedHash.isEmpty()) {
                log.warn("VNPay IPN: Thiếu vnp_SecureHash");
                response.put("RspCode", "97");
                response.put("Message", "Missing Secure Hash");
                return response;
            }

            // ===== VERIFY SIGNATURE =====
            StringBuilder hashData = new StringBuilder();
            boolean first = true;
            for (Map.Entry<String, String> entry : params.entrySet()) {
                String v = entry.getValue();
                if (v == null || v.isEmpty()) continue;
                if (!first) hashData.append('&');
                hashData.append(entry.getKey())
                        .append('=')
                        .append(URLEncoder.encode(v, StandardCharsets.UTF_8));
                first = false;
            }

            String computedHash = VNPayConfig.hmacSHA512(vnp_HashSecret, hashData.toString());
            if (!computedHash.equalsIgnoreCase(receivedHash)) {
                log.warn("VNPay IPN: Chữ ký không hợp lệ. Computed={} Received={}", computedHash, receivedHash);
                response.put("RspCode", "97");
                response.put("Message", "Invalid Checksum");
                return response;
            }

            // ===== PARSE DỮ LIỆU =====
            String txnRef       = params.get("vnp_TxnRef");
            String orderInfo    = params.get("vnp_OrderInfo");
            String responseCode = params.get("vnp_ResponseCode");
            long   amount       = Long.parseLong(params.getOrDefault("vnp_Amount", "0")) / 100;

            log.info("VNPay callback - txnRef={}, responseCode={}, amount={}", txnRef, responseCode, amount);

            // ===== TRÍCH XUẤT hoaDonId =====
            UUID hoaDonId;
            try {
                String idStr = orderInfo.replace("Thanh toan hoa don ", "").trim();
                hoaDonId = UUID.fromString(idStr);
            } catch (Exception e) {
                log.error("VNPay IPN: Không thể parse hoaDonId từ orderInfo='{}'", orderInfo);
                response.put("RspCode", "01");
                response.put("Message", "Order not found");
                return response;
            }

            // ===== KIỂM TRA HÓA ĐƠN =====
            // FIX: Dùng findById thường (không findWithLazyRelations)
            // khachThue đã có trực tiếp trong HoaDon qua cột khach_thue_id
            HoaDon hoaDon = hoaDonRepository.findById(hoaDonId).orElse(null);
            if (hoaDon == null) {
                log.warn("VNPay IPN: Không tìm thấy hóa đơn id={}", hoaDonId);
                response.put("RspCode", "01");
                response.put("Message", "Order not found");
                return response;
            }

            // ===== IDEMPOTENCY: chống xử lý trùng =====
            if (thanhToanRepository.findByExternalTransactionId(txnRef).isPresent()) {
                log.info("VNPay IPN: Giao dịch {} đã xử lý trước đó", txnRef);
                response.put("RspCode", "02");
                response.put("Message", "Order already confirmed");
                return response;
            }

            // ===== CẬP NHẬT DB NẾU THÀNH CÔNG =====
            if ("00".equals(responseCode)) {
                // Tạo bản ghi ThanhToan
                ThanhToan thanhToan = new ThanhToan();
                thanhToan.setHoaDon(hoaDon);
                thanhToan.setSoTien(BigDecimal.valueOf(amount));
                thanhToan.setNgayThanhToan(ZonedDateTime.now());
                thanhToan.setPhuongThucThanhToan(PhuongThucThanhToan.VNPAY);
                thanhToan.setExternalTransactionId(txnRef);
                thanhToan.setTrangThai(TrangThaiThanhToan.SUCCESS);
                thanhToan.setGhiChu("VNPay | TxnRef: " + txnRef);

                // FIX QUAN TRỌNG: HoaDon đã có sẵn khachThue trực tiếp
                // → KHÔNG gọi hoaDon.getHopDong().getKhachThue() vì LAZY sẽ gây
                //   LazyInitializationException, dẫn đến rollback toàn bộ transaction
                thanhToan.setKhachThue(hoaDon.getKhachThue());

                ThanhToan saved = thanhToanRepository.save(thanhToan);
                log.info("VNPay: Đã lưu ThanhToan id={} cho hoaDon={}", saved.getId(), hoaDonId);

                // Cập nhật HoaDon - tính daTra và trạng thái
                BigDecimal daTraMoi = hoaDon.getDaTra().add(BigDecimal.valueOf(amount));
                BigDecimal conLai   = hoaDon.getTongTien().subtract(daTraMoi);
                hoaDon.setDaTra(daTraMoi);

                if (conLai.compareTo(BigDecimal.ZERO) <= 0) {
                    hoaDon.setTrangThai(TrangThaiHoaDon.PAID);
                } else {
                    hoaDon.setTrangThai(TrangThaiHoaDon.PARTIAL);
                }

                hoaDonRepository.save(hoaDon);
                log.info("VNPay: Đã cập nhật HoaDon={} daTra={} trangThai={}", hoaDonId, daTraMoi, hoaDon.getTrangThai());

                // ===== LƯU LOG VÀO bank_transaction (transaction độc lập REQUIRES_NEW) =====
                // Gọi qua bean inject (không gọi this.method()) → Spring AOP mới interceptđược
                bankTransactionLogService.saveVNPayLog(params, hoaDon, txnRef, amount);

            } else {
                log.info("VNPay: Giao dịch thất bại - responseCode={}", responseCode);
            }

            response.put("RspCode", "00");
            response.put("Message", "Confirm Success");

        } catch (Exception e) {
            log.error("VNPay IPN: Lỗi không xác định", e);
            response.put("RspCode", "99");
            response.put("Message", "Unknown error: " + e.getMessage());
        }
        return response;
    }

}
