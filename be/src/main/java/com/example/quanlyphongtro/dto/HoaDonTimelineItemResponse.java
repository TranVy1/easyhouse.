package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class HoaDonTimelineItemResponse {
    private UUID id;
    private String hanhDong;
    private String nguoiThucHien;
    private String duLieuCu;
    private String duLieuMoi;
    private ZonedDateTime thoiDiem;
}
