package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.HopDong;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class HopDongResponse {
    @JsonProperty("_id")
    private UUID id;
    private String maHopDong;
    private PhongResponse phong;
    private KhachThueResponse khachThue;
    private List<KhachThueResponse> khachThueId;
    private UUID khachThueDaiDienId;
    private KhachThueResponse nguoiDaiDien;
    private List<ThanhVienHopDongResponse> thanhVien;
    private LocalDate ngayBatDau;
    private LocalDate ngayKetThuc;
    private LocalDate ngayKetThucThucTe;
    @JsonProperty("giaThue")
    private BigDecimal giaThueHopDong;
    private BigDecimal tienCoc;
    private String trangThaiCoc;
    private String trangThai;
    private String chuKyThanhToan;
    @JsonProperty("ngayThanhToan")
    private Integer ngayThanhToanHangThang;
    private Boolean tuDongGiaHan;
    private Boolean dongMotCocMot;
    private Integer chiSoDienBanDau;
    private Integer chiSoNuocBanDau;
    @JsonProperty("dieuKhoan")
    private String noiDungHopDong;
    private BigDecimal giaDien;
    private BigDecimal giaNuoc;
    private List<PhiDichVuResponse> phiDichVu;
    private String filePdf;
    private String templateVersion;
    private ZonedDateTime previewedAt;
    private ZonedDateTime confirmedAt;
    private ZonedDateTime lockedAt;
    private String pdfUrl;
    private String signedPdfUrl;
    private ZonedDateTime tenantSignedAt;
    private ZonedDateTime landlordSignedAt;
    private String signatureStatus;
    private String ghiChu;
    private ZonedDateTime ngayTao;

    @Data
    @Builder
    public static class ThanhVienHopDongResponse {
        @JsonProperty("_id")
        private UUID id;
        private UUID hopDongId;
        private UUID khachThueId;
        private String hoTen;
        private String soCccd;
        private String soDienThoai;
        private LocalDate ngayVao;
        private LocalDate ngayRoi;
        private Boolean dangO;
        private Boolean laNguoiDaiDien;
        private String ghiChu;
    }

    @Data
    @Builder
    public static class PhiDichVuResponse {
        @JsonProperty("_id")
        private UUID id;
        private UUID dichVuId;
        private String ten;
        private BigDecimal gia;
        private BigDecimal soLuong;
        private String loaiTinhPhi;
        private String donVi;
        private LocalDate batDauTu;
        private LocalDate ketThucLuc;
    }

    public static HopDongResponse fromEntity(HopDong hd) {
        if (hd == null) return null;

        PhongResponse phongResp = null;
        if (hd.getPhong() != null) {
            phongResp = PhongResponse.fromEntity(hd.getPhong());
        }

        KhachThueResponse ktResp = null;
        if (hd.getKhachThue() != null) {
            ktResp = KhachThueResponse.fromEntity(hd.getKhachThue());
        }

        return HopDongResponse.builder()
                .id(hd.getId())
                .maHopDong(hd.getMaHopDong())
                .phong(phongResp)
                .khachThue(ktResp)
                .khachThueId(ktResp != null ? List.of(ktResp) : List.of())
                .khachThueDaiDienId(hd.getKhachThue() != null ? hd.getKhachThue().getId() : null)
                .nguoiDaiDien(ktResp)
                .thanhVien(List.of())
                .ngayBatDau(hd.getNgayBatDau())
                .ngayKetThuc(hd.getNgayKetThuc())
                .ngayKetThucThucTe(hd.getNgayKetThucThucTe())
                .giaThueHopDong(hd.getGiaThueHopDong())
                .tienCoc(hd.getTienCoc())
                .trangThaiCoc(hd.getTrangThaiCoc() != null ? hd.getTrangThaiCoc().name() : null)
                .trangThai(hd.getTrangThai() != null ? mapTrangThai(hd.getTrangThai().name()) : null)
                .chuKyThanhToan(mapChuKy(hd.getChuKyThanhToan()))
                .ngayThanhToanHangThang(hd.getNgayThanhToanHangThang())
                .tuDongGiaHan(hd.getTuDongGiaHan())
                .dongMotCocMot(hd.getDongMotCocMot())
                .chiSoDienBanDau(hd.getChiSoDienBanDau())
                .chiSoNuocBanDau(hd.getChiSoNuocBanDau())
                .noiDungHopDong(hd.getNoiDungHopDong() != null ? hd.getNoiDungHopDong() : "")
                .phiDichVu(List.of())
                .filePdf(hd.getFilePdf())
                .templateVersion(hd.getTemplateVersion())
                .previewedAt(hd.getPreviewedAt())
                .confirmedAt(hd.getConfirmedAt())
                .lockedAt(hd.getLockedAt())
                .pdfUrl(hd.getFilePdf())
                .signedPdfUrl(hd.getSignedPdfUrl())
                .tenantSignedAt(hd.getTenantSignedAt())
                .landlordSignedAt(hd.getLandlordSignedAt())
                .signatureStatus(hd.getSignatureStatus() != null ? hd.getSignatureStatus().name() : "UNSIGNED")
                .ghiChu(hd.getGhiChu())
                .ngayTao(hd.getTaoLuc())
                .build();
    }

    private static String mapTrangThai(String trangThai) {
        if (trangThai == null) return "nhap";
        return switch (trangThai) {
            case "DRAFT" -> "nhap";
            case "PENDING" -> "choKichHoat";
            case "ACTIVE" -> "hoatDong";
            case "EXPIRED" -> "hetHan";
            case "TERMINATED" -> "daKetThuc";
            case "CANCELLED" -> "daHuy";
            default -> "nhap";
        };
    }

    private static String mapChuKy(String chuKy) {
        if (chuKy == null) return "thang";
        return switch (chuKy) {
            case "MONTHLY" -> "thang";
            case "QUARTERLY" -> "quy";
            case "YEARLY" -> "nam";
            default -> "thang";
        };
    }
}
