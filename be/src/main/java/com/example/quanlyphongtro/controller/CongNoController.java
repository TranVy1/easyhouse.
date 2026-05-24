package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.CongNoResponse;
import com.example.quanlyphongtro.services.CongNoService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/cong-no")
@RequiredArgsConstructor
public class CongNoController {

    private final CongNoService congNoService;

    @GetMapping
    public ApiResponse<List<CongNoResponse>> getAll() {
        return ApiResponse.success(congNoService.getTongNo());
    }
}
