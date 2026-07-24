package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.ArgumentMatchers.anyCollection;
import static org.mockito.ArgumentMatchers.anyMap;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.CuocTroChuyenResponse;
import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.exception.ChatYeuCauKhongHopLeException;
import com.example.quanlyphongtro.repository.CuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.TinNhanRepository;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.DataIntegrityViolationException;

@ExtendWith(MockitoExtension.class)
class CuocTroChuyenServiceTest {

    @Mock private CuocTroChuyenRepository cuocTroChuyenRepository;
    @Mock private ThanhVienCuocTroChuyenRepository thanhVienRepository;
    @Mock private TinNhanRepository tinNhanRepository;
    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private NguoiDungNhaTroRepository nguoiDungNhaTroRepository;
    @Mock private PermissionService permissionService;
    @Mock private ChatPermissionService chatPermissionService;
    @Mock private CuocTroChuyenFactory cuocTroChuyenFactory;
    @Mock private ChatMembershipService chatMembershipService;
    @Mock private org.springframework.context.ApplicationEventPublisher eventPublisher;

    /**
     * @InjectMocks: Lombok doi chu ky constructor moi lan them dependency. Mockito
     * khop theo KIEU nen test khong vo nua.
     */
    @InjectMocks
    private CuocTroChuyenService cuocTroChuyenService;

    private final UUID toi = UUID.randomUUID();
    private final UUID doiPhuong = UUID.randomUUID();

    // ── Khoa chong trung ───────────────────────────────────────────────────

    @Test
    void khoaTrucTiepGiongNhauDuDaoThuTuHaiNguoi() {
        UUID a = UUID.randomUUID();
        UUID b = UUID.randomUUID();

        assertEquals(CuocTroChuyenService.khoaTrucTiep(a, b),
                CuocTroChuyenService.khoaTrucTiep(b, a),
                "Ai bam truoc cung phai sinh ra cung mot khoa, neu khong se tao 2 phong chat");
    }

    @Test
    void khoaTrucTiepKhacNhauVoiCapNguoiKhacNhau() {
        UUID a = UUID.randomUUID();
        UUID b = UUID.randomUUID();
        UUID c = UUID.randomUUID();

        org.junit.jupiter.api.Assertions.assertNotEquals(
                CuocTroChuyenService.khoaTrucTiep(a, b),
                CuocTroChuyenService.khoaTrucTiep(a, c));
    }

    // ── Get-or-create ──────────────────────────────────────────────────────

    @Test
    void khongTaoMoiKhiHoiThoaiDaTonTai() {
        chuanBiNguoiDungHopLe();
        CuocTroChuyen daCo = hoiThoaiSan();
        when(cuocTroChuyenRepository.findByKhoaDuyNhatAndXoaLucIsNull(anyString()))
                .thenReturn(Optional.of(daCo));
        chuanBiDungResponse(daCo);

        CuocTroChuyenResponse ketQua = cuocTroChuyenService.layHoacTaoTrucTiep(doiPhuong);

        assertNotNull(ketQua);
        assertEquals(daCo.getId(), ketQua.getId());
        verify(cuocTroChuyenFactory, never())
                .tao(any(), anyString(), any(), any(), any(), any(), anyCollection(), anyMap());
    }

    /**
     * Hai nguoi bam "nhan tin" voi nhau gan nhu cung luc: rang buoc UNIQUE chan ban
     * ghi thu hai. Service phai doc lai ban ghi ben kia vua tao, khong duoc nem loi
     * ra mat nguoi dung.
     */
    @Test
    void khiDungDoTaoTrungThiDocLaiBanGhiDaCo() {
        chuanBiNguoiDungHopLe();
        CuocTroChuyen benKiaVuaTao = hoiThoaiSan();

        when(cuocTroChuyenRepository.findByKhoaDuyNhatAndXoaLucIsNull(anyString()))
                .thenReturn(Optional.empty())          // lan doc dau: chua co
                .thenReturn(Optional.of(benKiaVuaTao)); // lan doc sau khi dinh trung khoa

        when(cuocTroChuyenFactory.tao(any(), anyString(), any(), any(), any(), any(), anyCollection(), anyMap()))
                .thenThrow(new DataIntegrityViolationException("uq khoa_duy_nhat"));

        chuanBiDungResponse(benKiaVuaTao);

        CuocTroChuyenResponse ketQua = cuocTroChuyenService.layHoacTaoTrucTiep(doiPhuong);

        assertEquals(benKiaVuaTao.getId(), ketQua.getId());
        verify(cuocTroChuyenRepository, times(2)).findByKhoaDuyNhatAndXoaLucIsNull(anyString());
    }

    @Test
    void khongChoTuNhanTinVoiChinhMinh() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);

        assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> cuocTroChuyenService.layHoacTaoTrucTiep(toi));

        verify(chatPermissionService, never()).yeuCauCungPhamVi(any(), any());
    }

    // ── Nhom tu tao (P2) ───────────────────────────────────────────────────

    @Test
    void taoNhomChanNguoiNgoaiPhamViNhaTro() {
        UUID nguoiLa = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        org.mockito.Mockito.doThrow(new com.example.quanlyphongtro.exception.ChatKhongCoQuyenException("ngoai pham vi"))
                .when(chatPermissionService).yeuCauCungPhamVi(toi, nguoiLa);

        com.example.quanlyphongtro.dto.TaoNhomRequest req = new com.example.quanlyphongtro.dto.TaoNhomRequest();
        req.setTen("Nhóm mượn đồ");
        req.setThanhVienIds(List.of(nguoiLa));

        assertThrows(com.example.quanlyphongtro.exception.ChatKhongCoQuyenException.class,
                () -> cuocTroChuyenService.taoNhom(req));
        verify(cuocTroChuyenFactory, never())
                .tao(any(), anyString(), any(), any(), any(), any(), anyCollection(), anyMap());
    }

    @Test
    void taoNhomChiVoiChinhMinhThiBiTuChoi() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);

        com.example.quanlyphongtro.dto.TaoNhomRequest req = new com.example.quanlyphongtro.dto.TaoNhomRequest();
        req.setTen("Nhóm một mình");
        req.setThanhVienIds(List.of(toi)); // trùng chính mình -> bị loại -> còn 1 người

        assertThrows(ChatYeuCauKhongHopLeException.class, () -> cuocTroChuyenService.taoNhom(req));
    }

    /**
     * Thong diep loi phai khop viec dang lam. Truoc day tao nhom that bai lai bao
     * "chua co ban quan ly de lien he" — nguoi dung khong hieu vi ho co dinh mo
     * kenh ho tro dau.
     */
    @Test
    void taoNhomThieuNhaTroBaoLoiDungNguCanh() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(chatPermissionService.nhaTroCuaNguoiDung(toi)).thenReturn(Set.of());

        com.example.quanlyphongtro.dto.TaoNhomRequest req = new com.example.quanlyphongtro.dto.TaoNhomRequest();
        req.setTen("Nhóm mượn đồ");
        req.setThanhVienIds(List.of(doiPhuong, UUID.randomUUID()));

        ChatYeuCauKhongHopLeException ex = assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> cuocTroChuyenService.taoNhom(req));
        assertTrue(ex.getMessage().contains("tao nhom"), "Loi thuc te: " + ex.getMessage());
        assertFalse(ex.getMessage().contains("ban quan ly"), "Loi thuc te: " + ex.getMessage());
    }

    /**
     * Ca hai cho goi deu cho admin di qua bang `|| isAdmin`, nhung neu bo trong
     * nhaTroId thi ham suy mac dinh nem loi TRUOC do — admin bi chan voi thong bao
     * "ban chua thue phong nao", vo nghia voi quan tri vien.
     */
    @Test
    void adminThieuNhaTroDuocBaoRoLaPhaiChonNhaTro() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(permissionService.isAdmin(toi)).thenReturn(true);
        when(chatPermissionService.nhaTroCuaNguoiDung(toi)).thenReturn(Set.of());

        ChatYeuCauKhongHopLeException ex = assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> cuocTroChuyenService.layHoacTaoHoTro(null));
        assertTrue(ex.getMessage().contains("chon nha tro"), "Loi thuc te: " + ex.getMessage());
        assertFalse(ex.getMessage().contains("chua thue phong"), "Loi thuc te: " + ex.getMessage());
    }

    /**
     * Nhóm theo nhà trọ / theo tầng do hệ thống quản lý, rời tay sẽ bị job đồng bộ
     * thêm lại ngay nên phải chặn từ đầu.
     */
    @Test
    void khongChoRoiNhomTuDong() {
        UUID hoiThoaiId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(cuocTroChuyenRepository.findByIdAndXoaLucIsNull(hoiThoaiId))
                .thenReturn(Optional.of(CuocTroChuyen.builder()
                        .id(hoiThoaiId)
                        .loai(LoaiCuocTroChuyen.BUILDING)
                        .khoaDuyNhat("building_x")
                        .build()));

        assertThrows(ChatYeuCauKhongHopLeException.class, () -> cuocTroChuyenService.roiNhom(hoiThoaiId));
        verify(thanhVienRepository, never()).save(any());
    }

    @Test
    void danhSachCuaToiLuonDongBoNhomTuDongTruoc() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(cuocTroChuyenRepository.danhSachCuaToi(eq(toi), any(), anyBoolean(), any()))
                .thenReturn(org.springframework.data.domain.Page.empty());

        cuocTroChuyenService.danhSachCuaToi(1, 20, null, false);

        // Nếu bỏ bước này, người vừa chuyển vào sẽ không thấy nhóm của nhà mình.
        verify(chatMembershipService).dongBoChoNguoiDung(toi);
    }

    /**
     * Danh sach thuong phai LOAI muc da luu tru, con tab "Da luu tru" thi chi lay
     * dung nhung muc do — hai lan goi phai truyen co khac nhau xuong repository.
     */
    @Test
    void danhSachTruyenDungCoLuuTruXuongRepository() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(cuocTroChuyenRepository.danhSachCuaToi(eq(toi), any(), anyBoolean(), any()))
                .thenReturn(org.springframework.data.domain.Page.empty());

        cuocTroChuyenService.danhSachCuaToi(1, 20, null, false);
        verify(cuocTroChuyenRepository).danhSachCuaToi(eq(toi), any(), eq(false), any());

        cuocTroChuyenService.danhSachCuaToi(1, 20, null, true);
        verify(cuocTroChuyenRepository).danhSachCuaToi(eq(toi), any(), eq(true), any());
    }

    // ── Helper ─────────────────────────────────────────────────────────────

    private void chuanBiNguoiDungHopLe() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(nguoiDungRepository.findById(doiPhuong))
                .thenReturn(Optional.of(NguoiDung.builder().id(doiPhuong).hoTen("Doi phuong").build()));
        when(chatPermissionService.nhaTroCuaNguoiDung(any())).thenReturn(Set.of());
    }

    private CuocTroChuyen hoiThoaiSan() {
        return CuocTroChuyen.builder()
                .id(UUID.randomUUID())
                .loai(LoaiCuocTroChuyen.DIRECT)
                .khoaDuyNhat(CuocTroChuyenService.khoaTrucTiep(toi, doiPhuong))
                .build();
    }

    private void chuanBiDungResponse(CuocTroChuyen hoiThoai) {
        when(thanhVienRepository.dangHoatDong(hoiThoai.getId())).thenReturn(List.of(
                ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(hoiThoai)
                        .nguoiDung(NguoiDung.builder().id(toi).hoTen("Toi").build())
                        .build(),
                ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(hoiThoai)
                        .nguoiDung(NguoiDung.builder().id(doiPhuong).hoTen("Doi phuong").build())
                        .build()));
        when(tinNhanRepository.demChuaDocTheoHoiThoai(eq(toi), any())).thenReturn(List.of());
    }
}
