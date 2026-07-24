package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "chi_so_dien_nuoc")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChiSoDienNuoc {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

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
    private Integer kyNam;

    @Column(nullable = false)
    private Integer kyThang;

    @Column(nullable = false)
    private LocalDate ngayGhi;

    @Column(nullable = false)
    private Integer chiSoCu;

    @Column(nullable = false)
    private Integer chiSoMoi;

    @Column(insertable = false, updatable = false)
    private Integer tieuThu;

    private String anhDongHo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_ghi_id")
    private NguoiDung nguoiGhi;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiChiSo trangThai = TrangThaiChiSo.DRAFT;

    private String ghiChu;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
