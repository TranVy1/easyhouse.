package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ChiSoDienNuocRequest;
import com.example.quanlyphongtro.dto.ChiSoDienNuocResponse;
import com.example.quanlyphongtro.dto.PhongResponse;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.entity.ChiSoDienNuoc;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.repository.ChiSoDienNuocRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.entity.TrangThaiChiSo;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChiSoDienNuocService {

    private final ChiSoDienNuocRepository chiSoDienNuocRepository;
    private final PhongRepository phongRepository;
    private final HopDongRepository hopDongRepository;
    private final MediaService mediaService;

    public List<ChiSoDienNuocResponse> getAll() {
        return chiSoDienNuocRepository.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public List<ChiSoDienNuocResponse> getByPhong(UUID phongId) {
        return chiSoDienNuocRepository.findByPhongIdOrderByKyNamDescKyThangDesc(phongId).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public ChiSoDienNuocResponse getById(UUID id) {
        ChiSoDienNuoc chiSo = chiSoDienNuocRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy chỉ số"));
        return mapToResponse(chiSo);
    }

    @Transactional
    public ChiSoDienNuocResponse create(ChiSoDienNuocRequest request) {
        Phong phong = phongRepository.findById(request.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));

        // Validate duplicates
        chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(
                request.getPhongId(), request.getLoai(), request.getKyNam(), request.getKyThang()
        ).ifPresent(c -> {
            throw new RuntimeException("Chỉ số " + request.getLoai() + " cho kỳ " + request.getKyThang() + "/" + request.getKyNam() + " đã tồn tại");
        });

        if (request.getChiSoMoi() < request.getChiSoCu()) {
            throw new RuntimeException("Chỉ số mới phải lớn hơn hoặc bằng chỉ số cũ");
        }

        ChiSoDienNuoc chiSo = new ChiSoDienNuoc();
        chiSo.setPhong(phong);

        if (request.getHopDongId() != null) {
            HopDong hopDong = hopDongRepository.findById(request.getHopDongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
            chiSo.setHopDong(hopDong);
        } else {
            // Find active contract for the room
            List<HopDong> activeContracts = hopDongRepository.findRoomOccupyingContracts(phong.getId(), List.of(com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE));
            if (!activeContracts.isEmpty()) {
                chiSo.setHopDong(activeContracts.get(0));
            }
        }

        chiSo.setLoai(request.getLoai());
        chiSo.setKyNam(request.getKyNam());
        chiSo.setKyThang(request.getKyThang());
        chiSo.setNgayGhi(request.getNgayGhi() != null ? request.getNgayGhi() : java.time.LocalDate.now());
        chiSo.setChiSoCu(request.getChiSoCu());
        chiSo.setChiSoMoi(request.getChiSoMoi());
        chiSo.setTrangThai(request.getTrangThai() != null ? request.getTrangThai() : TrangThaiChiSo.DRAFT);
        chiSo.setGhiChu(request.getGhiChu());

        ChiSoDienNuoc saved = chiSoDienNuocRepository.save(chiSo);
        if (request.getAnhDongHo() != null) {
            mediaService.replaceUrl(LoaiDoiTuongMedia.METER_READING, saved.getId(), request.getAnhDongHo(), MediaService.METER_IMAGE);
        }
        return mapToResponse(saved);
    }

    @Transactional
    public ChiSoDienNuocResponse update(UUID id, ChiSoDienNuocRequest request) {
        ChiSoDienNuoc chiSo = chiSoDienNuocRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy chỉ số"));

        if (chiSo.getTrangThai() == TrangThaiChiSo.BILLED && request.getTrangThai() != TrangThaiChiSo.CANCELLED) {
            throw new RuntimeException("Không thể sửa chỉ số đã được lập hóa đơn");
        }

        if (request.getChiSoMoi() < request.getChiSoCu()) {
            throw new RuntimeException("Chỉ số mới phải lớn hơn hoặc bằng chỉ số cũ");
        }

        if (request.getHopDongId() != null) {
            HopDong hopDong = hopDongRepository.findById(request.getHopDongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
            chiSo.setHopDong(hopDong);
        } else if (chiSo.getHopDong() == null && chiSo.getPhong() != null) {
            // Find active contract for the room
            List<HopDong> activeContracts = hopDongRepository.findRoomOccupyingContracts(chiSo.getPhong().getId(), List.of(com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE));
            if (!activeContracts.isEmpty()) {
                chiSo.setHopDong(activeContracts.get(0));
            }
        }

        chiSo.setLoai(request.getLoai());
        chiSo.setKyNam(request.getKyNam());
        chiSo.setKyThang(request.getKyThang());
        chiSo.setNgayGhi(request.getNgayGhi() != null ? request.getNgayGhi() : java.time.LocalDate.now());
        chiSo.setChiSoCu(request.getChiSoCu());
        chiSo.setChiSoMoi(request.getChiSoMoi());
        if (request.getTrangThai() != null) chiSo.setTrangThai(request.getTrangThai());
        chiSo.setGhiChu(request.getGhiChu());

        ChiSoDienNuoc saved = chiSoDienNuocRepository.save(chiSo);
        if (request.getAnhDongHo() != null) {
            mediaService.replaceUrl(LoaiDoiTuongMedia.METER_READING, saved.getId(), request.getAnhDongHo(), MediaService.METER_IMAGE);
        }
        return mapToResponse(saved);
    }

    @Transactional
    public void delete(UUID id) {
        ChiSoDienNuoc chiSo = chiSoDienNuocRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy chỉ số"));
        if (chiSo.getTrangThai() == TrangThaiChiSo.BILLED) {
            throw new RuntimeException("Không thể xóa chỉ số đã được lập hóa đơn. Chỉ có thể Hủy.");
        }
        chiSoDienNuocRepository.deleteById(id);
    }

    private ChiSoDienNuocResponse mapToResponse(ChiSoDienNuoc entity) {
        ChiSoDienNuocResponse response = new ChiSoDienNuocResponse();
        response.setId(entity.getId());

        if (entity.getPhong() != null) {
            response.setPhong(PhongResponse.builder()
                    .id(entity.getPhong().getId())
                    .ten(entity.getPhong().getTen())
                    .build());
        }

        if (entity.getHopDong() != null) {
            response.setHopDong(HopDongResponse.builder()
                    .id(entity.getHopDong().getId())
                    .maHopDong(entity.getHopDong().getMaHopDong())
                    .build());
        }

        response.setLoai(entity.getLoai());
        response.setKyNam(entity.getKyNam());
        response.setKyThang(entity.getKyThang());
        response.setNgayGhi(entity.getNgayGhi());
        response.setChiSoCu(entity.getChiSoCu());
        response.setChiSoMoi(entity.getChiSoMoi());
        response.setTieuThu(entity.getTieuThu());
        response.setAnhDongHo(mediaService.firstUrl(LoaiDoiTuongMedia.METER_READING, entity.getId(), MediaService.METER_IMAGE));
        response.setTrangThai(entity.getTrangThai());
        response.setGhiChu(entity.getGhiChu());
        response.setTaoLuc(entity.getTaoLuc());
        response.setCapNhatLuc(entity.getCapNhatLuc());

        return response;
    }
}
