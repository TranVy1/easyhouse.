package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class KhoTaiSanResponse {
    private UUID id;
    private UUID nhaTroId;
    private String tenNhaTro;
    private String tenTaiSan;
    private String hinhAnh;
    private Integer tongSoLuong;
    private Integer soLuongKhaDung;
    private Integer soLuongDaCapPhat;
    private Integer soLuongHuHong;
    private String tinhTrang;
    private String ghiChu;
}
