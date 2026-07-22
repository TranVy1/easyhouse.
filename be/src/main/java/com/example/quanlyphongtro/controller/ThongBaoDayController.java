package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.DangKyPushRequest;
import com.example.quanlyphongtro.services.push.DangKyPushService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Dang ky nhan thong bao day.
 *
 * Tach khoi TinNhanController vi day la ha tang chung: sau nay hoa don, su co,
 * lich hen cung co the dung chung duong nay.
 */
@RestController
@RequestMapping("/api/thong-bao-day")
@RequiredArgsConstructor
public class ThongBaoDayController {

    private final DangKyPushService dangKyPushService;

    @Value("${push.vapid.public-key:}")
    private String khoaCongVapid;

    /**
     * Khoa cong VAPID cho trinh duyet dang ky.
     *
     * Tra ve chuoi rong nghia la server chua bat thong bao day — client dua vao do
     * de an nut "Bat thong bao" thay vi hien nut bam vao khong chay.
     */
    @GetMapping("/khoa-cong")
    public ResponseEntity<ApiResponse<Map<String, String>>> khoaCong() {
        return ResponseEntity.ok(ApiResponse.success(Map.of("khoaCong", khoaCongVapid)));
    }

    @PostMapping("/dang-ky")
    public ResponseEntity<ApiResponse<Void>> dangKy(@Valid @RequestBody DangKyPushRequest request) {
        dangKyPushService.dangKy(request);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/huy-dang-ky")
    public ResponseEntity<ApiResponse<Void>> huyDangKy(@RequestBody Map<String, String> body) {
        dangKyPushService.huyDangKy(body.get("endpoint"));
        return ResponseEntity.ok(ApiResponse.success(null));
    }
}
