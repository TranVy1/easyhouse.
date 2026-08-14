package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;
import lombok.*;

@Entity
@Table(name = "lich_su_phuong_tien")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LichSuPhuongTien {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "phuong_tien_id", nullable = false) private PhuongTien phuongTien;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "khach_thue_id", nullable = false) private KhachThue khachThue;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "phong_id", nullable = false) private Phong phong;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "nha_tro_id", nullable = false) private NhaTro nhaTro;
    @Column(name = "hieu_luc_tu", nullable = false) private LocalDate hieuLucTu;
    @Column(name = "hieu_luc_den") private LocalDate hieuLucDen;
    @Column(name = "tao_luc", nullable = false, updatable = false) private ZonedDateTime taoLuc;
    @PrePersist void prePersist() { if (taoLuc == null) taoLuc = ZonedDateTime.now(); }
}
