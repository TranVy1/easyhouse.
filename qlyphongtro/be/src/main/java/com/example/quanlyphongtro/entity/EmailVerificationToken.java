package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "email_verification_token")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmailVerificationToken {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", nullable = false)
    private NguoiDung nguoiDung;

    @Column(nullable = false, unique = true)
    private String token;

    @Column(nullable = false)
    private ZonedDateTime ngayHetHan;

    @Column(nullable = false)
    private ZonedDateTime taoLuc;

    @PrePersist
    void prePersist() {
        if (taoLuc == null) taoLuc = ZonedDateTime.now();
    }
}
