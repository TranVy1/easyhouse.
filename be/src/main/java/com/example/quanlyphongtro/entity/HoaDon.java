package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "hoa_don")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id")
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id")
    private HopDong hopDong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id")
    private KhachThue khachThue;

    @Column(name = "ma_hoa_don", unique = true, length = 100)
    private String maHoaDon;

    @Column(name = "thang_hoa_don", nullable = false)
    private LocalDate thangHoaDon;

    @Column(name = "tong_tien", nullable = false, precision = 15, scale = 2)
    private BigDecimal tongTien;

    @Column(name = "da_tra", nullable = false, precision = 15, scale = 2)
    @Builder.Default
    private BigDecimal daTra = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai", columnDefinition = "trang_thai_hoa_don")
    @Builder.Default
    private TrangThaiHoaDon trangThai = TrangThaiHoaDon.UNPAID;

    @Column(name = "han_tra", nullable = false)
    private LocalDate hanTra;

    @Column(name = "ngay_phat_hanh")
    private LocalDate ngayPhatHanh;

    @Column(name = "ngay_gui")
    private ZonedDateTime ngayGui;

    @Column(name = "da_gui")
    @Builder.Default
    private Boolean daGui = false;

    @Column(name = "tien_giam", precision = 15, scale = 2)
    @Builder.Default
    private BigDecimal tienGiam = BigDecimal.ZERO;

    @Column(name = "phi_phat_sinh", precision = 15, scale = 2)
    @Builder.Default
    private BigDecimal phiPhatSinh = BigDecimal.ZERO;

    @Column(name = "ghi_chu", columnDefinition = "TEXT")
    private String ghiChu;

    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;

    @Column(name = "cap_nhat_luc")
    private ZonedDateTime capNhatLuc;

    @Column(name = "xoa_luc")
    private ZonedDateTime xoaLuc;

    @PrePersist
    protected void onCreate() {
        taoLuc = ZonedDateTime.now();
        capNhatLuc = ZonedDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        capNhatLuc = ZonedDateTime.now();
    }
}
