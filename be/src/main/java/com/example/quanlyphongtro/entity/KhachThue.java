package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "khach_thue")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KhachThue {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Relationship với NguoiDung - lấy thông tin cá nhân từ đây
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", unique = true)
    private NguoiDung nguoiDung;

    @Column(name = "so_cccd", nullable = false, unique = true, length = 50)
    private String soCccd;

    @Column(name = "lien_he_khan_cap", length = 255)
    private String lienHeKhanCap;

    @Column(name = "ngay_sinh")
    private LocalDate ngaySinh;

    @Column(name = "dia_chi_thuong_tru", columnDefinition = "TEXT")
    private String diaChiThuongTru;

    @Column(name = "nghe_nghiep", length = 255)
    private String ngheNghiep;

    @Column(name = "anh_cccd_truoc", columnDefinition = "TEXT")
    private String anhCccdTruoc;

    @Column(name = "anh_cccd_sau", columnDefinition = "TEXT")
    private String anhCccdSau;

    @CreationTimestamp
    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;

    @UpdateTimestamp
    @Column(name = "cap_nhat_luc")
    private ZonedDateTime capNhatLuc;

    @Column(name = "xoa_luc")
    private ZonedDateTime xoaLuc;
}