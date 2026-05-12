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

    @Column(name = "ma_hop_dong", unique = true, length = 100)
    private String maHopDong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id")
    private Phong phong;

    // Người đại diện ký hợp đồng (FK chính)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id")
    private KhachThue nguoiDaiDien;

    // Danh sách tất cả khách thuê (JSON array of UUIDs)
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "khach_thue_ids", columnDefinition = "jsonb")
    private List<UUID> khachThueIds;

    @Column(name = "ngay_bat_dau", nullable = false)
    private LocalDate ngayBatDau;

    @Column(name = "ngay_ket_thuc")
    private LocalDate ngayKetThuc;

    @Column(name = "gia_thue_hop_dong", precision = 15, scale = 2)
    private BigDecimal giaThue;

    @Column(name = "tien_coc", precision = 15, scale = 2)
    private BigDecimal tienCoc;

    @Column(name = "chu_ky_thanh_toan", length = 50)
    private String chuKyThanhToan;

    @Column(name = "ngay_thanh_toan")
    private Integer ngayThanhToan;

    // Điều khoản hợp đồng (mapping noi_dung_hop_dong hoặc dieu_khoan)
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
    private String phiDichVu;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai")
    private TrangThaiHopDong trangThai;

    @Column(name = "file_hop_dong")
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
