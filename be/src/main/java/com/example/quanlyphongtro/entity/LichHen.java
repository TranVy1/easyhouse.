package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "lich_hen")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LichHen {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "phong_id", nullable = false)
    private Phong phong;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id")
    private NguoiDung nguoiDung;

    private String hoTen;
    private String soDienThoai;
    private String email;
    private String soCccd;

    @Column(nullable = false)
    private ZonedDateTime ngayHen;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiLichHen trangThai = TrangThaiLichHen.PENDING;

    private String googleCalendarEventId;

    @Column(nullable = false)
    private Boolean daGuiNhacNho = false;

    private String ghiChu;
    private String ghiChuAdmin;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
