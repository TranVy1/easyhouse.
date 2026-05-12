package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import java.util.Collections;
import java.util.Map;

@Data
@Builder
public class HopDongResponse {
    @JsonProperty("_id")
    private UUID id;
    private String maHopDong;
    private PhongResponse phong;
    private List<KhachThueResponse> khachThue;
    private List<UUID> khachThueId;
    private KhachThueResponse nguoiDaiDien;
    private LocalDate ngayBatDau;
    private LocalDate ngayKetThuc;
    private BigDecimal giaThue;
    private BigDecimal tienCoc;
    private String chuKyThanhToan;
    private Integer ngayThanhToan;
    private String dieuKhoan;
    private BigDecimal giaDien;
    private BigDecimal giaNuoc;
    private Integer chiSoDienBanDau;
    private Integer chiSoNuocBanDau;
    private Object phiDichVu;
    private String trangThai;
    private ZonedDateTime ngayTao;

    public static HopDongResponse fromEntity(HopDong hopDong, List<KhachThue> allTenants) {
        if (hopDong == null) return null;

        List<KhachThueResponse> khachThueList = null;
        if (allTenants != null && hopDong.getKhachThueIds() != null) {
            khachThueList = allTenants.stream()
                    .filter(t -> hopDong.getKhachThueIds().contains(t.getId()))
                    .map(KhachThueResponse::fromEntity)
                    .collect(Collectors.toList());
        }

        Object parsedPhiDichVu = Collections.emptyList();
        if (hopDong.getPhiDichVu() != null && !hopDong.getPhiDichVu().isEmpty()) {
            try {
                ObjectMapper mapper = new ObjectMapper();
                parsedPhiDichVu = mapper.readValue(hopDong.getPhiDichVu(), new TypeReference<List<Map<String, Object>>>() {});
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String statusFrontend = "hoatDong";
        if (hopDong.getTrangThai() != null) {
            switch (hopDong.getTrangThai()) {
                case ACTIVE: statusFrontend = "hoatDong"; break;
                case EXPIRED: statusFrontend = "hetHan"; break;
                case TERMINATED: statusFrontend = "daHuy"; break;
            }
        }

        return HopDongResponse.builder()
                .id(hopDong.getId())
                .maHopDong(hopDong.getMaHopDong())
                .phong(PhongResponse.fromEntity(hopDong.getPhong()))
                .khachThue(khachThueList)
                .khachThueId(hopDong.getKhachThueIds())
                .nguoiDaiDien(KhachThueResponse.fromEntity(hopDong.getNguoiDaiDien()))
                .ngayBatDau(hopDong.getNgayBatDau())
                .ngayKetThuc(hopDong.getNgayKetThuc())
                .giaThue(hopDong.getGiaThue())
                .tienCoc(hopDong.getTienCoc())
                .chuKyThanhToan(hopDong.getChuKyThanhToan())
                .ngayThanhToan(hopDong.getNgayThanhToan())
                .dieuKhoan(hopDong.getDieuKhoan())
                .giaDien(hopDong.getGiaDien())
                .giaNuoc(hopDong.getGiaNuoc())
                .chiSoDienBanDau(hopDong.getChiSoDienBanDau())
                .chiSoNuocBanDau(hopDong.getChiSoNuocBanDau())
                .phiDichVu(parsedPhiDichVu)
                .trangThai(statusFrontend)
                .ngayTao(hopDong.getTaoLuc())
                .build();
    }
}
