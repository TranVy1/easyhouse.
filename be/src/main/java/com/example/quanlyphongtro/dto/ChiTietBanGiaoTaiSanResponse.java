package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.ChiTietBanGiaoTaiSan;
import lombok.Builder;
import lombok.Data;
import java.util.UUID;

@Data
@Builder
public class ChiTietBanGiaoTaiSanResponse {
    private UUID id;
    private UUID taiSanPhongId;
    private String tenTaiSan;
    private Integer soLuongBanDau;
    private String tinhTrangBanDau;
    private String anhTaiSanBanDau;
    private Integer soLuongThucTe;
    private String tinhTrangThucTe;
    private String chungTuUrl;
    private String ghiChu;
    private Boolean daXacNhan;

    public static ChiTietBanGiaoTaiSanResponse fromEntity(ChiTietBanGiaoTaiSan item) {
        return builder().id(item.getId()).taiSanPhongId(item.getTaiSanPhong() != null ? item.getTaiSanPhong().getId() : null)
                .tenTaiSan(item.getTenTaiSan()).soLuongBanDau(item.getSoLuongBanDau()).tinhTrangBanDau(item.getTinhTrangBanDau())
                .anhTaiSanBanDau(item.getAnhTaiSanBanDau()).soLuongThucTe(item.getSoLuongThucTe())
                .tinhTrangThucTe(item.getTinhTrangThucTe()).chungTuUrl(item.getChungTuUrl()).ghiChu(item.getGhiChu())
                .daXacNhan(item.getDaXacNhan()).build();
    }
}
