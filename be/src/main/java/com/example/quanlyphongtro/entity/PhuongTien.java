package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "phuong_tien")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PhuongTien {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "ma_pt", nullable = false, unique = true)
    private String maPt;

    @Column(name = "loai_xe", nullable = false)
    private String loaiXe;

    @Column(name = "bien_so", nullable = false)
    private String bienSo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id")
    private KhachThue khachThue;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id")
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id", nullable = false)
    private NhaTro nhaTro;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chu_tro_id", nullable = false)
    private NguoiDung chuTro;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai", columnDefinition = "trang_thai_phuong_tien")
    private TrangThaiPhuongTien trangThai;

    @Column(name = "anh_xe")
    private String anhXe;

    @Column(name = "loai_phuong_tien", length = 50)
    private String loaiPhuongTien;

    @Column(name = "ten_dong_xe", length = 100)
    private String tenDongXe;

    @Column(name = "mau_xe", length = 50)
    private String mauXe;

    @Column(name = "ten_chu_xe", length = 100)
    private String tenChuXe;

    @Column(name = "so_ve_xe", length = 50)
    private String soVeXe;

    @Column(name = "created_at", updatable = false)
    private ZonedDateTime createdAt;

    @Column(name = "updated_at")
    private ZonedDateTime updatedAt;
}
