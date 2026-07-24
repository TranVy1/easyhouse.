package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "nha_tro")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NhaTro {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chu_tro_id", nullable = false)
    private NguoiDung chuTro;

    @Column(nullable = false)
    private String ten;

    @Column(nullable = false)
    private String diaChi;

    private String soNha;
    private String duong;
    private String phuong;
    private String quan;
    private String thanhPho;
    private String moTa;
    private String tienNghiChung;
    private String noiQuy;

    @Column(precision = 10, scale = 7)
    private BigDecimal viDo;

    @Column(precision = 10, scale = 7)
    private BigDecimal kinhDo;

    private String googlePlaceId;
    private String diaChiDaChuanHoa;

    @Column(nullable = false)
    private String trangThai = "ACTIVE";

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;
}
