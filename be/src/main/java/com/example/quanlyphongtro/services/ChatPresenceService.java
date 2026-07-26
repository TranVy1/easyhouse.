package com.example.quanlyphongtro.services;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * Theo doi ai dang ket noi WebSocket.
 *
 * Dung de tra loi mot cau hoi duy nhat nhung quan trong: **co can gui thong bao
 * day khong?** Nguoi dang mo app thi da thay tin qua WebSocket roi, gui push nua
 * la lam phien.
 *
 * DEM THEO SO PHIEN chu khong phai co/khong:
 * mot nguoi co the mo nhieu tab, hoac vua web vua dien thoai. Neu chi luu mot co
 * boolean thi dong MOT tab se lam he thong tuong ho da offline, trong khi tab kia
 * van dang mo.
 *
 * Luu trong bo nho: hop le voi mo hinh trien khai hien tai (mot instance backend,
 * container_name co dinh nen khong scale ngang duoc). Khi nao chay nhieu instance
 * thi chuyen sang Redis — dependency da co san trong pom.
 */
@Slf4j
@Service
public class ChatPresenceService {

    /** nguoiDungId -> so phien WebSocket dang mo. */
    private final Map<UUID, Integer> soPhienTheoNguoi = new ConcurrentHashMap<>();

    /** phienId -> nguoiDungId, de luc ngat con biet tru cho ai. */
    private final Map<String, UUID> nguoiTheoPhien = new ConcurrentHashMap<>();

    public void ghiNhanKetNoi(String phienId, UUID nguoiDungId) {
        if (phienId == null || nguoiDungId == null) return;

        // putIfAbsent: cung mot phien bao ket noi hai lan thi khong duoc dem doi.
        if (nguoiTheoPhien.putIfAbsent(phienId, nguoiDungId) != null) return;

        soPhienTheoNguoi.merge(nguoiDungId, 1, Integer::sum);
        log.debug("WebSocket ket noi: nguoi {} ({} phien)", nguoiDungId, soPhienTheoNguoi.get(nguoiDungId));
    }

    public void ghiNhanNgatKetNoi(String phienId) {
        if (phienId == null) return;

        UUID nguoiDungId = nguoiTheoPhien.remove(phienId);
        if (nguoiDungId == null) return;

        soPhienTheoNguoi.computeIfPresent(nguoiDungId, (id, so) -> so <= 1 ? null : so - 1);
        log.debug("WebSocket ngat: nguoi {} (con {} phien)", nguoiDungId,
                soPhienTheoNguoi.getOrDefault(nguoiDungId, 0));
    }

    public boolean dangOnline(UUID nguoiDungId) {
        return nguoiDungId != null && soPhienTheoNguoi.containsKey(nguoiDungId);
    }

    /** Loc ra nhung nguoi KHONG online — day chinh la tap can gui push. */
    public Set<UUID> locNguoiOffline(Collection<UUID> nguoiDungIds) {
        if (nguoiDungIds == null) return Set.of();
        return nguoiDungIds.stream()
                .filter(id -> id != null && !dangOnline(id))
                .collect(Collectors.toSet());
    }

    /** Chi dung cho theo doi/gian sat, khong dung trong logic nghiep vu. */
    public int soNguoiDangOnline() {
        return soPhienTheoNguoi.size();
    }
}
