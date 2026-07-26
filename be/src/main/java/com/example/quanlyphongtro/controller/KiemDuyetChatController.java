package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.BaoCaoTinNhanResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.kiemduyet.KiemDuyetChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

/**
 * Kiem duyet noi dung chat (P6).
 *
 * Tach khoi TinNhanController vi doi tuong su dung khac han: nguoi dung thuong chi
 * dung hai endpoint bao cao/chan, phan con lai danh cho admin.
 */
@RestController
@RequestMapping("/api/kiem-duyet-chat")
@RequiredArgsConstructor
public class KiemDuyetChatController {

    private final KiemDuyetChatService kiemDuyetChatService;

    // ── Nguoi dung thuong ──────────────────────────────────────────────────

    @PostMapping("/bao-cao/{tinNhanId}")
    public ResponseEntity<ApiResponse<Void>> baoCao(
            @PathVariable UUID tinNhanId,
            @RequestBody Map<String, String> body) {
        kiemDuyetChatService.baoCao(tinNhanId, body.get("lyDo"));
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/chan/{nguoiDungId}")
    public ResponseEntity<ApiResponse<Void>> chan(@PathVariable UUID nguoiDungId) {
        kiemDuyetChatService.chan(nguoiDungId);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @DeleteMapping("/chan/{nguoiDungId}")
    public ResponseEntity<ApiResponse<Void>> boChan(@PathVariable UUID nguoiDungId) {
        kiemDuyetChatService.boChan(nguoiDungId);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    // ── Admin ──────────────────────────────────────────────────────────────

    /** Moi lan goi deu ghi AuditLog — doc tin rieng cua nguoi khac phai co dau vet. */
    @GetMapping("/bao-cao")
    public ResponseEntity<ApiResponse<PaginatedResponse<BaoCaoTinNhanResponse>>> danhSachBaoCao(
            @RequestParam(required = false) String trangThai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit) {
        return ResponseEntity.ok(ApiResponse.success(
                kiemDuyetChatService.danhSachChoAdmin(trangThai, page, limit)));
    }

    @PatchMapping("/bao-cao/{id}")
    public ResponseEntity<ApiResponse<Void>> xuLyBaoCao(
            @PathVariable UUID id,
            @RequestBody Map<String, String> body) {
        kiemDuyetChatService.xuLyBaoCao(id, body.get("trangThai"), body.get("ghiChu"));
        return ResponseEntity.ok(ApiResponse.success(null));
    }
}
