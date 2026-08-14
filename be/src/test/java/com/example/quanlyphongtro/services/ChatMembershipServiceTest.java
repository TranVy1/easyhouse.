package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.repository.CuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.NguoiDungVaiTroRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.TangRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class ChatMembershipServiceTest {

    @Mock private CuocTroChuyenRepository cuocTroChuyenRepository;
    @Mock private ThanhVienCuocTroChuyenRepository thanhVienRepository;
    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private TangRepository tangRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private NguoiDungNhaTroRepository nguoiDungNhaTroRepository;
    @Mock private NguoiDungVaiTroRepository nguoiDungVaiTroRepository;
    @Mock private PermissionService permissionService;

    @InjectMocks
    private ChatMembershipService chatMembershipService;

    @Test
    void thanhVienKenhHoTroGomNguoiGoiTatCaAdminVaQuanLyNhaTro() {
        UUID nguoiGoi = UUID.randomUUID();
        UUID admin = UUID.randomUUID();
        UUID chuTro = UUID.randomUUID();
        UUID nhanVien = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();

        when(nguoiDungVaiTroRepository.findNguoiDungIdsTheoVaiTroVaTrangThai(any(), any()))
                .thenReturn(List.of(admin));
        when(nhaTroRepository.findChuTroIdTheoTrangThai(nhaTroId, TrangThaiNguoiDung.ACTIVE))
                .thenReturn(Optional.of(chuTro));
        when(nguoiDungNhaTroRepository.findNguoiDungIdsCoQuyenTheoTrangThai(
                nhaTroId, TrangThaiNguoiDung.ACTIVE)).thenReturn(List.of(nhanVien));

        Set<UUID> ketQua = chatMembershipService.thanhVienKenhHoTro(nguoiGoi, nhaTroId);

        assertEquals(Set.of(nguoiGoi, admin, chuTro, nhanVien), ketQua);
    }

    @Test
    void adminMoDanhSachThiDuocThemVaoMoiKenhSupportCu() {
        UUID adminA = UUID.randomUUID();
        UUID adminB = UUID.randomUUID();
        UUID khachThue = UUID.randomUUID();
        UUID hoiThoaiId = UUID.randomUUID();

        CuocTroChuyen support = CuocTroChuyen.builder()
                .id(hoiThoaiId)
                .loai(LoaiCuocTroChuyen.SUPPORT)
                .nguoiTao(nguoiDungHoatDong(khachThue))
                .khoaDuyNhat("support_test")
                .build();

        when(hopDongRepository.findPhamViDangThue(adminA)).thenReturn(List.of());
        when(thanhVienRepository.nhomTuDongDangThamGia(adminA)).thenReturn(List.of());
        when(permissionService.isAdmin(adminA)).thenReturn(true);
        when(cuocTroChuyenRepository.findByLoaiAndNguoiTaoIdAndXoaLucIsNull(
                LoaiCuocTroChuyen.SUPPORT, adminA)).thenReturn(List.of());
        when(cuocTroChuyenRepository.findByLoaiAndXoaLucIsNull(LoaiCuocTroChuyen.SUPPORT))
                .thenReturn(List.of(support));
        when(nguoiDungVaiTroRepository.findNguoiDungIdsTheoVaiTroVaTrangThai(any(), any()))
                .thenReturn(List.of(adminA, adminB));
        when(thanhVienRepository.dangHoatDong(hoiThoaiId)).thenReturn(List.of(
                ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(support)
                        .nguoiDung(nguoiDungHoatDong(khachThue))
                        .build()));
        when(thanhVienRepository.findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, adminA))
                .thenReturn(Optional.empty());
        when(thanhVienRepository.findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, adminB))
                .thenReturn(Optional.empty());
        when(nguoiDungRepository.getReferenceById(any(UUID.class)))
                .thenAnswer(invocation -> nguoiDungHoatDong(invocation.getArgument(0)));
        when(thanhVienRepository.kenhHoTroDangThamGia(adminA)).thenReturn(List.of());

        chatMembershipService.dongBoChoNguoiDung(adminA);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<ThanhVienCuocTroChuyen>> captor = ArgumentCaptor.forClass(List.class);
        verify(thanhVienRepository).saveAll(captor.capture());

        Set<UUID> nguoiDuocThem = captor.getValue().stream()
                .map(ThanhVienCuocTroChuyen::getNguoiDung)
                .map(NguoiDung::getId)
                .collect(java.util.stream.Collectors.toSet());
        assertEquals(Set.of(adminA, adminB), nguoiDuocThem);
    }

    @Test
    void dongBoKenhHoTroThuHoiAdminCuKhongConQuyen() {
        UUID khachThue = UUID.randomUUID();
        UUID adminMoi = UUID.randomUUID();
        UUID adminCu = UUID.randomUUID();
        UUID hoiThoaiId = UUID.randomUUID();

        CuocTroChuyen support = CuocTroChuyen.builder()
                .id(hoiThoaiId)
                .loai(LoaiCuocTroChuyen.SUPPORT)
                .nguoiTao(nguoiDungHoatDong(khachThue))
                .khoaDuyNhat("support_test")
                .build();
        ThanhVienCuocTroChuyen thanhVienCu = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(support)
                .nguoiDung(nguoiDungHoatDong(adminCu))
                .build();

        when(cuocTroChuyenRepository.findByIdAndXoaLucIsNull(hoiThoaiId))
                .thenReturn(Optional.of(support));
        when(nguoiDungVaiTroRepository.findNguoiDungIdsTheoVaiTroVaTrangThai(any(), any()))
                .thenReturn(List.of(adminMoi));
        when(thanhVienRepository.dangHoatDong(hoiThoaiId)).thenReturn(List.of(
                ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(support)
                        .nguoiDung(nguoiDungHoatDong(khachThue))
                        .build(),
                thanhVienCu));
        when(thanhVienRepository.findByCuocTroChuyenIdAndNguoiDungId(hoiThoaiId, adminMoi))
                .thenReturn(Optional.empty());
        when(nguoiDungRepository.getReferenceById(adminMoi)).thenReturn(nguoiDungHoatDong(adminMoi));

        chatMembershipService.dongBoKenhHoTro(hoiThoaiId);

        assertNotNull(thanhVienCu.getRoiLuc());
        assertTrue(thanhVienCu.getRoiLuc().isBefore(java.time.ZonedDateTime.now().plusSeconds(1)));
    }

    @Test
    void dongBoKenhHoTroKhongDongVaoChatDirect() {
        UUID hoiThoaiId = UUID.randomUUID();
        when(cuocTroChuyenRepository.findByIdAndXoaLucIsNull(hoiThoaiId))
                .thenReturn(Optional.of(CuocTroChuyen.builder()
                        .id(hoiThoaiId)
                        .loai(LoaiCuocTroChuyen.DIRECT)
                        .khoaDuyNhat("direct_test")
                        .build()));

        chatMembershipService.dongBoKenhHoTro(hoiThoaiId);

        verify(thanhVienRepository, never()).dangHoatDong(any());
        verify(thanhVienRepository, never()).saveAll(any());
    }

    private NguoiDung nguoiDungHoatDong(UUID id) {
        return NguoiDung.builder()
                .id(id)
                .trangThai(TrangThaiNguoiDung.ACTIVE)
                .build();
    }
}
