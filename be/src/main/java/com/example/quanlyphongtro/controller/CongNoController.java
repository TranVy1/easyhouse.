package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.CongNoResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.CongNoService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/cong-no")
@RequiredArgsConstructor
public class CongNoController {

    private final CongNoService congNoService;

    @GetMapping
    public ApiResponse<PaginatedResponse<CongNoResponse>> getAll(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(defaultValue = "tongNo,desc") String sort,
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "false") boolean overdueOnly) {
        org.springframework.data.domain.Pageable pageable = com.example.quanlyphongtro.utils.PaginationUtils.createPageable(page, limit, sort);
        return ApiResponse.success(congNoService.getTongNo(pageable, search, overdueOnly));
    }
}
