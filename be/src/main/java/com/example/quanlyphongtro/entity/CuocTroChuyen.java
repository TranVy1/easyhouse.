package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

/**
 * Mot cuoc tro chuyen: chat 1-1, kenh ho tro, hoac nhom.
 *
 * Chat 1-1 chinh la truong hop N=2 cua nhom, nen toan bo logic gui/nhan/phan quyen
 * deu di qua bang thanh_vien_cuoc_tro_chuyen chu khong co duong rieng cho 1-1.
 */
@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "cuoc_tro_chuyen")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CuocTroChuyen {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoaiCuocTroChuyen loai;

    /** Chi dung cho nhom. DIRECT/SUPPORT hien thi ten doi phuong. */
    private String ten;

    private String anh;

    /** Truc phan quyen chinh. Null voi DIRECT xuyen nha tro. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NhaTro nhaTro;

    /** Chi dung cho loai FLOOR. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tang_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Tang tang;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_tao_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiTao;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private TrangThaiCuocTroChuyen trangThai = TrangThaiCuocTroChuyen.ACTIVE;

    /**
     * Khoa chong tao trung hoi thoai, UNIQUE o DB.
     * Sinh boi {@code CuocTroChuyenService.dungKhoaDuyNhat(...)}.
     */
    @Column(name = "khoa_duy_nhat", nullable = false, unique = true)
    private String khoaDuyNhat;

    /** Denormalize de sap xep danh sach hoi thoai ma khong join bang tin nhan. */
    private ZonedDateTime tinNhanCuoiLuc;

    /** Preview tin cuoi, cat ngan de hien trong danh sach. */
    private String xemTruoc;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;
}
