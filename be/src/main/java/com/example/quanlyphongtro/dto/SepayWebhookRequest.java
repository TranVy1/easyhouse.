package com.example.quanlyphongtro.dto;

import lombok.Data;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class SepayWebhookRequest {
    private Long id;
    private String gateway;
    private String transactionDate;
    private String accountNumber;
    private String subAccount;
    private java.math.BigDecimal amountIn;
    private java.math.BigDecimal amountOut;
    private java.math.BigDecimal accumulated;
    private String code;
    private String transactionContent;
    private String referenceNumber;
    private String body;
    private String description;
}
