package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "phu_luc_hop_dong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PhuLucHopDong {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id", nullable = false)
    private HopDong hopDong;

    @Column(nullable = false, length = 50)
    private String loai;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String noiDung;

    @Column(nullable = false)
    private LocalDate ngayHieuLuc;

    private BigDecimal giaThueMoi;
    private LocalDate ngayKetThucMoi;
    private String filePdf;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_tao_id")
    private NguoiDung nguoiTao;

    @Column(nullable = false, updatable = false)
    private ZonedDateTime taoLuc;

    @PrePersist
    public void prePersist() {
        if (taoLuc == null) {
            taoLuc = ZonedDateTime.now();
        }
    }
}
