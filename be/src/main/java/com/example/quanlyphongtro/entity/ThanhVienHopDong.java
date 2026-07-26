package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "thanh_vien_hop_dong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ThanhVienHopDong {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id", nullable = false)
    private HopDong hopDong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id")
    private KhachThue khachThue;

    @Column(name = "ho_ten", nullable = false)
    private String hoTen;

    @Column(name = "so_cccd")
    private String soCccd;

    @Column(name = "so_dien_thoai")
    private String soDienThoai;

    @Column(name = "ngay_vao", nullable = false)
    private LocalDate ngayVao;

    @Column(name = "ngay_roi")
    private LocalDate ngayRoi;

    @Column(name = "dang_o", nullable = false)
    private Boolean dangO;

    @Column(name = "la_nguoi_dai_dien", nullable = false)
    private Boolean laNguoiDaiDien;

    @Column(name = "ghi_chu")
    private String ghiChu;

    @Column(name = "tao_luc")
    private ZonedDateTime taoLuc;

    @Column(name = "cap_nhat_luc")
    private ZonedDateTime capNhatLuc;
}
