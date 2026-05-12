package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "chi_tiet_hoa_don")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChiTietHoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hoa_don_id")
    private HoaDon hoaDon;

    @Enumerated(EnumType.STRING)
    @Column(name = "loai", columnDefinition = "loai_muc_hoa_don", nullable = false)
    private LoaiMucHoaDon loai;

    @Column(name = "mo_ta", length = 255)
    private String moTa;

    @Column(name = "so_luong", nullable = false, precision = 10, scale = 2)
    private BigDecimal soLuong;

    @Column(name = "don_gia", nullable = false, precision = 15, scale = 2)
    private BigDecimal donGia;

    @Column(name = "thanh_tien", nullable = false, precision = 15, scale = 2)
    private BigDecimal thanhTien;

    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;

    @PrePersist
    protected void onCreate() {
        taoLuc = ZonedDateTime.now();
    }
}
