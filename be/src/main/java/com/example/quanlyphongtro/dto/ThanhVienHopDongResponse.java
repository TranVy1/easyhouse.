package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.ThanhVienHopDong;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.util.UUID;

@Data
@Builder
public class ThanhVienHopDongResponse {
    private UUID id;
    private UUID hopDongId;
    private String hoTen;
    private String soCccd;
    private String soDienThoai;
    private LocalDate ngayVao;
    private LocalDate ngayRoi;
    private Boolean dangO;
    private Boolean laNguoiDaiDien;
    private String ghiChu;

    public static ThanhVienHopDongResponse fromEntity(ThanhVienHopDong entity) {
        if (entity == null) return null;
        return ThanhVienHopDongResponse.builder()
                .id(entity.getId())
                .hopDongId(entity.getHopDong() != null ? entity.getHopDong().getId() : null)
                .hoTen(entity.getHoTen())
                .soCccd(entity.getSoCccd())
                .soDienThoai(entity.getSoDienThoai())
                .ngayVao(entity.getNgayVao())
                .ngayRoi(entity.getNgayRoi())
                .dangO(entity.getDangO())
                .laNguoiDaiDien(entity.getLaNguoiDaiDien())
                .ghiChu(entity.getGhiChu())
                .build();
    }
}
