package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "file_media")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FileMedia {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoaiDoiTuongMedia doiTuong;

    @Column(nullable = false)
    private UUID doiTuongId;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String url;

    private String publicId;
    private String loaiFile;
    private Long kichThuocBytes;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private String metadata;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_tai_len_id")
    private NguoiDung nguoiTaiLen;

    private ZonedDateTime taoLuc;
}
