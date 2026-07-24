package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "bank_transaction")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BankTransaction {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id")
    private NhaTro nhaTro;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hoa_don_id")
    private HoaDon hoaDon;

    @Column(nullable = false)
    private BigDecimal soTien;

    private String noiDungChuyenKhoan;
    
    @Column(length = 150)
    private String maGiaoDich;
    
    @Column(length = 100)
    private String nganHang;

    @Column(nullable = false)
    private ZonedDateTime thoiGianGiaoDich;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private String payload;

    @Column(nullable = false)
    @Builder.Default
    private Boolean daDoiSoat = false;

    @Column(updatable = false)
    private ZonedDateTime taoLuc;
}
