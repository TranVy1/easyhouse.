package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Data
public class PhongRequest {
    
    @NotBlank(message = "Mã phòng không được để trống")
    private String maPhong;
    
    @NotNull(message = "Vui lòng chọn tòa nhà")
    private UUID toaNha;
    
    private Integer tang;
    
    @NotNull(message = "Diện tích không được để trống")
    private BigDecimal dienTich;
    
    @NotNull(message = "Giá thuê không được để trống")
    private BigDecimal giaThue;
    
    private BigDecimal tienCoc;
    
    private Integer soNguoiToiDa;
    
    private String trangThai;
    
    private String moTa;
    
    // Bỏ qua map anhPhong và tienNghi lúc này vì DB dùng bảng phụ
    private List<String> anhPhong;
    private List<String> tienNghi;
}
