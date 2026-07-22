package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.SQLRestriction;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "kho_tai_san")
@SQLRestriction("xoa_luc IS NULL")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KhoTaiSan {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id", nullable = false)
    private NhaTro nhaTro;

    @Column(nullable = false)
    private String tenTaiSan;

    private String hinhAnh;

    @Column(nullable = false)
    @Builder.Default
    private Integer tongSoLuong = 0;

    @Column(nullable = false)
    @Builder.Default
    private Integer soLuongKhaDung = 0;

    @Column(nullable = false)
    @Builder.Default
    private Integer soLuongDaCapPhat = 0;

    @Column(nullable = false)
    @Builder.Default
    private Integer soLuongHuHong = 0;

    @Column(nullable = false)
    private String tinhTrang;

    private String ghiChu;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;

    @Column(name = "xoa_luc")
    private ZonedDateTime xoaLuc;
}
