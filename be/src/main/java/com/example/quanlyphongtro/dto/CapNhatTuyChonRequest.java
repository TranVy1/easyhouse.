package com.example.quanlyphongtro.dto;

import lombok.Data;

/**
 * Tuy chon RIENG cua tung nguoi tren mot hoi thoai.
 * Truong nao bo trong thi giu nguyen gia tri cu.
 */
@Data
public class CapNhatTuyChonRequest {

    /** Ghim len dau danh sach. */
    private Boolean ghim;

    /**
     * Tat thong bao VO THOI HAN.
     * Gui false = bat lai thong bao (xoa luon ca han neu dang co).
     */
    private Boolean tatThongBao;

    /**
     * Tat thong bao trong bao nhieu PHUT ke tu bay gio.
     * Vd: 15, 60, 480, 1440. Gui kem thi bo qua truong tatThongBao.
     */
    private Integer tatThongBaoPhut;

    /**
     * Luu tru: an khoi danh sach nhung giu lich su, co tin moi thi hien lai.
     * Bat luu tru se tu bo ghim — hai thu nay mau thuan nhau.
     */
    private Boolean luuTru;
}
