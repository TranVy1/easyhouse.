package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.TrangThaiPhuongTien;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PhuongTienDto {
    private UUID id;
    private String maPt;
    private String loaiXe;
    private String bienSo;
    
    private String anhXe;
    private String loaiPhuongTien;
    private String tenDongXe;
    private String mauXe;
    private String tenChuXe;
    private String soVeXe;
    private LocalDate hieuLucTu;
    private LocalDate hieuLucDen;

    private UUID khachThueId;
    private KhachThueResponse khachThue;
    
    private UUID phongId;
    private PhongResponse phong;
    
    private UUID nhaTroId;
    private NhaTroResponse nhaTro;
    
    private TrangThaiPhuongTien trangThai;
    private ZonedDateTime createdAt;
    private ZonedDateTime updatedAt;
}
