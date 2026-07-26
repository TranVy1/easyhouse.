package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "dat_coc_phong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DatCocPhong {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id", nullable = false)
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id", nullable = false)
    private KhachThue khachThue;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id")
    private HopDong hopDong;

    @Column(nullable = false)
    private BigDecimal soTienCoc;

    @Column(nullable = false)
    private ZonedDateTime ngayDatCoc;

    private LocalDate ngayDuKienVao;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiDatCoc trangThai = TrangThaiDatCoc.PENDING;

    private String ghiChu;
    
    private String lyDoHuy;
    private ZonedDateTime confirmedAt;
    private ZonedDateTime cancelledAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_xac_nhan_id")
    private NguoiDung nguoiXacNhan;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
