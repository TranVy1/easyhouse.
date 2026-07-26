package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "thong_bao")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ThongBao {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_gui_id")
    private NguoiDung nguoiGui;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoaiThongBao loai = LoaiThongBao.SYSTEM;

    @Column(nullable = false)
    private String tieuDe;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String noiDung;

    @Enumerated(EnumType.STRING)
    private LoaiDoiTuongMedia doiTuong;

    @Column(name = "doi_tuong_id")
    private UUID doiTuongId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private KenhThongBao kenh = KenhThongBao.IN_APP;

    @Column(nullable = false)
    private Boolean guiTatCa = false;

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;
}
