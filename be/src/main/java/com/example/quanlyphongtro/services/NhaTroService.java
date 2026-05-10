package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.NhaTroRequest;
import com.example.quanlyphongtro.dto.NhaTroResponse;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.NhaTroRepository;
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
public class NhaTroService {

    private final NhaTroRepository nhaTroRepository;
    private final PhongRepository phongRepository;

    public List<NhaTroResponse> getAllNhaTro() {
        return nhaTroRepository.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public NhaTroResponse getNhaTroById(UUID id) {
        NhaTro nhaTro = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tòa nhà"));
        return mapToResponse(nhaTro);
    }

    @Transactional
    public NhaTroResponse createNhaTro(NhaTroRequest request) {
        NhaTro nhaTro = new NhaTro();
        mapRequestToEntity(request, nhaTro);
        nhaTro = nhaTroRepository.save(nhaTro);
        return mapToResponse(nhaTro);
    }

    @Transactional
    public NhaTroResponse updateNhaTro(UUID id, NhaTroRequest request) {
        NhaTro nhaTro = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tòa nhà"));
        mapRequestToEntity(request, nhaTro);
        nhaTro = nhaTroRepository.save(nhaTro);
        return mapToResponse(nhaTro);
    }

    @Transactional
    public void deleteNhaTro(UUID id) {
        if (!nhaTroRepository.existsById(id)) {
            throw new RuntimeException("Không tìm thấy tòa nhà");
        }
        nhaTroRepository.deleteById(id);
    }

    private void mapRequestToEntity(NhaTroRequest request, NhaTro nhaTro) {
        if (request.getTenToaNha() != null)
            nhaTro.setTen(request.getTenToaNha());
        if (request.getMoTa() != null)
            nhaTro.setMoTa(request.getMoTa());
        // if (request.getTienNghiChung() != null)
        // nhaTro.setTienNghiChung(request.getTienNghiChung());

        if (request.getDiaChi() != null) {
            String diaChi = "";
            if (request.getDiaChi().getSoNha() != null && !request.getDiaChi().getSoNha().isEmpty()) {
                diaChi += request.getDiaChi().getSoNha() + " ";
            }
            if (request.getDiaChi().getDuong() != null && !request.getDiaChi().getDuong().isEmpty()) {
                diaChi += request.getDiaChi().getDuong();
            }
            nhaTro.setDiaChi(diaChi.trim());
            nhaTro.setXa(request.getDiaChi().getPhuong());
            nhaTro.setHuyen(request.getDiaChi().getQuan());
            nhaTro.setTinh(request.getDiaChi().getThanhPho());
        }
    }

    private NhaTroResponse mapToResponse(NhaTro nhaTro) {
        int tongSoPhong = (int) phongRepository.countByNhaTroId(nhaTro.getId());
        int phongTrong = (int) phongRepository.countByNhaTroIdAndTrangThai(nhaTro.getId(), TrangThaiPhong.AVAILABLE);
        int phongDangThue = (int) phongRepository.countByNhaTroIdAndTrangThai(nhaTro.getId(), TrangThaiPhong.RENTED);
        return NhaTroResponse.fromEntity(nhaTro, tongSoPhong, phongTrong, phongDangThue);
    }
}
