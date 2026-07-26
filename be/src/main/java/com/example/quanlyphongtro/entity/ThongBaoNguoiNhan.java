package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "thong_bao_nguoi_nhan")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ThongBaoNguoiNhan {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "thong_bao_id", nullable = false)
    private ThongBao thongBao;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", nullable = false)
    private NguoiDung nguoiDung;

    @Column(nullable = false)
    private Boolean daDoc = false;

    private ZonedDateTime docLuc;
    private ZonedDateTime guiLuc;
    private String loiGui;
}
