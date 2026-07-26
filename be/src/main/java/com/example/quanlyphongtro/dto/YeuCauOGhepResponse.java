package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.TrangThaiYeuCauOGhep;
import com.example.quanlyphongtro.entity.YeuCauOGhep;
import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class YeuCauOGhepResponse {
    private UUID id;
    private UUID khachThueId;
    private String tenKhachThue;
    private UUID hopDongId;
    private String maHopDong;
    private String tenPhong;
    private TrangThaiYeuCauOGhep trangThai;
    private String loiNhan;
    private String ghiChuTuChoi;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;

    public static YeuCauOGhepResponse fromEntity(YeuCauOGhep entity) {
        return YeuCauOGhepResponse.builder()
                .id(entity.getId())
                .khachThueId(entity.getKhachThue().getId())
                .tenKhachThue(entity.getKhachThue().getHoTen())
                .hopDongId(entity.getHopDong().getId())
                .maHopDong(entity.getHopDong().getMaHopDong())
                .tenPhong(entity.getHopDong().getPhong().getTen())
                .trangThai(entity.getTrangThai())
                .loiNhan(entity.getLoiNhan())
                .ghiChuTuChoi(entity.getGhiChuTuChoi())
                .taoLuc(entity.getTaoLuc())
                .capNhatLuc(entity.getCapNhatLuc())
                .build();
    }
}
