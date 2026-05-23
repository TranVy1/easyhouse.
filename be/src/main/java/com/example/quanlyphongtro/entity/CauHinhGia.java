package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "cau_hinh_gia")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CauHinhGia {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id", nullable = false)
    private NhaTro nhaTro;

    @Column(name = "dich_vu_id")
    private UUID dichVuId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoaiMucHoaDon loai;

    @Column(nullable = false)
    private String tenHienThi;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoaiTinhPhi loaiTinhPhi = LoaiTinhPhi.FIXED;

    @Column(nullable = false)
    private BigDecimal donGia;

    @Column(nullable = false)
    private LocalDate hieuLucTu;

    private LocalDate hieuLucDen;

    @Column(nullable = false)
    private Boolean dangApDung = true;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
