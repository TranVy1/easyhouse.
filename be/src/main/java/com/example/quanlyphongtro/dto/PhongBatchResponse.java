package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class PhongBatchResponse {
    private int totalRequested;
    private int totalCreated;
    private int totalSkipped;
    private List<String> createdRooms;
    private List<String> skippedRooms;
    private String reason; // e.g. "đã tồn tại"
}
