package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "refresh_token")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RefreshToken {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", nullable = false)
    private NguoiDung nguoiDung;

    /**
     * SHA-256 digest of the refresh token. The raw token is returned once to
     * the client and must never be persisted in plaintext.
     */
    @Column(name = "token", nullable = false, unique = true)
    private String tokenHash;

    @Column(nullable = false)
    private ZonedDateTime ngayHetHan;

    @Column(nullable = false)
    private ZonedDateTime taoLuc;

    @PrePersist
    void prePersist() {
        if (taoLuc == null) taoLuc = ZonedDateTime.now();
    }
}
