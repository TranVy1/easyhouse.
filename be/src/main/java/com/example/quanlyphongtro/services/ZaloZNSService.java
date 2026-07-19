package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.KhachThue;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class ZaloZNSService {

    @Value("${zalo.zns.access-token:}")
    private String accessToken;

    @Value("${zalo.zns.template.invoice:123456}")
    private String invoiceTemplateId;

    private final RestTemplate restTemplate = new RestTemplate();

    public void sendInvoiceNotification(HoaDon hoaDon) {
        KhachThue khach = hoaDon.getKhachThue();
        if (khach == null || khach.getSoDienThoai() == null || khach.getSoDienThoai().isEmpty()) {
            log.warn("Zalo ZNS: Khách thuê không có số điện thoại để gửi Zalo cho Hóa Đơn {}", hoaDon.getMaHoaDon());
            return;
        }

        String phone = formatPhoneForZalo(khach.getSoDienThoai());

        if (accessToken == null || accessToken.isBlank()) {
            log.info("[MOCK ZALO ZNS] Đã gửi thông báo Zalo ZNS cho sđt {} về hóa đơn {}, số tiền: {}", 
                phone, hoaDon.getMaHoaDon(), hoaDon.getTongTien().subtract(hoaDon.getDaTra()));
            return;
        }

        try {
            String url = "https://business.openapi.zalo.me/message/template";
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("access_token", accessToken);

            Map<String, Object> templateData = new HashMap<>();
            templateData.put("ma_hoa_don", hoaDon.getMaHoaDon());
            templateData.put("ten_khach", khach.getHoTen());
            templateData.put("so_tien", String.format("%,.0f VNĐ", hoaDon.getTongTien().subtract(hoaDon.getDaTra())));
            templateData.put("thang", hoaDon.getKyThang() + "/" + hoaDon.getKyNam());

            Map<String, Object> body = new HashMap<>();
            body.put("phone", phone);
            body.put("template_id", invoiceTemplateId);
            body.put("template_data", templateData);
            body.put("tracking_id", "HD_" + hoaDon.getId().toString());

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
            
            String response = restTemplate.postForObject(url, request, String.class);
            log.info("Zalo ZNS response for invoice {}: {}", hoaDon.getMaHoaDon(), response);
        } catch (Exception e) {
            log.error("Lỗi khi gửi Zalo ZNS cho hóa đơn {}: {}", hoaDon.getMaHoaDon(), e.getMessage());
        }
    }

    private String formatPhoneForZalo(String phone) {
        // Zalo requires phone in format 84...
        if (phone.startsWith("0")) {
            return "84" + phone.substring(1);
        } else if (phone.startsWith("+84")) {
            return "84" + phone.substring(3);
        }
        return phone;
    }
}
