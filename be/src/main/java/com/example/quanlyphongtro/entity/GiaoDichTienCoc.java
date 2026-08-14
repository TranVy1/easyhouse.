package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "giao_dich_tien_coc")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GiaoDichTienCoc {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id", nullable = false)
    private HopDong hopDong;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "thanh_toan_id", unique = true)
    private ThanhToan thanhToan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quyet_toan_tra_phong_id")
    private QuyetToanTraPhong quyetToanTraPhong;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoaiGiaoDichTienCoc loai;

    @Column(nullable = false)
    private BigDecimal soTien;

    @Column(nullable = false)
    private ZonedDateTime thoiDiem;

    @Column(nullable = false)
    private String dienGiai;

    private String maThamChieu;
    private String chungTuUrl;
    private ZonedDateTime taoLuc;
}
