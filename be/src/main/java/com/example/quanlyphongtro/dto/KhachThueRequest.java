package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.time.LocalDate;
import java.util.UUID;

@Data
public class KhachThueRequest {
    private UUID nguoiDungId;
    private String hoTen;
    private String email;
    private String soDienThoai;
    private String gioiTinh;
    private String matKhau;
    private String soCccd;
    private String lienHeKhanCap;
    private LocalDate ngaySinh;
    private String diaChiThuongTru;
    private String ngheNghiep;

    private AnhCCCDRequest anhCCCD;

    @Data
    public static class AnhCCCDRequest {
        private String matTruoc;
        private String matSau;
    }
}