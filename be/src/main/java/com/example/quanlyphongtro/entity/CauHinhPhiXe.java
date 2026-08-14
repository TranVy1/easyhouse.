package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "cau_hinh_phi_xe")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class CauHinhPhiXe {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "nha_tro_id", nullable = false)
    private NhaTro nhaTro;
    @Column(name = "loai_xe", nullable = false, length = 100)
    private String loaiXe;
    @Column(nullable = false)
    private BigDecimal donGia;
    @Column(nullable = false)
    private LocalDate hieuLucTu;
    private LocalDate hieuLucDen;
    @Column(nullable = false) @Builder.Default
    private Boolean dangApDung = true;
    private String ghiChu;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
}
