package com.example.quanlyphongtro.services.push;

import com.example.quanlyphongtro.dto.DangKyPushRequest;
import com.example.quanlyphongtro.entity.DangKyPush;
import com.example.quanlyphongtro.entity.NenTangPush;
import com.example.quanlyphongtro.exception.ChatYeuCauKhongHopLeException;
import com.example.quanlyphongtro.repository.DangKyPushRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.services.PermissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class DangKyPushService {

    private final DangKyPushRepository dangKyPushRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final PermissionService permissionService;

    /**
     * Dang ky nhan thong bao day cho thiet bi hien tai.
     *
     * Endpoint la dinh danh duy nhat cua mot thiet bi/trinh duyet. Neu da ton tai
     * thi CAP NHAT chu khong tao ban ghi thu hai — nguoi dung dang nhap lai tren
     * cung may la chuyen thuong xuyen, va rang buoc UNIQUE se chan neu chen moi.
     *
     * Truong hop dang chu y: may dung chung. Nguoi B dang ky tren may cua nguoi A
     * thi endpoint do phai chuyen sang B, neu khong B se nhan tin cua A.
     */
    @Transactional
    public void dangKy(DangKyPushRequest request) {
        UUID toi = permissionService.requireCurrentUserId();
        NenTangPush nenTang = phanTichNenTang(request.getNenTang());

        if (nenTang == NenTangPush.WEB
                && (isBlank(request.getKhoaP256dh()) || isBlank(request.getKhoaAuth()))) {
            throw new ChatYeuCauKhongHopLeException(
                    "Web Push can ca khoa p256dh va auth de ma hoa noi dung");
        }

        DangKyPush dangKy = dangKyPushRepository.findByEndpoint(request.getEndpoint())
                .orElseGet(DangKyPush::new);

        dangKy.setNguoiDung(nguoiDungRepository.getReferenceById(toi));
        dangKy.setNenTang(nenTang);
        dangKy.setEndpoint(request.getEndpoint());
        dangKy.setKhoaP256dh(request.getKhoaP256dh());
        dangKy.setKhoaAuth(request.getKhoaAuth());
        dangKy.setMoTaThietBi(request.getMoTaThietBi());
        dangKy.setDungLuc(null); // dang ky lai thi kich hoat lai
        if (dangKy.getTaoLuc() == null) dangKy.setTaoLuc(ZonedDateTime.now());

        dangKyPushRepository.save(dangKy);
    }

    /** Huy dang ky — goi khi nguoi dung tat thong bao hoac dang xuat. */
    @Transactional
    public void huyDangKy(String endpoint) {
        UUID toi = permissionService.requireCurrentUserId();
        dangKyPushRepository.findByEndpoint(endpoint)
                .filter(d -> d.getNguoiDung() != null && d.getNguoiDung().getId().equals(toi))
                .ifPresent(d -> {
                    d.setDungLuc(ZonedDateTime.now());
                    dangKyPushRepository.save(d);
                });
    }

    private NenTangPush phanTichNenTang(String nenTang) {
        try {
            return NenTangPush.valueOf(nenTang.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new ChatYeuCauKhongHopLeException("Nen tang khong hop le: " + nenTang);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.isBlank();
    }
}
