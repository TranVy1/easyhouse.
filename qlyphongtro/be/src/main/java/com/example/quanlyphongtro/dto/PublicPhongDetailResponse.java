package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
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
public class PublicPhongDetailResponse {
    @JsonProperty("_id")
    private UUID _id;
    private String ten;
    private BigDecimal giaHienTai;
    private BigDecimal tienCocMacDinh;
    private BigDecimal dienTich;
    private Integer soNguoiToiDa;
    private TrangThaiPhong trangThai;
    private String moTa;
    private PublicNhaTroSummaryResponse nhaTro;
    private List<String> tienIchList;
    private List<String> anhList;
    private List<HopDongDichVuOptionResponse> dichVuList;

    public static PublicPhongDetailResponse fromEntity(Phong phong, List<String> anhList, List<HopDongDichVuOptionResponse> dichVuList, List<String> tienIchList) {
        if (phong == null) return null;

        return PublicPhongDetailResponse.builder()
                ._id(phong.getId())
                .ten(phong.getTen())
                .giaHienTai(phong.getGiaHienTai())
                .tienCocMacDinh(phong.getTienCocMacDinh())
                .dienTich(phong.getDienTich())
                .soNguoiToiDa(phong.getSoNguoiToiDa())
                .trangThai(phong.getTrangThai())
                .moTa(phong.getMoTa())
                .nhaTro(PublicNhaTroSummaryResponse.fromEntity(phong.getNhaTro()))
                .tienIchList(tienIchList)
                .anhList(anhList)
                .dichVuList(dichVuList)
                .build();
    }
}
