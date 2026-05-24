package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThongBaoRequest;
import com.example.quanlyphongtro.dto.ThongBaoResponse;
import com.example.quanlyphongtro.entity.KenhThongBao;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.LoaiThongBao;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.ThongBao;
import com.example.quanlyphongtro.entity.ThongBaoNguoiNhan;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.ThongBaoNguoiNhanRepository;
import com.example.quanlyphongtro.repository.ThongBaoRepository;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ThongBaoService {

    private final ThongBaoRepository thongBaoRepository;
    private final ThongBaoNguoiNhanRepository thongBaoNguoiNhanRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final KhachThueRepository khachThueRepository;

    @Transactional(readOnly = true)
    public List<ThongBaoResponse> getAll() {
        return thongBaoRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ThongBaoResponse getById(UUID id) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        return toResponse(tb);
    }

    @Transactional
    public ThongBaoResponse create(ThongBaoRequest req) {
        LoaiThongBao loai = parseLoai(req.getLoai(), LoaiThongBao.SYSTEM);

        ThongBao tb = ThongBao.builder()
                .tieuDe(req.getTieuDe())
                .noiDung(req.getNoiDung())
                .loai(loai)
                .kenh(KenhThongBao.IN_APP)
                .guiTatCa(req.getNguoiNhan() == null || req.getNguoiNhan().isEmpty())
                .build();
        ThongBao saved = thongBaoRepository.save(tb);
        replaceRecipients(saved, req.getNguoiNhan());
        return toResponse(saved);
    }

    @Transactional
    public ThongBaoResponse update(UUID id, ThongBaoRequest req) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        if (req.getTieuDe() != null) tb.setTieuDe(req.getTieuDe());
        if (req.getNoiDung() != null) tb.setNoiDung(req.getNoiDung());
        if (req.getLoai() != null) tb.setLoai(parseLoai(req.getLoai(), tb.getLoai()));
        if (req.getNguoiNhan() != null) {
            tb.setGuiTatCa(req.getNguoiNhan().isEmpty());
            replaceRecipients(tb, req.getNguoiNhan());
        }
        return toResponse(thongBaoRepository.save(tb));
    }

    @Transactional
    public ThongBaoResponse send(UUID id) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        List<ThongBaoNguoiNhan> recipients = thongBaoNguoiNhanRepository.findByThongBaoId(id);
        ZonedDateTime now = ZonedDateTime.now();
        for (ThongBaoNguoiNhan recipient : recipients) {
            recipient.setGuiLuc(now);
            recipient.setLoiGui(null);
        }
        thongBaoNguoiNhanRepository.saveAll(recipients);
        return toResponse(tb);
    }

    @Transactional
    public ThongBaoResponse markRead(UUID id, UUID nguoiDungId, boolean daDoc) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        if (nguoiDungId == null) {
            List<ThongBaoNguoiNhan> recipients = thongBaoNguoiNhanRepository.findByThongBaoId(id);
            ZonedDateTime now = ZonedDateTime.now();
            for (ThongBaoNguoiNhan recipient : recipients) {
                recipient.setDaDoc(daDoc);
                recipient.setDocLuc(daDoc ? now : null);
            }
            thongBaoNguoiNhanRepository.saveAll(recipients);
            return toResponse(tb);
        }
        NguoiDung nguoiDung = resolveNguoiDungForRecipient(nguoiDungId);
        ThongBaoNguoiNhan recipient = thongBaoNguoiNhanRepository.findByThongBaoIdAndNguoiDungId(id, nguoiDung.getId())
                .orElseGet(() -> ThongBaoNguoiNhan.builder()
                        .thongBao(tb)
                        .nguoiDung(nguoiDung)
                        .daDoc(false)
                        .build());
        recipient.setDaDoc(daDoc);
        recipient.setDocLuc(daDoc ? ZonedDateTime.now() : null);
        thongBaoNguoiNhanRepository.save(recipient);
        return toResponse(tb);
    }

    @Transactional
    public void delete(UUID id) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        tb.setXoaLuc(ZonedDateTime.now());
        thongBaoRepository.save(tb);
    }

    private void replaceRecipients(ThongBao thongBao, List<UUID> nguoiNhanIds) {
        thongBaoNguoiNhanRepository.deleteByThongBaoId(thongBao.getId());
        if (nguoiNhanIds == null || nguoiNhanIds.isEmpty()) return;

        List<ThongBaoNguoiNhan> recipients = nguoiNhanIds.stream()
                .distinct()
                .map(id -> ThongBaoNguoiNhan.builder()
                        .thongBao(thongBao)
                        .nguoiDung(resolveNguoiDungForRecipient(id))
                        .daDoc(false)
                        .build())
                .toList();
        thongBaoNguoiNhanRepository.saveAll(recipients);
    }

    private ThongBaoResponse toResponse(ThongBao thongBao) {
        List<ThongBaoNguoiNhan> recipients = thongBaoNguoiNhanRepository.findByThongBaoId(thongBao.getId());
        List<UUID> nguoiNhanIds = recipients.stream()
                .filter(item -> item.getNguoiDung() != null)
                .map(item -> toFrontendRecipientId(item.getNguoiDung().getId()))
                .toList();
        List<UUID> daDocIds = recipients.stream()
                .filter(item -> Boolean.TRUE.equals(item.getDaDoc()))
                .filter(item -> item.getNguoiDung() != null)
                .map(item -> toFrontendRecipientId(item.getNguoiDung().getId()))
                .toList();
        return ThongBaoResponse.fromEntity(thongBao, nguoiNhanIds, daDocIds);
    }

    private NguoiDung resolveNguoiDungForRecipient(UUID id) {
        return nguoiDungRepository.findById(id)
                .or(() -> khachThueRepository.findById(id)
                        .map(KhachThue::getNguoiDung))
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi nhan thong bao"));
    }

    private UUID toFrontendRecipientId(UUID nguoiDungId) {
        return khachThueRepository.findByNguoiDungId(nguoiDungId)
                .map(KhachThue::getId)
                .orElse(nguoiDungId);
    }

    private LoaiThongBao parseLoai(String value, LoaiThongBao fallback) {
        if (value == null || value.isBlank()) return fallback != null ? fallback : LoaiThongBao.SYSTEM;
        return switch (value) {
            case "chung" -> LoaiThongBao.SYSTEM;
            case "hoaDon" -> LoaiThongBao.INVOICE;
            case "thanhToan" -> LoaiThongBao.PAYMENT;
            case "hopDong" -> LoaiThongBao.CONTRACT;
            case "suCo" -> LoaiThongBao.INCIDENT;
            case "lichHen" -> LoaiThongBao.APPOINTMENT;
            case "congNo" -> LoaiThongBao.DEBT;
            default -> {
                try {
                    yield LoaiThongBao.valueOf(value.toUpperCase());
                } catch (Exception ignored) {
                    yield fallback != null ? fallback : LoaiThongBao.SYSTEM;
                }
            }
        };
    }
}
