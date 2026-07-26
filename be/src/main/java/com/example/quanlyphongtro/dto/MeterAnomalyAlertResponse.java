package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.LoaiChiSo;
import com.example.quanlyphongtro.entity.MucDoAlert;
import com.example.quanlyphongtro.entity.TrangThaiAlert;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class MeterAnomalyAlertResponse {
    private UUID id;
    private UUID chiSoId;
    private UUID phongId;
    private String tenPhong;
    private String nhaTroTen;
    private LoaiChiSo loai;
    private Integer kyThang;
    private Integer kyNam;
    private Integer tieuThuHienTai;
    private BigDecimal tieuThuTrungBinh;
    private BigDecimal tyLeTang;
    private MucDoAlert mucDo;
    private String lyDo;
    private TrangThaiAlert trangThai;
    private ZonedDateTime taoLuc;
}
