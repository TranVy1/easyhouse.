package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "meter_anomaly_alert")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MeterAnomalyAlert {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chi_so_id", nullable = false)
    private ChiSoDienNuoc chiSoDienNuoc;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id", nullable = false)
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id")
    private HopDong hopDong;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoaiChiSo loai;

    @Column(nullable = false)
    private Integer kyThang;

    @Column(nullable = false)
    private Integer kyNam;

    @Column(nullable = false)
    private Integer tieuThuHienTai;

    private BigDecimal tieuThuTrungBinh;

    private BigDecimal tyLeTang;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MucDoAlert mucDo;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String lyDo;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiAlert trangThai = TrangThaiAlert.OPEN;

    private ZonedDateTime resolvedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "resolved_by")
    private NguoiDung resolvedBy;

    @Column(nullable = false, updatable = false)
    private ZonedDateTime taoLuc;

    @PrePersist
    protected void onCreate() {
        if (taoLuc == null) {
            taoLuc = ZonedDateTime.now();
        }
    }
}
