package com.example.quanlyphongtro.dto;

import lombok.Data;

@Data
public class CloneToaNhaRequest {
    private String tenToaNha;
    private NhaTroRequest.DiaChiRequest diaChi;
    private String moTa;
    private Boolean cloneTienNghiChung = true;
    private Boolean cloneNoiQuy = true;
}
