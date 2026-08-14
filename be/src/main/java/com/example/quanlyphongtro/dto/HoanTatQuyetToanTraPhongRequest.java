package com.example.quanlyphongtro.dto;

import lombok.Data;

@Data
public class HoanTatQuyetToanTraPhongRequest {
    private Boolean daHoanCoc;
    private String chungTuHoanCoc;
    private String maThamChieuHoanCoc;
    private Boolean banGiaoDaXacNhan;
    private Boolean veSinhKiemTraXong;
    private String ghiChu;
}
