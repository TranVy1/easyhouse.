package com.example.quanlyphongtro.services.push;

import com.example.quanlyphongtro.dto.TinNhanResponse;
import com.example.quanlyphongtro.entity.DangKyPush;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.repository.DangKyPushRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import com.example.quanlyphongtro.services.ChatPresenceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Quyet dinh AI can nhan thong bao day, va gui.
 *
 * Toan bo gia tri cua P5 nam o ba bo loc duoi day — gui push cho dung nguoi kho
 * hon nhieu so voi viec gui duoc push.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PushService {

    private static final int DO_DAI_TRICH_DAN = 120;

    private final ThanhVienCuocTroChuyenRepository thanhVienRepository;
    private final DangKyPushRepository dangKyPushRepository;
    private final ChatPresenceService chatPresenceService;
    private final List<KenhGuiPush> cacKenhGui;

    /**
     * Gui thong bao cho mot tin nhan moi.
     *
     * Goi tu listener AFTER_COMMIT nen tin chac chan da nam trong DB.
     */
    @Transactional
    public void guiChoTinNhan(TinNhanResponse tin, List<UUID> nguoiNhanIds) {
        if (tin == null || nguoiNhanIds == null || nguoiNhanIds.isEmpty()) return;
        if (cacKenhGui.isEmpty()) return; // chua cau hinh kenh nao thi khong lam gi

        List<UUID> canGui = locNguoiCanGui(tin, nguoiNhanIds);
        if (canGui.isEmpty()) return;

        List<DangKyPush> dangKys = dangKyPushRepository.dangDung(canGui);
        if (dangKys.isEmpty()) return;

        NoiDungPush noiDung = dungNoiDung(tin);
        List<DangKyPush> daChet = new ArrayList<>();

        for (DangKyPush dangKy : dangKys) {
            cacKenhGui.stream()
                    .filter(kenh -> kenh.hoTro(dangKy.getNenTang()))
                    .findFirst()
                    .ifPresent(kenh -> {
                        if (!kenh.gui(dangKy, noiDung)) daChet.add(dangKy);
                    });
        }

        // Endpoint da chet (nguoi dung go app / thu hoi quyen) thi ngung gui, nhung
        // giu lai ban ghi de con doi chieu khi ho hoi "sao khong nhan duoc".
        if (!daChet.isEmpty()) {
            daChet.forEach(d -> d.setDungLuc(ZonedDateTime.now()));
            dangKyPushRepository.saveAll(daChet);
            log.info("Da ngung {} dang ky push khong con hop le", daChet.size());
        }
    }

    /**
     * Ba bo loc, theo thu tu re truoc dat sau:
     *
     * 1. BO NGUOI GUI — khong ai muon nhan thong bao ve tin cua chinh minh.
     * 2. BO NGUOI DANG ONLINE — ho da thay tin qua WebSocket roi; gui them push la
     *    lam phien va la loi de nhan thay nhat cua mot he thong chat.
     * 3. BO NGUOI DA TAT THONG BAO hoi thoai do — ton trong lua chon cua ho.
     */
    private List<UUID> locNguoiCanGui(TinNhanResponse tin, List<UUID> nguoiNhanIds) {
        UUID nguoiGuiId = tin.getNguoiGuiId();

        Set<UUID> offline = chatPresenceService.locNguoiOffline(
                nguoiNhanIds.stream()
                        .filter(id -> nguoiGuiId == null || !id.equals(nguoiGuiId))
                        .toList());
        if (offline.isEmpty()) return List.of();

        Map<UUID, ThanhVienCuocTroChuyen> theoNguoi = thanhVienRepository
                .dangHoatDong(tin.getCuocTroChuyenId()).stream()
                .filter(tv -> tv.getNguoiDung() != null)
                .collect(Collectors.toMap(tv -> tv.getNguoiDung().getId(), Function.identity(), (a, b) -> a));

        return offline.stream()
                .filter(id -> {
                    ThanhVienCuocTroChuyen tv = theoNguoi.get(id);
                    // dangTatThongBao() xet ca tat vo thoi han lan tat co han —
                    // doc thang co tatThongBao se bo sot truong hop thu hai.
                    return tv != null && !tv.dangTatThongBao();
                })
                .toList();
    }

    private NoiDungPush dungNoiDung(TinNhanResponse tin) {
        String tieuDe = tin.getTenNguoiGui() != null && !tin.getTenNguoiGui().isBlank()
                ? tin.getTenNguoiGui()
                : "Tin nhắn mới";

        String trichDan;
        if (Boolean.TRUE.equals(tin.getDaThuHoi())) {
            trichDan = "Tin nhắn đã được thu hồi";
        } else if (tin.getFileUrl() != null && (tin.getNoiDung() == null || tin.getNoiDung().isBlank())) {
            trichDan = "IMAGE".equals(tin.getLoai()) ? "[Hình ảnh]" : "[Tệp đính kèm]";
        } else {
            trichDan = catNgan(tin.getNoiDung());
        }

        return new NoiDungPush(
                tieuDe,
                trichDan,
                "/khach-thue/dashboard/tin-nhan",
                tin.getCuocTroChuyenId());
    }

    private String catNgan(String text) {
        if (text == null) return "";
        String gon = text.strip().replaceAll("\\s+", " ");
        return gon.length() <= DO_DAI_TRICH_DAN ? gon : gon.substring(0, DO_DAI_TRICH_DAN) + "…";
    }

    @Transactional
    public void guiChoThongBao(com.example.quanlyphongtro.entity.ThongBao tb, List<UUID> nguoiNhanIds) {
        if (tb == null || cacKenhGui.isEmpty()) return;

        List<DangKyPush> dangKys;
        if (Boolean.TRUE.equals(tb.getGuiTatCa()) || nguoiNhanIds == null || nguoiNhanIds.isEmpty()) {
            dangKys = dangKyPushRepository.tatCaDangDung();
        } else {
            dangKys = dangKyPushRepository.dangDung(nguoiNhanIds);
        }

        if (dangKys == null || dangKys.isEmpty()) return;

        NoiDungPush noiDung = new NoiDungPush(
            tb.getTieuDe(),
            catNgan(tb.getNoiDung()),
            "/khach-thue/dashboard/thong-bao",
            null
        );

        List<DangKyPush> daChet = new ArrayList<>();
        for (DangKyPush dangKy : dangKys) {
            cacKenhGui.stream()
                    .filter(kenh -> kenh.hoTro(dangKy.getNenTang()))
                    .findFirst()
                    .ifPresent(kenh -> {
                        if (!kenh.gui(dangKy, noiDung)) daChet.add(dangKy);
                    });
        }

        if (!daChet.isEmpty()) {
            daChet.forEach(d -> d.setDungLuc(ZonedDateTime.now()));
            dangKyPushRepository.saveAll(daChet);
            log.info("Da ngung {} dang ky push khong con hop le sau khi gui thong bao", daChet.size());
        }
    }
}
