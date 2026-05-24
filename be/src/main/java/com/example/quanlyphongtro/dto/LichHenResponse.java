package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.LichHen;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class LichHenResponse {
    @JsonProperty("_id")
    private UUID id;
    
    private UUID phongId;
    private PhongResponse phong; // if needed

    private UUID nguoiDungId;
    private String hoTen;
    private String soDienThoai;
    private String email;
    private ZonedDateTime ngayHen;
    private String trangThai;
    private Boolean daGuiNhacNho;
    private String ghiChu;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;

    public static LichHenResponse fromEntity(LichHen lichHen) {
        if (lichHen == null) return null;
        
        PhongResponse phongResp = null;
        if (lichHen.getPhong() != null) {
            phongResp = PhongResponse.builder()
                .id(lichHen.getPhong().getId())
                .ten(lichHen.getPhong().getTen())
                .build();
        }

        return LichHenResponse.builder()
                .id(lichHen.getId())
                .phongId(lichHen.getPhong() != null ? lichHen.getPhong().getId() : null)
                .phong(phongResp)
                .nguoiDungId(lichHen.getNguoiDung() != null ? lichHen.getNguoiDung().getId() : null)
                .hoTen(lichHen.getHoTen())
                .soDienThoai(lichHen.getSoDienThoai())
                .email(lichHen.getEmail())
                .ngayHen(lichHen.getNgayHen())
                .trangThai(lichHen.getTrangThai() != null ? lichHen.getTrangThai().name() : null)
                .daGuiNhacNho(lichHen.getDaGuiNhacNho())
                .ghiChu(lichHen.getGhiChu())
                .taoLuc(lichHen.getTaoLuc())
                .capNhatLuc(lichHen.getCapNhatLuc())
                .build();
    }
}
