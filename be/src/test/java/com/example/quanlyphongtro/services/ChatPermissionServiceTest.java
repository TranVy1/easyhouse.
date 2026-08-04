package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.NguoiLienHeResponse;
import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.entity.TrangThaiCuocTroChuyen;
import com.example.quanlyphongtro.exception.ChatKhongCoQuyenException;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class ChatPermissionServiceTest {

    @Mock private PermissionService permissionService;
    @Mock private com.example.quanlyphongtro.repository.ChanNguoiDungRepository chanNguoiDungRepository;
    @Mock private ThanhVienCuocTroChuyenRepository thanhVienRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private NguoiDungNhaTroRepository nguoiDungNhaTroRepository;

    /**
     * @InjectMocks thay vi goi constructor tay: Lombok @RequiredArgsConstructor doi
     * chu ky moi lan them mot dependency, va viec do da lam vo test nay ba lan.
     * Mockito khop theo KIEU nen them dependency moi khong lam hong test nua.
     */
    @InjectMocks
    private ChatPermissionService chatPermissionService;

    private final UUID khachThueNhaA = UUID.randomUUID();
    private final UUID khachThueNhaB = UUID.randomUUID();
    private final UUID chuTroNhaA = UUID.randomUUID();
    private final UUID nhaA = UUID.randomUUID();
    private final UUID nhaB = UUID.randomUUID();

    @BeforeEach
    void setUp() {
        // Mac dinh khong ai chan ai. Test nao can chan thi tu ghi de.
        lenient().when(chanNguoiDungRepository.coChanGiuaHaiNguoi(any(), any())).thenReturn(false);
    }

    /** Mac dinh khong ai la admin, tru khi test noi khac. */
    private void khongPhaiAdmin() {
        lenient().when(permissionService.isAdmin(any())).thenReturn(false);
    }

    private void nguoiDungThuoc(UUID nguoiDungId, List<UUID> nhaTroIds) {
        lenient().when(hopDongRepository.findNhaTroIdsDangThue(nguoiDungId)).thenReturn(nhaTroIds);
        lenient().when(nhaTroRepository.findByChuTroIdAndXoaLucIsNull(nguoiDungId)).thenReturn(List.of());
        lenient().when(nguoiDungNhaTroRepository.findByNguoiDungId(nguoiDungId)).thenReturn(List.of());
    }

    // ── Pham vi ────────────────────────────────────────────────────────────

    @Test
    void haiKhachThueCungNhaThiNhanTinDuoc() {
        khongPhaiAdmin();
        nguoiDungThuoc(khachThueNhaA, List.of(nhaA));
        UUID banCungNha = UUID.randomUUID();
        nguoiDungThuoc(banCungNha, List.of(nhaA));

        assertTrue(chatPermissionService.cungPhamVi(khachThueNhaA, banCungNha));
    }

    @Test
    void khachThueKhacNhaThiKhongNhanTinDuoc() {
        khongPhaiAdmin();
        nguoiDungThuoc(khachThueNhaA, List.of(nhaA));
        nguoiDungThuoc(khachThueNhaB, List.of(nhaB));

        assertFalse(chatPermissionService.cungPhamVi(khachThueNhaA, khachThueNhaB));
    }

    @Test
    void khachThueNhanTinDuocVoiChuTroCuaNhaMinh() {
        khongPhaiAdmin();
        nguoiDungThuoc(khachThueNhaA, List.of(nhaA));

        // Chu tro khong thue phong nao, nhung so huu nha A.
        NhaTro nha = NhaTro.builder().id(nhaA).build();
        lenient().when(hopDongRepository.findNhaTroIdsDangThue(chuTroNhaA)).thenReturn(List.of());
        lenient().when(nhaTroRepository.findByChuTroIdAndXoaLucIsNull(chuTroNhaA)).thenReturn(List.of(nha));
        lenient().when(nguoiDungNhaTroRepository.findByNguoiDungId(chuTroNhaA)).thenReturn(List.of());

        assertTrue(chatPermissionService.cungPhamVi(khachThueNhaA, chuTroNhaA));
    }

    @Test
    void khongTheTuNhanTinVoiChinhMinh() {
        assertFalse(chatPermissionService.cungPhamVi(khachThueNhaA, khachThueNhaA));
    }

    @Test
    void nguoiKhongThuocNhaTroNaoThiKhongNhanTinDuocVoiAi() {
        khongPhaiAdmin();
        nguoiDungThuoc(khachThueNhaA, List.of());
        nguoiDungThuoc(khachThueNhaB, List.of(nhaB));

        assertFalse(chatPermissionService.cungPhamVi(khachThueNhaA, khachThueNhaB));
    }

    @Test
    void yeuCauCungPhamViNemLoiKhiKhacNha() {
        khongPhaiAdmin();
        nguoiDungThuoc(khachThueNhaA, List.of(nhaA));
        nguoiDungThuoc(khachThueNhaB, List.of(nhaB));

        assertThrows(ChatKhongCoQuyenException.class,
                () -> chatPermissionService.yeuCauCungPhamVi(khachThueNhaA, khachThueNhaB));
    }

    // ── Thanh vien hoi thoai ───────────────────────────────────────────────

    @Test
    void nguoiDaRoiNhomThiKhongCoDuocQuyenDoc() {
        UUID hoiThoaiId = UUID.randomUUID();
        ThanhVienCuocTroChuyen daRoi = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai(hoiThoaiId))
                .nguoiDung(NguoiDung.builder().id(khachThueNhaA).build())
                .roiLuc(ZonedDateTime.now())
                .build();
        when(thanhVienRepository.findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, khachThueNhaA))
                .thenReturn(Optional.of(daRoi));

        assertFalse(chatPermissionService.coTheDoc(hoiThoaiId, khachThueNhaA));
        assertThrows(ChatKhongCoQuyenException.class,
                () -> chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, khachThueNhaA));
    }

    @Test
    void nguoiLaThanhVienThiDocDuoc() {
        UUID hoiThoaiId = UUID.randomUUID();
        ThanhVienCuocTroChuyen dangHoatDong = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai(hoiThoaiId))
                .nguoiDung(NguoiDung.builder().id(khachThueNhaA).build())
                .build();
        when(thanhVienRepository.findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, khachThueNhaA))
                .thenReturn(Optional.of(dangHoatDong));

        assertTrue(chatPermissionService.coTheDoc(hoiThoaiId, khachThueNhaA));
    }

    @Test
    void adminKhongTuDongDocDuocChatDirectNeuKhongLaThanhVien() {
        UUID hoiThoaiId = UUID.randomUUID();
        UUID adminId = UUID.randomUUID();
        lenient().when(permissionService.isAdmin(adminId)).thenReturn(true);
        when(thanhVienRepository.findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, adminId))
                .thenReturn(Optional.empty());

        assertFalse(chatPermissionService.coTheDoc(hoiThoaiId, adminId));
        assertThrows(ChatKhongCoQuyenException.class,
                () -> chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, adminId));
    }

    @Test
    void hoiThoaiBiKhoaThiKhongGuiDuocDuLaThanhVien() {
        UUID hoiThoaiId = UUID.randomUUID();
        CuocTroChuyen biKhoa = hoiThoai(hoiThoaiId);
        biKhoa.setTrangThai(TrangThaiCuocTroChuyen.LOCKED);

        when(thanhVienRepository.findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, khachThueNhaA))
                .thenReturn(Optional.of(ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(biKhoa)
                        .nguoiDung(NguoiDung.builder().id(khachThueNhaA).build())
                        .build()));

        assertThrows(ChatKhongCoQuyenException.class,
                () -> chatPermissionService.yeuCauCoTheGui(biKhoa, khachThueNhaA));
    }

    // ── Danh ba ────────────────────────────────────────────────────────────

    @Test
    void danhBaGomChuTroVaKhachThueCungNhaNhungKhongGomChinhMinh() {
        khongPhaiAdmin();
        nguoiDungThuoc(khachThueNhaA, List.of(nhaA));

        NguoiDung chuTro = NguoiDung.builder().id(chuTroNhaA).hoTen("Chu tro A").build();
        NguoiDung banCungNha = NguoiDung.builder().id(UUID.randomUUID()).hoTen("Ban cung nha").build();
        NguoiDung chinhMinh = NguoiDung.builder().id(khachThueNhaA).hoTen("Toi").build();

        when(nhaTroRepository.findAllById(List.of(nhaA)))
                .thenReturn(List.of(NhaTro.builder().id(nhaA).chuTro(chuTro).build()));
        when(nguoiDungNhaTroRepository.findByNhaTroIdIn(List.of(nhaA))).thenReturn(List.of());
        when(hopDongRepository.findNguoiDungKhachThueDangThue(List.of(nhaA)))
                .thenReturn(List.of(banCungNha, chinhMinh));

        List<NguoiLienHeResponse> danhBa = chatPermissionService.danhBa(khachThueNhaA, null);

        assertEquals(2, danhBa.size());
        assertTrue(danhBa.stream().noneMatch(n -> n.getNguoiDungId().equals(khachThueNhaA)),
                "Danh ba khong duoc chua chinh nguoi dang xem");
        assertTrue(danhBa.stream().anyMatch(n -> "LANDLORD".equals(n.getVaiTro())));
    }

    @Test
    void danhBaRongKhiNguoiDungChuaThuocNhaTroNao() {
        nguoiDungThuoc(khachThueNhaA, List.of());
        assertTrue(chatPermissionService.danhBa(khachThueNhaA, null).isEmpty());
    }

    @Test
    void danhBaAdminBaoGomKhachThueCuaMoiNhaTro() {
        UUID adminId = UUID.randomUUID();
        NguoiDung chuTro = NguoiDung.builder().id(chuTroNhaA).hoTen("Chu tro A").build();
        NguoiDung khachThue = NguoiDung.builder().id(khachThueNhaA).hoTen("Khach thue A").build();
        NhaTro nhaTro = NhaTro.builder().id(nhaA).chuTro(chuTro).build();

        when(permissionService.isAdmin(adminId)).thenReturn(true);
        when(nhaTroRepository.findByXoaLucIsNullOrderByTaoLucDesc()).thenReturn(List.of(nhaTro));
        when(nhaTroRepository.findAllById(List.of(nhaA))).thenReturn(List.of(nhaTro));
        when(nguoiDungNhaTroRepository.findByNhaTroIdIn(List.of(nhaA))).thenReturn(List.of());
        when(hopDongRepository.findNguoiDungKhachThueDangThue(List.of(nhaA))).thenReturn(List.of(khachThue));

        List<NguoiLienHeResponse> danhBa = chatPermissionService.danhBa(adminId, "Khach");

        assertEquals(1, danhBa.size());
        assertEquals(khachThueNhaA, danhBa.get(0).getNguoiDungId());
        assertEquals("TENANT", danhBa.get(0).getVaiTro());
    }

    private CuocTroChuyen hoiThoai(UUID id) {
        return CuocTroChuyen.builder()
                .id(id)
                .loai(LoaiCuocTroChuyen.DIRECT)
                .khoaDuyNhat("direct_test")
                .build();
    }
}
