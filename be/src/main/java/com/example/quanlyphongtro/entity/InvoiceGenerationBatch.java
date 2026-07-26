package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "invoice_generation_batch")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceGenerationBatch {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nha_tro_id")
    private NhaTro nhaTro;

    @Column(nullable = false)
    private Integer kyThang;

    @Column(nullable = false)
    private Integer kyNam;

    @Column(nullable = false)
    private String trangThai;

    @Column(nullable = false)
    private Integer tongHopDong;

    @Column(nullable = false)
    private Integer taoThanhCong;

    @Column(nullable = false)
    private Integer boQua;

    @Column(nullable = false)
    private Integer loi;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_tao_id")
    private NguoiDung nguoiTao;

    @Column(updatable = false)
    private ZonedDateTime taoLuc;
}
