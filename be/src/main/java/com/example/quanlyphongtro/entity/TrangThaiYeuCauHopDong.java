package com.example.quanlyphongtro.entity;

/**
 * Vong doi cua mot yeu cau huy / gia han hop dong.
 *
 * Chi duoc phep MOT yeu cau CHO_DUYET tren mot hop dong tai mot thoi diem —
 * rang buoc nay do unique partial index uq_yeu_cau_hop_dong_cho_duyet bao dam
 * o tang CSDL, khong phu thuoc vao kiem tra phia ung dung.
 */
public enum TrangThaiYeuCauHopDong {
    CHO_DUYET,
    DA_DUYET,
    TU_CHOI,
    /** Khach thue tu rut lai yeu cau truoc khi admin xu ly. */
    DA_HUY_YEU_CAU
}
