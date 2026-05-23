package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "khach_thue")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KhachThue {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", unique = true)
    private NguoiDung nguoiDung;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chu_tro_id", nullable = false)
    private NguoiDung chuTro;

    @Column(nullable = false)
    private String hoTen;

    private String soDienThoai;
    private String email;
    private String soCccd;
    private LocalDate ngaySinh;
    private String gioiTinh;
    private String diaChi;
    private String queQuan;
    private String ngheNghiep;
    private String ghiChu;

    @Column(nullable = false)
    private Boolean dangHoatDong = true;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;
}
