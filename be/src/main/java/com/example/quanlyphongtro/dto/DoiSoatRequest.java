package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.util.UUID;

@Data
public class DoiSoatRequest {
    private UUID transactionId;
    private UUID hoaDonId;
}
