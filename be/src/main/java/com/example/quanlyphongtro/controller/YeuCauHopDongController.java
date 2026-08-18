package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.DuyetYeuCauHopDongRequest;
import com.example.quanlyphongtro.dto.YeuCauHopDongResponse;
import com.example.quanlyphongtro.services.YeuCauHopDongService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Hang doi duyet yeu cau huy / gia han hop dong cho chu tro va admin.
 *
 * Phia khach thue gui yeu cau qua /api/hop-dong/{id}/yeu-cau (xem HopDongController)
 * vi thao tac do gan voi mot hop dong cu the.
 */
@RestController
@RequestMapping("/api/yeu-cau-hop-dong")
@RequiredArgsConstructor
public class YeuCauHopDongController {

    private final YeuCauHopDongService yeuCauHopDongService;

    /** Danh sach yeu cau dang cho duyet. Chu tro chi thay hop dong cua minh. */
    @GetMapping("/cho-duyet")
    public ResponseEntity<ApiResponse<List<YeuCauHopDongResponse>>> hangDoiChoDuyet() {
        return ResponseEntity.ok(ApiResponse.success(yeuCauHopDongService.hangDoiChoDuyet()));
    }

    @PostMapping("/{id}/duyet")
    public ResponseEntity<ApiResponse<YeuCauHopDongResponse>> duyet(
            @PathVariable UUID id,
            @RequestBody(required = false) DuyetYeuCauHopDongRequest request) {
        DuyetYeuCauHopDongRequest req = request != null ? request : new DuyetYeuCauHopDongRequest();
        return ResponseEntity.ok(ApiResponse.success(
                yeuCauHopDongService.duyet(id, req), "Đã duyệt yêu cầu"));
    }

    @PostMapping("/{id}/tu-choi")
    public ResponseEntity<ApiResponse<YeuCauHopDongResponse>> tuChoi(
            @PathVariable UUID id,
            @RequestBody DuyetYeuCauHopDongRequest request) {
        return ResponseEntity.ok(ApiResponse.success(
                yeuCauHopDongService.tuChoi(id, request), "Đã từ chối yêu cầu"));
    }

    /** Khach thue rut lai yeu cau khi chua duoc xu ly. */
    @PostMapping("/{id}/rut-lai")
    public ResponseEntity<ApiResponse<YeuCauHopDongResponse>> rutLai(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(
                yeuCauHopDongService.rutLai(id), "Đã rút lại yêu cầu"));
    }
}
