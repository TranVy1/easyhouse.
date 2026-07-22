package com.example.quanlyphongtro.services.push;

import com.example.quanlyphongtro.entity.DangKyPush;
import com.example.quanlyphongtro.entity.NenTangPush;

/**
 * Duong chuyen thong bao day toi mot nen tang cu the.
 *
 * Tach interface de luat quyet dinh "co gui khong" (PushService) khong dinh gi toi
 * chi tiet cua Web Push hay FCM. Them nen tang moi chi can them mot lop, khong
 * phai sua logic nghiep vu.
 */
public interface KenhGuiPush {

    boolean hoTro(NenTangPush nenTang);

    /**
     * Gui mot thong bao.
     *
     * @return true neu dang ky nay van dung duoc; false neu nha cung cap bao la
     *         endpoint da chet (404/410) — luc do PushService se danh dau ngung dung.
     */
    boolean gui(DangKyPush dangKy, NoiDungPush noiDung);
}
