package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import com.example.quanlyphongtro.services.HoaDonService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/hoa-don-public")
@RequiredArgsConstructor
public class HoaDonPublicController {

    private final HoaDonService hoaDonService;
    private final ThanhToanRepository thanhToanRepository;

    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> getPublicInvoice(@PathVariable UUID id) {
        try {
            // Lấy thông tin hóa đơn (bao gồm chi tiết)
            HoaDonResponse hoaDon = hoaDonService.getPublicById(id);
            
            // Lấy lịch sử thanh toán
            List<ThanhToan> payments = thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(id);
            
            // Map thanh toán sang format frontend mong đợi
            List<Map<String, Object>> thanhToanList = payments.stream().map(p -> {
                Map<String, Object> map = new HashMap<>();
                map.put("_id", p.getId());
                map.put("soTien", p.getSoTien());
                map.put("ngayThanhToan", p.getNgayThanhToan());
                map.put("phuongThuc", p.getPhuongThucThanhToan() != null ? p.getPhuongThucThanhToan().name() : "CASH");
                map.put("ghiChu", p.getGhiChu());
                
                if (p.getMaThamChieu() != null || p.getPhuongThucThanhToan() != null) {
                    Map<String, Object> thongTin = new HashMap<>();
                    thongTin.put("nganHang", p.getMaThamChieu()); // Tạm dùng maThamChieu làm tên ngân hàng
                    thongTin.put("soGiaoDich", p.getMaThamChieu());
                    map.put("thongTinChuyenKhoan", thongTin);
                }
                
                return map;
            }).collect(Collectors.toList());

            Map<String, Object> data = new HashMap<>();
            data.put("hoaDon", hoaDon);
            data.put("thanhToanList", thanhToanList);

            return ApiResponse.success(data);
        } catch (Exception e) {
            return ApiResponse.error("Không thể tìm thấy hóa đơn hoặc hóa đơn không tồn tại.");
        }
    }
}
