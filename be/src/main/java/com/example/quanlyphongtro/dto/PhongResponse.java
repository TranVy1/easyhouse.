package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.HopDong;
import lombok.Builder;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import java.util.UUID;
import java.util.List;
import java.time.LocalDateTime;

@Data
@Builder
public class PhongResponse {
    
    @JsonProperty("_id")
    private UUID id;
    
    @JsonProperty("maPhong")
    private String ten;
    
    private NhaTroResponse toaNha;
    private Integer tang;
    private BigDecimal dienTich;
    
    @JsonProperty("giaThue")
    private BigDecimal giaHienTai;
    
    @JsonProperty("tienCoc")
    private BigDecimal tienCocMacDinh;
    
    private String trangThai;
    private Integer soNguoiToiDa;
    private String moTa;
    
    private List<String> anhPhong;
    
    private List<String> tienNghi;

    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;

    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    private HopDongResponse hopDongHienTai;

    public static PhongResponse fromEntity(Phong phong) {
        return fromEntity(phong, null);
    }

    public static PhongResponse fromEntity(Phong phong, HopDong activeContract) {
        if (phong == null) return null;
        
        NhaTroResponse nhaTroResp = null;
        if (phong.getNhaTro() != null) {
            nhaTroResp = NhaTroResponse.builder()
                .id(phong.getNhaTro().getId())
                .tenToaNha(phong.getNhaTro().getTen())
                .diaChi(NhaTroResponse.DiaChiResponse.builder()
                        .soNha("")
                        .duong(phong.getNhaTro().getDiaChi() != null ? phong.getNhaTro().getDiaChi() : "")
                        .phuong(phong.getNhaTro().getXa() != null ? phong.getNhaTro().getXa() : "")
                        .quan(phong.getNhaTro().getHuyen() != null ? phong.getNhaTro().getHuyen() : "")
                        .thanhPho(phong.getNhaTro().getTinh() != null ? phong.getNhaTro().getTinh() : "")
                        .build())
                .build();
        }

        // Enum mapping for Frontend
        String trangThaiFrontend = "trong";
        if (phong.getTrangThai() != null) {
            switch (phong.getTrangThai().name()) {
                case "AVAILABLE": trangThaiFrontend = "trong"; break;
                case "RENTED": trangThaiFrontend = "dangThue"; break;
                case "MAINTENANCE": trangThaiFrontend = "baoTri"; break;
            }
        }

        LocalDateTime taoLucLocal = phong.getTaoLuc() != null
            ? phong.getTaoLuc().toLocalDateTime()
            : null;
        LocalDateTime capNhatLucLocal = phong.getCapNhatLuc() != null
            ? phong.getCapNhatLuc().toLocalDateTime()
            : null;

        return PhongResponse.builder()
            .id(phong.getId())
            .ten(phong.getTen())
            .toaNha(nhaTroResp)
            .tang(phong.getTang())
            .dienTich(phong.getDienTich())
            .giaHienTai(phong.getGiaHienTai())
            .tienCocMacDinh(phong.getTienCocMacDinh())
            .soNguoiToiDa(phong.getSoNguoiToiDa())
            .trangThai(trangThaiFrontend)
            .moTa(phong.getMoTa())
            .anhPhong(phong.getAnhPhong())
            .tienNghi(phong.getTienNghi())
            .taoLuc(taoLucLocal)
            .capNhatLuc(capNhatLucLocal)
            .hopDongHienTai(activeContract != null ? HopDongResponse.fromEntity(activeContract, null) : null)
            .build();
    }
}
