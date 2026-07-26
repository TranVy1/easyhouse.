package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * Chi tiet mot tin nhan: ai da xem, ai chua.
 *
 * Tra ca hai danh sach thay vi chi tra "da xem": trong nhom, biet ai CHUA doc moi
 * la thong tin nguoi dung can (nhac ai, cho ai).
 */
@Data
@Builder
public class ChiTietTinNhanResponse {

    private TinNhanResponse tinNhan;

    private List<NguoiXemTinResponse> daXem;
    private List<NguoiXemTinResponse> chuaXem;
}
