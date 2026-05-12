package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "thanh_toan")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ThanhToan {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hoa_don_id")
    private HoaDon hoaDon;

    @Column(name = "so_tien", nullable = false, precision = 15, scale = 2)
    private BigDecimal soTien;

    @Column(name = "ngay_thanh_toan")
    private ZonedDateTime ngayThanhToan;

    @Column(name = "phuong_thuc_thanh_toan", length = 50)
    private String phuongThuc;

    @Column(name = "ma_tham_chieu", length = 100)
    private String maThamChieu;

    @Column(name = "trang_thai", length = 50)
    @Builder.Default
    private String trangThai = "SUCCESS";

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_thanh_toan")
    private NguoiDung nguoiThanhToan;

    @Column(name = "ghi_chu", columnDefinition = "TEXT")
    private String ghiChu;

    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;

    @PrePersist
    protected void onCreate() {
        taoLuc = ZonedDateTime.now();
        if (ngayThanhToan == null) {
            ngayThanhToan = ZonedDateTime.now();
        }
    }
}
