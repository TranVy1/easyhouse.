package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.services.HoaDonService;
import com.example.quanlyphongtro.services.ThanhToanService;
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
    private final ThanhToanService thanhToanService;

    @GetMapping
    public ApiResponse<List<HoaDonResponse>> getAll() {
        try {
            return ApiResponse.success(hoaDonService.getAll());
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ApiResponse<HoaDonResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(hoaDonService.getById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<HoaDonResponse> create(@RequestBody HoaDonRequest request) {
        try {
            return ApiResponse.success(hoaDonService.create(request), "Tạo hóa đơn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<HoaDonResponse> update(@PathVariable UUID id, @RequestBody HoaDonRequest request) {
        try {
            return ApiResponse.success(hoaDonService.update(id, request), "Cập nhật hóa đơn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try {
            hoaDonService.delete(id);
            return ApiResponse.success(null, "Xóa hóa đơn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping
    public ApiResponse<Void> deleteByParam(@RequestParam UUID id) {
        try {
            hoaDonService.delete(id);
            return ApiResponse.success(null, "Xóa hóa đơn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/form-data")
    public ApiResponse<Map<String, Object>> getFormData() {
        try {
            return ApiResponse.success(hoaDonService.getFormData());
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

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

    @PostMapping("/{id}/thanh-toan")
    public ApiResponse<HoaDonResponse> thanhToan(
            @PathVariable UUID id,
            @RequestBody Map<String, Object> body) {
        try {
            ThanhToanRequest ttRequest = new ThanhToanRequest();
            ttRequest.setHoaDonId(id);
            ttRequest.setSoTien(new BigDecimal(body.get("soTien").toString()));
            ttRequest.setPhuongThuc((String) body.get("phuongThuc"));
            ttRequest.setGhiChu((String) body.get("ghiChu"));
            ttRequest.setAnhBienLai((String) body.get("anhBienLai"));
            ttRequest.setNgayThanhToan((String) body.get("ngayThanhToan"));
            
            if (body.get("thongTinChuyenKhoan") != null) {
                Map<String, Object> thongTin = (Map<String, Object>) body.get("thongTinChuyenKhoan");
                ThanhToanRequest.ThongTinChuyenKhoan thongTinCK = new ThanhToanRequest.ThongTinChuyenKhoan();
                thongTinCK.setSoGiaoDich((String) thongTin.get("soGiaoDich"));
                thongTinCK.setNganHang((String) thongTin.get("nganHang"));
                ttRequest.setThongTinChuyenKhoan(thongTinCK);
            }

            thanhToanService.create(ttRequest);
            return ApiResponse.success(hoaDonService.getById(id), "Thanh toán thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
