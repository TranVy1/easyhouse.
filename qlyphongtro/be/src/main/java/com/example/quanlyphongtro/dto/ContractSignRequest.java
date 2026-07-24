package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContractSignRequest {
    private String signatureBase64;
    private String ipAddress;
    private String userAgent;
    private String rejectionReason;
    private String role; // LANDLORD or TENANT
    private java.util.UUID signerId;
}
