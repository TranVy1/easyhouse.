package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "lich_su_kho_tai_san")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LichSuKhoTaiSan {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "kho_tai_san_id", nullable = false)
    private KhoTaiSan khoTaiSan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id")
    private Phong phong;

    @Column(nullable = false)
    private String loaiGiaoDich;

    @Column(nullable = false)
    private Integer soLuong;

    private String ghiChu;

    private ZonedDateTime taoLuc;
}
