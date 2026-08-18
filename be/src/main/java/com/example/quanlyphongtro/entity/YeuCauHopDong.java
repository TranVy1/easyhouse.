package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

/**
 * Yeu cau huy hoac gia han hop dong do khach thue gui, cho chu tro/admin duyet.
 *
 * Dung chung mot bang cho ca hai loai vi vong doi va cac cot duyet giong het
 * nhau; tach hai bang chi lam trung lap logic duyet.
 */
@Entity
@Table(name = "yeu_cau_hop_dong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class YeuCauHopDong {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id", nullable = false)
    private HopDong hopDong;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private LoaiYeuCauHopDong loai;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai", nullable = false, length = 20)
    @Builder.Default
    private TrangThaiYeuCauHopDong trangThai = TrangThaiYeuCauHopDong.CHO_DUYET;

    @Column(columnDefinition = "TEXT")
    private String lyDo;

    /** HUY: ngay mong muon tra phong. GIA_HAN: ngay ket thuc mong muon. */
    @Column(name = "ngay_mong_muon")
    private LocalDate ngayMongMuon;

    /** Chi dung cho GIA_HAN; voi HUY phai de null (CSDL co check constraint). */
    @Column(name = "so_thang_gia_han")
    private Integer soThangGiaHan;

    @Column(name = "nguoi_tao_id")
    private UUID nguoiTaoId;

    @Column(name = "nguoi_duyet_id")
    private UUID nguoiDuyetId;

    @Column(name = "ghi_chu_duyet", columnDefinition = "TEXT")
    private String ghiChuDuyet;

    @Column(name = "duyet_luc")
    private ZonedDateTime duyetLuc;

    @Column(name = "tao_luc", nullable = false)
    @Builder.Default
    private ZonedDateTime taoLuc = ZonedDateTime.now();

    @Column(name = "cap_nhat_luc", nullable = false)
    @Builder.Default
    private ZonedDateTime capNhatLuc = ZonedDateTime.now();

    @PreUpdate
    void onUpdate() {
        this.capNhatLuc = ZonedDateTime.now();
    }
}
