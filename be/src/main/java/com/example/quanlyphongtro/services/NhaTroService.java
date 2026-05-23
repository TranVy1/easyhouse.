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
    private final com.example.quanlyphongtro.repository.NguoiDungRepository nguoiDungRepository;

    public List<NhaTroResponse> getAllNhaTro() {
        return nhaTroRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .map(this::mapToResponse).collect(Collectors.toList());
    }

    public NhaTroResponse getNhaTroById(UUID id) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
        return mapToResponse(nt);
    }

    @Transactional
    public NhaTroResponse createNhaTro(NhaTroRequest request) {
        NhaTro nt = new NhaTro();
        // Temporary: Set chuTro to the first admin user since auth is not fully implemented
        com.example.quanlyphongtro.entity.NguoiDung defaultUser = nguoiDungRepository.findById(UUID.fromString("22222222-2222-2222-2222-222222222221"))
                .orElseThrow(() -> new RuntimeException("Lỗi cấu hình: Không tìm thấy tài khoản admin mặc định."));
        nt.setChuTro(defaultUser);
        
        mapRequestToEntity(request, nt);
        return mapToResponse(nhaTroRepository.save(nt));
    }

    @Transactional
    public NhaTroResponse updateNhaTro(UUID id, NhaTroRequest request) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
        mapRequestToEntity(request, nt);
        return mapToResponse(nhaTroRepository.save(nt));
    }

    @Transactional
    public void deleteNhaTro(UUID id) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
        nt.setXoaLuc(java.time.ZonedDateTime.now());
        nhaTroRepository.save(nt);
    }

    private void mapRequestToEntity(NhaTroRequest request, NhaTro nt) {
        if (request.getTenToaNha() != null) nt.setTen(request.getTenToaNha());
        if (request.getMoTa() != null) nt.setMoTa(request.getMoTa());
        if (request.getTienNghiChung() != null) {
            nt.setTienNghiChung(String.join(",", request.getTienNghiChung()));
        }
        if (request.getDiaChi() != null) {
            String soNha = request.getDiaChi().getSoNha() != null ? request.getDiaChi().getSoNha() : "";
            String duong = request.getDiaChi().getDuong() != null ? request.getDiaChi().getDuong() : "";
            String fullDiaChi = (soNha + " " + duong).trim();
            nt.setDiaChi(fullDiaChi.isEmpty() ? null : fullDiaChi);
            nt.setSoNha(request.getDiaChi().getSoNha());
            nt.setDuong(request.getDiaChi().getDuong());
            nt.setPhuong(request.getDiaChi().getPhuong());
            nt.setQuan(request.getDiaChi().getQuan());
            nt.setThanhPho(request.getDiaChi().getThanhPho());
        }
    }

    private NhaTroResponse mapToResponse(NhaTro nt) {
        int tong = (int) phongRepository.countByNhaTroIdAndXoaLucIsNull(nt.getId());
        int trong = (int) phongRepository.countByNhaTroIdAndTrangThaiAndXoaLucIsNull(nt.getId(), TrangThaiPhong.AVAILABLE);
        int thue = (int) phongRepository.countByNhaTroIdAndTrangThaiAndXoaLucIsNull(nt.getId(), TrangThaiPhong.RENTED);
        return NhaTroResponse.fromEntity(nt, tong, trong, thue);
    }
}
