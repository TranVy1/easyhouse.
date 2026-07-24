package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.TrangThaiDatCoc;
import lombok.Data;

@Data
public class CancelDatCocRequest {
    private TrangThaiDatCoc trangThai;
    private String lyDoHuy;
}
