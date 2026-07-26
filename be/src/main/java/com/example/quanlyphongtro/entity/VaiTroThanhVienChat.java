package com.example.quanlyphongtro.entity;

/**
 * Vai tro trong mot cuoc tro chuyen. Chi co y nghia voi nhom;
 * voi DIRECT/SUPPORT thi moi thanh vien deu la MEMBER.
 */
public enum VaiTroThanhVienChat {
    /** Nguoi tao nhom. */
    OWNER,
    /** Duoc quyen them/xoa thanh vien, doi ten, khoa nhom. */
    MODERATOR,
    MEMBER
}
