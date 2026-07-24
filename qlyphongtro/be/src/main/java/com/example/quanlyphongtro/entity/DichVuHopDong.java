package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "dich_vu_hop_dong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DichVuHopDong {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id", nullable = false)
    private HopDong hopDong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dich_vu_id", nullable = false)
    private DichVu dichVu;

    @Enumerated(EnumType.STRING)
    @Column(name = "loai_tinh_phi", nullable = false)
    private LoaiTinhPhi loaiTinhPhi;

    @Column(name = "don_gia_ap_dung", nullable = false)
    private BigDecimal donGiaApDung;

    @Column(nullable = false)
    private BigDecimal soLuong;

    @Column(name = "bat_dau_tu", nullable = false)
    private LocalDate batDauTu;

    @Column(name = "ket_thuc_luc")
    private LocalDate ketThucLuc;

    @Column(name = "tao_luc")
    private ZonedDateTime taoLuc;
}
