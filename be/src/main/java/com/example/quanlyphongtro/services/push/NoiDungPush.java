package com.example.quanlyphongtro.services.push;

import java.util.UUID;

/**
 * Noi dung mot thong bao day, doc lap voi nen tang.
 *
 * @param tieuDe    ten nguoi gui hoac ten nhom
 * @param noiDung   trich ngan cua tin nhan
 * @param duongDan  duong dan mo khi bam vao thong bao
 * @param hoiThoaiId de client gom cac thong bao cung hoi thoai lam mot
 */
public record NoiDungPush(String tieuDe, String noiDung, String duongDan, UUID hoiThoaiId) {
}
