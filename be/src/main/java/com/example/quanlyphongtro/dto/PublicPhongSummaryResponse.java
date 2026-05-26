package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.util.UUID;
import java.util.List;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TienIch;
import com.example.quanlyphongtro.entity.TrangThaiPhong;

@Data
@Builder
public class PublicPhongSummaryResponse {
    private UUID _id;
    private String ten;
    private BigDecimal giaHienTai;
    private BigDecimal dienTich;
    private Integer soNguoiToiDa;
    private TrangThaiPhong trangThai;
    private String anhDaiDien;
    private UUID nhaTroId;
    private String tenNhaTro;
    private String diaChiNhaTro;
    private List<String> tienIchNoiBat;

    public static PublicPhongSummaryResponse fromEntity(Phong phong, String anhDaiDien, List<String> tienIchList) {
        if (phong == null) return null;
            
        String tenNt = phong.getNhaTro() != null ? phong.getNhaTro().getTen() : null;
        String diaChiNt = phong.getNhaTro() != null ? phong.getNhaTro().getDiaChi() : null;
        UUID ntId = phong.getNhaTro() != null ? phong.getNhaTro().getId() : null;

        return PublicPhongSummaryResponse.builder()
                ._id(phong.getId())
                .ten(phong.getTen())
                .giaHienTai(phong.getGiaHienTai())
                .dienTich(phong.getDienTich())
                .soNguoiToiDa(phong.getSoNguoiToiDa())
                .trangThai(phong.getTrangThai())
                .anhDaiDien(anhDaiDien)
                .nhaTroId(ntId)
                .tenNhaTro(tenNt)
                .diaChiNhaTro(diaChiNt)
                .tienIchNoiBat(tienIchList)
                .build();
    }
}
