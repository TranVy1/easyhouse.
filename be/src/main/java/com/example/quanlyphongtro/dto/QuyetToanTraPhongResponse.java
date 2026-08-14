package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.QuyetToanTraPhong;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class QuyetToanTraPhongResponse {
    private UUID id;
    private String trangThai;
    private LocalDate ngayTraPhong;
    private HoaDonResponse hoaDon;
    private BigDecimal tienCocBanDau;
    private BigDecimal tienCocDaCanTru;
    private BigDecimal tienCocCanHoan;
    private BigDecimal tienPhaiThuThem;
    private String khoanKhauTru;
    private Boolean banGiaoDaXacNhan;
    private Boolean veSinhKiemTraXong;
    private ZonedDateTime hoanCocLuc;
    private ZonedDateTime hoanTatLuc;
    private String ghiChu;

    public static QuyetToanTraPhongResponse fromEntity(QuyetToanTraPhong entity, HoaDonResponse hoaDon) {
        return QuyetToanTraPhongResponse.builder()
                .id(entity.getId())
                .trangThai(entity.getTrangThai().name())
                .ngayTraPhong(entity.getNgayTraPhong())
                .hoaDon(hoaDon)
                .tienCocBanDau(entity.getTienCocBanDau())
                .tienCocDaCanTru(entity.getTienCocDaCanTru())
                .tienCocCanHoan(entity.getTienCocCanHoan())
                .tienPhaiThuThem(entity.getTienPhaiThuThem())
                .khoanKhauTru(entity.getKhoanKhauTru())
                .banGiaoDaXacNhan(entity.getBanGiaoDaXacNhan())
                .veSinhKiemTraXong(entity.getVeSinhKiemTraXong())
                .hoanCocLuc(entity.getHoanCocLuc())
                .hoanTatLuc(entity.getHoanTatLuc())
                .ghiChu(entity.getGhiChu())
                .build();
    }
}
