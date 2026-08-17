package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.time.LocalDate;

/**
 * Du lieu bo sung cho cac truong bat buoc con thieu, gui tu dialog ky hop dong.
 *
 * Moi truong deu tuy chon: chi truong nao khac null/rong moi duoc ghi de, nen
 * goi mot phan cung an toan va khong bao gio xoa mat du lieu dang co.
 */
@Data
public class BoSungThongTinRequest {

    // Ben A - chu tro (bang nguoi_dung)
    private String benAHoTen;
    private String benASoCccd;
    private String benASoDienThoai;
    private String benADiaChi;

    // Ben B - khach thue (bang khach_thue)
    private String benBHoTen;
    private String benBSoCccd;
    private String benBSoDienThoai;
    private LocalDate benBNgaySinh;
    private String benBDiaChi;
}
