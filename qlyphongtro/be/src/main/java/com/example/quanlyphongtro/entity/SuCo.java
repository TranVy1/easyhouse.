package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import com.example.quanlyphongtro.entity.converter.LoaiSuCoConverter;
import com.example.quanlyphongtro.entity.converter.UuTienConverter;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "su_co")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SuCo {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id", nullable = false)
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id")
    private KhachThue khachThue;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_bao_id")
    private NguoiDung nguoiBao;

    @Column(nullable = false)
    private String tieuDe;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String moTa;

    @Convert(converter = LoaiSuCoConverter.class)
    @Column(nullable = false)
    private LoaiSuCo loaiSuCo = LoaiSuCo.KHAC;

    @Convert(converter = UuTienConverter.class)
    @Column(nullable = false)
    private UuTien uuTien = UuTien.TRUNG_BINH;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiSuCo trangThai = TrangThaiSuCo.PENDING;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_phu_trach_id")
    private NguoiDung nguoiPhuTrach;

    @Column(nullable = false)
    private BigDecimal chiPhiSuaChua = BigDecimal.ZERO;

    @Column(nullable = false)
    private Boolean tinhVaoHoaDon = false;

    @Column(columnDefinition = "TEXT")
    private String ghiChuChuNha;

    private ZonedDateTime giaiQuyetLuc;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
