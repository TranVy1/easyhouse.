package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.NguoiLienHeResponse;
import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.NguoiDungNhaTro;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.entity.TrangThaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.VaiTroThanhVienChat;
import com.example.quanlyphongtro.exception.ChatKhongCoQuyenException;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Phan quyen cho module tin nhan.
 *
 * QUAN TRONG — khong duoc tin vai tro trong JWT de suy ra "la chu nha":
 * AuthService lam phang LANDLORD va STAFF thanh ADMIN khi dang ky va khi resolve
 * (xem AuthService.assignRole / resolveRole), nen token chi con ADMIN hoac TENANT.
 * Moi cau hoi "nguoi nay co lien quan toi nha tro X khong" deu phai tra DB.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChatPermissionService {

    private final PermissionService permissionService;
    private final com.example.quanlyphongtro.repository.ChanNguoiDungRepository chanNguoiDungRepository;
    private final ThanhVienCuocTroChuyenRepository thanhVienRepository;
    private final HopDongRepository hopDongRepository;
    private final NhaTroRepository nhaTroRepository;
    private final NguoiDungNhaTroRepository nguoiDungNhaTroRepository;

    // ── Thanh vien hoi thoai ────────────────────────────────────────────────

    public Optional<ThanhVienCuocTroChuyen> thanhVienDangHoatDong(UUID hoiThoaiId, UUID nguoiDungId) {
        return thanhVienRepository.findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, nguoiDungId)
                .filter(ThanhVienCuocTroChuyen::dangHoatDong);
    }

    /**
     * Doc duoc khi la thanh vien dang hoat dong.
     *
     * Admin he thong KHONG duoc tu dong doc chat rieng cua nguoi khac — muon kiem
     * duyet thi phai co hanh dong ro rang va ghi AuditLog, lam o giai doan sau.
     */
    public boolean coTheDoc(UUID hoiThoaiId, UUID nguoiDungId) {
        return thanhVienDangHoatDong(hoiThoaiId, nguoiDungId).isPresent();
    }

    public ThanhVienCuocTroChuyen yeuCauLaThanhVien(UUID hoiThoaiId, UUID nguoiDungId) {
        return thanhVienDangHoatDong(hoiThoaiId, nguoiDungId)
                .orElseThrow(() -> new ChatKhongCoQuyenException(
                        "Ban khong co quyen truy cap cuoc tro chuyen nay"));
    }

    public void yeuCauCoTheGui(CuocTroChuyen hoiThoai, UUID nguoiDungId) {
        yeuCauLaThanhVien(hoiThoai.getId(), nguoiDungId);
        if (hoiThoai.getTrangThai() == TrangThaiCuocTroChuyen.LOCKED) {
            throw new ChatKhongCoQuyenException("Cuoc tro chuyen da bi khoa, chi co the xem lai");
        }
    }

    /**
     * Quyen quan tri mot nhom TU TAO: doi ten, them/xoa thanh vien, khoa nhom.
     *
     * Nhom TU DONG (BUILDING/FLOOR) khong ai duoc sua tay — thanh vien cua chung do
     * hop dong quyet dinh, sua tay se bi job dong bo ghi de va gay kho hieu.
     */
    public void yeuCauQuanTriNhom(CuocTroChuyen hoiThoai, UUID nguoiDungId) {
        if (hoiThoai.getLoai() != LoaiCuocTroChuyen.GROUP) {
            throw new ChatKhongCoQuyenException(
                    "Chi sua duoc nhom tu tao. Nhom theo nha tro va theo tang do he thong tu quan ly.");
        }

        ThanhVienCuocTroChuyen thanhVien = yeuCauLaThanhVien(hoiThoai.getId(), nguoiDungId);
        boolean laQuanTri = thanhVien.getVaiTro() == VaiTroThanhVienChat.OWNER
                || thanhVien.getVaiTro() == VaiTroThanhVienChat.MODERATOR;
        if (laQuanTri) return;

        // Chu tro / nhan vien co quyen sua nha tro cung duoc quan tri nhom trong pham vi do.
        UUID nhaTroId = hoiThoai.getNhaTro() != null ? hoiThoai.getNhaTro().getId() : null;
        if (nhaTroId != null) {
            UUID chuTroId = nhaTroRepository.findByIdAndXoaLucIsNull(nhaTroId)
                    .map(nt -> nt.getChuTro() != null ? nt.getChuTro().getId() : null)
                    .orElse(null);
            if (permissionService.canWriteNhaTro(nguoiDungId, nhaTroId, chuTroId)) return;
        }

        throw new ChatKhongCoQuyenException("Ban khong co quyen quan tri nhom nay");
    }

    // ── Pham vi nha tro ─────────────────────────────────────────────────────

    /**
     * Tap nha tro ma nguoi dung co lien quan, gop tu ca ba tu cach:
     * khach thue dang thue, chu tro so huu, nhan vien duoc gan quyen.
     *
     * Mot nguoi co the vua la chu tro nha nay vua thue phong nha khac, nen phai
     * cong ca ba nguon chu khong duoc dung if/else.
     */
    public Set<UUID> nhaTroCuaNguoiDung(UUID nguoiDungId) {
        Set<UUID> ketQua = new java.util.HashSet<>(hopDongRepository.findNhaTroIdsDangThue(nguoiDungId));

        nhaTroRepository.findByChuTroIdAndXoaLucIsNull(nguoiDungId)
                .forEach(nt -> ketQua.add(nt.getId()));

        nguoiDungNhaTroRepository.findByNguoiDungId(nguoiDungId).stream()
                .filter(q -> Boolean.TRUE.equals(q.getCoQuyenXem()) || Boolean.TRUE.equals(q.getCoQuyenSua()))
                .map(NguoiDungNhaTro::getNhaTro)
                .filter(java.util.Objects::nonNull)
                .forEach(nt -> ketQua.add(nt.getId()));

        return ketQua;
    }

    /**
     * Hai nguoi co duoc nhan tin voi nhau khong.
     *
     * Luat: phai cung it nhat mot nha tro. Nho vay khach thue nha A khong the
     * nhan tin lam phien khach thue nha B, nhung van nhan tin duoc voi chu tro
     * va voi nguoi cung nha minh.
     */
    public boolean cungPhamVi(UUID nguoiA, UUID nguoiB) {
        if (nguoiA.equals(nguoiB)) return false;

        // Chan xet TRUOC ca quyen admin va truoc pham vi nha tro: da chan nhau thi
        // khong mo chat moi duoc, bat ke ai la ai.
        //
        // Xet CA HAI CHIEU du chan la mot chieu — neu B chan A ma van cho A mo cuoc
        // tro chuyen thi A gui vao khoang khong, do la lua nguoi dung.
        if (chanNguoiDungRepository.coChanGiuaHaiNguoi(nguoiA, nguoiB)) return false;

        if (permissionService.isAdmin(nguoiA)) return true;

        Set<UUID> cuaA = nhaTroCuaNguoiDung(nguoiA);
        if (cuaA.isEmpty()) return false;

        Set<UUID> cuaB = nhaTroCuaNguoiDung(nguoiB);
        return cuaB.stream().anyMatch(cuaA::contains);
    }

    public void yeuCauCungPhamVi(UUID nguoiA, UUID nguoiB) {
        if (!cungPhamVi(nguoiA, nguoiB)) {
            throw new ChatKhongCoQuyenException(
                    "Ban khong co quyen nhan tin voi nguoi nay");
        }
    }

    // ── Danh ba ────────────────────────────────────────────────────────────

    /**
     * Nhung nguoi ma nguoi dung hien tai duoc phep bat dau tro chuyen.
     *
     * Gom: chu tro va nhan vien cua cac nha tro lien quan, cong voi khach thue
     * dang thue trong nhung nha tro do. Da loc bo chinh minh va nguoi trung lap.
     *
     * @param tuKhoa loc theo ten hoac so dien thoai, co the null
     */
    public List<NguoiLienHeResponse> danhBa(UUID nguoiDungId, String tuKhoa) {
        List<UUID> nhaTroIds = new ArrayList<>(nhaTroCuaNguoiDung(nguoiDungId));
        if (nhaTroIds.isEmpty()) return List.of();

        // LinkedHashMap giu thu tu uu tien: chu tro -> nhan vien -> khach thue,
        // va tu dong khu trung khi mot nguoi giu nhieu vai tro.
        Map<UUID, NguoiLienHeResponse> theoId = new LinkedHashMap<>();

        for (NhaTro nhaTro : nhaTroRepository.findAllById(nhaTroIds)) {
            NguoiDung chuTro = nhaTro.getChuTro();
            if (chuTro != null && !chuTro.getId().equals(nguoiDungId)) {
                theoId.putIfAbsent(chuTro.getId(), NguoiLienHeResponse.fromEntity(chuTro, "LANDLORD"));
            }
        }

        for (NguoiDungNhaTro quyen : nguoiDungNhaTroRepository.findByNhaTroIdIn(nhaTroIds)) {
            NguoiDung nhanVien = quyen.getNguoiDung();
            if (nhanVien != null && !nhanVien.getId().equals(nguoiDungId)) {
                theoId.putIfAbsent(nhanVien.getId(), NguoiLienHeResponse.fromEntity(nhanVien, "STAFF"));
            }
        }

        for (NguoiDung khachThue : hopDongRepository.findNguoiDungKhachThueDangThue(nhaTroIds)) {
            if (!khachThue.getId().equals(nguoiDungId)) {
                theoId.putIfAbsent(khachThue.getId(), NguoiLienHeResponse.fromEntity(khachThue, "TENANT"));
            }
        }

        // Loai nguoi da chan / bi chan. Phai loc RIENG o day vi danhBa dung tu pham
        // vi nha tro chu khong di qua cungPhamVi — de sot thi nguoi da chan van hien
        // ra cho bam vao, va chi bao loi sau khi bam.
        Set<UUID> biChan = chanNguoiDungRepository.findByNguoiChanId(nguoiDungId).stream()
                .map(c -> c.getNguoiBiChan() != null ? c.getNguoiBiChan().getId() : null)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());

        return theoId.values().stream()
                .filter(nguoi -> !biChan.contains(nguoi.getNguoiDungId()))
                .filter(nguoi -> !chanNguoiDungRepository.coChanGiuaHaiNguoi(nguoiDungId, nguoi.getNguoiDungId()))
                .filter(nguoi -> khopTuKhoa(nguoi, tuKhoa))
                .sorted(Comparator.comparing(NguoiLienHeResponse::getHoTen,
                        Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER)))
                .collect(Collectors.toList());
    }

    private boolean khopTuKhoa(NguoiLienHeResponse nguoi, String tuKhoa) {
        if (tuKhoa == null || tuKhoa.isBlank()) return true;
        String tk = tuKhoa.trim().toLowerCase();
        String ten = nguoi.getHoTen() != null ? nguoi.getHoTen().toLowerCase() : "";
        String sdt = nguoi.getSoDienThoai() != null ? nguoi.getSoDienThoai().toLowerCase() : "";
        return ten.contains(tk) || sdt.contains(tk);
    }
}
