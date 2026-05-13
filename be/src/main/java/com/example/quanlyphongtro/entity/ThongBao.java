package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "thong_bao")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ThongBao {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id")
    private NguoiDung nguoiDung;

    @Column(name = "tieu_de", nullable = false, length = 255)
    private String tieuDe;

    @Column(name = "noi_dung", nullable = false, columnDefinition = "TEXT")
    private String noiDung;

    @Column(name = "loai", length = 50)
    private String loai;

    @Column(name = "toa_nha_id")
    private UUID toaNhaId;

    @Builder.Default
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "phong_ids", columnDefinition = "jsonb")
    private List<UUID> phongIds = new ArrayList<>();

    @Builder.Default
    @Column(name = "da_doc")
    private Boolean daDoc = false;

    @CreationTimestamp
    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;
}
