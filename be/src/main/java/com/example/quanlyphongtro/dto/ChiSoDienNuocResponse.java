package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.LoaiChiSo;
import com.example.quanlyphongtro.entity.TrangThaiChiSo;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
public class ChiSoDienNuocResponse {
    private UUID id;

    @JsonProperty("_id")
    public UUID get_id() {
        return id;
    }

    private PhongResponse phong;
    private HopDongResponse hopDong;
    private LoaiChiSo loai;
    private Integer kyNam;
    private Integer kyThang;
    private LocalDate ngayGhi;
    private Integer chiSoCu;
    private Integer chiSoMoi;
    private Integer tieuThu;
    private String anhDongHo;
    private UserResponse nguoiGhi;
    private TrangThaiChiSo trangThai;
    private String ghiChu;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
