package com.example.quanlyphongtro.entity;

public enum NenTangPush {
    /** Trinh duyet, dung Web Push (RFC 8291). */
    WEB,
    /** Ung dung Expo/Android, dung FCM. */
    ANDROID,
    /** Ung dung Expo/iOS, dung FCM hoac APNs. */
    IOS
}
