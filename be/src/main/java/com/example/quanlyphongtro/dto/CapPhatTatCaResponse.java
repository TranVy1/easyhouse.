package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CapPhatTatCaResponse {
    private boolean success;
    private UUID assetId;
    private String assetName;
    private int allocatedQuantity;
    private int remainingStock;
    private int roomsAllocated;
    private int roomsRemaining;
    private List<Detail> details;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Detail {
        private String room;
        private int quantity;
    }
}
