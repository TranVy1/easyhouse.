package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.services.DatCocPhongService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/dat-coc")
@RequiredArgsConstructor
public class DatCocPhongController {

    private final DatCocPhongService datCocPhongService;

    @GetMapping
    public ApiResponse<List<DatCocPhongResponse>> getAll(
            @RequestParam(required = false) UUID nhaTroId) {
        return ApiResponse.success(datCocPhongService.getAll(nhaTroId));
    }

    @GetMapping("/{id}")
    public ApiResponse<DatCocPhongResponse> getById(@PathVariable UUID id) {
        return ApiResponse.success(datCocPhongService.getById(id));
    }

    @PostMapping
    public ApiResponse<DatCocPhongResponse> create(@RequestBody DatCocPhongRequest request) {
        return ApiResponse.success(datCocPhongService.create(request));
    }

    @PatchMapping("/{id}/confirm")
    public ApiResponse<DatCocPhongResponse> confirm(@PathVariable UUID id) {
        return ApiResponse.success(datCocPhongService.confirm(id));
    }

    @PatchMapping("/{id}/cancel")
    public ApiResponse<DatCocPhongResponse> cancel(
            @PathVariable UUID id,
            @RequestBody CancelDatCocRequest request) {
        return ApiResponse.success(datCocPhongService.cancel(id, request));
    }

    @PostMapping("/{id}/convert-to-contract")
    public ApiResponse<DatCocPhongResponse> convertToContract(
            @PathVariable UUID id,
            @RequestBody ConvertDatCocRequest request) {
        return ApiResponse.success(datCocPhongService.convertToContract(id, request));
    }
}
