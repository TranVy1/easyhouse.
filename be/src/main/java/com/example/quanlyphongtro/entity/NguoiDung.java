package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "nguoi_dung")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NguoiDung {
    @Id
    private UUID id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String hoTen;

    @Column(unique = true)
    private String soDienThoai;

    private String anhDaiDien;
    private LocalDate ngaySinh;
    private String gioiTinh;
    private String diaChi;
    private String queQuan;

    @Column(unique = true)
    private String soCccd;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiNguoiDung trangThai = TrangThaiNguoiDung.ACTIVE;

    @Column(nullable = false)
    private Integer soLanDangNhapSai = 0;

    private ZonedDateTime khoaDenLuc;
    private ZonedDateTime lanDangNhapCuoi;
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "cau_hinh_2fa", columnDefinition = "jsonb")
    private String cauHinh2fa;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;
}
