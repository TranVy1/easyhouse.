package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceGenerationResultResponse {
    private UUID batchId;
    private Integer createdCount;
    private Integer skippedCount;
    private Integer errorCount;
    private List<GenerationLogDto> logs;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class GenerationLogDto {
        private UUID hopDongId;
        private String maPhong;
        private String status;
        private String reason;
    }
}
