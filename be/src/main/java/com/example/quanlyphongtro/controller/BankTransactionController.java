package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.BankTransactionResponse;
import com.example.quanlyphongtro.dto.DoiSoatRequest;
import com.example.quanlyphongtro.services.BankTransactionService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/bank-transaction")
@RequiredArgsConstructor
public class BankTransactionController {

    private final BankTransactionService bankTransactionService;

    @GetMapping
    public ResponseEntity<ApiResponse<Page<BankTransactionResponse>>> getAll(
            @RequestParam(required = false) UUID nhaTroId,
            @RequestParam(required = false) Boolean daDoiSoat,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "thoiGianGiaoDich"));
        return ResponseEntity.ok(ApiResponse.<Page<BankTransactionResponse>>builder()
                .success(true)
                .message("Lấy danh sách giao dịch thành công")
                .data(bankTransactionService.getAll(nhaTroId, daDoiSoat, pageable))
                .build());
    }

    @PostMapping("/manual-match")
    public ResponseEntity<ApiResponse<BankTransactionResponse>> manualMatch(@RequestBody DoiSoatRequest request) {
        return ResponseEntity.ok(ApiResponse.<BankTransactionResponse>builder()
                .success(true)
                .message("Đối soát thủ công thành công")
                .data(bankTransactionService.manualMatch(request))
                .build());
    }
}
