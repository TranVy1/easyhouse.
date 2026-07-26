package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "dich_vu")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DichVu {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chu_tro_id")
    private NguoiDung chuTro;

    @Column(name = "ten_dich_vu", nullable = false)
    private String tenDichVu;

    @Enumerated(EnumType.STRING)
    @Column(name = "loai_tinh_phi", nullable = false)
    private LoaiTinhPhi loaiTinhPhi = LoaiTinhPhi.FIXED;

    private String donVi;

    @Column(name = "don_gia_mac_dinh", nullable = false)
    private java.math.BigDecimal donGiaMacDinh = java.math.BigDecimal.ZERO;

    @Column(nullable = false)
    private Boolean batBuoc = false;

    @Column(name = "tao_luc")
    private ZonedDateTime taoLuc;
    @Column(name = "cap_nhat_luc")
    private ZonedDateTime capNhatLuc;
}
