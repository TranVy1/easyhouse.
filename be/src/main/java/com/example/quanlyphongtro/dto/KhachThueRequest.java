package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.time.LocalDate;
import java.util.UUID;

@Data
public class KhachThueRequest {
    private UUID nguoiDungId;  // Optional link to existing NguoiDung
    private UUID chuTroId;     // Required: owner
    private String hoTen;
    private String email;
    private String soDienThoai;
    private String soCccd;
    private String cccd;
    private LocalDate ngaySinh;
    private String gioiTinh;
    private String diaChi;
    private String queQuan;
    private String ngheNghiep;
    private String ghiChu;
    private java.util.Map<String, String> anhCCCD;
    private String matKhau;
}
