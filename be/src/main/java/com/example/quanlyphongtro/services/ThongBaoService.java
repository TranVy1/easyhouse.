package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThongBaoRequest;
import com.example.quanlyphongtro.dto.ThongBaoResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ThongBaoService {

    private final ThongBaoRepository thongBaoRepository;

    @Transactional(readOnly = true)
    public List<ThongBaoResponse> getAll() {
        return thongBaoRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .map(ThongBaoResponse::fromEntity).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ThongBaoResponse getById(UUID id) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông báo"));
        return ThongBaoResponse.fromEntity(tb);
    }

    @Transactional
    public ThongBaoResponse create(ThongBaoRequest req) {
        LoaiThongBao loai = LoaiThongBao.SYSTEM;
        try { loai = LoaiThongBao.valueOf(req.getLoai()); } catch (Exception ignored) {}

        ThongBao tb = ThongBao.builder()
                .tieuDe(req.getTieuDe()).noiDung(req.getNoiDung())
                .loai(loai).kenh(KenhThongBao.IN_APP)
                .guiTatCa(false)
                .build();
        return ThongBaoResponse.fromEntity(thongBaoRepository.save(tb));
    }

    @Transactional
    public ThongBaoResponse update(UUID id, ThongBaoRequest req) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông báo"));
        if (req.getTieuDe() != null) tb.setTieuDe(req.getTieuDe());
        if (req.getNoiDung() != null) tb.setNoiDung(req.getNoiDung());
        return ThongBaoResponse.fromEntity(thongBaoRepository.save(tb));
    }

    @Transactional
    public void delete(UUID id) {
        ThongBao tb = thongBaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông báo"));
        tb.setXoaLuc(java.time.ZonedDateTime.now());
        thongBaoRepository.save(tb);
    }
}
