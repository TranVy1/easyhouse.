package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "chi_tiet_hoa_don")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChiTietHoaDon {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hoa_don_id", nullable = false)
    private HoaDon hoaDon;

    // Optional refs omitted for brevity, you can map them if needed
    @Column(name = "dich_vu_id")
    private UUID dichVuId;

    @Column(name = "chi_so_dien_nuoc_id")
    private UUID chiSoDienNuocId;

    @Column(name = "su_co_id")
    private UUID suCoId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoaiMucHoaDon loai;

    @Column(nullable = false)
    private String moTa;

    @Column(nullable = false)
    private BigDecimal soLuong = BigDecimal.ONE;

    @Column(nullable = false)
    private BigDecimal donGia = BigDecimal.ZERO;

    @Column(nullable = false)
    private BigDecimal thanhTien = BigDecimal.ZERO;

    private ZonedDateTime taoLuc;
}
