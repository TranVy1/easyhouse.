package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "quyet_toan_tra_phong")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuyetToanTraPhong {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id", nullable = false, unique = true)
    private HopDong hopDong;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hoa_don_id", nullable = false, unique = true)
    private HoaDon hoaDon;

    @Column(nullable = false)
    private LocalDate ngayTraPhong;

    @Column(nullable = false)
    private BigDecimal tienCocBanDau = BigDecimal.ZERO;

    @Column(nullable = false)
    private BigDecimal tienCocDaCanTru = BigDecimal.ZERO;

    @Column(nullable = false)
    private BigDecimal tienCocCanHoan = BigDecimal.ZERO;

    @Column(nullable = false)
    private BigDecimal tienPhaiThuThem = BigDecimal.ZERO;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "khoan_khau_tru", columnDefinition = "jsonb", nullable = false)
    private String khoanKhauTru = "[]";

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiQuyetToanTraPhong trangThai = TrangThaiQuyetToanTraPhong.PENDING_PAYMENT;

    private Boolean banGiaoDaXacNhan = false;
    private Boolean veSinhKiemTraXong = false;
    private ZonedDateTime hoanCocLuc;
    private ZonedDateTime banGiaoLuc;
    private ZonedDateTime kiemTraLuc;
    private ZonedDateTime hoanTatLuc;
    private String ghiChu;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
