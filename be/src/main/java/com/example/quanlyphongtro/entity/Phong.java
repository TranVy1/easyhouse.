package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "phong")
@Getter
@Setter
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

    @Column(nullable = false, length = 100)
    private String ten;

    private Integer tang;

    @Column(name = "dien_tich", nullable = false, precision = 10, scale = 2)
    private BigDecimal dienTich;

    @Builder.Default
    @Column(name = "so_nguoi_toi_da", nullable = false)
    private Integer soNguoiToiDa = 2;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai")
    private TrangThaiPhong trangThai = TrangThaiPhong.AVAILABLE;

    @Column(name = "gia_hien_tai", nullable = false, precision = 15, scale = 2)
    private BigDecimal giaHienTai;

    @Column(name = "tien_coc_mac_dinh", precision = 15, scale = 2)
    private BigDecimal tienCocMacDinh;

    @Column(name = "mo_ta", columnDefinition = "TEXT")
    private String moTa;

    @Builder.Default
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "anh_phong", columnDefinition = "jsonb")
    private List<String> anhPhong = new ArrayList<>();

    @Builder.Default
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "tien_nghi", columnDefinition = "jsonb")
    private List<String> tienNghi = new ArrayList<>();

    @CreationTimestamp
    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;

    @UpdateTimestamp
    @Column(name = "cap_nhat_luc")
    private ZonedDateTime capNhatLuc;

    @Column(name = "xoa_luc")
    private ZonedDateTime xoaLuc;
}
