package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.DichVuResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.entity.DichVu;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.example.quanlyphongtro.repository.CauHinhGiaRepository;
import com.example.quanlyphongtro.repository.DichVuHopDongRepository;
import com.example.quanlyphongtro.repository.DichVuRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.UUID;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DichVuService {

    private final DichVuRepository dichVuRepository;
    private final DichVuHopDongRepository dichVuHopDongRepository;
    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final PermissionService permissionService;
    private final NguoiDungRepository nguoiDungRepository;

    public PaginatedResponse<DichVuResponse> getAll(Pageable pageable) {
        UUID currentUserId = permissionService.requireCurrentUserId();
        Page<DichVu> page;
        if (permissionService.isAdmin(currentUserId)) {
            page = dichVuRepository.findAll(pageable);
        } else {
            page = dichVuRepository.findByChuTroId(currentUserId, pageable);
        }
        
        List<DichVuResponse> data = page.getContent().stream()
                .map(DichVuResponse::fromEntity)
                .collect(Collectors.toList());
        return PaginatedResponse.of(page, data);
    }

    public DichVuResponse getById(UUID id) {
        DichVu dichVu = dichVuRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ"));
        assertCanRead(dichVu, permissionService.requireCurrentUserId());
        return DichVuResponse.fromEntity(dichVu);
    }

    @Transactional
    public DichVuResponse create(com.example.quanlyphongtro.dto.DichVuRequest req) {
        DichVu dichVu = new DichVu();
        mapRequestToEntity(req, dichVu);
        UUID currentUserId = permissionService.requireCurrentUserId();
        dichVu.setChuTro(nguoiDungRepository.findById(currentUserId).orElse(null));
        return DichVuResponse.fromEntity(dichVuRepository.save(dichVu));
    }

    @Transactional
    public DichVuResponse update(UUID id, com.example.quanlyphongtro.dto.DichVuRequest req) {
        DichVu dichVu = dichVuRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ"));
        assertCanWrite(dichVu, permissionService.requireCurrentUserId());
        mapRequestToEntity(req, dichVu);
        return DichVuResponse.fromEntity(dichVuRepository.save(dichVu));
    }

    @Transactional
    public void delete(UUID id) {
        DichVu dichVu = dichVuRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ"));
        assertCanWrite(dichVu, permissionService.requireCurrentUserId());
        
        if (dichVuHopDongRepository.existsByDichVuId(id) || cauHinhGiaRepository.existsByDichVuId(id)) {
            throw new RuntimeException("Không thể xóa dịch vụ đang được sử dụng trong hợp đồng hoặc cấu hình giá");
        }
        
        dichVuRepository.deleteById(id);
    }

    private void mapRequestToEntity(com.example.quanlyphongtro.dto.DichVuRequest req, DichVu dichVu) {
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

    private void assertCanRead(DichVu dichVu, UUID userId) {
        if (permissionService.isAdmin(userId)) return;
        if (dichVu.getChuTro() != null && userId.equals(dichVu.getChuTro().getId())) return;
        throw new RuntimeException("Ban khong co quyen xem dich vu nay");
    }

    private void assertCanWrite(DichVu dichVu, UUID userId) {
        if (permissionService.isAdmin(userId)) return;
        if (dichVu.getChuTro() != null && userId.equals(dichVu.getChuTro().getId())) return;
        throw new RuntimeException("Ban khong co quyen sua dich vu nay");
    }
}
