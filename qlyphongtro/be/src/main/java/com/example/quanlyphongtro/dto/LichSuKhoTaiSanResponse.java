package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LichSuKhoTaiSanResponse {
    private UUID id;
    private UUID khoTaiSanId;
    private UUID phongId;
    private String tenPhong;
    private String loaiGiaoDich;
    private Integer soLuong;
    private String ghiChu;
    private ZonedDateTime taoLuc;
}
