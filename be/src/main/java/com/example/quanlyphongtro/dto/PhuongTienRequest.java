package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.TrangThaiPhuongTien;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PhuongTienRequest {
    
    private String maPt;

    @NotBlank(message = "Loại xe không được để trống")
    private String loaiXe;

    @NotBlank(message = "Biển số không được để trống")
    private String bienSo;

    private UUID khachThueId;
    
    private UUID phongId;

    @NotNull(message = "Tòa nhà không được để trống")
    private UUID nhaTroId;

    @NotNull(message = "Trạng thái không được để trống")
    private TrangThaiPhuongTien trangThai;

    private String anhXe;
    private String loaiPhuongTien;
    private String tenDongXe;
    private String mauXe;
    private String tenChuXe;
    private String soVeXe;
}
