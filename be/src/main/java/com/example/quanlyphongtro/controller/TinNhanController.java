package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.CapNhatNhomRequest;
import com.example.quanlyphongtro.dto.CapNhatTuyChonRequest;
import com.example.quanlyphongtro.dto.ChiTietTinNhanResponse;
import com.example.quanlyphongtro.dto.ChuyenTiepRequest;
import com.example.quanlyphongtro.dto.DatBietDanhRequest;
import com.example.quanlyphongtro.dto.LienKetChatResponse;
import com.example.quanlyphongtro.dto.TepDinhKemResponse;
import com.example.quanlyphongtro.dto.CuocTroChuyenResponse;
import com.example.quanlyphongtro.dto.DanhDauDaDocRequest;
import com.example.quanlyphongtro.dto.GuiTinNhanRequest;
import com.example.quanlyphongtro.dto.NguoiLienHeResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.dto.TaoHoiThoaiTrucTiepRequest;
import com.example.quanlyphongtro.dto.TaoNhomRequest;
import com.example.quanlyphongtro.dto.ThemThanhVienRequest;
import com.example.quanlyphongtro.dto.TinNhanResponse;
import com.example.quanlyphongtro.services.ChatPermissionService;
import com.example.quanlyphongtro.services.CuocTroChuyenService;
import com.example.quanlyphongtro.services.PermissionService;
import com.example.quanlyphongtro.services.TinNhanService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * REST cho module tin nhan.
 *
 * Dat o /api/tin-nhan chu KHONG phai /api/chat: frontend da co route handler
 * /api/chat cho chatbot Gemini, va rewrites() cua Next tra ve mang phang nen chay
 * SAU filesystem route — dat trung ten se khien dinh tuyen kho doan.
 *
 * Khac voi cac controller cu (bat het exception roi luon tra HTTP 200), module nay
 * de exception co kieu bay len GlobalExceptionHandler de status dung ngu nghia.
 * Client chat can phan biet 403 (dung han, thoi ket noi lai) voi loi mang (retry).
 */
@RestController
@RequestMapping("/api/tin-nhan")
@RequiredArgsConstructor
public class TinNhanController {

    private final CuocTroChuyenService cuocTroChuyenService;
    private final TinNhanService tinNhanService;
    private final ChatPermissionService chatPermissionService;
    private final PermissionService permissionService;

    // ── Hoi thoai ──────────────────────────────────────────────────────────

    /** @param luuTru false = danh sach thuong, true = xem cac muc da luu tru */
    @GetMapping("/hoi-thoai")
    public ResponseEntity<ApiResponse<PaginatedResponse<CuocTroChuyenResponse>>> danhSach(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit,
            @RequestParam(required = false) String loai,
            @RequestParam(defaultValue = "false") boolean luuTru) {
        return ResponseEntity.ok(ApiResponse.success(
                cuocTroChuyenService.danhSachCuaToi(page, limit, loai, luuTru)));
    }

    @GetMapping("/hoi-thoai/{id}")
    public ResponseEntity<ApiResponse<CuocTroChuyenResponse>> chiTiet(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(cuocTroChuyenService.chiTiet(id)));
    }

    /** Mo chat 1-1. Goi nhieu lan luon tra ve cung mot hoi thoai. */
    @PostMapping("/hoi-thoai/truc-tiep")
    public ResponseEntity<ApiResponse<CuocTroChuyenResponse>> moTrucTiep(
            @Valid @RequestBody TaoHoiThoaiTrucTiepRequest request) {
        return ResponseEntity.ok(ApiResponse.success(
                cuocTroChuyenService.layHoacTaoTrucTiep(request.getNguoiDungId())));
    }

    /** Mo kenh bao viec toi chu nha / nhan vien quan ly. */
    @PostMapping("/hoi-thoai/ho-tro")
    public ResponseEntity<ApiResponse<CuocTroChuyenResponse>> moHoTro(
            @RequestParam(required = false) UUID nhaTroId) {
        return ResponseEntity.ok(ApiResponse.success(
                cuocTroChuyenService.layHoacTaoHoTro(nhaTroId)));
    }

    // ── Nhom tu tao ────────────────────────────────────────────────────────

    /** Tao nhom tu chon nguoi — dung cho muon do, trao doi trong khu tro. */
    @PostMapping("/hoi-thoai")
    public ResponseEntity<ApiResponse<CuocTroChuyenResponse>> taoNhom(
            @Valid @RequestBody TaoNhomRequest request) {
        return ResponseEntity.ok(ApiResponse.success(cuocTroChuyenService.taoNhom(request)));
    }

    /** Doi ten / doi anh / khoa nhom. Chi ap dung cho nhom tu tao. */
    @PatchMapping("/hoi-thoai/{id}")
    public ResponseEntity<ApiResponse<CuocTroChuyenResponse>> capNhatNhom(
            @PathVariable UUID id,
            @Valid @RequestBody CapNhatNhomRequest request) {
        return ResponseEntity.ok(ApiResponse.success(cuocTroChuyenService.capNhatNhom(id, request)));
    }

    @PostMapping("/hoi-thoai/{id}/thanh-vien")
    public ResponseEntity<ApiResponse<CuocTroChuyenResponse>> themThanhVien(
            @PathVariable UUID id,
            @Valid @RequestBody ThemThanhVienRequest request) {
        return ResponseEntity.ok(ApiResponse.success(
                cuocTroChuyenService.themThanhVien(id, request.getNguoiDungIds())));
    }

    @DeleteMapping("/hoi-thoai/{id}/thanh-vien/{nguoiDungId}")
    public ResponseEntity<ApiResponse<CuocTroChuyenResponse>> xoaThanhVien(
            @PathVariable UUID id,
            @PathVariable UUID nguoiDungId) {
        return ResponseEntity.ok(ApiResponse.success(
                cuocTroChuyenService.xoaThanhVien(id, nguoiDungId)));
    }

    @PostMapping("/hoi-thoai/{id}/roi")
    public ResponseEntity<ApiResponse<Void>> roiNhom(@PathVariable UUID id) {
        cuocTroChuyenService.roiNhom(id);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    // ── Tin nhan ───────────────────────────────────────────────────────────

    /**
     * Lich su, cuon nguoc ve qua khu.
     *
     * @param truoc so thu tu lam moc; bo trong = bat dau tu tin moi nhat
     */
    @GetMapping("/hoi-thoai/{id}/tin-nhan")
    public ResponseEntity<ApiResponse<List<TinNhanResponse>>> lichSu(
            @PathVariable UUID id,
            @RequestParam(required = false) Long truoc,
            @RequestParam(defaultValue = "30") int limit) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.lichSu(id, truoc, limit)));
    }

    /**
     * Tin moi hon moc {@code sau}.
     *
     * Client goi endpoint nay moi lan noi lai WebSocket va moi khi phat hien lo hong
     * so thu tu. Cung la duong lui khi WebSocket khong noi duoc.
     */
    @GetMapping("/hoi-thoai/{id}/tin-nhan/moi")
    public ResponseEntity<ApiResponse<List<TinNhanResponse>>> delta(
            @PathVariable UUID id,
            @RequestParam(defaultValue = "0") long sau,
            @RequestParam(defaultValue = "50") int limit) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.delta(id, sau, limit)));
    }

    @PostMapping("/hoi-thoai/{id}/tin-nhan")
    public ResponseEntity<ApiResponse<TinNhanResponse>> gui(
            @PathVariable UUID id,
            @Valid @RequestBody GuiTinNhanRequest request) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.guiTinNhan(id, request)));
    }

    @PostMapping("/hoi-thoai/{id}/da-doc")
    public ResponseEntity<ApiResponse<Void>> danhDauDaDoc(
            @PathVariable UUID id,
            @Valid @RequestBody DanhDauDaDocRequest request) {
        tinNhanService.danhDauDaDoc(id, request.getDenSeq());
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    /**
     * Tai tep dinh kem cho hoi thoai, tra ve id de gui kem trong tin nhan.
     *
     * Khong dung /api/upload san co vi endpoint do khong kiem tra nguoi goi co
     * thuoc hoi thoai nao khong, va khong tao ban ghi FileMedia.
     */
    @PostMapping(value = "/hoi-thoai/{id}/tep", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ApiResponse<TepDinhKemResponse>> taiTepLen(
            @PathVariable UUID id,
            @RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.taiTepLen(id, file)));
    }

    /**
     * Tim kiem noi dung tin nhan, khong phan biet dau.
     *
     * @param hoiThoaiId bo trong = tim trong moi hoi thoai dang tham gia
     */
    @GetMapping("/tim-kiem")
    public ResponseEntity<ApiResponse<PaginatedResponse<TinNhanResponse>>> timKiem(
            @RequestParam String q,
            @RequestParam(required = false) UUID hoiThoaiId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit) {
        return ResponseEntity.ok(ApiResponse.success(
                tinNhanService.timKiem(q, hoiThoaiId, page, limit)));
    }

    // ── Bang thong tin hoi thoai (P7) ──────────────────────────────────────

    /** Anh hoac tep da trao doi — hai tab rieng vi cach hien thi khac han nhau. */
    @GetMapping("/hoi-thoai/{id}/tep-dinh-kem")
    public ResponseEntity<ApiResponse<PaginatedResponse<TinNhanResponse>>> tepDinhKem(
            @PathVariable UUID id,
            @RequestParam(defaultValue = "IMAGE") String loai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "30") int limit) {
        return ResponseEntity.ok(ApiResponse.success(
                tinNhanService.tepDinhKem(id, loai, page, limit)));
    }

    /** Cac lien ket da chia se, trich tu noi dung tin nhan. */
    @GetMapping("/hoi-thoai/{id}/lien-ket")
    public ResponseEntity<ApiResponse<PaginatedResponse<LienKetChatResponse>>> lienKet(
            @PathVariable UUID id,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "30") int limit) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.lienKet(id, page, limit)));
    }

    /** Dat/xoa biet danh cho mot thanh vien — moi nguoi trong hoi thoai cung thay. */
    @PatchMapping("/hoi-thoai/{id}/thanh-vien/{nguoiDungId}/biet-danh")
    public ResponseEntity<ApiResponse<CuocTroChuyenResponse>> datBietDanh(
            @PathVariable UUID id,
            @PathVariable UUID nguoiDungId,
            @Valid @RequestBody DatBietDanhRequest request) {
        tinNhanService.datBietDanh(id, nguoiDungId, request.getBietDanh());
        return ResponseEntity.ok(ApiResponse.success(cuocTroChuyenService.chiTiet(id)));
    }

    /** Ghim / tat thong bao — tuy chon rieng cua tung nguoi, khong anh huong ai khac. */
    @PatchMapping("/hoi-thoai/{id}/tuy-chon")
    public ResponseEntity<ApiResponse<Void>> capNhatTuyChon(
            @PathVariable UUID id,
            @RequestBody CapNhatTuyChonRequest request) {
        tinNhanService.capNhatTuyChon(id, request.getGhim(),
                request.getTatThongBao(), request.getTatThongBaoPhut(), request.getLuuTru());
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/{tinNhanId}/thu-hoi")
    public ResponseEntity<ApiResponse<TinNhanResponse>> thuHoi(@PathVariable UUID tinNhanId) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.thuHoi(tinNhanId)));
    }

    // ── Ghim tin, chuyen tiep, chi tiet (P8) ───────────────────────────────

    /** Ghim tin — pham vi ca hoi thoai, khac han ghim hoi thoai o /tuy-chon. */
    @PostMapping("/{tinNhanId}/ghim")
    public ResponseEntity<ApiResponse<TinNhanResponse>> ghim(@PathVariable UUID tinNhanId) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.datGhim(tinNhanId, true)));
    }

    @DeleteMapping("/{tinNhanId}/ghim")
    public ResponseEntity<ApiResponse<TinNhanResponse>> boGhim(@PathVariable UUID tinNhanId) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.datGhim(tinNhanId, false)));
    }

    /** Bang tin da ghim o dau khung chat. */
    @GetMapping("/hoi-thoai/{id}/ghim")
    public ResponseEntity<ApiResponse<List<TinNhanResponse>>> danhSachGhim(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.danhSachGhim(id)));
    }

    @PostMapping("/{tinNhanId}/chuyen-tiep")
    public ResponseEntity<ApiResponse<List<TinNhanResponse>>> chuyenTiep(
            @PathVariable UUID tinNhanId,
            @Valid @RequestBody ChuyenTiepRequest request) {
        return ResponseEntity.ok(ApiResponse.success(
                tinNhanService.chuyenTiep(tinNhanId, request.getHoiThoaiIds())));
    }

    /** Ai da xem tin nay, ai chua. */
    @GetMapping("/{tinNhanId}/chi-tiet")
    public ResponseEntity<ApiResponse<ChiTietTinNhanResponse>> chiTietTinNhan(@PathVariable UUID tinNhanId) {
        return ResponseEntity.ok(ApiResponse.success(tinNhanService.chiTiet(tinNhanId)));
    }

    /**
     * Xoa cuoc tro chuyen — chi xoa ban cua NGUOI GOI.
     *
     * Khong dung tu "xoa" theo nghia SQL: du lieu van con nguyen cho nhung nguoi
     * khac. Xem giai thich o TinNhanService.xoaBanCuaToi.
     */
    @DeleteMapping("/hoi-thoai/{id}")
    public ResponseEntity<ApiResponse<Void>> xoaBanCuaToi(@PathVariable UUID id) {
        tinNhanService.xoaBanCuaToi(id);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    // ── Phu tro ────────────────────────────────────────────────────────────

    /** Tong so tin chua doc — phuc vu badge, goi rat thuong xuyen nen giu that nhe. */
    @GetMapping("/chua-doc")
    public ResponseEntity<ApiResponse<Map<String, Long>>> demChuaDoc() {
        return ResponseEntity.ok(ApiResponse.success(
                Map.of("soTinChuaDoc", cuocTroChuyenService.demTongChuaDoc())));
    }

    /** Nhung nguoi ma nguoi dung hien tai duoc phep bat dau tro chuyen. */
    @GetMapping("/nguoi-lien-he")
    public ResponseEntity<ApiResponse<List<NguoiLienHeResponse>>> danhBa(
            @RequestParam(required = false) String q) {
        UUID toi = permissionService.requireCurrentUserId();
        return ResponseEntity.ok(ApiResponse.success(chatPermissionService.danhBa(toi, q)));
    }
}
