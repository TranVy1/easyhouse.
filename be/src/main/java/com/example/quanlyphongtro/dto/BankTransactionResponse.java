package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.BankTransaction;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class BankTransactionResponse {
    @JsonProperty("_id")
    private UUID id;
    private UUID nhaTroId;
    private UUID hoaDonId;
    private BigDecimal soTien;
    private String noiDungChuyenKhoan;
    private String maGiaoDich;
    private String nganHang;
    private ZonedDateTime thoiGianGiaoDich;
    private String payload;
    private Boolean daDoiSoat;
    private ZonedDateTime taoLuc;

    public static BankTransactionResponse fromEntity(BankTransaction transaction) {
        if (transaction == null) return null;
        return BankTransactionResponse.builder()
                .id(transaction.getId())
                .nhaTroId(transaction.getNhaTro() != null ? transaction.getNhaTro().getId() : null)
                .hoaDonId(transaction.getHoaDon() != null ? transaction.getHoaDon().getId() : null)
                .soTien(transaction.getSoTien())
                .noiDungChuyenKhoan(transaction.getNoiDungChuyenKhoan())
                .maGiaoDich(transaction.getMaGiaoDich())
                .nganHang(transaction.getNganHang())
                .thoiGianGiaoDich(transaction.getThoiGianGiaoDich())
                .payload(transaction.getPayload())
                .daDoiSoat(transaction.getDaDoiSoat())
                .taoLuc(transaction.getTaoLuc())
                .build();
    }
}
