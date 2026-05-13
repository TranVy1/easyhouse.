package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ThongBaoRequest;
import com.example.quanlyphongtro.dto.ThongBaoResponse;
import com.example.quanlyphongtro.entity.ThongBao;
import com.example.quanlyphongtro.services.ThongBaoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/thong-bao")
@RequiredArgsConstructor
public class ThongBaoController {

    private final ThongBaoService thongBaoService;

    @GetMapping
    public ApiResponse<List<ThongBaoResponse>> getAll(@RequestParam(required = false) UUID nguoiDungId) {
        List<ThongBaoResponse> response = thongBaoService.getAll(nguoiDungId).stream()
                .map(thongBaoService::toResponse)
                .collect(Collectors.toList());
        return ApiResponse.success(response);
    }

    @GetMapping("/{id}")
    public ApiResponse<ThongBaoResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(thongBaoService.toResponse(thongBaoService.getById(id)));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<List<ThongBaoResponse>> create(@Valid @RequestBody ThongBaoRequest request) {
        try {
            List<ThongBaoResponse> response = thongBaoService.create(request).stream()
                    .map(thongBaoService::toResponse)
                    .collect(Collectors.toList());
            return ApiResponse.success(response, "Tao thong bao thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<ThongBaoResponse> update(@PathVariable UUID id, @Valid @RequestBody ThongBaoRequest request) {
        try {
            ThongBao thongBao = thongBaoService.update(id, request);
            return ApiResponse.success(thongBaoService.toResponse(thongBao), "Cap nhat thong bao thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PatchMapping("/{id}/da-doc")
    public ApiResponse<ThongBaoResponse> markRead(
            @PathVariable UUID id,
            @RequestParam(defaultValue = "true") boolean daDoc) {
        try {
            ThongBao thongBao = thongBaoService.markRead(id, daDoc);
            return ApiResponse.success(thongBaoService.toResponse(thongBao), "Cap nhat trang thai doc thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/{id}/send")
    public ApiResponse<ThongBaoResponse> send(@PathVariable UUID id) {
        try {
            ThongBao thongBao = thongBaoService.send(id);
            return ApiResponse.success(thongBaoService.toResponse(thongBao), "Gui thong bao thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteByPath(@PathVariable UUID id) {
        return delete(id);
    }

    @DeleteMapping
    public ApiResponse<Void> deleteByQuery(@RequestParam UUID id) {
        return delete(id);
    }

    private ApiResponse<Void> delete(UUID id) {
        try {
            thongBaoService.delete(id);
            return ApiResponse.success(null, "Xoa thong bao thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
