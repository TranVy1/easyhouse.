package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.dto.HopDongDichVuOptionResponse;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HopDongService {

    private final HopDongRepository hopDongRepository;
    private final PhongRepository phongRepository;
    private final KhachThueRepository khachThueRepository;
    private final ThanhVienHopDongRepository thanhVienHopDongRepository;
    private final DichVuHopDongRepository dichVuHopDongRepository;
    private final DichVuRepository dichVuRepository;
    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final TienIchService tienIchService;

    @Transactional(readOnly = true)
    public List<HopDongResponse> getAll() {
        return hopDongRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public HopDongResponse getById(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay hop dong"));
        return toResponse(hd);
    }

    @Transactional
    public HopDongResponse create(HopDongRequest req) {
        UUID phongId = coalesce(req.getPhongId(), req.getPhong());
        UUID khachThueId = resolveRepresentativeId(req);
        if (khachThueId == null) {
            throw new RuntimeException("Vui long chon nguoi dai dien hop dong");
        }

        Phong phong = phongRepository.findById(phongId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay phong"));

        hopDongRepository.findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(phongId, TrangThaiHopDong.ACTIVE)
                .ifPresent(existing -> {
                    throw new RuntimeException("Phong nay da co hop dong dang hoat dong");
                });

        KhachThue kt = khachThueRepository.findById(khachThueId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay khach thue"));

        List<String> tienIchHienTai = tienIchService.listByPhong(phongId);
        String snapshotTienIch = String.join(", ", tienIchHienTai);

        HopDong hd = HopDong.builder()
                .maHopDong(req.getMaHopDong())
                .phong(phong)
                .khachThue(kt)
                .ngayBatDau(req.getNgayBatDau())
                .ngayKetThuc(req.getNgayKetThuc())
                .giaThueHopDong(req.getGiaThueHopDong() != null ? req.getGiaThueHopDong() : req.getGiaThue())
                .tienCoc(req.getTienCoc())
                .trangThaiCoc(parseCocStatus(req.getTrangThaiCoc()))
                .trangThai(parseStatus(req.getTrangThai()))
                .chuKyThanhToan(parseChuKy(req.getChuKyThanhToan()))
                .ngayThanhToanHangThang(req.getNgayThanhToanHangThang() != null ? req.getNgayThanhToanHangThang() : (req.getNgayThanhToan() != null ? req.getNgayThanhToan() : 5))
                .tuDongGiaHan(req.getTuDongGiaHan() != null ? req.getTuDongGiaHan() : false)
                .chiSoDienBanDau(req.getChiSoDienBanDau())
                .chiSoNuocBanDau(req.getChiSoNuocBanDau())
                .tienIchBanGiao(snapshotTienIch)
                .noiDungHopDong(req.getNoiDungHopDong() != null ? req.getNoiDungHopDong() : req.getDieuKhoan())
                .filePdf(req.getFilePdf())
                .ghiChu(req.getGhiChu())
                .build();

        HopDong saved = hopDongRepository.save(hd);
        replaceThanhVien(saved, req);
        replaceDichVuHopDong(saved, req);
        phong.setTrangThai(TrangThaiPhong.RENTED);
        phongRepository.save(phong);
        return toResponse(saved);
    }

    @Transactional
    public HopDongResponse update(UUID id, HopDongRequest req) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay hop dong"));

        UUID phongId = coalesce(req.getPhongId(), req.getPhong());
        UUID khachThueId = resolveRepresentativeId(req);
        if (phongId != null) {
            hd.setPhong(phongRepository.findById(phongId)
                    .orElseThrow(() -> new RuntimeException("Khong tim thay phong")));
        }
        if (khachThueId != null) {
            hd.setKhachThue(khachThueRepository.findById(khachThueId)
                    .orElseThrow(() -> new RuntimeException("Khong tim thay khach thue")));
        }
        if (req.getMaHopDong() != null) hd.setMaHopDong(req.getMaHopDong());
        if (req.getNgayBatDau() != null) hd.setNgayBatDau(req.getNgayBatDau());
        if (req.getNgayKetThuc() != null) hd.setNgayKetThuc(req.getNgayKetThuc());
        if (req.getGiaThueHopDong() != null || req.getGiaThue() != null)
            hd.setGiaThueHopDong(req.getGiaThueHopDong() != null ? req.getGiaThueHopDong() : req.getGiaThue());
        if (req.getTienCoc() != null) hd.setTienCoc(req.getTienCoc());
        if (req.getTrangThaiCoc() != null) hd.setTrangThaiCoc(parseCocStatus(req.getTrangThaiCoc()));
        if (req.getChuKyThanhToan() != null) hd.setChuKyThanhToan(parseChuKy(req.getChuKyThanhToan()));
        if (req.getNgayThanhToanHangThang() != null || req.getNgayThanhToan() != null)
            hd.setNgayThanhToanHangThang(req.getNgayThanhToanHangThang() != null ? req.getNgayThanhToanHangThang() : req.getNgayThanhToan());
        if (req.getTuDongGiaHan() != null) hd.setTuDongGiaHan(req.getTuDongGiaHan());
        if (req.getChiSoDienBanDau() != null) hd.setChiSoDienBanDau(req.getChiSoDienBanDau());
        if (req.getChiSoNuocBanDau() != null) hd.setChiSoNuocBanDau(req.getChiSoNuocBanDau());
        if (req.getNoiDungHopDong() != null || req.getDieuKhoan() != null)
            hd.setNoiDungHopDong(req.getNoiDungHopDong() != null ? req.getNoiDungHopDong() : req.getDieuKhoan());
        if (req.getFilePdf() != null) hd.setFilePdf(req.getFilePdf());
        if (req.getGhiChu() != null) hd.setGhiChu(req.getGhiChu());
        if (req.getTrangThai() != null) {
            TrangThaiHopDong newStatus = parseStatus(req.getTrangThai());
            hd.setTrangThai(newStatus);
            if (newStatus == TrangThaiHopDong.TERMINATED || newStatus == TrangThaiHopDong.CANCELLED) {
                Phong phong = hd.getPhong();
                phong.setTrangThai(TrangThaiPhong.AVAILABLE);
                phongRepository.save(phong);
            }
        }
        HopDong saved = hopDongRepository.save(hd);
        if (req.hasMemberPayload()) {
            replaceThanhVien(saved, req);
        }
        if (req.getPhiDichVu() != null) {
            replaceDichVuHopDong(saved, req);
        }
        return toResponse(saved);
    }

    public List<HopDongDichVuOptionResponse> getDichVuTheoPhong(UUID phongId) {
        Phong phong = phongRepository.findById(phongId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        LocalDate today = LocalDate.now();
        Map<UUID, HopDongDichVuOptionResponse> options = new LinkedHashMap<>();

        for (CauHinhGia config : cauHinhGiaRepository.findApplicableServices(phong.getNhaTro().getId(), today)) {
            if (config.getDichVuId() == null || options.containsKey(config.getDichVuId())) continue;
            DichVu dichVu = dichVuRepository.findById(config.getDichVuId()).orElse(null);
            options.put(config.getDichVuId(), HopDongDichVuOptionResponse.builder()
                    .dichVuId(config.getDichVuId())
                    .ten(config.getTenHienThi())
                    .loaiTinhPhi(config.getLoaiTinhPhi() != null ? config.getLoaiTinhPhi().name() : null)
                    .donVi(dichVu != null ? dichVu.getDonVi() : null)
                    .donGiaMacDinh(config.getDonGia())
                    .batBuoc(dichVu != null && Boolean.TRUE.equals(dichVu.getBatBuoc()))
                    .build());
        }

        return new ArrayList<>(options.values());
    }

    @Transactional
    public void delete(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay hop dong"));
        if (hd.getTrangThai() == TrangThaiHopDong.ACTIVE) {
            Phong phong = hd.getPhong();
            phong.setTrangThai(TrangThaiPhong.AVAILABLE);
            phongRepository.save(phong);
        }
        hd.setXoaLuc(java.time.ZonedDateTime.now());
        hopDongRepository.save(hd);
    }

    private TrangThaiHopDong parseStatus(String s) {
        if (s == null) return TrangThaiHopDong.ACTIVE;
        return switch (s) {
            case "hoatDong" -> TrangThaiHopDong.ACTIVE;
            case "hetHan" -> TrangThaiHopDong.EXPIRED;
            case "daHuy" -> TrangThaiHopDong.CANCELLED;
            default -> {
                try { yield TrangThaiHopDong.valueOf(s.toUpperCase()); } catch (Exception e) { yield TrangThaiHopDong.ACTIVE; }
            }
        };
    }

    private TrangThaiCocHopDong parseCocStatus(String s) {
        if (s == null) return TrangThaiCocHopDong.NOT_PAID;
        try { return TrangThaiCocHopDong.valueOf(s.toUpperCase()); } catch (Exception e) { return TrangThaiCocHopDong.NOT_PAID; }
    }

    private String parseChuKy(String value) {
        if (value == null || value.isBlank()) return "MONTHLY";
        return switch (value) {
            case "thang" -> "MONTHLY";
            case "quy" -> "QUARTERLY";
            case "nam" -> "YEARLY";
            default -> value.toUpperCase();
        };
    }

    private UUID coalesce(UUID first, UUID second) {
        return first != null ? first : second;
    }

    private UUID resolveRepresentativeId(HopDongRequest req) {
        if (req.getNguoiDaiDien() != null) return req.getNguoiDaiDien();
        if (req.getKhachThueId() != null) return req.getKhachThueId();
        if (req.getKhachThueIds() != null && !req.getKhachThueIds().isEmpty()) return req.getKhachThueIds().get(0);
        return null;
    }

    @Transactional
    private void replaceThanhVien(HopDong hopDong, HopDongRequest req) {
        if (hopDong == null || hopDong.getId() == null) return;

        UUID representativeId = hopDong.getKhachThue() != null ? hopDong.getKhachThue().getId() : resolveRepresentativeId(req);
        Set<UUID> memberIds = new LinkedHashSet<>();
        if (representativeId != null) memberIds.add(representativeId);
        if (req.getKhachThueIds() != null) memberIds.addAll(req.getKhachThueIds());
        if (req.getThanhVien() != null) {
            req.getThanhVien().stream()
                    .map(HopDongRequest.ThanhVienRequest::getKhachThueId)
                    .filter(id -> id != null)
                    .forEach(memberIds::add);
        }

        thanhVienHopDongRepository.deleteByHopDongId(hopDong.getId());
        LocalDate defaultNgayVao = hopDong.getNgayBatDau() != null ? hopDong.getNgayBatDau() : LocalDate.now();

        for (UUID memberId : memberIds) {
            KhachThue kt = khachThueRepository.findById(memberId)
                    .orElseThrow(() -> new RuntimeException("Khong tim thay thanh vien hop dong"));
            thanhVienHopDongRepository.save(com.example.quanlyphongtro.entity.ThanhVienHopDong.builder()
                    .hopDong(hopDong)
                    .khachThue(kt)
                    .hoTen(kt.getHoTen())
                    .soCccd(kt.getSoCccd())
                    .soDienThoai(kt.getSoDienThoai())
                    .ngayVao(defaultNgayVao)
                    .dangO(true)
                    .laNguoiDaiDien(memberId.equals(representativeId))
                    .build());
        }
    }

    @Transactional
    private void replaceDichVuHopDong(HopDong hopDong, HopDongRequest req) {
        if (hopDong == null || hopDong.getId() == null || req.getPhiDichVu() == null) return;
        dichVuHopDongRepository.deleteByHopDongId(hopDong.getId());
        LocalDate defaultStart = hopDong.getNgayBatDau() != null ? hopDong.getNgayBatDau() : LocalDate.now();

        for (HopDongRequest.PhiDichVuItem item : req.getPhiDichVu()) {
            DichVu dichVu = resolveDichVu(hopDong, item);
            if (dichVu == null) continue;
            LoaiTinhPhi loaiTinhPhi = parseLoaiTinhPhi(item.getLoaiTinhPhi(), dichVu.getLoaiTinhPhi());
            BigDecimal donGia = item.getGia() != null ? item.getGia() : defaultMoney(dichVu.getDonGiaMacDinh());
            BigDecimal soLuong = item.getSoLuong() != null ? item.getSoLuong() : BigDecimal.ONE;

            dichVuHopDongRepository.save(DichVuHopDong.builder()
                    .hopDong(hopDong)
                    .dichVu(dichVu)
                    .loaiTinhPhi(loaiTinhPhi)
                    .donGiaApDung(donGia)
                    .soLuong(soLuong)
                    .batDauTu(item.getBatDauTu() != null ? item.getBatDauTu() : defaultStart)
                    .ketThucLuc(item.getKetThucLuc())
                    .build());
        }
    }

    private DichVu resolveDichVu(HopDong hopDong, HopDongRequest.PhiDichVuItem item) {
        if (item == null) return null;
        if (item.getDichVuId() != null) {
            return dichVuRepository.findById(item.getDichVuId())
                    .orElseThrow(() -> new RuntimeException("Khong tim thay dich vu hop dong"));
        }
        if (item.getTen() == null || item.getTen().isBlank() || hopDong.getPhong() == null || hopDong.getPhong().getNhaTro() == null) {
            return null;
        }
        NguoiDung chuTro = hopDong.getPhong().getNhaTro().getChuTro();
        if (chuTro == null) return null;
        return dichVuRepository.findByChuTroIdAndTenDichVuIgnoreCase(chuTro.getId(), item.getTen())
                .orElseGet(() -> dichVuRepository.save(DichVu.builder()
                        .chuTro(chuTro)
                        .tenDichVu(item.getTen())
                        .loaiTinhPhi(parseLoaiTinhPhi(item.getLoaiTinhPhi(), LoaiTinhPhi.FIXED))
                        .donGiaMacDinh(item.getGia() != null ? item.getGia() : BigDecimal.ZERO)
                        .batBuoc(false)
                        .build()));
    }

    private HopDongResponse toResponse(HopDong hopDong) {
        HopDongResponse response = HopDongResponse.fromEntity(hopDong);
        List<com.example.quanlyphongtro.entity.ThanhVienHopDong> members =
                thanhVienHopDongRepository.findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(hopDong.getId());

        if (members.isEmpty() && hopDong.getKhachThue() != null) {
            response.setKhachThueId(List.of(KhachThueResponse.fromEntity(hopDong.getKhachThue())));
            response.setNguoiDaiDien(KhachThueResponse.fromEntity(hopDong.getKhachThue()));
            response.setKhachThueDaiDienId(hopDong.getKhachThue().getId());
            response.setThanhVien(List.of());
            response.setPhiDichVu(mapPhiDichVu(hopDong.getId()));
            return response;
        }

        List<KhachThueResponse> tenants = new ArrayList<>();
        List<HopDongResponse.ThanhVienHopDongResponse> memberResponses = new ArrayList<>();
        KhachThueResponse representative = null;
        UUID representativeId = null;

        for (com.example.quanlyphongtro.entity.ThanhVienHopDong member : members) {
            if (member.getKhachThue() != null) {
                KhachThueResponse tenant = KhachThueResponse.fromEntity(member.getKhachThue());
                tenants.add(tenant);
                if (Boolean.TRUE.equals(member.getLaNguoiDaiDien())) {
                    representative = tenant;
                    representativeId = member.getKhachThue().getId();
                }
            }
            memberResponses.add(HopDongResponse.ThanhVienHopDongResponse.builder()
                    .id(member.getId())
                    .hopDongId(hopDong.getId())
                    .khachThueId(member.getKhachThue() != null ? member.getKhachThue().getId() : null)
                    .hoTen(member.getHoTen())
                    .soCccd(member.getSoCccd())
                    .soDienThoai(member.getSoDienThoai())
                    .ngayVao(member.getNgayVao())
                    .ngayRoi(member.getNgayRoi())
                    .dangO(member.getDangO())
                    .laNguoiDaiDien(member.getLaNguoiDaiDien())
                    .ghiChu(member.getGhiChu())
                    .build());
        }

        if (representative == null && hopDong.getKhachThue() != null) {
            representative = KhachThueResponse.fromEntity(hopDong.getKhachThue());
            representativeId = hopDong.getKhachThue().getId();
        }

        response.setKhachThueId(tenants);
        response.setNguoiDaiDien(representative);
        response.setKhachThueDaiDienId(representativeId);
        response.setThanhVien(memberResponses);
        response.setPhiDichVu(mapPhiDichVu(hopDong.getId()));
        return response;
    }

    private List<HopDongResponse.PhiDichVuResponse> mapPhiDichVu(UUID hopDongId) {
        return dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(hopDongId).stream()
                .map(item -> HopDongResponse.PhiDichVuResponse.builder()
                        .id(item.getId())
                        .dichVuId(item.getDichVu() != null ? item.getDichVu().getId() : null)
                        .ten(item.getDichVu() != null ? item.getDichVu().getTenDichVu() : "")
                        .gia(item.getDonGiaApDung())
                        .soLuong(item.getSoLuong())
                        .loaiTinhPhi(item.getLoaiTinhPhi() != null ? item.getLoaiTinhPhi().name() : null)
                        .donVi(item.getDichVu() != null ? item.getDichVu().getDonVi() : null)
                        .batDauTu(item.getBatDauTu())
                        .ketThucLuc(item.getKetThucLuc())
                        .build())
                .toList();
    }

    private LoaiTinhPhi parseLoaiTinhPhi(String value, LoaiTinhPhi fallback) {
        if (value == null || value.isBlank()) return fallback != null ? fallback : LoaiTinhPhi.FIXED;
        try { return LoaiTinhPhi.valueOf(value.toUpperCase()); } catch (Exception e) { return fallback != null ? fallback : LoaiTinhPhi.FIXED; }
    }

    private BigDecimal defaultMoney(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }
}
