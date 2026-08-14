package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.util.List;
import java.util.UUID;

@Data
public class BanGiaoTaiSanRequest {
    private List<Item> items;

    @Data
    public static class Item {
        private UUID id;
        private Integer soLuongThucTe;
        private String tinhTrangThucTe;
        private String chungTuUrl;
        private String ghiChu;
        private Boolean daXacNhan;
    }
}
