package com.example.quanlyphongtro.entity;

/**
 * Loai doi tuong ma mot tep media thuoc ve.
 *
 * Cot file_media.doi_tuong la varchar KHONG co rang buoc CHECK (da kiem tra bang
 * pg_constraint), nen them gia tri moi vao day khong can migration DB.
 */
public enum LoaiDoiTuongMedia {
    USER, TENANT, ROOM, CONTRACT, INVOICE, PAYMENT, INCIDENT, METER_READING, APPOINTMENT,
    /** Tep gui kem trong tin nhan. doiTuongId la id cuoc tro chuyen. */
    MESSAGE,
    OTHER
}