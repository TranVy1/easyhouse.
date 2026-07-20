package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "tai_san_phong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TaiSanPhong {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id", nullable = false)
    private Phong phong;

    @Column(nullable = false)
    private String tenTaiSan;

    @Column(nullable = false)
    private Integer soLuong;

    @Column(nullable = false)
    private BigDecimal giaTri;

    @Column(nullable = false)
    private String tinhTrang;

    private String ghiChu;

    private String anhTaiSan;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
