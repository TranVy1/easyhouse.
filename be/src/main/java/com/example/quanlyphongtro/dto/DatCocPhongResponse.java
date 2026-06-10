package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.TrangThaiDatCoc;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DatCocPhongResponse {
    private UUID id;
    private PhongResponse phong;
    private KhachThueResponse khachThue;
    private UUID hopDongId;
    private BigDecimal soTienCoc;
    private ZonedDateTime ngayDatCoc;
    private LocalDate ngayDuKienVao;
    private TrangThaiDatCoc trangThai;
    private String ghiChu;
    private String lyDoHuy;
    private ZonedDateTime confirmedAt;
    private ZonedDateTime cancelledAt;
    private String nguoiXacNhanTen;
}
