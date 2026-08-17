package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HopDongDichVuOptionResponse;
import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.HopDongService;
import com.example.quanlyphongtro.services.PermissionService;
import com.example.quanlyphongtro.services.QuyetToanTraPhongService;
import com.example.quanlyphongtro.services.ContractDocumentService;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.dto.TaoQuyetToanTraPhongRequest;
import com.example.quanlyphongtro.dto.HoanTatQuyetToanTraPhongRequest;
import com.example.quanlyphongtro.dto.QuyetToanTraPhongResponse;
import com.example.quanlyphongtro.dto.BanGiaoTaiSanRequest;
import com.example.quanlyphongtro.dto.ContractSignRequest;
import com.example.quanlyphongtro.dto.ContractSignatureResponse;
import com.example.quanlyphongtro.entity.ContractSignature;
import com.example.quanlyphongtro.entity.HopDong;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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

@RestController
@RequestMapping("/api/hop-dong")
@RequiredArgsConstructor
public class HopDongController {

    private final HopDongService hopDongService;
    private final QuyetToanTraPhongService quyetToanTraPhongService;
    private final ContractDocumentService contractDocumentService;
    private final HopDongRepository hopDongRepository;
    private final PermissionService permissionService;

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

    @GetMapping("/default-terms")
    public ResponseEntity<ApiResponse<String>> getDefaultTerms() {
        return ResponseEntity.ok(ApiResponse.success(contractDocumentService.getDefaultTerms()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<HopDongResponse>> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.getById(id)));
    }

    @GetMapping("/{id}/document")
    public ResponseEntity<?> getDocument(
            @PathVariable UUID id,
            @RequestParam(defaultValue = "pdf") String format,
            @RequestParam(required = false) Integer download) {
        UUID currentUserId = permissionService.requireCurrentUserId();
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        hopDongService.assertCanRead(hd, currentUserId);

        // Goi overload nhan UUID: chung co @Transactional nen cac quan he lazy
        // (phong -> nha_tro -> chu_tro) van nap duoc. Truyen thang entity `hd`
        // lay o tren se nem LazyInitializationException vi session da dong.
        if ("html".equalsIgnoreCase(format)) {
            String html = contractDocumentService.renderHtml(id);
            return ResponseEntity.ok()
                    .contentType(MediaType.valueOf("text/html;charset=UTF-8"))
                    .body(html);
        }

        byte[] pdfBytes = contractDocumentService.generatePdfBytes(id);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        String disposition = (download != null && download == 1) ? "attachment" : "inline";
        String filename = "hop-dong-" + (hd.getMaHopDong() != null ? hd.getMaHopDong() : hd.getId()) + ".pdf";
        headers.setContentDisposition(ContentDisposition.builder(disposition)
                .filename(filename)
                .build());
        return ResponseEntity.ok().headers(headers).body(pdfBytes);
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
        return ResponseEntity.ok(ApiResponse.success(hopDongService.preview(id), "Xem trước hợp đồng thành công"));
    }

    @PostMapping("/{id}/confirm")
    public ResponseEntity<ApiResponse<HopDongResponse>> confirm(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.confirm(id), "Xác nhận hợp đồng thành công"));
    }

    @PostMapping("/{id}/generate-pdf")
    public ResponseEntity<ApiResponse<HopDongResponse>> generatePdf(@PathVariable UUID id) {
        contractDocumentService.generatePdf(id);
        return ResponseEntity.ok(ApiResponse.success(hopDongService.getById(id), "Sinh tài liệu PDF thành công"));
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
        contractDocumentService.rejectContract(id, request);
        return ResponseEntity.ok(ApiResponse.success(hopDongService.getById(id), "Từ chối ký hợp đồng thành công"));
    }

    /**
     * Tra ve danh sach truong bat buoc con thieu. Rong = du dieu kien ky.
     * Giao dien dung de tat nut ky va chi ro can bo sung gi, thay vi de nguoi
     * dung bam ky roi moi bao loi.
     */
    @GetMapping("/{id}/kiem-tra-truoc-ky")
    public ResponseEntity<ApiResponse<List<String>>> kiemTraTruocKy(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(contractDocumentService.kiemTraThongTinBatBuoc(id)));
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

    @PutMapping("/{id}/huy")
    public ResponseEntity<ApiResponse<HopDongResponse>> cancelContract(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(hopDongService.cancelContract(id), "Hủy hợp đồng thành công"));
    }

    @PutMapping("/{id}/ket-thuc")
    public ResponseEntity<com.example.quanlyphongtro.dto.ApiResponse<com.example.quanlyphongtro.dto.HopDongResponse>> terminateContract(
            @PathVariable java.util.UUID id,
            @RequestBody com.example.quanlyphongtro.dto.KetThucHopDongRequest req) {
        return ResponseEntity.status(HttpStatus.GONE).body(com.example.quanlyphongtro.dto.ApiResponse.error(
                "Hãy dùng quy trình quyết toán trả phòng để bảo đảm cọc, chứng từ, bàn giao và kiểm tra được ghi nhận"));
    }

    @PostMapping("/{id}/quyet-toan-tra-phong")
    public ResponseEntity<ApiResponse<QuyetToanTraPhongResponse>> taoQuyetToanTraPhong(
            @PathVariable UUID id, @RequestBody TaoQuyetToanTraPhongRequest request) {
        return ResponseEntity.ok(ApiResponse.success(quyetToanTraPhongService.tao(id, request), "Đã lập quyết toán trả phòng"));
    }

    @GetMapping("/{id}/quyet-toan-tra-phong")
    public ResponseEntity<ApiResponse<QuyetToanTraPhongResponse>> getQuyetToanTraPhong(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(quyetToanTraPhongService.getByHopDong(id)));
    }

    @PostMapping("/{id}/quyet-toan-tra-phong/hoan-tat")
    public ResponseEntity<ApiResponse<HopDongResponse>> hoanTatQuyetToanTraPhong(
            @PathVariable UUID id, @RequestBody HoanTatQuyetToanTraPhongRequest request) {
        return ResponseEntity.ok(ApiResponse.success(quyetToanTraPhongService.hoanTat(id, request), "Đã hoàn tất trả phòng"));
    }

    @PostMapping("/{id}/quyet-toan-tra-phong/ban-giao")
    public ResponseEntity<ApiResponse<QuyetToanTraPhongResponse>> capNhatBanGiaoTaiSan(
            @PathVariable UUID id, @RequestBody BanGiaoTaiSanRequest request) {
        return ResponseEntity.ok(ApiResponse.success(quyetToanTraPhongService.capNhatBanGiaoTaiSan(id, request), "Đã lưu biên bản bàn giao tài sản"));
    }

    @PutMapping("/{id}/gia-han")
    public ResponseEntity<com.example.quanlyphongtro.dto.ApiResponse<com.example.quanlyphongtro.dto.HopDongResponse>> extendContract(
            @PathVariable java.util.UUID id,
            @RequestBody com.example.quanlyphongtro.dto.GiaHanHopDongRequest req) {
        return ResponseEntity.ok(com.example.quanlyphongtro.dto.ApiResponse.success(hopDongService.extendContract(id, req), "Gia hạn hợp đồng thành công"));
    }
}
