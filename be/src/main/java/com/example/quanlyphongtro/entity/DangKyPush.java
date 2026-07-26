package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

/**
 * Mot thiet bi/trinh duyet dang ky nhan thong bao day.
 *
 * Dung chung cho ca Web Push va FCM: luat quyet dinh "co gui push khong" giong
 * nhau, chi khac cach chuyen di.
 */
@Entity
@Table(name = "dang_ky_push")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DangKyPush {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiDung;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private NenTangPush nenTang;

    /** Web Push: endpoint URL. FCM: registration token. */
    @Column(nullable = false, unique = true, columnDefinition = "text")
    private String endpoint;

    /** Chi Web Push dung — khoa ma hoa payload theo RFC 8291. */
    @Column(name = "khoa_p256dh", columnDefinition = "text")
    private String khoaP256dh;

    @Column(name = "khoa_auth", columnDefinition = "text")
    private String khoaAuth;

    @Column(columnDefinition = "text")
    private String moTaThietBi;

    @Column(nullable = false)
    @Builder.Default
    private ZonedDateTime taoLuc = ZonedDateTime.now();

    /**
     * Danh dau ngung dung thay vi xoa: khi nha cung cap tra ve 404/410 (nguoi dung
     * da go app hoac xoa quyen), ta ngung gui nhung van giu lai de doi chieu.
     */
    private ZonedDateTime dungLuc;
}
