package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class KhoTaiSanService {

    private final KhoTaiSanRepository khoTaiSanRepository;
    private final LichSuKhoTaiSanRepository lichSuKhoTaiSanRepository;
    private final NhaTroRepository nhaTroRepository;
    private final PhongRepository phongRepository;
    private final TaiSanPhongRepository taiSanPhongRepository;
    private final PermissionService permissionService;

    @Transactional(readOnly = true)
    public List<KhoTaiSanResponse> getAllByNhaTro(UUID nhaTroId) {
        return khoTaiSanRepository.findByNhaTroId(nhaTroId).stream()
                .map(this::mapToKhoTaiSanResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public KhoTaiSanResponse createKhoTaiSan(KhoTaiSanRequest request) {
        NhaTro nhaTro = nhaTroRepository.findById(request.getNhaTroId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));

        KhoTaiSan khoTaiSan = KhoTaiSan.builder()
                .nhaTro(nhaTro)
                .tenTaiSan(request.getTenTaiSan())
                .hinhAnh(request.getHinhAnh())
                .tongSoLuong(request.getTongSoLuong())
                .soLuongKhaDung(request.getTongSoLuong()) // Khi mới tạo, khả dụng = tổng
                .soLuongDaCapPhat(0)
                .soLuongHuHong(0)
                .tinhTrang(request.getTinhTrang())
                .ghiChu(request.getGhiChu())
                .build();

        khoTaiSan = khoTaiSanRepository.save(khoTaiSan);

        // Record history
        recordHistory(khoTaiSan, null, "NHAP_KHO", khoTaiSan.getTongSoLuong(), "Nhập kho ban đầu");

        return mapToKhoTaiSanResponse(khoTaiSan);
    }

    @Transactional
    public KhoTaiSanResponse updateKhoTaiSan(UUID id, KhoTaiSanRequest request) {
        KhoTaiSan khoTaiSan = khoTaiSanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài sản trong kho"));

        int diff = request.getTongSoLuong() - khoTaiSan.getTongSoLuong();
        if (diff < 0 && khoTaiSan.getSoLuongKhaDung() < Math.abs(diff)) {
            throw new RuntimeException("Không thể giảm tổng số lượng vì số lượng khả dụng không đủ");
        }

        khoTaiSan.setTenTaiSan(request.getTenTaiSan());
        khoTaiSan.setHinhAnh(request.getHinhAnh());
        khoTaiSan.setTongSoLuong(request.getTongSoLuong());
        khoTaiSan.setSoLuongKhaDung(khoTaiSan.getSoLuongKhaDung() + diff);
        khoTaiSan.setTinhTrang(request.getTinhTrang());
        khoTaiSan.setGhiChu(request.getGhiChu());

        khoTaiSan = khoTaiSanRepository.save(khoTaiSan);

        if (diff > 0) {
            recordHistory(khoTaiSan, null, "NHAP_KHO", diff, "Nhập thêm vào kho");
        } else if (diff < 0) {
            recordHistory(khoTaiSan, null, "XUAT_KHO", Math.abs(diff), "Xuất bớt khỏi kho");
        }

        return mapToKhoTaiSanResponse(khoTaiSan);
    }

    @Transactional
    public void deleteKhoTaiSan(UUID id) {
        KhoTaiSan khoTaiSan = khoTaiSanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài sản trong kho"));
        
        if (khoTaiSan.getSoLuongDaCapPhat() > 0) {
            throw new RuntimeException("Không thể xóa tài sản đã được cấp phát");
        }

        khoTaiSan.setXoaLuc(ZonedDateTime.now());
        khoTaiSanRepository.save(khoTaiSan);
    }

    @Transactional
    public void capPhatTaiSan(UUID khoTaiSanId, CapPhatTaiSanRequest request) {
        KhoTaiSan khoTaiSan = khoTaiSanRepository.findById(khoTaiSanId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài sản trong kho"));

        if (khoTaiSan.getSoLuongKhaDung() < request.getSoLuong()) {
            throw new RuntimeException("Số lượng khả dụng trong kho không đủ");
        }

        Phong phong = phongRepository.findById(request.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
        if (phong.getNhaTro() == null || !phong.getNhaTro().getId().equals(khoTaiSan.getNhaTro().getId())) {
            throw new RuntimeException("Phòng cấp phát phải thuộc cùng tòa nhà với tài sản trong kho");
        }

        // Update Kho
        khoTaiSan.setSoLuongKhaDung(khoTaiSan.getSoLuongKhaDung() - request.getSoLuong());
        khoTaiSan.setSoLuongDaCapPhat(khoTaiSan.getSoLuongDaCapPhat() + request.getSoLuong());
        khoTaiSanRepository.save(khoTaiSan);

        // Add to TaiSanPhong
        TaiSanPhong taiSanPhong = TaiSanPhong.builder()
                .phong(phong)
                .khoTaiSan(khoTaiSan)
                .tenTaiSan(khoTaiSan.getTenTaiSan())
                .soLuong(request.getSoLuong())
                .giaTri(request.getGiaTri())
                .tinhTrang(khoTaiSan.getTinhTrang())
                .anhTaiSan(khoTaiSan.getHinhAnh())
                .ghiChu(request.getGhiChu())
                .build();
        taiSanPhongRepository.save(taiSanPhong);

        // Record history
        recordHistory(khoTaiSan, phong, "CAP_PHAT", request.getSoLuong(), request.getGhiChu());
    }

    @Transactional
    public void thuHoiTaiSan(UUID khoTaiSanId, ThuHoiTaiSanRequest request) {
        KhoTaiSan khoTaiSan = khoTaiSanRepository.findById(khoTaiSanId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài sản trong kho"));

        Phong phong = phongRepository.findById(request.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));

        // Update Kho
        if (khoTaiSan.getSoLuongDaCapPhat() < request.getSoLuong()) {
            throw new RuntimeException("Số lượng thu hồi vượt quá số lượng đã cấp phát");
        }

        khoTaiSan.setSoLuongDaCapPhat(khoTaiSan.getSoLuongDaCapPhat() - request.getSoLuong());
        
        if (request.getKhaDung()) {
            khoTaiSan.setSoLuongKhaDung(khoTaiSan.getSoLuongKhaDung() + request.getSoLuong());
        } else {
            khoTaiSan.setSoLuongHuHong(khoTaiSan.getSoLuongHuHong() + request.getSoLuong());
        }
        
        khoTaiSanRepository.save(khoTaiSan);

        // Reduce or delete TaiSanPhong records
        List<TaiSanPhong> roomAssets = taiSanPhongRepository.findByPhongId(phong.getId()).stream()
                .filter(t -> t.getKhoTaiSan() != null && t.getKhoTaiSan().getId().equals(khoTaiSanId))
                .filter(t -> t.getXoaLuc() == null)
                .collect(Collectors.toList());

        int remainingToRevoke = request.getSoLuong();
        for (TaiSanPhong ts : roomAssets) {
            if (remainingToRevoke <= 0) break;
            if (ts.getSoLuong() <= remainingToRevoke) {
                remainingToRevoke -= ts.getSoLuong();
                ts.setXoaLuc(ZonedDateTime.now());
                ts.setSoLuong(0);
                taiSanPhongRepository.save(ts);
            } else {
                ts.setSoLuong(ts.getSoLuong() - remainingToRevoke);
                remainingToRevoke = 0;
                taiSanPhongRepository.save(ts);
            }
        }
        // Record history
        String loaiGD = request.getKhaDung() ? "THU_HOI_TOT" : "THU_HOI_HONG";
        recordHistory(khoTaiSan, phong, loaiGD, request.getSoLuong(), request.getGhiChu());
    }

    @Transactional(readOnly = true)
    public List<LichSuKhoTaiSanResponse> getLichSuGiaoDich(UUID khoTaiSanId) {
        return lichSuKhoTaiSanRepository.findByKhoTaiSanIdOrderByTaoLucDesc(khoTaiSanId).stream()
                .map(ls -> LichSuKhoTaiSanResponse.builder()
                        .id(ls.getId())
                        .khoTaiSanId(ls.getKhoTaiSan().getId())
                        .phongId(ls.getPhong() != null ? ls.getPhong().getId() : null)
                        .tenPhong(ls.getPhong() != null ? ls.getPhong().getTen() : null)
                        .loaiGiaoDich(ls.getLoaiGiaoDich())
                        .soLuong(ls.getSoLuong())
                        .ghiChu(ls.getGhiChu())
                        .taoLuc(ls.getTaoLuc())
                        .build())
                .collect(Collectors.toList());
    }

    private void recordHistory(KhoTaiSan kho, Phong phong, String loaiGiaoDich, int soLuong, String ghiChu) {
        LichSuKhoTaiSan ls = LichSuKhoTaiSan.builder()
                .khoTaiSan(kho)
                .phong(phong)
                .loaiGiaoDich(loaiGiaoDich)
                .soLuong(soLuong)
                .ghiChu(ghiChu)
                .build();
        lichSuKhoTaiSanRepository.save(ls);
    }

    private KhoTaiSanResponse mapToKhoTaiSanResponse(KhoTaiSan entity) {
        return KhoTaiSanResponse.builder()
                .id(entity.getId())
                .nhaTroId(entity.getNhaTro().getId())
                .tenNhaTro(entity.getNhaTro().getTen())
                .tenTaiSan(entity.getTenTaiSan())
                .hinhAnh(entity.getHinhAnh())
                .tongSoLuong(entity.getTongSoLuong())
                .soLuongKhaDung(entity.getSoLuongKhaDung())
                .soLuongDaCapPhat(entity.getSoLuongDaCapPhat())
                .soLuongHuHong(entity.getSoLuongHuHong())
                .tinhTrang(entity.getTinhTrang())
                .ghiChu(entity.getGhiChu())
                .build();
    }
}
