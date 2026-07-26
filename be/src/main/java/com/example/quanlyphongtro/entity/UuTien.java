package com.example.quanlyphongtro.entity;

import java.util.Arrays;

public enum UuTien {
    THAP("thap"),
    TRUNG_BINH("trung_binh"),
    CAO("cao"),
    KHAN_CAP("khan_cap");

    private final String dbValue;

    UuTien(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static UuTien fromDbValue(String value) {
        if (value == null || value.isBlank()) {
            return TRUNG_BINH;
        }
        return Arrays.stream(values())
                .filter(item -> item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value))
                .findFirst()
                .orElse(TRUNG_BINH);
    }
}
