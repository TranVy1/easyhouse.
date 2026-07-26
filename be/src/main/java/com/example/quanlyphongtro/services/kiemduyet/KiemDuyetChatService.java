package com.example.quanlyphongtro.services.kiemduyet;

import com.example.quanlyphongtro.dto.BaoCaoTinNhanResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.entity.BaoCaoTinNhan;
import com.example.quanlyphongtro.entity.ChanNguoiDung;
import com.example.quanlyphongtro.entity.TinNhan;
import com.example.quanlyphongtro.entity.TrangThaiBaoCao;
import com.example.quanlyphongtro.exception.ChatKhongCoQuyenException;
import com.example.quanlyphongtro.exception.ChatKhongTimThayException;
import com.example.quanlyphongtro.exception.ChatYeuCauKhongHopLeException;
import com.example.quanlyphongtro.repository.BaoCaoTinNhanRepository;
import com.example.quanlyphongtro.repository.ChanNguoiDungRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.TinNhanRepository;
import com.example.quanlyphongtro.entity.AuditLog;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.services.ChatPermissionService;
import com.example.quanlyphongtro.services.PermissionService;
import com.example.quanlyphongtro.utils.PaginationUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.UUID;

/**
 * Kiem duyet noi dung chat (P6).
 *
 * Chat giua khach thue la noi dung do nguoi dung tao ra. Khong co duong bao cao
 * va xu ly thi chu tro khong co cach nao can thiep khi co quay roi.
 */
@Service
@RequiredArgsConstructor
public class KiemDuyetChatService {

    private final BaoCaoTinNhanRepository baoCaoRepository;
    private final ChanNguoiDungRepository chanRepository;
    private final TinNhanRepository tinNhanRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final PermissionService permissionService;
    private final ChatPermissionService chatPermissionService;
    private final AuditLogRepository auditLogRepository;
    private final com.fasterxml.jackson.databind.ObjectMapper objectMapper;

    /**
     * Kiem tra quyen admin va tra ve id nguoi goi.
     *
     * Khong dung permissionService.requireAdmin() truc tiep vi no nem RuntimeException
     * voi message "Quyen truy cap bi tu choi" — GlobalExceptionHandler doan HTTP status
     * bang cach do chuoi, va chuoi do khong khop tu khoa nao nen ra 400 thay vi 403.
     * Nem exception CO KIEU thi status la hop dong ro rang, khong phu thuoc cau chu.
     */
    private UUID yeuCauAdmin() {
        UUID toi = permissionService.requireCurrentUserId();
        if (!permissionService.isAdmin(toi)) {
            throw new ChatKhongCoQuyenException("Chi quan tri vien moi xem duoc bao cao");
        }
        return toi;
    }

    // ── Bao cao ────────────────────────────────────────────────────────────

    @Transactional
    public void baoCao(UUID tinNhanId, String lyDo) {
        UUID toi = permissionService.requireCurrentUserId();

        if (lyDo == null || lyDo.isBlank()) {
            throw new ChatYeuCauKhongHopLeException("Phai neu ly do bao cao");
        }

        TinNhan tinNhan = tinNhanRepository.findById(tinNhanId)
                .filter(t -> t.getXoaLuc() == null)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay tin nhan"));

        UUID hoiThoaiId = tinNhan.getCuocTroChuyen().getId();
        // Chi bao cao duoc tin trong hoi thoai minh tham gia — neu khong thi doan id
        // la bao cao duoc tin cua bat ky ai.
        chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        if (tinNhan.getNguoiGui() != null && tinNhan.getNguoiGui().getId().equals(toi)) {
            throw new ChatYeuCauKhongHopLeException("Khong the tu bao cao tin cua chinh minh");
        }
        if (baoCaoRepository.existsByTinNhanIdAndNguoiBaoCaoId(tinNhanId, toi)) {
            throw new ChatYeuCauKhongHopLeException("Ban da bao cao tin nay roi");
        }

        baoCaoRepository.save(BaoCaoTinNhan.builder()
                .tinNhan(tinNhan)
                .cuocTroChuyen(tinNhan.getCuocTroChuyen())
                .nguoiBaoCao(nguoiDungRepository.getReferenceById(toi))
                .lyDo(lyDo.trim())
                .build());
    }

    /**
     * Danh sach bao cao cho admin.
     *
     * Ghi AuditLog moi lan admin XEM, khong chi khi xu ly: xem tin nhan rieng cua
     * nguoi khac la hanh dong nhay cam, phai co dau vet.
     */
    @Transactional
    public PaginatedResponse<BaoCaoTinNhanResponse> danhSachChoAdmin(String trangThai, int page, int limit) {
        UUID toi = yeuCauAdmin();

        Page<BaoCaoTinNhan> trang = baoCaoRepository.danhSach(
                trangThai, PaginationUtils.createPageable(page, limit, null));

        if (!trang.isEmpty()) {
            ghiNhatKy(toi, "XEM_BAO_CAO_CHAT", null,
                    "Admin xem " + trang.getNumberOfElements() + " bao cao tin nhan");
        }

        return PaginatedResponse.of(trang, trang.getContent().stream()
                .map(BaoCaoTinNhanResponse::fromEntity)
                .toList());
    }

    @Transactional
    public void xuLyBaoCao(UUID baoCaoId, String trangThai, String ghiChu) {
        UUID toi = yeuCauAdmin();

        BaoCaoTinNhan baoCao = baoCaoRepository.findById(baoCaoId)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay bao cao"));

        TrangThaiBaoCao moi;
        try {
            moi = TrangThaiBaoCao.valueOf(trangThai.trim().toUpperCase());
        } catch (Exception ex) {
            throw new ChatYeuCauKhongHopLeException("Trang thai khong hop le: " + trangThai);
        }

        baoCao.setTrangThai(moi);
        baoCao.setNguoiXuLy(nguoiDungRepository.getReferenceById(toi));
        baoCao.setGhiChuXuLy(ghiChu);
        baoCao.setXuLyLuc(ZonedDateTime.now());
        baoCaoRepository.save(baoCao);

        ghiNhatKy(toi, "XU_LY_BAO_CAO_CHAT", baoCaoId,
                "Ket luan: " + moi + (ghiChu != null ? " — " + ghiChu : ""));
    }

    /**
     * Ghi dau vet moi thao tac kiem duyet.
     *
     * Ghi ca khi admin chi XEM, khong chi khi xu ly: doc tin nhan rieng cua nguoi
     * khac la hanh dong nhay cam, phai co dau vet de con quy trach nhiem.
     */
    private void ghiNhatKy(UUID nguoiDungId, String hanhDong, UUID banGhiId, String moTa) {
        auditLogRepository.save(AuditLog.builder()
                .nguoiDung(nguoiDungRepository.getReferenceById(nguoiDungId))
                .hanhDong(hanhDong)
                .bangTacDong("bao_cao_tin_nhan")
                .banGhiId(banGhiId)
                // du_lieu_moi la cot JSONB, khong phai text: truyen chuoi thuong vao
                // se bi PostgreSQL tu choi ("invalid input syntax for type json").
                .duLieuMoi(dongGoiJson(moTa))
                .build());
    }

    private String dongGoiJson(String moTa) {
        try {
            return objectMapper.writeValueAsString(java.util.Map.of("moTa", moTa != null ? moTa : ""));
        } catch (Exception ex) {
            return "{}";
        }
    }

    // ── Chan nguoi dung ────────────────────────────────────────────────────

    @Transactional
    public void chan(UUID nguoiBiChanId) {
        UUID toi = permissionService.requireCurrentUserId();
        if (toi.equals(nguoiBiChanId)) {
            throw new ChatYeuCauKhongHopLeException("Khong the tu chan chinh minh");
        }
        if (chanRepository.findByNguoiChanIdAndNguoiBiChanId(toi, nguoiBiChanId).isPresent()) {
            return; // da chan roi thi coi nhu xong
        }
        nguoiDungRepository.findById(nguoiBiChanId)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay nguoi dung"));

        chanRepository.save(ChanNguoiDung.builder()
                .nguoiChan(nguoiDungRepository.getReferenceById(toi))
                .nguoiBiChan(nguoiDungRepository.getReferenceById(nguoiBiChanId))
                .build());
    }

    @Transactional
    public void boChan(UUID nguoiBiChanId) {
        UUID toi = permissionService.requireCurrentUserId();
        chanRepository.findByNguoiChanIdAndNguoiBiChanId(toi, nguoiBiChanId)
                .ifPresent(chanRepository::delete);
    }

    @Transactional(readOnly = true)
    public boolean biChan(UUID nguoiA, UUID nguoiB) {
        return chanRepository.coChanGiuaHaiNguoi(nguoiA, nguoiB);
    }
}
