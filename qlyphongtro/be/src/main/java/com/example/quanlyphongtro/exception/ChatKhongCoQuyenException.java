package com.example.quanlyphongtro.exception;

/**
 * 403 — khong phai thanh vien dang hoat dong, hoac hoi thoai bi khoa.
 *
 * Client dung status nay de dung han viec goi lai / dung ket noi lai WebSocket,
 * thay vi coi nhu loi mang roi retry vo han.
 */
public class ChatKhongCoQuyenException extends RuntimeException {
    public ChatKhongCoQuyenException(String message) {
        super(message);
    }
}
