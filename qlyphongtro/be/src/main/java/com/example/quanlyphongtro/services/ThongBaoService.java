package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThongBaoRequest;
import com.example.quanlyphongtro.dto.ThongBaoResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
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
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class ThongBaoService {

    private final ThongBaoRepository thongBaoRepository;
    private final ThongBaoNguoiNhanRepository thongBaoNguoiNhanRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final KhachThueRepository khachThueRepository;

    @Transactional(readOnly = true)
    public PaginatedResponse<ThongBaoResponse> getAll(org.springframework.data.domain.Pageable pageable) {
        permissionService.requireAdmin();
        org.springframework.data.domain.Page<ThongBao> page = thongBaoRepository.findByXoaLucIsNullOrderByTaoLucDesc(pageable);
        List<ThongBaoResponse> mappedData = page.getContent().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        return PaginatedResponse.of(page, mappedData);
    }

    @Transactional(readOnly = true)
    public ThongBaoResponse getById(UUID id) {
        permissionService.requireAdmin();
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        return toResponse(tb);
    }

    @Transactional
    public ThongBaoResponse create(ThongBaoRequest req) {
        permissionService.requireAdmin();
        LoaiThongBao loai = parseLoai(req.getLoai(), LoaiThongBao.SYSTEM);

        ThongBao tb = ThongBao.builder()
                .tieuDe(req.getTieuDe())
                .noiDung(req.getNoiDung())
                .loai(loai)
                .kenh(KenhThongBao.IN_APP)
                .guiTatCa(req.getNguoiNhan() == null || req.getNguoiNhan().isEmpty())
                .nguoiGui(nguoiDungRepository.findById(permissionService.requireCurrentUserId()).orElse(null))
                .build();
        ThongBao saved = thongBaoRepository.save(tb);
        replaceRecipients(saved, req.getNguoiNhan());
        logAudit(saved, "CREATE");
        return toResponse(saved);
    }

    @Transactional
    public ThongBaoResponse createSystemNotification(String tieuDe, String noiDung, LoaiThongBao loai, List<UUID> nguoiNhanIds) {
        ThongBao tb = ThongBao.builder()
                .tieuDe(tieuDe)
                .noiDung(noiDung)
                .loai(loai)
                .kenh(KenhThongBao.IN_APP)
                .guiTatCa(nguoiNhanIds == null || nguoiNhanIds.isEmpty())
                .nguoiGui(null)
                .build();
        ThongBao saved = thongBaoRepository.save(tb);
        replaceRecipients(saved, nguoiNhanIds);
        logSystemAudit(saved, "SYSTEM_CREATE");
        return toResponse(saved);
    }

    private void logSystemAudit(ThongBao thongBao, String action) {
        if (auditLogRepository == null) return;
        auditLogRepository.save(com.example.quanlyphongtro.entity.AuditLog.builder()
                .nguoiDung(null)
                .hanhDong(action)
                .bangTacDong("thong_bao")
                .banGhiId(thongBao.getId())
                .taoLuc(ZonedDateTime.now())
                .build());
    }

    @Transactional
    public ThongBaoResponse update(UUID id, ThongBaoRequest req) {
        permissionService.requireAdmin();
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        if (req.getTieuDe() != null) tb.setTieuDe(req.getTieuDe());
        if (req.getNoiDung() != null) tb.setNoiDung(req.getNoiDung());
        if (req.getLoai() != null) tb.setLoai(parseLoai(req.getLoai(), tb.getLoai()));
        if (req.getNguoiNhan() != null) {
            tb.setGuiTatCa(req.getNguoiNhan().isEmpty());
            replaceRecipients(tb, req.getNguoiNhan());
        }
        ThongBao saved = thongBaoRepository.save(tb);
        logAudit(saved, "UPDATE");
        return toResponse(saved);
    }

    @Transactional
    public ThongBaoResponse send(UUID id) {
        permissionService.requireAdmin();
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        List<ThongBaoNguoiNhan> recipients = thongBaoNguoiNhanRepository.findByThongBaoId(id);
        ZonedDateTime now = ZonedDateTime.now();
        
        List<UUID> recipientIds = recipients.stream().map(r -> r.getNguoiDung().getId()).toList();
        
        if (Boolean.TRUE.equals(tb.getGuiTatCa()) && recipients.isEmpty()) {
            tb.setCapNhatLuc(now);
            thongBaoRepository.save(tb);
        } else {
            for (ThongBaoNguoiNhan recipient : recipients) {
                recipient.setGuiLuc(now);
                recipient.setLoiGui(null);
            }
            thongBaoNguoiNhanRepository.saveAll(recipients);
        }
        
        if (pushService != null) {
            pushService.guiChoThongBao(tb, recipientIds);
        }
        
        try {
            if (Boolean.TRUE.equals(tb.getGuiTatCa()) && recipients.isEmpty()) {
                messagingTemplate.convertAndSend("/queue/thong-bao-chung", "{\"type\":\"NEW_THONG_BAO\"}");
            } else {
                for (UUID recipientId : recipientIds) {
                    messagingTemplate.convertAndSendToUser(recipientId.toString(), "/queue/thong-bao", "{\"type\":\"NEW_THONG_BAO\"}");
                }
            }
        } catch (Exception ex) {
            log.warn("Khong the gui STOMP message: {}", ex.getMessage());
        }
        
        logAudit(tb, "SEND");
        return toResponse(tb);
    }

    @Transactional
    public ThongBaoResponse markRead(UUID id, UUID nguoiDungId, boolean daDoc) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        
        UUID currentUserId = permissionService.requireCurrentUserId();
        UUID targetUserId = nguoiDungId != null ? nguoiDungId : currentUserId;
        if (!targetUserId.equals(currentUserId)) {
            throw new RuntimeException("Khong co quyen danh dau da doc cho nguoi dung khac");
        }
        
        NguoiDung nguoiDung = resolveNguoiDungForRecipient(targetUserId);
        ThongBaoNguoiNhan recipient = thongBaoNguoiNhanRepository.findByThongBaoIdAndNguoiDungId(id, nguoiDung.getId())
                .orElseGet(() -> {
                    if (!Boolean.TRUE.equals(tb.getGuiTatCa())) {
                        throw new RuntimeException("Thong bao nay khong gui den nguoi dung hien tai");
                    }
                    return ThongBaoNguoiNhan.builder()
                        .thongBao(tb)
                        .nguoiDung(nguoiDung)
                        .daDoc(false)
                        .build();
                });
        recipient.setDaDoc(daDoc);
        recipient.setDocLuc(daDoc ? ZonedDateTime.now() : null);
        thongBaoNguoiNhanRepository.save(recipient);
        return toResponse(tb);
    }

    @Transactional
    public void delete(UUID id) {
        permissionService.requireAdmin();
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
        tb.setXoaLuc(ZonedDateTime.now());
        thongBaoRepository.save(tb);
        logAudit(tb, "DELETE");
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

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.services.PermissionService permissionService;
    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;
    @org.springframework.beans.factory.annotation.Autowired(required = false)
    private com.example.quanlyphongtro.services.push.PushService pushService;
    @org.springframework.beans.factory.annotation.Autowired
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    private void logAudit(ThongBao thongBao, String action) {
        if (auditLogRepository == null) return;
        auditLogRepository.save(com.example.quanlyphongtro.entity.AuditLog.builder()
                .nguoiDung(NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
                .hanhDong(action)
                .bangTacDong("thong_bao")
                .banGhiId(thongBao.getId())
                .taoLuc(ZonedDateTime.now())
                .build());
    }

    @Transactional(readOnly = true)
    public PaginatedResponse<ThongBaoResponse> getMyThongBao(org.springframework.data.domain.Pageable pageable) {
        UUID currentUserId = permissionService.requireCurrentUserId();
        
        List<ThongBaoNguoiNhan> myRecipients = thongBaoNguoiNhanRepository.findByNguoiDungId(currentUserId);
        List<UUID> myThongBaoIds = myRecipients.stream().map(r -> r.getThongBao().getId()).toList();
        
        org.springframework.data.domain.Page<ThongBao> page;
        if (myThongBaoIds.isEmpty()) {
            page = thongBaoRepository.findMyThongBaoGuiTatCa(pageable);
        } else {
            page = thongBaoRepository.findMyThongBao(myThongBaoIds, pageable);
        }

        List<ThongBaoResponse> mappedData = page.getContent().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        return PaginatedResponse.of(page, mappedData);
    }
}
