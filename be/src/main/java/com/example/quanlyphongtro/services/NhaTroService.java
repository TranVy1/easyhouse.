package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.NhaTroRequest;
import com.example.quanlyphongtro.dto.NhaTroResponse;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import java.time.ZonedDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NhaTroService {

    private final NhaTroRepository nhaTroRepository;
    private final PhongRepository phongRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final PermissionService permissionService;

    public PaginatedResponse<NhaTroResponse> getAllNhaTro(int page, int limit) {
        UUID userId = permissionService.currentUserId().orElse(null);
        boolean isAdmin = userId != null && permissionService.isAdmin(userId);
        List<UUID> nhaTroIds = List.of(UUID.randomUUID());
        if (!isAdmin && userId != null) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (!accessibleIds.isEmpty()) {
                nhaTroIds = accessibleIds;
            }
        }

        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<NhaTro> pageResult = nhaTroRepository.findAllAccessible(isAdmin, nhaTroIds, pageable);
        
        List<NhaTroResponse> mappedList = pageResult.getContent().stream().map(this::mapToResponse).toList();
        return PaginatedResponse.of(pageResult, mappedList);
    }

    public NhaTroResponse getNhaTroById(UUID id) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        permissionService.currentUserId().ifPresent(userId -> assertCanRead(nt, userId));
        return mapToResponse(nt);
    }

    public List<NhaTroResponse> getPublicAllNhaTro() {
        List<NhaTro> nhaTroList = nhaTroRepository.findByXoaLucIsNullOrderByTaoLucDesc();
        return nhaTroList.stream().map(this::mapToResponse).toList();
    }

    public NhaTroResponse getPublicNhaTroById(UUID id) {
        NhaTro nt = nhaTroRepository.findByIdAndXoaLucIsNull(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        return mapToResponse(nt);
    }

    @Transactional
    public NhaTroResponse createNhaTro(NhaTroRequest request) {
        UUID userId = permissionService.requireCurrentUserId();
        NguoiDung currentUser = nguoiDungRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai"));

        NhaTro nt = new NhaTro();
        nt.setChuTro(currentUser);
        mapRequestToEntity(request, nt);
        return mapToResponse(nhaTroRepository.save(nt));
    }

    @Transactional
    public NhaTroResponse updateNhaTro(UUID id, NhaTroRequest request) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        assertCanWrite(nt, permissionService.requireCurrentUserId());
        mapRequestToEntity(request, nt);
        return mapToResponse(nhaTroRepository.save(nt));
    }

    @Transactional
    public void deleteNhaTro(UUID id) {
        NhaTro nt = nhaTroRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        assertCanWrite(nt, permissionService.requireCurrentUserId());
        if (phongRepository.countByNhaTroIdAndXoaLucIsNull(id) > 0) {
            throw new RuntimeException("Khong the xoa nha tro dang co phong hoat dong");
        }
        nt.setXoaLuc(ZonedDateTime.now());
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

    private void assertCanRead(NhaTro nhaTro, UUID userId) {
        if (!permissionService.canReadNhaTro(userId, nhaTro.getId(), ownerId(nhaTro))) {
            throw new RuntimeException("Ban khong co quyen xem nha tro nay");
        }
    }

    private void assertCanWrite(NhaTro nhaTro, UUID userId) {
        if (!permissionService.canWriteNhaTro(userId, nhaTro.getId(), ownerId(nhaTro))) {
            throw new RuntimeException("Ban khong co quyen sua nha tro nay");
        }
    }

    private boolean isOwnedBy(NhaTro nhaTro, UUID userId) {
        UUID ownerId = ownerId(nhaTro);
        return ownerId != null && ownerId.equals(userId);
    }

    private UUID ownerId(NhaTro nhaTro) {
        return nhaTro.getChuTro() != null ? nhaTro.getChuTro().getId() : null;
    }
}
