package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceGenerationPreviewRequest {
    private UUID nhaTroId;
    private Integer kyThang;
    private Integer kyNam;
    private Boolean requireConfirmedReadings;
}
