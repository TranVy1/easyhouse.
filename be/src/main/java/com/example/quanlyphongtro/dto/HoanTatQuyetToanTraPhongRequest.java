package com.example.quanlyphongtro.dto;

import lombok.Data;

@Data
public class HoanTatQuyetToanTraPhongRequest {
    private Boolean daHoanCoc;
    private Boolean banGiaoDaXacNhan;
    private Boolean veSinhKiemTraXong;
    private String ghiChu;
}
