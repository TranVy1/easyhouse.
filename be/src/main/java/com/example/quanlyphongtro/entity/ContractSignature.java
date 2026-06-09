package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "contract_signature")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContractSignature {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id", nullable = false)
    private HopDong hopDong;

    @Column(name = "signer_id")
    private UUID signerId;

    @Column(name = "signer_role", nullable = false)
    private String signerRole; // 'LANDLORD', 'TENANT'

    @Column(name = "signature_image_url")
    private String signatureImageUrl;

    @Column(name = "signed_at", nullable = false)
    @Builder.Default
    private ZonedDateTime signedAt = ZonedDateTime.now();

    @Column(name = "ip_address")
    private String ipAddress;

    @Column(name = "user_agent")
    private String userAgent;
}
