package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "email_verification_token")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmailVerificationToken {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true, length = 255)
    private String token;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", nullable = false)
    private NguoiDung nguoiDung;

    @Column(name = "het_han_luc", nullable = false)
    private ZonedDateTime hetHanLuc;

    @Column(nullable = false)
    @Builder.Default
    private boolean used = false;

    @CreationTimestamp
    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;
}
