package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Mot truong bat buoc con thieu de hop dong du dieu kien ky.
 *
 * Tra ve co cau truc (thay vi chuoi mo ta) de giao dien dung duoc ma truong ma
 * dung san form bo sung ngay tai cho, admin khong phai vao DB them tay.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ThieuThongTinResponse {

    /** Ma truong, vi du BEN_B_NGAY_SINH. Giao dien dua vao day de dung o nhap. */
    private String ma;

    /** Nhan hien thi cho nguoi dung, vi du "Ngày sinh". */
    private String nhan;

    /** BEN_A, BEN_B hoac HOP_DONG. */
    private String ben;

    /** true khi co the bo sung ngay tren dialog ky; false thi phai sua o form hop dong. */
    private boolean suaTaiCho;
}
