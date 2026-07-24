package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class ImportToaNhaRequest {
    private List<Row> rows;

    @Data
    public static class Row {
        private String tenToaNha;
        private String diaChi;
        private Integer tang;
        private String maPhong;
        private BigDecimal dienTich;
        private BigDecimal giaThue;
        private BigDecimal tienCoc;
        private Integer soNguoiToiDa;
    }
}
