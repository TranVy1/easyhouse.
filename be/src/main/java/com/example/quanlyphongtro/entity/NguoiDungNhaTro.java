package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "nguoi_dung_nha_tro")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NguoiDungNhaTro {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", nullable = false)
    private NguoiDung nguoiDung;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id", nullable = false)
    private NhaTro nhaTro;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private VaiTroHeThong vaiTro;

    @Column(nullable = false)
    private Boolean coQuyenXem = true;

    @Column(nullable = false)
    private Boolean coQuyenSua = false;

    @Column(nullable = false)
    private Boolean coQuyenThuTien = false;

    private ZonedDateTime taoLuc;
}
