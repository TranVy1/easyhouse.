package com.example.quanlyphongtro.entity;

public enum TrangThaiBaoCao {
    /** Moi bao cao, chua ai xem. */
    PENDING,
    /** Da xem va ket luan la khong vi pham. */
    DISMISSED,
    /** Da xem va da xu ly (thu hoi tin, khoa hoi thoai...). */
    ACTIONED,
    /** Da xem nhung chua quyet dinh. */
    REVIEWED
}
