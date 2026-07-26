package com.example.quanlyphongtro.exception;

/** 404 — hoi thoai / tin nhan khong ton tai hoac da bi xoa. */
public class ChatKhongTimThayException extends RuntimeException {
    public ChatKhongTimThayException(String message) {
        super(message);
    }
}
