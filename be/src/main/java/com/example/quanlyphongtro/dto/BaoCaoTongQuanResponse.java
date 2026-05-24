package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
public class BaoCaoTongQuanResponse {
    private BigDecimal doanhThu; // Tổng tiền hóa đơn trong tháng
    private BigDecimal tienDaThu; // Tổng tiền đã thanh toán trong tháng
    private BigDecimal tienChuaThu; // Tiền còn nợ (doanhThu - tienDaThu)
    private Double tyLeLapDay; // % phòng đang thuê
    private long suCoCanXuLy; // Sự cố trạng thái mới/đang xử lý
    private long hopDongSapHetHan; // Hợp đồng sắp hết hạn trong 30 ngày tới

    private List<BieuDoDoanhThu> bieuDoDoanhThu; // Cho biểu đồ 6-12 tháng

    @Data
    @Builder
    public static class BieuDoDoanhThu {
        private String thang;
        private BigDecimal doanhThu;
        private BigDecimal daThu;
    }
}
