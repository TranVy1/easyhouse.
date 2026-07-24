package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContractSignatureResponse {
    private UUID id;
    private UUID signerId;
    private String signerName;
    private String signerRole;
    private String signatureImageUrl;
    private ZonedDateTime signedAt;
    private String ipAddress;
    private String userAgent;
}
