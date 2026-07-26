package com.example.quanlyphongtro.exception;

/** 400 — du lieu gui len khong dung (tin rong, tu nhan tin voi chinh minh...). */
public class ChatYeuCauKhongHopLeException extends RuntimeException {
    public ChatYeuCauKhongHopLeException(String message) {
        super(message);
    }
}
