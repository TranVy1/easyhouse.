package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ActionItemResponse {
    private String type; // OVERDUE_INVOICE, UPCOMING_INVOICE, EXPIRING_CONTRACT, OPEN_INCIDENT
    private String priority; // HIGH, MEDIUM, LOW
    private String title;
    private String description;
    private BigDecimal amount;
    private ZonedDateTime dueDate;
    private String href;
    private UUID entityId;
}
