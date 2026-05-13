package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
public class ThongBaoRequest {

    @NotBlank(message = "Tieu de khong duoc de trong")
    private String tieuDe;

    @NotBlank(message = "Noi dung khong duoc de trong")
    private String noiDung;

    private String loai = "chung";
    private UUID nguoiGui;
    private List<UUID> nguoiNhan = new ArrayList<>();
    private List<UUID> phong = new ArrayList<>();
    private UUID toaNha;
}
