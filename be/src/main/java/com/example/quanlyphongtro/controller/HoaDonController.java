package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.services.HoaDonService;
import com.example.quanlyphongtro.services.ThanhToanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
    public ResponseEntity<ApiResponse<PaginatedResponse<HoaDonResponse>>> getAll(
            @RequestParam(required = false) String hopDongId,
            @RequestParam(required = false) String trangThai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hoaDonService.getAll(hopDongId, trangThai, page, limit)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<HoaDonResponse>> getById(@PathVariable UUID id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hoaDonService.getById(id)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<ApiResponse<HoaDonResponse>> create(@RequestBody HoaDonRequest request) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hoaDonService.create(request), "Tạo hóa đơn thành công"));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<HoaDonResponse>> update(@PathVariable UUID id, @RequestBody HoaDonRequest request) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hoaDonService.update(id, request), "Cập nhật hóa đơn thành công"));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        try {
            hoaDonService.delete(id);
            return ResponseEntity.ok(ApiResponse.success(null, "Xóa hóa đơn thành công"));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @DeleteMapping
    public ResponseEntity<ApiResponse<Void>> deleteByParam(@RequestParam UUID id) {
        return delete(id);
    }

    @GetMapping("/form-data")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getFormData() {
        try {
            return ResponseEntity.ok(ApiResponse.success(hoaDonService.getFormData()));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @GetMapping("/latest-reading")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getLatestReading(
            @RequestParam String hopDong,
            @RequestParam int thang,
            @RequestParam int nam) {
        try {
            UUID hopDongId = UUID.fromString(hopDong);
            return ResponseEntity.ok(ApiResponse.success(hoaDonService.getLatestReading(hopDongId, thang, nam)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @PostMapping("/{id}/thanh-toan")
    public ResponseEntity<ApiResponse<HoaDonResponse>> thanhToan(
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

            if (body.get("thongTinChuyenKhoan") instanceof Map<?, ?> thongTin) {
                ThanhToanRequest.ThongTinChuyenKhoan thongTinCK = new ThanhToanRequest.ThongTinChuyenKhoan();
                thongTinCK.setSoGiaoDich((String) thongTin.get("soGiaoDich"));
                thongTinCK.setNganHang((String) thongTin.get("nganHang"));
                ttRequest.setThongTinChuyenKhoan(thongTinCK);
            }

            thanhToanService.create(ttRequest);
            return ResponseEntity.ok(ApiResponse.success(hoaDonService.getById(id), "Thanh toán thành công"));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    private <T> ResponseEntity<ApiResponse<T>> badRequest(String message) {
        return ResponseEntity.badRequest().body(ApiResponse.error(message));
    }
}
