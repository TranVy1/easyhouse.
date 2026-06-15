package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "phong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Phong {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id", nullable = false)
    private NhaTro nhaTro;

    @Column(nullable = false)
    private String ten;

    private String khuVuc;
    private Integer tang;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tang_id")
    private Tang tangEntity;

    @Column(nullable = false)
    private BigDecimal dienTich;

    @Column(nullable = false)
    private Integer soNguoiToiDa = 2;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiPhong trangThai = TrangThaiPhong.AVAILABLE;

    @Column(nullable = false)
    private BigDecimal giaHienTai;

    @Column(nullable = false)
    private BigDecimal tienCocMacDinh = BigDecimal.ZERO;

    private String moTa;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;

    @Version
    @Column(nullable = false, columnDefinition = "bigint default 0")
    private Long version;
}
