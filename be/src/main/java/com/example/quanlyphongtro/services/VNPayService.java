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

    @Value("${vnpay.tmn-code}")
    private String vnp_TmnCode;

    @Value("${vnpay.hash-secret}")
    private String vnp_HashSecret;

    @Value("${vnpay.pay-url}")
    private String vnp_PayUrl;

    @Value("${vnpay.return-url}")
    private String vnp_ReturnUrl;

    public String createPaymentUrl(UUID hoaDonId, long amount, String ipAddress) {
        // Build VNPay URL
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_OrderInfo = "Thanh toan hoa don " + hoaDonId.toString();
        String orderType = "other";
        String vnp_TxnRef = hoaDonId.toString().substring(0, 8) + VNPayConfig.getRandomNumber(8);
        
        long amountVnp = amount * 100; // VNPay requires amount * 100

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amountVnp));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", ipAddress);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        // Build query url
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                // Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                // Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = VNPayConfig.hmacSHA512(vnp_HashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = vnp_PayUrl + "?" + queryUrl;
        return paymentUrl;
    }

    @Transactional
    public Map<String, String> processIpn(Map<String, String> vnp_Params) {
        Map<String, String> response = new HashMap<>();
        try {
            String vnp_SecureHash = vnp_Params.get("vnp_SecureHash");
            if (vnp_Params.containsKey("vnp_SecureHashType")) {
                vnp_Params.remove("vnp_SecureHashType");
            }
            if (vnp_Params.containsKey("vnp_SecureHash")) {
                vnp_Params.remove("vnp_SecureHash");
            }

            // Checksum
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                    if (itr.hasNext()) {
                        hashData.append('&');
                    }
                }
            }
            String signValue = VNPayConfig.hmacSHA512(vnp_HashSecret, hashData.toString());
            
            if (!signValue.equals(vnp_SecureHash)) {
                response.put("RspCode", "97");
                response.put("Message", "Invalid Checksum");
                return response;
            }

            // Valid signature
            String orderInfo = vnp_Params.get("vnp_OrderInfo"); // "Thanh toan hoa don " + hoaDonId
            String txnRef = vnp_Params.get("vnp_TxnRef");
            long amount = Long.parseLong(vnp_Params.get("vnp_Amount")) / 100;
            String responseCode = vnp_Params.get("vnp_ResponseCode");
            
            // Extract hoaDonId
            UUID hoaDonId = null;
            try {
                String idStr = orderInfo.replace("Thanh toan hoa don ", "").trim();
                hoaDonId = UUID.fromString(idStr);
            } catch (Exception e) {
                log.error("Cannot extract HoaDon ID from OrderInfo: {}", orderInfo);
                response.put("RspCode", "01");
                response.put("Message", "Order not found");
                return response;
            }

            HoaDon hoaDon = hoaDonRepository.findById(hoaDonId).orElse(null);
            if (hoaDon == null) {
                response.put("RspCode", "01");
                response.put("Message", "Order not found");
                return response;
            }

            // Check if already processed
            if (thanhToanRepository.findByExternalTransactionId(txnRef).isPresent()) {
                response.put("RspCode", "02");
                response.put("Message", "Order already confirmed");
                return response;
            }

            // Check amount (optional strict check, here we just trust the amount paid if it's less or equal to conLai, 
            // but usually VNPay pays the exact amount we requested)
            // if (hoaDon.getConLai().compareTo(BigDecimal.valueOf(amount)) != 0) {
            //     response.put("RspCode", "04");
            //     response.put("Message", "Invalid amount");
            //     return response;
            // }

            if ("00".equals(responseCode)) {
                // Payment success
                ThanhToan thanhToan = new ThanhToan();
                thanhToan.setHoaDon(hoaDon);
                thanhToan.setSoTien(BigDecimal.valueOf(amount));
                thanhToan.setNgayThanhToan(ZonedDateTime.now());
                thanhToan.setPhuongThucThanhToan(PhuongThucThanhToan.VNPAY);
                thanhToan.setExternalTransactionId(txnRef);
                thanhToan.setTrangThai(TrangThaiThanhToan.SUCCESS);
                thanhToan.setGhiChu("Thanh toán qua VNPay");
                
                // KhachThue reference if possible
                if (hoaDon.getHopDong() != null && hoaDon.getHopDong().getKhachThue() != null) {
                    thanhToan.setKhachThue(hoaDon.getHopDong().getKhachThue());
                }

                thanhToanRepository.save(thanhToan);
                
                // Update HoaDon
                BigDecimal totalPaid = hoaDon.getDaTra().add(BigDecimal.valueOf(amount));
                hoaDon.setDaTra(totalPaid);
                BigDecimal conLai = hoaDon.getTongTien().subtract(totalPaid);
                
                if (conLai.compareTo(BigDecimal.ZERO) <= 0) {
                    hoaDon.setTrangThai(TrangThaiHoaDon.PAID);
                } else {
                    hoaDon.setTrangThai(TrangThaiHoaDon.PARTIAL);
                }
                
                hoaDonRepository.save(hoaDon);
            }

            response.put("RspCode", "00");
            response.put("Message", "Confirm Success");

        } catch (Exception e) {
            log.error("IPN Process Error", e);
            response.put("RspCode", "99");
            response.put("Message", "Unknown error");
        }
        return response;
    }
}
