package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "su_co")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SuCo {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id")
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id")
    private KhachThue khachThue;

    @Column(name = "tieu_de", nullable = false, length = 255)
    private String tieuDe;

    @Column(name = "mo_ta", nullable = false, columnDefinition = "TEXT")
    private String moTa;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(name = "loai_su_co")
    private LoaiSuCo loaiSuCo = LoaiSuCo.khac;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(name = "uu_tien")
    private UuTien uuTien = UuTien.trung_binh;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai")
    private TrangThaiSuCo trangThai = TrangThaiSuCo.PENDING;

    @Column(name = "nguoi_phu_trach")
    private UUID nguoiPhuTrach;

    @Column(name = "chi_phi_sua_chua", precision = 15, scale = 2)
    private BigDecimal chiPhiSuaChua;

    @Builder.Default
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "anh_su_co", columnDefinition = "jsonb")
    private List<String> anhSuCo = new ArrayList<>();

    @Column(name = "ghi_chu_chu_nha", columnDefinition = "TEXT")
    private String ghiChuChuNha;

    @Column(name = "giai_quyet_luc")
    private ZonedDateTime giaiQuyetLuc;

    @CreationTimestamp
    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;

    @UpdateTimestamp
    @Column(name = "cap_nhat_luc")
    private ZonedDateTime capNhatLuc;
}
