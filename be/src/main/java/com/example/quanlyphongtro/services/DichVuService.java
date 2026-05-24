package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.DichVuResponse;
import com.example.quanlyphongtro.repository.DichVuRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DichVuService {

    private final DichVuRepository dichVuRepository;

    public List<DichVuResponse> getAll() {
        return dichVuRepository.findAll().stream()
                .map(DichVuResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public DichVuResponse getById(java.util.UUID id) {
        com.example.quanlyphongtro.entity.DichVu dichVu = dichVuRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ"));
        return DichVuResponse.fromEntity(dichVu);
    }

    @Transactional
    public DichVuResponse create(com.example.quanlyphongtro.dto.DichVuRequest req) {
        com.example.quanlyphongtro.entity.DichVu dichVu = new com.example.quanlyphongtro.entity.DichVu();
        mapRequestToEntity(req, dichVu);
        return DichVuResponse.fromEntity(dichVuRepository.save(dichVu));
    }

    @Transactional
    public DichVuResponse update(java.util.UUID id, com.example.quanlyphongtro.dto.DichVuRequest req) {
        com.example.quanlyphongtro.entity.DichVu dichVu = dichVuRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ"));
        mapRequestToEntity(req, dichVu);
        return DichVuResponse.fromEntity(dichVuRepository.save(dichVu));
    }

    @Transactional
    public void delete(java.util.UUID id) {
        dichVuRepository.deleteById(id);
    }

    private void mapRequestToEntity(com.example.quanlyphongtro.dto.DichVuRequest req, com.example.quanlyphongtro.entity.DichVu dichVu) {
        dichVu.setTenDichVu(req.getTenDichVu());
        if (req.getLoaiTinhPhi() != null) {
            dichVu.setLoaiTinhPhi(com.example.quanlyphongtro.entity.LoaiTinhPhi.valueOf(req.getLoaiTinhPhi()));
        }
        dichVu.setDonVi(req.getDonVi());
        if (req.getDonGiaMacDinh() != null) {
            dichVu.setDonGiaMacDinh(req.getDonGiaMacDinh());
        }
        if (req.getBatBuoc() != null) {
            dichVu.setBatBuoc(req.getBatBuoc());
        }
    }
}
