package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.HoaDonService;
import com.example.quanlyphongtro.services.HopDongService;
import com.example.quanlyphongtro.services.PermissionService;
import com.example.quanlyphongtro.services.SuCoService;
import com.example.quanlyphongtro.services.ThongBaoService;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/tenant")
@RequiredArgsConstructor
public class TenantApiController {

    private final HoaDonService hoaDonService;
    private final HopDongService hopDongService;
    private final PermissionService permissionService;
    private final ThanhToanRepository thanhToanRepository;
    private final SuCoService suCoService;
    private final ThongBaoService thongBaoService;

    @GetMapping("/hoa-don")
    public ResponseEntity<ApiResponse<PaginatedResponse<HoaDonResponse>>> getMyInvoices(
            @RequestParam(required = false) String trangThai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            // HoaDonService.getAll is already secured to only return invoices accessible by the current user.
            // For a tenant, it will return invoices where khachThue.nguoiDung.id = currentUserId.
            return ResponseEntity.ok(ApiResponse.success(
                    hoaDonService.getAll(null, trangThai, null, null, null, page, limit)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @GetMapping("/hoa-don/{id}")
    public ResponseEntity<ApiResponse<java.util.Map<String, Object>>> getMyInvoiceDetail(@PathVariable UUID id) {
        try {
            // HoaDonService.getById checks permissionService.canReadHoaDon which allows tenants to read their own.
            HoaDonResponse hoaDon = hoaDonService.getById(id);
            
            java.util.List<com.example.quanlyphongtro.entity.ThanhToan> payments = thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(id);
            
            java.util.List<java.util.Map<String, Object>> thanhToanList = payments.stream().map(p -> {
                java.util.Map<String, Object> map = new java.util.HashMap<>();
                map.put("_id", p.getId());
                map.put("soTien", p.getSoTien());
                map.put("ngayThanhToan", p.getNgayThanhToan());
                map.put("phuongThuc", p.getPhuongThucThanhToan() != null ? p.getPhuongThucThanhToan().name() : "CASH");
                map.put("ghiChu", p.getGhiChu());
                
                if (p.getMaThamChieu() != null || p.getPhuongThucThanhToan() != null) {
                    java.util.Map<String, Object> thongTin = new java.util.HashMap<>();
                    thongTin.put("nganHang", p.getMaThamChieu()); 
                    thongTin.put("soGiaoDich", p.getMaThamChieu());
                    map.put("thongTinChuyenKhoan", thongTin);
                }
                return map;
            }).collect(java.util.stream.Collectors.toList());

            java.util.Map<String, Object> data = new java.util.HashMap<>();
            data.put("hoaDon", hoaDon);
            data.put("thanhToanList", thanhToanList);

            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @GetMapping("/hop-dong")
    public ResponseEntity<ApiResponse<PaginatedResponse<HopDongResponse>>> getMyContracts(
            @RequestParam(required = false) String trangThai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hopDongService.getAll(null, null, trangThai, null, page, limit)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @GetMapping("/su-co")
    public ResponseEntity<ApiResponse<PaginatedResponse<com.example.quanlyphongtro.dto.SuCoResponse>>> getMyIncidents(
            @RequestParam(required = false) String trangThai,
            @RequestParam(required = false) String loaiSuCo,
            @RequestParam(required = false) String uuTien,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            return ResponseEntity.ok(ApiResponse.success(suCoService.getAllSuCo(
                    null, null, trangThai, loaiSuCo, uuTien, org.springframework.data.domain.PageRequest.of(Math.max(0, page - 1), limit)
            )));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @GetMapping("/thong-bao")
    public ResponseEntity<ApiResponse<PaginatedResponse<com.example.quanlyphongtro.dto.ThongBaoResponse>>> getMyNotifications(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            return ResponseEntity.ok(ApiResponse.success(thongBaoService.getMyThongBao(
                    org.springframework.data.domain.PageRequest.of(Math.max(0, page - 1), limit, org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "taoLuc"))
            )));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @PutMapping("/hop-dong/{id}/thanh-toan-coc")
    public ResponseEntity<ApiResponse<HopDongResponse>> thanhToanCoc(@PathVariable UUID id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hopDongService.thanhToanCoc(id)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    private <T> ResponseEntity<ApiResponse<T>> badRequest(String message) {
        return ResponseEntity.badRequest().body(ApiResponse.error(message));
    }
}
