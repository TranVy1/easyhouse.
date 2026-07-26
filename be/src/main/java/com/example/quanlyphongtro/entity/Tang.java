package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "tang")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Tang {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id", nullable = false)
    private NhaTro nhaTro;

    @Column(nullable = false)
    private Integer soTang;

    private String tenTang;
    private Integer thuTuHienThi;
    private Integer soPhongDuKien;

    @Column(nullable = false)
    private String trangThai = "ACTIVE";

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;
}
