package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.LichHenRequest;
import com.example.quanlyphongtro.dto.LichHenResponse;
import com.example.quanlyphongtro.entity.LichHen;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiLichHen;
import com.example.quanlyphongtro.repository.LichHenRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class LichHenService {

    private final LichHenRepository lichHenRepository;
    private final PhongRepository phongRepository;

    public List<LichHenResponse> getAll() {
        return lichHenRepository.findAll().stream()
                .map(LichHenResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public LichHenResponse getById(UUID id) {
        LichHen lichHen = lichHenRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lịch hẹn"));
        return LichHenResponse.fromEntity(lichHen);
    }

    @Transactional
    public LichHenResponse create(LichHenRequest req) {
        Phong phong = phongRepository.findById(req.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));

        LichHen lichHen = new LichHen();
        lichHen.setPhong(phong);
        lichHen.setHoTen(req.getHoTen());
        lichHen.setSoDienThoai(req.getSoDienThoai());
        lichHen.setEmail(req.getEmail());
        lichHen.setNgayHen(req.getNgayHen());
        lichHen.setGhiChu(req.getGhiChu());
        
        if (req.getTrangThai() != null) {
            lichHen.setTrangThai(TrangThaiLichHen.valueOf(req.getTrangThai()));
        } else {
            lichHen.setTrangThai(TrangThaiLichHen.PENDING);
        }

        return LichHenResponse.fromEntity(lichHenRepository.save(lichHen));
    }

    @Transactional
    public LichHenResponse update(UUID id, LichHenRequest req) {
        LichHen lichHen = lichHenRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lịch hẹn"));

        if (req.getPhongId() != null && !req.getPhongId().equals(lichHen.getPhong().getId())) {
            Phong phong = phongRepository.findById(req.getPhongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
            lichHen.setPhong(phong);
        }

        if (req.getHoTen() != null) lichHen.setHoTen(req.getHoTen());
        if (req.getSoDienThoai() != null) lichHen.setSoDienThoai(req.getSoDienThoai());
        if (req.getEmail() != null) lichHen.setEmail(req.getEmail());
        if (req.getNgayHen() != null) lichHen.setNgayHen(req.getNgayHen());
        if (req.getGhiChu() != null) lichHen.setGhiChu(req.getGhiChu());
        if (req.getTrangThai() != null) {
            lichHen.setTrangThai(TrangThaiLichHen.valueOf(req.getTrangThai()));
        }

        return LichHenResponse.fromEntity(lichHenRepository.save(lichHen));
    }

    @Transactional
    public LichHenResponse updateStatus(UUID id, String status) {
        LichHen lichHen = lichHenRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lịch hẹn"));
        
        lichHen.setTrangThai(TrangThaiLichHen.valueOf(status));
        return LichHenResponse.fromEntity(lichHenRepository.save(lichHen));
    }

    @Transactional
    public void delete(UUID id) {
        lichHenRepository.deleteById(id);
    }
}
