package com.example.quanlyphongtro.entity;

import java.util.Arrays;

public enum LoaiSuCo {
    DIEN_NUOC("dien_nuoc"),
    NOI_THAT("noi_that"),
    VE_SINH("ve_sinh"),
    AN_NINH("an_ninh"),
    INTERNET("internet"),
    KHAC("khac");

    private final String dbValue;

    LoaiSuCo(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static LoaiSuCo fromDbValue(String value) {
        if (value == null || value.isBlank()) {
            return KHAC;
        }
        return Arrays.stream(values())
                .filter(item -> item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value))
                .findFirst()
                .orElse(KHAC);
    }
}
