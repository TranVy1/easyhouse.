package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
public class LichHenRequest {
    private UUID phongId;
    private String hoTen;
    private String soDienThoai;
    private String email;
    private ZonedDateTime ngayHen;
    private String ghiChu;
    private String honeypot;
    private String trangThai; // PENDING, CONFIRMED, CANCELLED, COMPLETED, NO_SHOW
}
