package com.example.quanlyphongtro.dto;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;

import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.Test;

class CuocTroChuyenResponseTest {

    @Test
    void supportHienBanQuanLyChoNguoiTaoVaNguoiYeuCauChoAdmin() {
        UUID khachThueId = UUID.randomUUID();
        UUID adminId = UUID.randomUUID();
        NguoiDung khachThue = NguoiDung.builder().id(khachThueId).hoTen("Nguyễn Minh").build();
        NguoiDung admin = NguoiDung.builder().id(adminId).hoTen("Admin Trực Ca").build();
        NhaTro nhaTro = NhaTro.builder().id(UUID.randomUUID()).ten("HH2A").build();

        CuocTroChuyen support = CuocTroChuyen.builder()
                .id(UUID.randomUUID())
                .loai(LoaiCuocTroChuyen.SUPPORT)
                .nguoiTao(khachThue)
                .nhaTro(nhaTro)
                .khoaDuyNhat("support_test")
                .build();
        List<ThanhVienCuocTroChuyen> thanhVien = List.of(
                thanhVien(support, khachThue),
                thanhVien(support, admin));

        CuocTroChuyenResponse cuaKhachThue = CuocTroChuyenResponse.fromEntity(
                support, thanhVien, khachThueId, 0);
        CuocTroChuyenResponse cuaAdmin = CuocTroChuyenResponse.fromEntity(
                support, thanhVien, adminId, 0);

        assertEquals("Ban quản lý · HH2A", cuaKhachThue.getTen());
        assertEquals("Hỗ trợ · Nguyễn Minh · HH2A", cuaAdmin.getTen());
    }

    @Test
    void directVanHienTenDoiPhuong() {
        UUID aId = UUID.randomUUID();
        UUID bId = UUID.randomUUID();
        NguoiDung a = NguoiDung.builder().id(aId).hoTen("Người A").build();
        NguoiDung b = NguoiDung.builder().id(bId).hoTen("Người B").build();
        CuocTroChuyen direct = CuocTroChuyen.builder()
                .id(UUID.randomUUID())
                .loai(LoaiCuocTroChuyen.DIRECT)
                .khoaDuyNhat("direct_test")
                .build();

        CuocTroChuyenResponse response = CuocTroChuyenResponse.fromEntity(
                direct,
                List.of(thanhVien(direct, a), thanhVien(direct, b)),
                aId,
                0);

        assertEquals("Người B", response.getTen());
    }

    private ThanhVienCuocTroChuyen thanhVien(CuocTroChuyen hoiThoai, NguoiDung nguoiDung) {
        return ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(nguoiDung)
                .build();
    }
}
