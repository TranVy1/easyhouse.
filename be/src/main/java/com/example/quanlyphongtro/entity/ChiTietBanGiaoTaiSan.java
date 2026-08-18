package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "chi_tiet_ban_giao_tai_san")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChiTietBanGiaoTaiSan {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quyet_toan_tra_phong_id", nullable = false)
    private QuyetToanTraPhong quyetToanTraPhong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tai_san_phong_id")
    private TaiSanPhong taiSanPhong;

    @Column(nullable = false) private String tenTaiSan;
    @Column(nullable = false) private Integer soLuongBanDau;
    @Column(nullable = false) private String tinhTrangBanDau;
    private String anhTaiSanBanDau;
    private Integer soLuongThucTe;
    private String tinhTrangThucTe;
    private String chungTuUrl;
    private String ghiChu;
    private Boolean daXacNhan = false;
    private ZonedDateTime xacNhanLuc;

    /**
     * Muc tien de xuat khau tru cho tai san nay khi tra phong (hu hong, mat mat,
     * khau hao vuot muc). Tach thanh cot rieng thay vi nhet vao ghiChu de con
     * cong tong duoc bang SQL va doi chieu voi khoan_khau_tru cua quyet toan.
     */
    @Column(name = "muc_khau_tru", nullable = false)
    private java.math.BigDecimal mucKhauTru = java.math.BigDecimal.ZERO;

    private String lyDoKhauTru;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
