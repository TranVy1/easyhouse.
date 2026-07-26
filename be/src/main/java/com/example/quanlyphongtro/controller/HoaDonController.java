package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.dto.InvoiceGenerationPreviewResponse;
import com.example.quanlyphongtro.dto.InvoiceGenerationRequest;
import com.example.quanlyphongtro.dto.InvoiceGenerationResultResponse;
import com.example.quanlyphongtro.services.HoaDonService;
import com.example.quanlyphongtro.services.ThanhToanService;
import com.example.quanlyphongtro.services.InvoiceGenerationService;
import jakarta.validation.Valid;
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
import java.util.Map;
import java.util.UUID;

/**
 * FIX #2: Loại bỏ try-catch và badRequest() helper cục bộ.
 * Exception được xử lý tập trung tại GlobalExceptionHandler → HTTP status đúng ngữ nghĩa.
 * FIX #2: Thêm @Valid vào create/update để kích hoạt Bean Validation trên DTO.
 */
@RestController
@RequestMapping("/api/hoa-don")
@RequiredArgsConstructor
public class HoaDonController {

    private final HoaDonService hoaDonService;
    private final ThanhToanService thanhToanService;
    private final InvoiceGenerationService invoiceGenerationService;

    @GetMapping
    public ResponseEntity<ApiResponse<PaginatedResponse<HoaDonResponse>>> getAll(
            @RequestParam(required = false) String hopDongId,
            @RequestParam(required = false) String trangThai,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Integer kyThang,
            @RequestParam(required = false) Integer kyNam,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(ApiResponse.success(
                hoaDonService.getAll(hopDongId, trangThai, search, kyThang, kyNam, page, limit)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<HoaDonResponse>> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(hoaDonService.getById(id)));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<HoaDonResponse>> create(@Valid @RequestBody HoaDonRequest request) {
        return ResponseEntity.ok(ApiResponse.success(hoaDonService.create(request), "Tạo hóa đơn thành công"));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<HoaDonResponse>> update(
            @PathVariable UUID id,
            @Valid @RequestBody HoaDonRequest request) {
        return ResponseEntity.ok(ApiResponse.success(hoaDonService.update(id, request), "Cập nhật hóa đơn thành công"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        hoaDonService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Xóa hóa đơn thành công"));
    }

    @DeleteMapping
    public ResponseEntity<ApiResponse<Void>> deleteByParam(@RequestParam UUID id) {
        return delete(id);
    }

    @GetMapping("/form-data")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getFormData() {
        return ResponseEntity.ok(ApiResponse.success(hoaDonService.getFormData()));
    }

    @GetMapping("/latest-reading")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getLatestReading(
            @RequestParam String hopDong,
            @RequestParam int thang,
            @RequestParam int nam) {
        UUID hopDongId = UUID.fromString(hopDong);
        return ResponseEntity.ok(ApiResponse.success(hoaDonService.getLatestReading(hopDongId, thang, nam)));
    }

    @PostMapping("/{id}/thanh-toan")
    public ResponseEntity<ApiResponse<HoaDonResponse>> thanhToan(
            @PathVariable UUID id,
            @RequestBody Map<String, Object> body) {
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
    }

    @GetMapping("/generation-preview")
    public ResponseEntity<ApiResponse<InvoiceGenerationPreviewResponse>> preview(
            @RequestParam(required = false) UUID nhaTroId,
            @RequestParam int kyThang,
            @RequestParam int kyNam,
            @RequestParam(defaultValue = "false") boolean requireConfirmedReadings) {
        return ResponseEntity.ok(ApiResponse.success(
                invoiceGenerationService.preview(nhaTroId, kyThang, kyNam, requireConfirmedReadings)));
    }

    @PostMapping("/generate-monthly")
    public ResponseEntity<ApiResponse<InvoiceGenerationResultResponse>> generate(
            @RequestBody InvoiceGenerationRequest request) {
        return ResponseEntity.ok(ApiResponse.success(
                invoiceGenerationService.generate(request), "Sinh hóa đơn hàng tháng thành công"));
    }
}
