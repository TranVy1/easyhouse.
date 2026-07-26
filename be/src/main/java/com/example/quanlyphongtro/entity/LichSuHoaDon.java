package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "lich_su_hoa_don")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LichSuHoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hoa_don_id", nullable = false)
    private HoaDon hoaDon;

    @Enumerated(EnumType.STRING)
    private TrangThaiHoaDon trangThaiTruoc;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiHoaDon trangThaiMoi;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_thay_doi_id")
    private NguoiDung nguoiThayDoi;

    private String ghiChu;
    private ZonedDateTime taoLuc;
}
