package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

/** Mot nguoi trong danh sach "da xem" / "chua xem" cua chi tiet tin nhan. */
@Data
@Builder
public class NguoiXemTinResponse {

    @JsonProperty("_id")
    private UUID nguoiDungId;

    /** Uu tien biet danh trong hoi thoai, khong co thi lay ho ten that. */
    private String hoTen;
    private String anhDaiDien;

    /**
     * Thoi diem doc. Day la moc "doc den dau" cua ca hoi thoai chu khong phai moc
     * rieng cho tin nay — chinh xac toi tung tin se can mot bang luot xem rieng,
     * phinh rat nhanh ma gia tri them khong dang.
     */
    private ZonedDateTime xemLuc;
}
