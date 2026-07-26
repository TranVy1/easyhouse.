package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.CloneToaNhaRequest;
import com.example.quanlyphongtro.dto.GenerateRoomsRequest;
import com.example.quanlyphongtro.dto.GenerateRoomsResponse;
import com.example.quanlyphongtro.dto.NhaTroRequest;
import com.example.quanlyphongtro.dto.NhaTroResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.dto.SoDoToaNhaResponse;
import com.example.quanlyphongtro.dto.TangResponse;
import com.example.quanlyphongtro.dto.ThongKeToaNhaResponse;
import com.example.quanlyphongtro.services.NhaTroService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping({"/api/nha-tro", "/api/toa-nha"})
@RequiredArgsConstructor
public class NhaTroController {

    private final NhaTroService nhaTroService;

    @GetMapping
    public ApiResponse<PaginatedResponse<NhaTroResponse>> getAll(
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit
    ) {
        return ApiResponse.success(nhaTroService.getAllNhaTro(search, page, limit));
    }

    @GetMapping("/{id}")
    public ApiResponse<NhaTroResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(nhaTroService.getNhaTroById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/{id}/tang")
    public ApiResponse<List<TangResponse>> getTang(@PathVariable UUID id) {
        try {
            return ApiResponse.success(nhaTroService.getTangByNhaTro(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/{id}/thong-ke")
    public ApiResponse<ThongKeToaNhaResponse> getThongKe(@PathVariable UUID id) {
        try {
            return ApiResponse.success(nhaTroService.getThongKeToaNha(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/{id}/so-do")
    public ApiResponse<SoDoToaNhaResponse> getSoDo(@PathVariable UUID id) {
        try {
            return ApiResponse.success(nhaTroService.getSoDoToaNha(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<NhaTroResponse> createNhaTro(@RequestBody NhaTroRequest request) {
        try {
            NhaTroResponse response = nhaTroService.createNhaTro(request);
            return ApiResponse.success(response, "Thêm tòa nhà thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/{id}/generate-rooms")
    public ApiResponse<GenerateRoomsResponse> generateRooms(@PathVariable UUID id, @RequestBody GenerateRoomsRequest request) {
        try {
            return ApiResponse.success(nhaTroService.generateRooms(id, request), "Tao phong hang loat thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/{id}/clone")
    public ApiResponse<NhaTroResponse> cloneNhaTro(@PathVariable UUID id, @RequestBody CloneToaNhaRequest request) {
        try {
            return ApiResponse.success(nhaTroService.cloneNhaTro(id, request), "Clone toa nha thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<NhaTroResponse> updateNhaTro(@PathVariable UUID id, @RequestBody NhaTroRequest request) {
        try {
            NhaTroResponse response = nhaTroService.updateNhaTro(id, request);
            return ApiResponse.success(response, "Cập nhật tòa nhà thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteNhaTro(@PathVariable UUID id) {
        try {
            nhaTroService.deleteNhaTro(id);
            return ApiResponse.success(null, "Xóa tòa nhà thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
