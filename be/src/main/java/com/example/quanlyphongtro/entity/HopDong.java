package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "hop_dong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HopDong {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id", nullable = false)
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id", nullable = false)
    private KhachThue khachThue;

    @Column(nullable = false, unique = true)
    private String maHopDong;

    @Column(nullable = false)
    private LocalDate ngayBatDau;

    @Column(nullable = false)
    private LocalDate ngayKetThuc;

    private LocalDate ngayKetThucThucTe;

    @Column(nullable = false)
    private BigDecimal giaThueHopDong;

    @Column(nullable = false)
    private BigDecimal tienCoc = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiCocHopDong trangThaiCoc = TrangThaiCocHopDong.NOT_PAID;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiHopDong trangThai = TrangThaiHopDong.DRAFT;

    @Column(nullable = false)
    private String chuKyThanhToan = "MONTHLY";

    @Column(nullable = false)
    private Integer ngayThanhToanHangThang = 5;

    @Column(nullable = false)
    private Boolean tuDongGiaHan = false;

    private Integer chiSoDienBanDau;
    private Integer chiSoNuocBanDau;
    
    private String noiDungHopDong;
    private String filePdf;
    private String templateVersion;
    private ZonedDateTime previewedAt;
    private ZonedDateTime confirmedAt;
    private ZonedDateTime lockedAt;

    private String signedPdfUrl;
    private ZonedDateTime tenantSignedAt;
    private ZonedDateTime landlordSignedAt;

    @Builder.Default
    private String signatureStatus = "UNSIGNED";

    private String ghiChu;


    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;
}
