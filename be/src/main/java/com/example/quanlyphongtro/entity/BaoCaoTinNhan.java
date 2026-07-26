package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

/**
 * Mot bao cao ve tin nhan vi pham.
 *
 * Tro toi TIN NHAN chu khong sao chep noi dung: sao chep thi khi nguoi gui thu
 * hoi, ban sao van nam lai — vua sai voi y dinh thu hoi, vua tao them mot noi luu
 * du lieu nhay cam can bao ve.
 */
@Entity
@Table(name = "bao_cao_tin_nhan",
        uniqueConstraints = @UniqueConstraint(
                name = "uq_bao_cao_tin_nhan",
                columnNames = {"tin_nhan_id", "nguoi_bao_cao_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BaoCaoTinNhan {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tin_nhan_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private TinNhan tinNhan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cuoc_tro_chuyen_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private CuocTroChuyen cuocTroChuyen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_bao_cao_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiBaoCao;

    @Column(nullable = false, columnDefinition = "text")
    private String lyDo;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private TrangThaiBaoCao trangThai = TrangThaiBaoCao.PENDING;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_xu_ly_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiXuLy;

    @Column(columnDefinition = "text")
    private String ghiChuXuLy;

    private ZonedDateTime xuLyLuc;

    @Column(nullable = false)
    @Builder.Default
    private ZonedDateTime taoLuc = ZonedDateTime.now();
}
