package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThongBaoRequest;
import com.example.quanlyphongtro.dto.ThongBaoResponse;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.ThongBao;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.ThongBaoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ThongBaoService {

    private final ThongBaoRepository thongBaoRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final KhachThueRepository khachThueRepository;
    private final PhongRepository phongRepository;

    @Transactional(readOnly = true)
    public List<ThongBao> getAll(UUID nguoiDungId) {
        if (nguoiDungId != null) {
            return thongBaoRepository.findByNguoiDungIdOrderByTaoLucDesc(nguoiDungId);
        }
        return thongBaoRepository.findAllByOrderByTaoLucDesc();
    }

    @Transactional(readOnly = true)
    public ThongBao getById(UUID id) {
        return thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thong bao"));
    }

    @Transactional
    public List<ThongBao> create(ThongBaoRequest request) {
        List<NguoiDung> recipients = resolveRecipients(request.getNguoiNhan());
        if (recipients.isEmpty()) {
            recipients.add(null);
        }

        List<ThongBao> created = new ArrayList<>();
        for (NguoiDung recipient : recipients) {
            created.add(thongBaoRepository.save(ThongBao.builder()
                    .nguoiDung(recipient)
                    .tieuDe(request.getTieuDe())
                    .noiDung(request.getNoiDung())
                    .loai(normalizeLoai(request.getLoai()))
                    .toaNhaId(resolveToaNhaId(request))
                    .phongIds(normalizeIds(request.getPhong()))
                    .daDoc(false)
                    .build()));
        }
        return created;
    }

    @Transactional
    public ThongBao update(UUID id, ThongBaoRequest request) {
        ThongBao thongBao = getById(id);
        thongBao.setTieuDe(request.getTieuDe());
        thongBao.setNoiDung(request.getNoiDung());
        thongBao.setLoai(normalizeLoai(request.getLoai()));
        thongBao.setToaNhaId(resolveToaNhaId(request));
        thongBao.setPhongIds(normalizeIds(request.getPhong()));

        List<NguoiDung> recipients = resolveRecipients(request.getNguoiNhan());
        if (!recipients.isEmpty()) {
            thongBao.setNguoiDung(recipients.getFirst());
            thongBao.setDaDoc(false);
        }

        return thongBaoRepository.save(thongBao);
    }

    @Transactional
    public ThongBao markRead(UUID id, boolean daDoc) {
        ThongBao thongBao = getById(id);
        thongBao.setDaDoc(daDoc);
        return thongBaoRepository.save(thongBao);
    }

    @Transactional
    public ThongBao send(UUID id) {
        ThongBao thongBao = getById(id);
        thongBao.setDaDoc(false);
        return thongBaoRepository.save(thongBao);
    }

    @Transactional
    public void delete(UUID id) {
        if (!thongBaoRepository.existsById(id)) {
            throw new RuntimeException("Khong tim thay thong bao");
        }
        thongBaoRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public ThongBaoResponse toResponse(ThongBao thongBao) {
        UUID recipientId = null;
        if (thongBao.getNguoiDung() != null) {
            recipientId = khachThueRepository.findByNguoiDungId(thongBao.getNguoiDung().getId())
                    .map(KhachThue::getId)
                    .orElse(thongBao.getNguoiDung().getId());
        }
        return ThongBaoResponse.fromEntity(thongBao, recipientId);
    }

    private List<NguoiDung> resolveRecipients(List<UUID> ids) {
        List<NguoiDung> recipients = new ArrayList<>();
        if (ids == null) {
            return recipients;
        }

        for (UUID id : ids) {
            Optional<KhachThue> khachThue = khachThueRepository.findByIdWithNguoiDung(id);
            if (khachThue.isPresent() && khachThue.get().getNguoiDung() != null) {
                recipients.add(khachThue.get().getNguoiDung());
                continue;
            }

            nguoiDungRepository.findById(id).ifPresent(recipients::add);
        }

        return recipients.stream().distinct().toList();
    }

    private String normalizeLoai(String loai) {
        return (loai == null || loai.isBlank()) ? "chung" : loai;
    }

    private List<UUID> normalizeIds(List<UUID> ids) {
        return ids == null ? new ArrayList<>() : ids.stream().distinct().toList();
    }

    private UUID resolveToaNhaId(ThongBaoRequest request) {
        if (request.getToaNha() != null) {
            return request.getToaNha();
        }

        List<UUID> phongIds = normalizeIds(request.getPhong());
        if (phongIds.isEmpty()) {
            return null;
        }

        List<Phong> phongs = phongRepository.findAllById(phongIds);
        List<UUID> toaNhaIds = phongs.stream()
                .filter(phong -> phong.getNhaTro() != null)
                .map(phong -> phong.getNhaTro().getId())
                .distinct()
                .toList();

        return toaNhaIds.size() == 1 ? toaNhaIds.getFirst() : null;
    }
}
