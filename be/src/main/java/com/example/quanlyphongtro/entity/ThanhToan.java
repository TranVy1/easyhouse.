package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "thanh_toan")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ThanhToan {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hoa_don_id", nullable = false)
    private HoaDon hoaDon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id")
    private KhachThue khachThue;

    @Column(nullable = false)
    private BigDecimal soTien;

    @Column(nullable = false)
    private ZonedDateTime ngayThanhToan;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PhuongThucThanhToan phuongThucThanhToan = PhuongThucThanhToan.CASH;

    private String maThamChieu;
    
    @Column(unique = true)
    private String externalTransactionId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiThanhToan trangThai = TrangThaiThanhToan.SUCCESS;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_thanh_toan_id")
    private NguoiDung nguoiThanhToan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_ghi_nhan_id")
    private NguoiDung nguoiGhiNhan;

    private String ghiChu;
    private ZonedDateTime taoLuc;
}
