package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
public class ThemThanhVienRequest {

    @NotEmpty(message = "Phai chon it nhat mot nguoi")
    private List<UUID> nguoiDungIds;
}
