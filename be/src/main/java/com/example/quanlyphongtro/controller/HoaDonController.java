package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.services.HoaDonService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/hoa-don")
@RequiredArgsConstructor
public class HoaDonController {

    private final HoaDonService hoaDonService;

    // ========== GET ALL ==========
    @GetMapping
    public ApiResponse<List<HoaDonResponse>> getAll() {
        try {
            return ApiResponse.success(hoaDonService.getAll());
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== GET BY ID ==========
    @GetMapping("/{id}")
    public ApiResponse<HoaDonResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(hoaDonService.getById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== CREATE ==========
    @PostMapping
    public ApiResponse<HoaDonResponse> create(@RequestBody HoaDonRequest request) {
        try {
            return ApiResponse.success(
                    hoaDonService.create(request),
                    "Tạo hóa đơn thành công"
            );
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== UPDATE ==========
    @PutMapping("/{id}")
    public ApiResponse<HoaDonResponse> update(@PathVariable UUID id, @RequestBody HoaDonRequest request) {
        try {
            return ApiResponse.success(
                    hoaDonService.update(id, request),
                    "Cập nhật hóa đơn thành công"
            );
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== DELETE ==========
    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try {
            hoaDonService.delete(id);
            return ApiResponse.success(null, "Xóa hóa đơn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== DELETE by query param (frontend uses ?id=xxx) ==========
    @DeleteMapping
    public ApiResponse<Void> deleteByParam(@RequestParam UUID id) {
        try {
            hoaDonService.delete(id);
            return ApiResponse.success(null, "Xóa hóa đơn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== FORM DATA (cho dropdown tạo/sửa hóa đơn) ==========
    @GetMapping("/form-data")
    public ApiResponse<Map<String, Object>> getFormData() {
        try {
            return ApiResponse.success(hoaDonService.getFormData());
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== LATEST READING (chỉ số điện nước gần nhất) ==========
    @GetMapping("/latest-reading")
    public ApiResponse<Map<String, Object>> getLatestReading(
            @RequestParam String hopDong,
            @RequestParam int thang,
            @RequestParam int nam) {
        try {
            UUID hopDongId = UUID.fromString(hopDong);
            return ApiResponse.success(hoaDonService.getLatestReading(hopDongId, thang, nam));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== THANH TOÁN ==========
    @PostMapping("/{id}/thanh-toan")
    public ApiResponse<HoaDonResponse> thanhToan(
            @PathVariable UUID id,
            @RequestBody Map<String, Object> body) {
        try {
            BigDecimal soTien = new BigDecimal(body.get("soTien").toString());
            String phuongThuc = (String) body.get("phuongThuc");
            String ghiChu = (String) body.get("ghiChu");
            
            // Lấy mã tham chiếu từ thongTinChuyenKhoan nếu có
            String maThamChieu = null;
            if (body.get("thongTinChuyenKhoan") != null) {
                Map<String, Object> thongTin = (Map<String, Object>) body.get("thongTinChuyenKhoan");
                maThamChieu = (String) thongTin.get("soGiaoDich");
            }

            return ApiResponse.success(
                    hoaDonService.thanhToan(id, soTien, phuongThuc, ghiChu, maThamChieu),
                    "Thanh toán thành công"
            );
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
