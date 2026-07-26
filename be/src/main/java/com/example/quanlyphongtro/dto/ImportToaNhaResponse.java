package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class ImportToaNhaResponse {
    private int tongDong;
    private int dongHopLe;
    private int dongLoi;
    private int toaNhaTaoMoi;
    private int tangTaoMoi;
    private int phongTaoMoi;
    private List<RowResult> rows;

    @Data
    @Builder
    public static class RowResult {
        private int dong;
        private boolean hopLe;
        private String tenToaNha;
        private Integer tang;
        private String maPhong;
        private String loi;
        private String hanhDong;
    }
}
