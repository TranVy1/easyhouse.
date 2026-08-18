package com.example.quanlyphongtro.entity;

/**
 * Vong doi bien ban ban giao khi khach tra phong.
 *
 * Quyet toan tra phong chi duoc hoan tat (tru coc / hoan coc / thu them) khi
 * bien ban da o trang thai HOAN_TAT — tuc ca hai ben da ky. Day la can cu phap
 * ly cho viec tru tien coc va boi thuong khau hao tai san.
 */
public enum TrangThaiBienBanBanGiao {
    /** Chua kiem ke xong, chua sinh bien ban. */
    CHUA_LAP,
    /** Da sinh bien ban, dang cho hai ben ky. */
    CHO_KY,
    BEN_A_DA_KY,
    BEN_B_DA_KY,
    /** Ca hai ben da ky. */
    HOAN_TAT
}
