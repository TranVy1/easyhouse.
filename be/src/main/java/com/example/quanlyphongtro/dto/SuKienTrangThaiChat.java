package com.example.quanlyphongtro.dto;

import java.util.UUID;

/**
 * Su kien trang thai day qua WebSocket, KHONG luu DB.
 *
 * @param loai             DANG_GO | DUNG_GO | DA_DOC
 * @param cuocTroChuyenId  hoi thoai lien quan
 * @param nguoiDungId      nguoi phat sinh su kien
 * @param denSeq           chi dung voi DA_DOC — da doc den so thu tu nay
 */
public record SuKienTrangThaiChat(String loai, UUID cuocTroChuyenId, UUID nguoiDungId, Long denSeq) {

    public static SuKienTrangThaiChat dangGo(UUID cuocTroChuyenId, UUID nguoiDungId, boolean dangGo) {
        return new SuKienTrangThaiChat(dangGo ? "DANG_GO" : "DUNG_GO", cuocTroChuyenId, nguoiDungId, null);
    }

    public static SuKienTrangThaiChat daDoc(UUID cuocTroChuyenId, UUID nguoiDungId, Long denSeq) {
        return new SuKienTrangThaiChat("DA_DOC", cuocTroChuyenId, nguoiDungId, denSeq);
    }
}
