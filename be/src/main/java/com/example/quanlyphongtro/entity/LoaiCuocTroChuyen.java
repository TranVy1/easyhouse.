package com.example.quanlyphongtro.entity;

/**
 * Loai cuoc tro chuyen.
 *
 * Giai doan 1 chi dung DIRECT va SUPPORT. Ba loai con lai da co san trong enum
 * va trong DB de mo rong sang chat nhom ma khong phai sua schema.
 */
public enum LoaiCuocTroChuyen {
    /** Chat 1-1 giua hai nguoi bat ky trong cung pham vi. */
    DIRECT,
    /** Nhom tu tao: muon do, trao doi... */
    GROUP,
    /** Nhom tu dong theo nha tro. */
    BUILDING,
    /** Nhom tu dong theo tang. */
    FLOOR,
    /** Kenh bao viec cho chu nha / nhan vien quan ly. */
    SUPPORT;

    /**
     * Nhom nhieu nguoi thi moi co ten, anh dai dien va vai tro thanh vien.
     * DIRECT va SUPPORT lay ten hien thi tu doi phuong.
     */
    public boolean laNhom() {
        return this == GROUP || this == BUILDING || this == FLOOR;
    }
}
