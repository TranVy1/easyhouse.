package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import java.time.LocalDate;
import java.util.UUID;

@Data
public class KhachThueRequest {

    // Cac rang buoc duoi deu bo qua gia tri null (mac dinh cua Jakarta Validation)
    // de request cap nhat mot phan khong bi vo. Truoc day khong co validate nao,
    // nen he thong nhan ca so dien thoai 12 chu so nhu 037472938332.
    private UUID nguoiDungId;  // Optional link to existing NguoiDung
    private UUID chuTroId;     // Required: owner
    private String hoTen;

    @Email(message = "Email không đúng định dạng")
    private String email;

    @Pattern(regexp = "^0\\d{9}$", message = "Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng 0")
    private String soDienThoai;

    @Pattern(regexp = "^(\\d{9}|\\d{12})$", message = "CCCD phải 12 chữ số (hoặc CMND 9 chữ số)")
    private String soCccd;

    @Pattern(regexp = "^(\\d{9}|\\d{12})$", message = "CCCD phải 12 chữ số (hoặc CMND 9 chữ số)")
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
