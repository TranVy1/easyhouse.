package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HopDongDichVuOptionResponse;
import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.HopDongService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

import com.example.quanlyphongtro.services.ContractDocumentService;
import com.example.quanlyphongtro.dto.ContractSignRequest;
import com.example.quanlyphongtro.dto.ContractSignatureResponse;
import com.example.quanlyphongtro.entity.ContractSignature;
import com.example.quanlyphongtro.entity.HopDong;

@RestController
@RequestMapping("/api/hop-dong")
@RequiredArgsConstructor
public class HopDongController {

    private final HopDongService hopDongService;
    private final ContractDocumentService contractDocumentService;


    @GetMapping
    public ResponseEntity<ApiResponse<PaginatedResponse<HopDongResponse>>> getAll(
            @RequestParam(required = false) String phongId,
            @RequestParam(required = false) String toaNha,
            @RequestParam(required = false) String trangThai,
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.getAll(phongId, toaNha, trangThai, search, page, limit)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<HopDongResponse>> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.getById(id)));
    }

    @GetMapping("/dich-vu")
    public ResponseEntity<ApiResponse<List<HopDongDichVuOptionResponse>>> getDichVuTheoPhong(@RequestParam UUID phongId) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.getDichVuTheoPhong(phongId)));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<HopDongResponse>> create(@Valid @RequestBody HopDongRequest request) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.create(request), "Tạo hợp đồng thành công"));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<HopDongResponse>> update(@PathVariable UUID id, @Valid @RequestBody HopDongRequest request) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.update(id, request), "Cập nhật hợp đồng thành công"));
    }

    @PostMapping("/{id}/preview")
    public ResponseEntity<ApiResponse<HopDongResponse>> preview(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.preview(id), "Xem truoc hop dong thanh cong"));
    }

    @PostMapping("/{id}/confirm")
    public ResponseEntity<ApiResponse<HopDongResponse>> confirm(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.confirm(id), "Xac nhan hop dong thanh cong"));
    }

    @PostMapping("/{id}/generate-pdf")
    public ResponseEntity<ApiResponse<HopDongResponse>> generatePdf(@PathVariable UUID id) {
        HopDong hd = contractDocumentService.generatePdf(id);
        return ResponseEntity.ok(ApiResponse.success(HopDongResponse.fromEntity(hd), "Sinh tài liệu PDF thành công"));
    }

    @PostMapping("/{id}/sign")
    public ResponseEntity<ApiResponse<ContractSignatureResponse>> signContract(
            @PathVariable UUID id, @RequestBody ContractSignRequest request) {
        ContractSignature sig = contractDocumentService.signContract(id, request);
        ContractSignatureResponse resp = ContractSignatureResponse.builder()
                .id(sig.getId())
                .signerId(sig.getSignerId())
                .signerRole(sig.getSignerRole())
                .signatureImageUrl(sig.getSignatureImageUrl())
                .signedAt(sig.getSignedAt())
                .ipAddress(sig.getIpAddress())
                .userAgent(sig.getUserAgent())
                .build();
        return ResponseEntity.ok(ApiResponse.success(resp, "Ký hợp đồng thành công"));
    }

    @PostMapping("/{id}/reject")
    public ResponseEntity<ApiResponse<HopDongResponse>> rejectContract(
            @PathVariable UUID id, @RequestBody ContractSignRequest request) {
        HopDong hd = contractDocumentService.rejectContract(id, request);
        return ResponseEntity.ok(ApiResponse.success(HopDongResponse.fromEntity(hd), "Từ chối ký hợp đồng thành công"));
    }

    @GetMapping("/{id}/signatures")
    public ResponseEntity<ApiResponse<List<ContractSignatureResponse>>> getSignatures(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(contractDocumentService.getSignatures(id)));
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        hopDongService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Xóa hợp đồng thành công"));
    }

    @PutMapping("/{id}/ket-thuc")
    public ResponseEntity<com.example.quanlyphongtro.dto.ApiResponse<com.example.quanlyphongtro.dto.HopDongResponse>> terminateContract(
            @PathVariable java.util.UUID id,
            @RequestBody com.example.quanlyphongtro.dto.KetThucHopDongRequest req) {
        return ResponseEntity.ok(com.example.quanlyphongtro.dto.ApiResponse.success(hopDongService.terminateContract(id, req), "Ket thuc hop dong thanh cong"));
    }

    @PutMapping("/{id}/gia-han")
    public ResponseEntity<com.example.quanlyphongtro.dto.ApiResponse<com.example.quanlyphongtro.dto.HopDongResponse>> extendContract(
            @PathVariable java.util.UUID id,
            @RequestBody com.example.quanlyphongtro.dto.GiaHanHopDongRequest req) {
        return ResponseEntity.ok(com.example.quanlyphongtro.dto.ApiResponse.success(hopDongService.extendContract(id, req), "Gia han hop dong thanh cong"));
    }
}
