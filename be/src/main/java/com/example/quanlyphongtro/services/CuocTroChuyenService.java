package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.CapNhatNhomRequest;
import com.example.quanlyphongtro.dto.CuocTroChuyenResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.dto.TaoNhomRequest;
import com.example.quanlyphongtro.dto.TinNhanResponse;
import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.NguoiDungNhaTro;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.entity.TinNhan;
import com.example.quanlyphongtro.entity.TrangThaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.VaiTroThanhVienChat;
import com.example.quanlyphongtro.event.TinNhanCreatedEvent;
import com.example.quanlyphongtro.exception.ChatKhongTimThayException;
import com.example.quanlyphongtro.exception.ChatYeuCauKhongHopLeException;
import com.example.quanlyphongtro.repository.CuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.TinNhanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CuocTroChuyenService {

    private final CuocTroChuyenRepository cuocTroChuyenRepository;
    private final ThanhVienCuocTroChuyenRepository thanhVienRepository;
    private final TinNhanRepository tinNhanRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final NhaTroRepository nhaTroRepository;
    private final NguoiDungNhaTroRepository nguoiDungNhaTroRepository;
    private final PermissionService permissionService;
    private final ChatPermissionService chatPermissionService;
    private final CuocTroChuyenFactory cuocTroChuyenFactory;
    private final ChatMembershipService chatMembershipService;
    private final ApplicationEventPublisher eventPublisher;

    // ── Get-or-create ──────────────────────────────────────────────────────

    /**
     * Mo chat 1-1 voi mot nguoi. Goi nhieu lan luon tra ve CUNG mot hoi thoai,
     * ke ca khi hai ben bam cung luc hoac ben kia bam truoc.
     *
     * KHONG dat @Transactional o day: factory phai chay trong transaction rieng
     * de bat duoc loi trung khoa ma khong lam hong transaction hien tai.
     */
    public CuocTroChuyenResponse layHoacTaoTrucTiep(UUID doiPhuongId) {
        UUID toi = permissionService.requireCurrentUserId();

        if (toi.equals(doiPhuongId)) {
            throw new ChatYeuCauKhongHopLeException("Khong the tu nhan tin voi chinh minh");
        }
        NguoiDung doiPhuong = nguoiDungRepository.findById(doiPhuongId)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay nguoi dung nay"));

        chatPermissionService.yeuCauCungPhamVi(toi, doiPhuongId);

        String khoa = khoaTrucTiep(toi, doiPhuongId);
        NhaTro nhaTroChung = nhaTroChung(toi, doiPhuongId);

        CuocTroChuyen hoiThoai = layHoacTao(khoa, () -> cuocTroChuyenFactory.tao(
                LoaiCuocTroChuyen.DIRECT,
                khoa,
                null,                       // ten hien thi suy tu doi phuong
                nhaTroChung,
                null,
                nguoiDungRepository.getReferenceById(toi),
                List.of(toi, doiPhuong.getId()),
                Map.of()));

        return dungResponse(hoiThoai, toi);
    }

    /**
     * Kenh bao viec cho chu nha / nhan vien quan ly.
     *
     * Thanh vien = nguoi goi + chu tro + toan bo nhan vien co quyen xem nha tro do.
     * Nho vay khach thue chi can gui mot cho, ai truc cung nhan duoc.
     *
     * @param nhaTroId co the null — khi do lay nha tro dau tien ma nguoi goi lien quan
     */
    public CuocTroChuyenResponse layHoacTaoHoTro(UUID nhaTroId) {
        UUID toi = permissionService.requireCurrentUserId();

        UUID nhaTroDich = nhaTroId != null ? nhaTroId
                : nhaTroMacDinh(toi, "Ban chua thue phong nao nen chua co ban quan ly de lien he");
        NhaTro nhaTro = nhaTroRepository.findByIdAndXoaLucIsNull(nhaTroDich)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay nha tro"));

        if (!chatPermissionService.nhaTroCuaNguoiDung(toi).contains(nhaTroDich)
                && !permissionService.isAdmin(toi)) {
            throw new ChatYeuCauKhongHopLeException("Ban khong lien quan toi nha tro nay");
        }

        String khoa = "support_" + nhaTroDich + "_" + toi;

        CuocTroChuyen hoiThoai = layHoacTao(khoa, () -> cuocTroChuyenFactory.tao(
                LoaiCuocTroChuyen.SUPPORT,
                khoa,
                null,
                nhaTro,
                null,
                nguoiDungRepository.getReferenceById(toi),
                thanhVienKenhHoTro(toi, nhaTro),
                Map.of()));

        return dungResponse(hoiThoai, toi);
    }

    /**
     * Doc truoc, tao sau, doc lai neu dinh trung khoa.
     *
     * Lan doc thu hai la truong hop hai request tao cung mot hoi thoai gan nhu
     * dong thoi: rang buoc UNIQUE chan ban ghi thu hai, va ta lay ban ghi ben kia
     * vua tao thay vi bao loi cho nguoi dung.
     */
    private CuocTroChuyen layHoacTao(String khoa, java.util.function.Supplier<CuocTroChuyen> taoMoi) {
        return cuocTroChuyenRepository.findByKhoaDuyNhatAndXoaLucIsNull(khoa)
                .orElseGet(() -> {
                    try {
                        return taoMoi.get();
                    } catch (DataIntegrityViolationException trungKhoa) {
                        return cuocTroChuyenRepository.findByKhoaDuyNhatAndXoaLucIsNull(khoa)
                                .orElseThrow(() -> trungKhoa);
                    }
                });
    }

    // ── Nhom tu tao ────────────────────────────────────────────────────────

    /**
     * Tao nhom tu chon nguoi (muon do, trao doi...).
     *
     * Dung chung ham tao voi chat 1-1 — chat 1-1 chi la truong hop hai thanh vien,
     * nen khong co duong code rieng nao phai bao tri song song.
     */
    @Transactional
    public CuocTroChuyenResponse taoNhom(TaoNhomRequest request) {
        UUID toi = permissionService.requireCurrentUserId();

        // LinkedHashSet: giu thu tu nguoi tao dau tien va tu khu trung neu client
        // gui lap id.
        Set<UUID> thanhVienIds = new LinkedHashSet<>();
        thanhVienIds.add(toi);
        for (UUID id : request.getThanhVienIds()) {
            if (id == null || id.equals(toi)) continue;
            // Kiem tung nguoi: khong duoc keo nguoi ngoai pham vi nha tro vao nhom.
            chatPermissionService.yeuCauCungPhamVi(toi, id);
            thanhVienIds.add(id);
        }
        if (thanhVienIds.size() < 2) {
            throw new ChatYeuCauKhongHopLeException("Nhom phai co it nhat 2 nguoi");
        }

        UUID nhaTroDich = request.getNhaTroId() != null ? request.getNhaTroId()
                : nhaTroMacDinh(toi, "Ban chua thuoc nha tro nao nen chua the tao nhom");
        if (!chatPermissionService.nhaTroCuaNguoiDung(toi).contains(nhaTroDich)
                && !permissionService.isAdmin(toi)) {
            throw new ChatYeuCauKhongHopLeException("Ban khong lien quan toi nha tro nay");
        }
        NhaTro nhaTro = nhaTroRepository.findByIdAndXoaLucIsNull(nhaTroDich)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay nha tro"));

        CuocTroChuyen nhom = cuocTroChuyenFactory.tao(
                LoaiCuocTroChuyen.GROUP,
                "group_" + UUID.randomUUID(),   // nhom tu tao thi khong chong trung
                request.getTen().trim(),
                nhaTro,
                null,
                nguoiDungRepository.getReferenceById(toi),
                thanhVienIds,
                Map.of(toi, VaiTroThanhVienChat.OWNER));

        String tenNguoiTao = tenNguoiDung(toi);
        banTinHeThong(nhom, tenNguoiTao + " đã tạo nhóm");
        return dungResponse(nhom, toi);
    }

    @Transactional
    public CuocTroChuyenResponse themThanhVien(UUID hoiThoaiId, List<UUID> nguoiDungIds) {
        UUID toi = permissionService.requireCurrentUserId();
        CuocTroChuyen nhom = yeuCauHoiThoai(hoiThoaiId);
        chatPermissionService.yeuCauQuanTriNhom(nhom, toi);

        List<ThanhVienCuocTroChuyen> dangCo = thanhVienRepository.dangHoatDong(hoiThoaiId);
        Set<UUID> daTrongNhom = dangCo.stream()
                .map(tv -> tv.getNguoiDung().getId())
                .collect(Collectors.toSet());

        List<String> tenDaThem = new ArrayList<>();
        List<ThanhVienCuocTroChuyen> canLuu = new ArrayList<>();

        for (UUID id : nguoiDungIds) {
            if (id == null || daTrongNhom.contains(id)) continue;
            chatPermissionService.yeuCauCungPhamVi(toi, id);

            // Tai kich hoat neu truoc do ho da roi nhom, thay vi tao ban ghi thu hai.
            ThanhVienCuocTroChuyen cu = thanhVienRepository
                    .findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, id).orElse(null);
            if (cu != null) {
                cu.setRoiLuc(null);
                cu.setThamGiaLuc(ZonedDateTime.now());
                canLuu.add(cu);
            } else {
                canLuu.add(ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(nhom)
                        .nguoiDung(nguoiDungRepository.getReferenceById(id))
                        .build());
            }
            tenDaThem.add(tenNguoiDung(id));
        }

        if (canLuu.isEmpty()) {
            throw new ChatYeuCauKhongHopLeException("Nhung nguoi nay da o trong nhom");
        }
        thanhVienRepository.saveAll(canLuu);
        banTinHeThong(nhom, tenNguoiDung(toi) + " đã thêm " + String.join(", ", tenDaThem));
        return dungResponse(nhom, toi);
    }

    @Transactional
    public CuocTroChuyenResponse xoaThanhVien(UUID hoiThoaiId, UUID nguoiDungId) {
        UUID toi = permissionService.requireCurrentUserId();
        CuocTroChuyen nhom = yeuCauHoiThoai(hoiThoaiId);
        chatPermissionService.yeuCauQuanTriNhom(nhom, toi);

        if (nguoiDungId.equals(toi)) {
            throw new ChatYeuCauKhongHopLeException("Muon tu ra thi dung chuc nang roi nhom");
        }

        ThanhVienCuocTroChuyen thanhVien = chatPermissionService
                .thanhVienDangHoatDong(hoiThoaiId, nguoiDungId)
                .orElseThrow(() -> new ChatKhongTimThayException("Nguoi nay khong o trong nhom"));

        // Danh dau roi thay vi xoa: tin cu cua ho van con ngu canh nguoi gui.
        thanhVien.setRoiLuc(ZonedDateTime.now());
        thanhVienRepository.save(thanhVien);

        banTinHeThong(nhom, tenNguoiDung(toi) + " đã xoá " + tenNguoiDung(nguoiDungId) + " khỏi nhóm");
        return dungResponse(nhom, toi);
    }

    @Transactional
    public void roiNhom(UUID hoiThoaiId) {
        UUID toi = permissionService.requireCurrentUserId();
        CuocTroChuyen hoiThoai = yeuCauHoiThoai(hoiThoaiId);

        if (hoiThoai.getLoai() != LoaiCuocTroChuyen.GROUP) {
            // Nhom theo nha/tang do hop dong quyet dinh; roi tay se bi job dong bo
            // them lai ngay, gay kho hieu cho nguoi dung.
            throw new ChatYeuCauKhongHopLeException(
                    "Chi roi duoc nhom tu tao. Nhom theo nha tro va theo tang do he thong quan ly.");
        }

        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);
        thanhVien.setRoiLuc(ZonedDateTime.now());
        thanhVienRepository.save(thanhVien);

        banTinHeThong(hoiThoai, tenNguoiDung(toi) + " đã rời nhóm");
    }

    @Transactional
    public CuocTroChuyenResponse capNhatNhom(UUID hoiThoaiId, CapNhatNhomRequest request) {
        UUID toi = permissionService.requireCurrentUserId();
        CuocTroChuyen nhom = yeuCauHoiThoai(hoiThoaiId);
        chatPermissionService.yeuCauQuanTriNhom(nhom, toi);

        List<String> thayDoi = new ArrayList<>();

        if (request.getTen() != null && !request.getTen().isBlank()
                && !request.getTen().trim().equals(nhom.getTen())) {
            nhom.setTen(request.getTen().trim());
            thayDoi.add("đổi tên nhóm thành \"" + nhom.getTen() + "\"");
        }
        if (request.getAnh() != null) {
            nhom.setAnh(request.getAnh());
            thayDoi.add("đổi ảnh nhóm");
        }
        if (request.getTrangThai() != null && !request.getTrangThai().isBlank()) {
            TrangThaiCuocTroChuyen trangThai = phanTichTrangThai(request.getTrangThai());
            if (trangThai != nhom.getTrangThai()) {
                nhom.setTrangThai(trangThai);
                thayDoi.add(trangThai == TrangThaiCuocTroChuyen.LOCKED ? "khoá nhóm" : "mở khoá nhóm");
            }
        }

        if (thayDoi.isEmpty()) {
            return dungResponse(nhom, toi);
        }

        cuocTroChuyenRepository.save(nhom);
        banTinHeThong(nhom, tenNguoiDung(toi) + " đã " + String.join(", ", thayDoi));
        return dungResponse(nhom, toi);
    }

    // ── Truy van ───────────────────────────────────────────────────────────

    /**
     * Danh sach hoi thoai cua nguoi dang dang nhap.
     *
     * Dung dung 3 query bat ke trang co bao nhieu hoi thoai (danh sach, thanh vien,
     * so tin chua doc) — khong lap lai loi N+1 cua ThongBaoService.
     */
    @Transactional(readOnly = true)
    public PaginatedResponse<CuocTroChuyenResponse> danhSachCuaToi(int page, int limit, String loai,
                                                                   boolean luuTru) {
        UUID toi = permissionService.requireCurrentUserId();

        // Doi chieu nhom tu dong TRUOC khi doc danh sach: nguoi vua chuyen vao se thay
        // ngay nhom cua nha/tang minh, nguoi da tra phong thi nhom bien mat.
        chatMembershipService.dongBoChoNguoiDung(toi);

        // Pageable KHONG kem sort: thu tu da co trong @Query (ghim truoc, tin moi truoc).
        Page<CuocTroChuyen> trang = cuocTroChuyenRepository.danhSachCuaToi(
                toi, loai, luuTru, PageRequest.of(page > 0 ? page - 1 : 0, limit));

        List<UUID> ids = trang.getContent().stream().map(CuocTroChuyen::getId).toList();
        if (ids.isEmpty()) {
            return PaginatedResponse.of(trang, List.of());
        }

        Map<UUID, List<ThanhVienCuocTroChuyen>> thanhVienTheoHoiThoai =
                thanhVienRepository.dangHoatDongTheoDanhSach(ids).stream()
                        .collect(Collectors.groupingBy(tv -> tv.getCuocTroChuyen().getId()));

        Map<UUID, Long> chuaDocTheoHoiThoai = tinNhanRepository
                .demChuaDocTheoHoiThoai(toi, ids).stream()
                .collect(Collectors.toMap(
                        hang -> (UUID) hang[0],
                        hang -> (Long) hang[1]));

        List<CuocTroChuyenResponse> data = trang.getContent().stream()
                .map(c -> CuocTroChuyenResponse.fromEntity(
                        c,
                        thanhVienTheoHoiThoai.getOrDefault(c.getId(), List.of()),
                        toi,
                        chuaDocTheoHoiThoai.getOrDefault(c.getId(), 0L)))
                .toList();

        return PaginatedResponse.of(trang, data);
    }

    @Transactional(readOnly = true)
    public CuocTroChuyenResponse chiTiet(UUID hoiThoaiId) {
        UUID toi = permissionService.requireCurrentUserId();
        chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);
        return dungResponse(yeuCauHoiThoai(hoiThoaiId), toi);
    }

    @Transactional(readOnly = true)
    public long demTongChuaDoc() {
        return tinNhanRepository.demTongChuaDoc(permissionService.requireCurrentUserId());
    }

    /** Dung chung cho TinNhanService. */
    @Transactional(readOnly = true)
    public CuocTroChuyen yeuCauHoiThoai(UUID hoiThoaiId) {
        return cuocTroChuyenRepository.findByIdAndXoaLucIsNull(hoiThoaiId)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay cuoc tro chuyen"));
    }

    // ── Helper ─────────────────────────────────────────────────────────────

    /**
     * Khoa chong trung cho chat 1-1: sap xep hai UUID truoc khi ghep, nen ai bam
     * truoc cung sinh ra dung mot chuoi.
     */
    static String khoaTrucTiep(UUID a, UUID b) {
        String s1 = a.toString();
        String s2 = b.toString();
        return s1.compareTo(s2) < 0 ? "direct_" + s1 + "_" + s2 : "direct_" + s2 + "_" + s1;
    }

    /** Nha tro dau tien ma ca hai cung lien quan, dung lam pham vi cho hoi thoai. */
    private NhaTro nhaTroChung(UUID nguoiA, UUID nguoiB) {
        Set<UUID> cuaB = chatPermissionService.nhaTroCuaNguoiDung(nguoiB);
        return chatPermissionService.nhaTroCuaNguoiDung(nguoiA).stream()
                .filter(cuaB::contains)
                .findFirst()
                .flatMap(nhaTroRepository::findByIdAndXoaLucIsNull)
                .orElse(null);
    }

    /**
     * Nha tro mac dinh khi client khong gui nhaTroId.
     *
     * Thong diep loi do ben goi truyen vao: cung mot ham nhung tao nhom va mo kenh
     * ho tro la hai viec khac han, bao "chua co ban quan ly de lien he" khi nguoi
     * dung dang tao nhom thi ho khong hieu chuyen gi.
     *
     * Admin khong thuoc nha tro nao nen khong the suy ra mac dinh — bat ho chi ro
     * thay vi tu chon bua nha tro dau tien trong he thong, vi chon sai thi hoi thoai
     * nam nham pham vi va rat kho phat hien ve sau.
     */
    private UUID nhaTroMacDinh(UUID nguoiDungId, String thongDiepKhiTrong) {
        return chatPermissionService.nhaTroCuaNguoiDung(nguoiDungId).stream()
                .findFirst()
                .orElseThrow(() -> new ChatYeuCauKhongHopLeException(
                        permissionService.isAdmin(nguoiDungId)
                                ? "Ban la quan tri vien nen khong thuoc nha tro nao — hay chon nha tro cu the"
                                : thongDiepKhiTrong));
    }

    /** Nguoi goi + chu tro + nhan vien co quyen xem nha tro. */
    private Set<UUID> thanhVienKenhHoTro(UUID nguoiGoi, NhaTro nhaTro) {
        Set<UUID> thanhVien = new LinkedHashSet<>();
        thanhVien.add(nguoiGoi);

        if (nhaTro.getChuTro() != null) {
            thanhVien.add(nhaTro.getChuTro().getId());
        }

        nguoiDungNhaTroRepository.findByNhaTroIdIn(List.of(nhaTro.getId())).stream()
                .filter(q -> Boolean.TRUE.equals(q.getCoQuyenXem()) || Boolean.TRUE.equals(q.getCoQuyenSua()))
                .map(NguoiDungNhaTro::getNguoiDung)
                .filter(java.util.Objects::nonNull)
                .forEach(nd -> thanhVien.add(nd.getId()));

        return thanhVien;
    }

    /**
     * Cho service khac ghi tin he thong (vd TinNhanService khi doi biet danh).
     *
     * Dat o day thay vi TinNhanService de tranh phu thuoc vong: TinNhanService da
     * phu thuoc CuocTroChuyenService roi.
     */
    @Transactional
    public void banTinHeThongCong(CuocTroChuyen hoiThoai, String noiDung) {
        banTinHeThong(hoiThoai, noiDung);
    }

    /**
     * Ghi tin he thong roi day realtime cho moi thanh vien.
     *
     * Su kien duoc publish trong transaction hien tai nen listener AFTER_COMMIT
     * chi ban sau khi du lieu da chac chan nam trong DB.
     */
    private void banTinHeThong(CuocTroChuyen hoiThoai, String noiDung) {
        TinNhan tin = cuocTroChuyenFactory.taoTinHeThong(hoiThoai, noiDung);
        List<UUID> nguoiNhan = thanhVienRepository.dangHoatDong(hoiThoai.getId()).stream()
                .filter(tv -> tv.getNguoiDung() != null)
                .map(tv -> tv.getNguoiDung().getId())
                .toList();
        eventPublisher.publishEvent(new TinNhanCreatedEvent(TinNhanResponse.fromEntity(tin), nguoiNhan));
    }

    private String tenNguoiDung(UUID nguoiDungId) {
        return nguoiDungRepository.findById(nguoiDungId)
                .map(NguoiDung::getHoTen)
                .filter(ten -> ten != null && !ten.isBlank())
                .orElse("Một thành viên");
    }

    private TrangThaiCuocTroChuyen phanTichTrangThai(String trangThai) {
        try {
            return TrangThaiCuocTroChuyen.valueOf(trangThai.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new ChatYeuCauKhongHopLeException("Trang thai khong hop le: " + trangThai);
        }
    }

    private CuocTroChuyenResponse dungResponse(CuocTroChuyen hoiThoai, UUID nguoiXem) {
        List<ThanhVienCuocTroChuyen> thanhVien = thanhVienRepository.dangHoatDong(hoiThoai.getId());
        long chuaDoc = tinNhanRepository
                .demChuaDocTheoHoiThoai(nguoiXem, List.of(hoiThoai.getId())).stream()
                .findFirst()
                .map(hang -> (Long) hang[1])
                .orElse(0L);
        return CuocTroChuyenResponse.fromEntity(hoiThoai, thanhVien, nguoiXem, chuaDoc);
    }
}
