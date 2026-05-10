package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;
import java.util.List;

@Entity
@Table(name = "hop_dong")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HopDong {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "ma_hop_dong", nullable = false, unique = true, length = 100)
    private String maHopDong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id", nullable = false)
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dai_dien_id", nullable = false)
    private KhachThue nguoiDaiDien;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "khach_thue_ids", columnDefinition = "jsonb")
    private List<UUID> khachThueIds;

    @Column(name = "ngay_bat_dau", nullable = false)
    private LocalDate ngayBatDau;

    @Column(name = "ngay_ket_thuc")
    private LocalDate ngayKetThuc;

    @Column(name = "gia_thue", nullable = false, precision = 15, scale = 2)
    private BigDecimal giaThue;

    @Column(name = "tien_coc", nullable = false, precision = 15, scale = 2)
    private BigDecimal tienCoc;

    @Column(name = "chu_ky_thanh_toan", length = 50)
    private String chuKyThanhToan;

    @Column(name = "ngay_thanh_toan")
    private Integer ngayThanhToan;

    @Column(name = "dieu_khoan", columnDefinition = "TEXT")
    private String dieuKhoan;

    @Column(name = "gia_dien", precision = 10, scale = 2)
    private BigDecimal giaDien;

    @Column(name = "gia_nuoc", precision = 10, scale = 2)
    private BigDecimal giaNuoc;

    @Column(name = "chi_so_dien_ban_dau")
    private Integer chiSoDienBanDau;

    @Column(name = "chi_so_nuoc_ban_dau")
    private Integer chiSoNuocBanDau;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "phi_dich_vu", columnDefinition = "jsonb")
    private String phiDichVu; // JSON Array of PhiDichVu

    @Column(name = "trang_thai", length = 50)
    private String trangThai; // hoatDong, hetHan, daHuy

    @Column(name = "file_hop_dong", length = 255)
    private String fileHopDong;

    @CreationTimestamp
    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;

    @UpdateTimestamp
    @Column(name = "cap_nhat_luc")
    private ZonedDateTime capNhatLuc;

    @Column(name = "xoa_luc")
    private ZonedDateTime xoaLuc;
}
