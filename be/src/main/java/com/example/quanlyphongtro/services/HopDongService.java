package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.dto.HopDongDichVuOptionResponse;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import org.springframework.transaction.annotation.Transactional;

import java.text.Normalizer;
import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HopDongService {
    private static final List<TrangThaiHopDong> OCCUPYING_STATUSES = List.of(TrangThaiHopDong.PENDING, TrangThaiHopDong.ACTIVE);

    private final HopDongRepository hopDongRepository;
    private final PhongRepository phongRepository;
    private final KhachThueRepository khachThueRepository;
    private final ThanhVienHopDongRepository thanhVienHopDongRepository;
    private final DichVuHopDongRepository dichVuHopDongRepository;
    private final DichVuRepository dichVuRepository;
    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final PermissionService permissionService;

    @Transactional(readOnly = true)
    public PaginatedResponse<HopDongResponse> getAll(
            String phongId, String toaNhaId, String trangThaiStr, String search, int page, int limit) {
        UUID userId = permissionService.requireCurrentUserId();
        boolean isAdmin = permissionService.isAdmin(userId);
        List<UUID> nhaTroIds = List.of();
        if (!isAdmin) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (!accessibleIds.isEmpty()) {
                nhaTroIds = accessibleIds;
            }
        }
        
        TrangThaiHopDong tt = null;
        if (trangThaiStr != null && !trangThaiStr.isBlank() && !trangThaiStr.equals("all")) {
            try { tt = TrangThaiHopDong.valueOf(trangThaiStr.toUpperCase()); } catch (Exception ignored) {}
        }
        
        UUID pid = parseOptionalUuid(phongId);
        UUID nid = parseOptionalUuid(toaNhaId);
        String normalizedSearch = search != null && !search.isBlank() ? search.trim() : null;

        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<HopDong> pageResult = hopDongRepository.findAllAccessible(
                isAdmin, userId, nhaTroIds, pid, nid, tt != null ? tt.name() : null, normalizedSearch, pageable);
        
        List<HopDongResponse> mappedList = pageResult.getContent().stream().map(this::toResponse).toList();
        return PaginatedResponse.of(pageResult, mappedList);
    }

    @Transactional(readOnly = true)
    public HopDongResponse getById(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        if (hd.getXoaLuc() != null) {
            throw new RuntimeException("Không tìm thấy hợp đồng");
        }
        assertCanRead(hd, permissionService.requireCurrentUserId());
        return toResponse(hd);
    }

    @Transactional
    public HopDongResponse create(HopDongRequest req) {
        UUID phongId = coalesce(req.getPhongId(), req.getPhong());
        if (phongId == null) {
            throw new RuntimeException("Vui lòng chọn phòng cho hợp đồng");
        }
        UUID khachThueId = resolveRepresentativeId(req);
        if (khachThueId == null) {
            throw new RuntimeException("Vui lòng chọn người đại diện hợp đồng");
        }

        Phong phong = phongRepository.findById(phongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
        assertCanWritePhong(phong, permissionService.requireCurrentUserId());

        KhachThue kt = khachThueRepository.findById(khachThueId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê"));
        TrangThaiHopDong trangThai = parseStatus(req.getTrangThai(), TrangThaiHopDong.DRAFT);
        validateRoomCanContract(phong, trangThai);
        validateTenantBelongsToRoomOwner(kt, phong);
        BigDecimal giaThue = firstMoney(req.getGiaThueHopDong(), req.getGiaThue(), phong.getGiaHienTai());
        BigDecimal tienCoc = firstMoney(req.getTienCoc(), phong.getTienCocMacDinh(), BigDecimal.ZERO);
        Integer ngayThanhToan = req.getNgayThanhToanHangThang() != null ? req.getNgayThanhToanHangThang()
                : (req.getNgayThanhToan() != null ? req.getNgayThanhToan() : 5);
        validateContractPayload(req.getNgayBatDau(), req.getNgayKetThuc(), giaThue, tienCoc, ngayThanhToan);
        validateInitialReadings(req.getChiSoDienBanDau(), req.getChiSoNuocBanDau());
        validateMemberPayload(req, phong, kt, req.getNgayBatDau(), req.getNgayKetThuc());
        ensureNoOverlappingOccupancy(phong.getId(), req.getNgayBatDau(), req.getNgayKetThuc(), null, trangThai);
        String maHopDong = resolveContractCode(req.getMaHopDong(), phong, req.getNgayBatDau());
        ensureContractCodeAvailable(maHopDong, null);

        HopDong hd = HopDong.builder()
                .maHopDong(maHopDong)
                .phong(phong)
                .khachThue(kt)
                .ngayBatDau(req.getNgayBatDau())
                .ngayKetThuc(req.getNgayKetThuc())
                .giaThueHopDong(giaThue)
                .tienCoc(tienCoc)
                .trangThaiCoc(parseCocStatus(req.getTrangThaiCoc()))
                .trangThai(trangThai)
                .chuKyThanhToan(parseChuKy(req.getChuKyThanhToan()))
                .ngayThanhToanHangThang(ngayThanhToan)
                .tuDongGiaHan(req.getTuDongGiaHan() != null ? req.getTuDongGiaHan() : false)
                .chiSoDienBanDau(req.getChiSoDienBanDau())
                .chiSoNuocBanDau(req.getChiSoNuocBanDau())
                .noiDungHopDong(req.getNoiDungHopDong() != null ? req.getNoiDungHopDong() : req.getDieuKhoan())
                .filePdf(req.getFilePdf())
                .ghiChu(req.getGhiChu())
                .build();

        HopDong saved = hopDongRepository.save(hd);
        replaceThanhVien(saved, req);
        replaceDichVuHopDong(saved, req);
        syncRoomStatus(phong.getId());
        return toResponse(saved);
    }

    @Transactional
    public HopDongResponse update(UUID id, HopDongRequest req) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWrite(hd, userId);

        UUID oldPhongId = hd.getPhong() != null ? hd.getPhong().getId() : null;
        UUID phongId = coalesce(req.getPhongId(), req.getPhong());
        UUID khachThueId = resolveRepresentativeId(req);
        if (phongId != null) {
            Phong newPhong = phongRepository.findById(phongId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
            assertCanWritePhong(newPhong, userId);
            hd.setPhong(newPhong);
        }
        if (khachThueId != null) {
            hd.setKhachThue(khachThueRepository.findById(khachThueId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê")));
        }
        if (req.getMaHopDong() != null)
            hd.setMaHopDong(resolveContractCode(req.getMaHopDong(), hd.getPhong(), hd.getNgayBatDau()));
        if (req.getNgayBatDau() != null)
            hd.setNgayBatDau(req.getNgayBatDau());
        if (req.getNgayKetThuc() != null)
            hd.setNgayKetThuc(req.getNgayKetThuc());
        if (req.getGiaThueHopDong() != null || req.getGiaThue() != null)
            hd.setGiaThueHopDong(req.getGiaThueHopDong() != null ? req.getGiaThueHopDong() : req.getGiaThue());
        if (req.getTienCoc() != null)
            hd.setTienCoc(req.getTienCoc());
        if (req.getTrangThaiCoc() != null)
            hd.setTrangThaiCoc(parseCocStatus(req.getTrangThaiCoc()));
        if (req.getChuKyThanhToan() != null)
            hd.setChuKyThanhToan(parseChuKy(req.getChuKyThanhToan()));
        if (req.getNgayThanhToanHangThang() != null || req.getNgayThanhToan() != null)
            hd.setNgayThanhToanHangThang(
                    req.getNgayThanhToanHangThang() != null ? req.getNgayThanhToanHangThang() : req.getNgayThanhToan());
        if (req.getTuDongGiaHan() != null)
            hd.setTuDongGiaHan(req.getTuDongGiaHan());
        if (req.getChiSoDienBanDau() != null)
            hd.setChiSoDienBanDau(req.getChiSoDienBanDau());
        if (req.getChiSoNuocBanDau() != null)
            hd.setChiSoNuocBanDau(req.getChiSoNuocBanDau());
        if (req.getNoiDungHopDong() != null || req.getDieuKhoan() != null)
            hd.setNoiDungHopDong(req.getNoiDungHopDong() != null ? req.getNoiDungHopDong() : req.getDieuKhoan());
        if (req.getFilePdf() != null)
            hd.setFilePdf(req.getFilePdf());
        if (req.getGhiChu() != null)
            hd.setGhiChu(req.getGhiChu());
        if (req.getTrangThai() != null) {
            TrangThaiHopDong newStatus = parseStatus(req.getTrangThai(), hd.getTrangThai());
            hd.setTrangThai(newStatus);
        }
        if (hd.getMaHopDong() == null || hd.getMaHopDong().isBlank()) {
            hd.setMaHopDong(resolveContractCode(null, hd.getPhong(), hd.getNgayBatDau()));
        }
        ensureContractCodeAvailable(hd.getMaHopDong(), hd.getId());
        validateRoomCanContract(hd.getPhong(), hd.getTrangThai());
        validateTenantBelongsToRoomOwner(hd.getKhachThue(), hd.getPhong());
        validateContractPayload(hd.getNgayBatDau(), hd.getNgayKetThuc(), hd.getGiaThueHopDong(), hd.getTienCoc(),
                hd.getNgayThanhToanHangThang());
        validateInitialReadings(hd.getChiSoDienBanDau(), hd.getChiSoNuocBanDau());
        if (req.hasMemberPayload()) {
            validateMemberPayload(req, hd.getPhong(), hd.getKhachThue(), hd.getNgayBatDau(), hd.getNgayKetThuc());
        }
        ensureNoOverlappingOccupancy(hd.getPhong().getId(), hd.getNgayBatDau(), hd.getNgayKetThuc(), hd.getId(),
                hd.getTrangThai());
        HopDong saved = hopDongRepository.save(hd);
        if (req.hasMemberPayload()) {
            replaceThanhVien(saved, req);
        }
        if (req.getPhiDichVu() != null) {
            replaceDichVuHopDong(saved, req);
        }
        if (oldPhongId != null && !oldPhongId.equals(saved.getPhong().getId())) {
            syncRoomStatus(oldPhongId);
        }
        syncRoomStatus(saved.getPhong().getId());
        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<HopDongDichVuOptionResponse> getDichVuTheoPhong(UUID phongId) {
        Phong phong = phongRepository.findById(phongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
        assertCanReadPhong(phong, permissionService.requireCurrentUserId());
        if (phong.getNhaTro() == null) {
            return List.of();
        }
        LocalDate today = LocalDate.now();
        Map<UUID, HopDongDichVuOptionResponse> options = new LinkedHashMap<>();

        if (phong.getNhaTro() != null && phong.getNhaTro().getChuTro() != null) {
            List<DichVu> defaultServices = dichVuRepository.findByChuTroId(phong.getNhaTro().getChuTro().getId());
            for (DichVu dv : defaultServices) {
                options.put(dv.getId(), HopDongDichVuOptionResponse.builder()
                        .dichVuId(dv.getId())
                        .ten(dv.getTenDichVu())
                        .loaiTinhPhi(dv.getLoaiTinhPhi() != null ? dv.getLoaiTinhPhi().name() : null)
                        .donVi(dv.getDonVi())
                        .donGiaMacDinh(dv.getDonGiaMacDinh())
                        .batBuoc(Boolean.TRUE.equals(dv.getBatBuoc()))
                        .build());
            }
        }

        for (CauHinhGia config : cauHinhGiaRepository.findApplicableServices(phong.getNhaTro().getId(), today)) {
            if (config.getDichVuId() == null)
                continue;
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
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        UUID phongId = hd.getPhong() != null ? hd.getPhong().getId() : null;
        hd.setXoaLuc(java.time.ZonedDateTime.now());
        hopDongRepository.save(hd);
        if (phongId != null) {
            syncRoomStatus(phongId);
        }
    }

    private void assertCanRead(HopDong hopDong, UUID userId) {
        if (!canReadHopDong(hopDong, userId)) {
            throw new RuntimeException("Ban khong co quyen xem hop dong nay");
        }
    }

    private void assertCanWrite(HopDong hopDong, UUID userId) {
        if (!canWriteHopDong(hopDong, userId)) {
            throw new RuntimeException("Ban khong co quyen sua hop dong nay");
        }
    }

    private boolean canReadHopDong(HopDong hopDong, UUID userId) {
        if (hopDong == null || userId == null || hopDong.getXoaLuc() != null) {
            return false;
        }
        if (permissionService.isAdmin(userId)) {
            return true;
        }
        KhachThue khachThue = hopDong.getKhachThue();
        if (khachThue != null && khachThue.getNguoiDung() != null && userId.equals(khachThue.getNguoiDung().getId())) {
            return true;
        }
        return canReadPhong(hopDong.getPhong(), userId);
    }

    private boolean canWriteHopDong(HopDong hopDong, UUID userId) {
        return hopDong != null && hopDong.getXoaLuc() == null && canWritePhong(hopDong.getPhong(), userId);
    }

    private void assertCanReadPhong(Phong phong, UUID userId) {
        if (!canReadPhong(phong, userId)) {
            throw new RuntimeException("Ban khong co quyen xem du lieu phong nay");
        }
    }

    private void assertCanWritePhong(Phong phong, UUID userId) {
        if (!canWritePhong(phong, userId)) {
            throw new RuntimeException("Ban khong co quyen sua hop dong trong nha tro nay");
        }
    }

    private boolean canReadPhong(Phong phong, UUID userId) {
        NhaTro nhaTro = phong != null ? phong.getNhaTro() : null;
        if (nhaTro == null || nhaTro.getId() == null) {
            return false;
        }
        return permissionService.canReadNhaTro(userId, nhaTro.getId(), ownerId(nhaTro));
    }

    private boolean canWritePhong(Phong phong, UUID userId) {
        NhaTro nhaTro = phong != null ? phong.getNhaTro() : null;
        if (nhaTro == null || nhaTro.getId() == null) {
            return false;
        }
        return permissionService.canWriteNhaTro(userId, nhaTro.getId(), ownerId(nhaTro));
    }

    private UUID ownerId(NhaTro nhaTro) {
        return nhaTro != null && nhaTro.getChuTro() != null ? nhaTro.getChuTro().getId() : null;
    }

    private TrangThaiHopDong parseStatus(String s, TrangThaiHopDong fallback) {
        if (s == null)
            return fallback != null ? fallback : TrangThaiHopDong.DRAFT;
        return switch (s.trim()) {
            case "nhap" -> TrangThaiHopDong.DRAFT;
            case "choKichHoat" -> TrangThaiHopDong.PENDING;
            case "hoatDong" -> TrangThaiHopDong.ACTIVE;
            case "hetHan" -> TrangThaiHopDong.EXPIRED;
            case "daKetThuc" -> TrangThaiHopDong.TERMINATED;
            case "daHuy" -> TrangThaiHopDong.CANCELLED;
            default -> {
                try {
                    yield TrangThaiHopDong.valueOf(s.trim().toUpperCase(Locale.ROOT));
                } catch (Exception e) {
                    throw new RuntimeException("Trạng thái hợp đồng không hợp lệ: " + s);
                }
            }
        };
    }

    private UUID parseOptionalUuid(String value) {
        if (value == null || value.isBlank() || "all".equalsIgnoreCase(value)) {
            return null;
        }
        try {
            return UUID.fromString(value);
        } catch (IllegalArgumentException ex) {
            throw new RuntimeException("ID khong hop le");
        }
    }

    private TrangThaiCocHopDong parseCocStatus(String s) {
        if (s == null)
            return TrangThaiCocHopDong.NOT_PAID;
        try {
            return TrangThaiCocHopDong.valueOf(s.trim().toUpperCase(Locale.ROOT));
        } catch (Exception e) {
            throw new RuntimeException("Trạng thái cọc hợp đồng không hợp lệ: " + s);
        }
    }

    private String parseChuKy(String value) {
        if (value == null || value.isBlank())
            return "MONTHLY";
        return switch (value.trim()) {
            case "thang" -> "MONTHLY";
            case "quy" -> "QUARTERLY";
            case "nam" -> "YEARLY";
            case "MONTHLY", "QUARTERLY", "YEARLY" -> value.trim().toUpperCase(Locale.ROOT);
            default -> throw new RuntimeException("Chu kỳ thanh toán không hợp lệ: " + value);
        };
    }

    private UUID coalesce(UUID first, UUID second) {
        return first != null ? first : second;
    }

    private UUID resolveRepresentativeId(HopDongRequest req) {
        if (req.getNguoiDaiDien() != null)
            return req.getNguoiDaiDien();
        if (req.getKhachThueId() != null)
            return req.getKhachThueId();
        if (req.getKhachThueIds() != null && !req.getKhachThueIds().isEmpty())
            return req.getKhachThueIds().get(0);
        return null;
    }

    @Transactional
    private void replaceThanhVien(HopDong hopDong, HopDongRequest req) {
        if (hopDong == null || hopDong.getId() == null)
            return;

        UUID representativeId = hopDong.getKhachThue() != null ? hopDong.getKhachThue().getId()
                : resolveRepresentativeId(req);
        Set<UUID> memberIds = new LinkedHashSet<>();
        if (representativeId != null)
            memberIds.add(representativeId);
        if (req.getKhachThueIds() != null)
            memberIds.addAll(req.getKhachThueIds());
        thanhVienHopDongRepository.deleteByHopDongId(hopDong.getId());
        thanhVienHopDongRepository.flush();
        LocalDate defaultNgayVao = hopDong.getNgayBatDau() != null ? hopDong.getNgayBatDau() : LocalDate.now();

        for (UUID memberId : memberIds) {
            KhachThue kt = khachThueRepository.findById(memberId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy thành viên hợp đồng"));
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

        if (req.getThanhVien() != null) {
            for (HopDongRequest.ThanhVienRequest member : req.getThanhVien()) {
                if (member == null || member.getKhachThueId() != null) continue;
                if (member.getHoTen() == null || member.getHoTen().isBlank()) continue;
                thanhVienHopDongRepository.save(com.example.quanlyphongtro.entity.ThanhVienHopDong.builder()
                        .hopDong(hopDong)
                        .khachThue(null)
                        .hoTen(member.getHoTen().trim())
                        .soCccd(member.getSoCccd())
                        .soDienThoai(member.getSoDienThoai())
                        .ngayVao(member.getNgayVao() != null ? member.getNgayVao() : defaultNgayVao)
                        .ngayRoi(member.getNgayRoi())
                        .dangO(member.getDangO() != null ? member.getDangO() : true)
                        .laNguoiDaiDien(false)
                        .ghiChu(member.getGhiChu())
                        .build());
            }
        }
    }

    @Transactional
    private void replaceDichVuHopDong(HopDong hopDong, HopDongRequest req) {
        if (hopDong == null || hopDong.getId() == null)
            return;
        dichVuHopDongRepository.deleteByHopDongId(hopDong.getId());
        dichVuHopDongRepository.flush();
        LocalDate defaultStart = hopDong.getNgayBatDau() != null ? hopDong.getNgayBatDau() : LocalDate.now();
        List<HopDongRequest.PhiDichVuItem> phiDichVu = mergeMandatoryServices(hopDong, req.getPhiDichVu());
        Set<UUID> savedDichVuIds = new LinkedHashSet<>();

        for (HopDongRequest.PhiDichVuItem item : phiDichVu) {
            DichVu dichVu = resolveDichVu(hopDong, item);
            if (dichVu == null)
                continue;
            if (!savedDichVuIds.add(dichVu.getId()))
                continue;
            LoaiTinhPhi loaiTinhPhi = parseLoaiTinhPhi(item.getLoaiTinhPhi(), dichVu.getLoaiTinhPhi());
            BigDecimal donGia = item.getGia() != null ? item.getGia() : defaultMoney(dichVu.getDonGiaMacDinh());
            BigDecimal soLuong = item.getSoLuong() != null ? item.getSoLuong() : BigDecimal.ONE;
            validateServiceCharge(dichVu.getTenDichVu(), donGia, soLuong);

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
        if (item == null)
            return null;
        if (item.getDichVuId() != null) {
            return dichVuRepository.findById(item.getDichVuId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ hợp đồng"));
        }
        if (item.getTen() == null || item.getTen().isBlank() || hopDong.getPhong() == null
                || hopDong.getPhong().getNhaTro() == null) {
            return null;
        }
        NguoiDung chuTro = hopDong.getPhong().getNhaTro().getChuTro();
        if (chuTro == null)
            return null;
        return dichVuRepository.findByChuTroIdAndTenDichVuIgnoreCase(chuTro.getId(), item.getTen())
                .orElseGet(() -> dichVuRepository.save(DichVu.builder()
                        .chuTro(chuTro)
                        .tenDichVu(item.getTen())
                        .loaiTinhPhi(parseLoaiTinhPhi(item.getLoaiTinhPhi(), LoaiTinhPhi.FIXED))
                        .donGiaMacDinh(item.getGia() != null ? item.getGia() : BigDecimal.ZERO)
                        .batBuoc(false)
                        .build()));
    }

    public HopDongResponse toResponse(HopDong hopDong) {
        HopDongResponse response = HopDongResponse.fromEntity(hopDong);
        List<com.example.quanlyphongtro.entity.ThanhVienHopDong> members = thanhVienHopDongRepository
                .findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(hopDong.getId());

        if (members.isEmpty() && hopDong.getKhachThue() != null) {
            List<HopDongResponse.PhiDichVuResponse> phiDichVu = mapPhiDichVu(hopDong.getId());
            response.setKhachThueId(List.of(KhachThueResponse.fromEntity(hopDong.getKhachThue())));
            response.setNguoiDaiDien(KhachThueResponse.fromEntity(hopDong.getKhachThue()));
            response.setKhachThueDaiDienId(hopDong.getKhachThue().getId());
            response.setThanhVien(List.of());
            response.setPhiDichVu(phiDichVu);
            applyMeterPrices(response, hopDong, phiDichVu);
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
        List<HopDongResponse.PhiDichVuResponse> phiDichVu = mapPhiDichVu(hopDong.getId());
        response.setPhiDichVu(phiDichVu);
        applyMeterPrices(response, hopDong, phiDichVu);
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

    private List<HopDongRequest.PhiDichVuItem> mergeMandatoryServices(HopDong hopDong, List<HopDongRequest.PhiDichVuItem> requestItems) {
        List<HopDongRequest.PhiDichVuItem> merged = new ArrayList<>();
        Set<UUID> includedIds = new LinkedHashSet<>();
        if (requestItems != null) {
            for (HopDongRequest.PhiDichVuItem item : requestItems) {
                if (item == null) continue;
                merged.add(item);
                if (item.getDichVuId() != null) includedIds.add(item.getDichVuId());
            }
        }
        if (hopDong.getPhong() == null || hopDong.getPhong().getNhaTro() == null) {
            return merged;
        }
        for (HopDongDichVuOptionResponse option : getDichVuTheoPhong(hopDong.getPhong().getId())) {
            if (!Boolean.TRUE.equals(option.getBatBuoc()) || option.getDichVuId() == null || includedIds.contains(option.getDichVuId())) {
                continue;
            }
            HopDongRequest.PhiDichVuItem item = new HopDongRequest.PhiDichVuItem();
            item.setDichVuId(option.getDichVuId());
            item.setTen(option.getTen());
            item.setGia(defaultMoney(option.getDonGiaMacDinh()));
            item.setSoLuong(BigDecimal.ONE);
            item.setLoaiTinhPhi(option.getLoaiTinhPhi());
            merged.add(item);
            includedIds.add(option.getDichVuId());
        }
        return merged;
    }

    private void applyMeterPrices(HopDongResponse response, HopDong hopDong, List<HopDongResponse.PhiDichVuResponse> phiDichVu) {
        response.setGiaDien(resolveMeterPrice(hopDong, phiDichVu, LoaiMucHoaDon.ELECTRICITY));
        response.setGiaNuoc(resolveMeterPrice(hopDong, phiDichVu, LoaiMucHoaDon.WATER));
    }

    private BigDecimal resolveMeterPrice(HopDong hopDong, List<HopDongResponse.PhiDichVuResponse> phiDichVu, LoaiMucHoaDon loai) {
        if (hopDong.getPhong() != null && hopDong.getPhong().getNhaTro() != null) {
            LocalDate ngayApDung = hopDong.getNgayBatDau() != null ? hopDong.getNgayBatDau() : LocalDate.now();
            List<CauHinhGia> configs = cauHinhGiaRepository.findApplicable(hopDong.getPhong().getNhaTro().getId(), loai, ngayApDung);
            if (!configs.isEmpty()) {
                return defaultMoney(configs.get(0).getDonGia());
            }
        }
        String keyword = loai == LoaiMucHoaDon.ELECTRICITY ? "dien" : "nuoc";
        String english = loai == LoaiMucHoaDon.ELECTRICITY ? "electricity" : "water";
        return phiDichVu.stream()
                .filter(item -> containsNormalized(item.getTen(), keyword) || containsNormalized(item.getTen(), english))
                .map(HopDongResponse.PhiDichVuResponse::getGia)
                .filter(value -> value != null && value.compareTo(BigDecimal.ZERO) >= 0)
                .findFirst()
                .orElse(BigDecimal.ZERO);
    }

    private boolean containsNormalized(String value, String keyword) {
        if (value == null || keyword == null) return false;
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('\u0111', 'd')
                .replace('\u0110', 'D')
                .toLowerCase(Locale.ROOT);
        return normalized.contains(keyword.toLowerCase(Locale.ROOT));
    }

    private LoaiTinhPhi parseLoaiTinhPhi(String value, LoaiTinhPhi fallback) {
        if (value == null || value.isBlank())
            return fallback != null ? fallback : LoaiTinhPhi.FIXED;
        try {
            return LoaiTinhPhi.valueOf(value.toUpperCase());
        } catch (Exception e) {
            return fallback != null ? fallback : LoaiTinhPhi.FIXED;
        }
    }

    private BigDecimal defaultMoney(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }

    private BigDecimal firstMoney(BigDecimal first, BigDecimal second, BigDecimal fallback) {
        if (first != null) return first;
        if (second != null) return second;
        return fallback != null ? fallback : BigDecimal.ZERO;
    }

    private void validateContractPayload(LocalDate ngayBatDau, LocalDate ngayKetThuc, BigDecimal giaThue,
            BigDecimal tienCoc, Integer ngayThanhToan) {
        if (ngayBatDau == null || ngayKetThuc == null) {
            throw new RuntimeException("Vui lòng nhập ngày bắt đầu và ngày kết thúc hợp đồng");
        }
        if (!ngayKetThuc.isAfter(ngayBatDau)) {
            throw new RuntimeException("Ngày kết thúc hợp đồng phải sau ngày bắt đầu");
        }
        if (giaThue == null || giaThue.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Giá thuê hợp đồng không hợp lệ");
        }
        if (tienCoc == null || tienCoc.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Tiền cọc hợp đồng không hợp lệ");
        }
        if (ngayThanhToan == null || ngayThanhToan < 1 || ngayThanhToan > 31) {
            throw new RuntimeException("Ngày thanh toán hằng tháng phải từ 1 đến 31");
        }
    }

    private void validateInitialReadings(Integer chiSoDien, Integer chiSoNuoc) {
        if (chiSoDien != null && chiSoDien < 0) {
            throw new RuntimeException("Chỉ số điện ban đầu không được âm");
        }
        if (chiSoNuoc != null && chiSoNuoc < 0) {
            throw new RuntimeException("Chỉ số nước ban đầu không được âm");
        }
    }

    private void validateRoomCanContract(Phong phong, TrangThaiHopDong trangThai) {
        if (phong == null || phong.getXoaLuc() != null) {
            throw new RuntimeException("Phòng không tồn tại hoặc đã bị xóa");
        }
        if (isOccupyingStatus(trangThai)
                && (phong.getTrangThai() == TrangThaiPhong.MAINTENANCE || phong.getTrangThai() == TrangThaiPhong.INACTIVE)) {
            throw new RuntimeException("Phòng đang bảo trì hoặc ngừng hoạt động, không thể tạo hợp đồng cho thuê");
        }
    }

    private void validateTenantBelongsToRoomOwner(KhachThue khachThue, Phong phong) {
        if (khachThue == null || khachThue.getXoaLuc() != null || Boolean.FALSE.equals(khachThue.getDangHoatDong())) {
            throw new RuntimeException("Khách thuê không tồn tại hoặc đã ngừng hoạt động");
        }
        UUID roomOwnerId = phong != null && phong.getNhaTro() != null && phong.getNhaTro().getChuTro() != null
                ? phong.getNhaTro().getChuTro().getId() : null;
        UUID tenantOwnerId = khachThue.getChuTro() != null ? khachThue.getChuTro().getId() : null;
        if (roomOwnerId != null && tenantOwnerId != null && !roomOwnerId.equals(tenantOwnerId)) {
            throw new RuntimeException("Khách thuê không thuộc cùng chủ trọ với phòng");
        }
    }

    private void validateMemberPayload(HopDongRequest req, Phong phong, KhachThue representative,
            LocalDate ngayBatDau, LocalDate ngayKetThuc) {
        Set<UUID> memberIds = resolveMemberIds(req, representative != null ? representative.getId() : null);
        for (UUID memberId : memberIds) {
            KhachThue member = khachThueRepository.findById(memberId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy thành viên hợp đồng"));
            validateTenantBelongsToRoomOwner(member, phong);
        }

        int externalActiveMembers = 0;
        if (req.getThanhVien() != null) {
            for (HopDongRequest.ThanhVienRequest member : req.getThanhVien()) {
                if (member == null || member.getKhachThueId() != null) continue;
                LocalDate ngayVao = member.getNgayVao() != null ? member.getNgayVao() : ngayBatDau;
                LocalDate ngayRoi = member.getNgayRoi();
                if (ngayVao == null) {
                    throw new RuntimeException("Ngày vào của thành viên không hợp lệ");
                }
                if (ngayRoi != null && ngayRoi.isBefore(ngayVao)) {
                    throw new RuntimeException("Ngày rời của thành viên phải sau ngày vào");
                }
                if (ngayBatDau != null && ngayVao.isBefore(ngayBatDau)) {
                    throw new RuntimeException("Ngày vào của thành viên không được trước ngày bắt đầu hợp đồng");
                }
                if (ngayKetThuc != null && ngayRoi != null && ngayRoi.isAfter(ngayKetThuc)) {
                    throw new RuntimeException("Ngày rời của thành viên không được sau ngày kết thúc hợp đồng");
                }
                if (Boolean.TRUE.equals(member.getDangO()) || member.getDangO() == null) {
                    externalActiveMembers++;
                }
            }
        }

        int totalActiveMembers = memberIds.size() + externalActiveMembers;
        if (phong != null && phong.getSoNguoiToiDa() != null && totalActiveMembers > phong.getSoNguoiToiDa()) {
            throw new RuntimeException("Số người trong hợp đồng vượt quá sức chứa tối đa của phòng");
        }
    }

    private Set<UUID> resolveMemberIds(HopDongRequest req, UUID representativeId) {
        Set<UUID> memberIds = new LinkedHashSet<>();
        if (representativeId != null) memberIds.add(representativeId);
        if (req.getKhachThueIds() != null) memberIds.addAll(req.getKhachThueIds());
        if (req.getKhachThueId() != null) memberIds.add(req.getKhachThueId());
        if (req.getNguoiDaiDien() != null) memberIds.add(req.getNguoiDaiDien());
        return memberIds;
    }

    private void validateServiceCharge(String tenDichVu, BigDecimal donGia, BigDecimal soLuong) {
        if (donGia == null || donGia.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Đơn giá dịch vụ không hợp lệ: " + tenDichVu);
        }
        if (soLuong == null || soLuong.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Số lượng dịch vụ không hợp lệ: " + tenDichVu);
        }
    }

    private String resolveContractCode(String raw, Phong phong, LocalDate ngayBatDau) {
        String normalized = raw != null ? raw.trim() : "";
        if (!normalized.isBlank()) {
            return normalized;
        }
        String roomPart = phong != null && phong.getTen() != null ? phong.getTen().trim() : "PHONG";
        roomPart = Normalizer.normalize(roomPart, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('\u0111', 'd')
                .replace('\u0110', 'D')
                .replaceAll("[^A-Za-z0-9]+", "-")
                .replaceAll("(^-|-$)", "")
                .toUpperCase(Locale.ROOT);
        if (roomPart.isBlank()) roomPart = "PHONG";
        LocalDate date = ngayBatDau != null ? ngayBatDau : LocalDate.now();
        return "HD-" + roomPart + "-" + date.getYear() + String.format("%02d", date.getMonthValue()) + "-"
                + UUID.randomUUID().toString().substring(0, 6).toUpperCase(Locale.ROOT);
    }

    private void ensureContractCodeAvailable(String maHopDong, UUID excludeId) {
        if (maHopDong == null || maHopDong.isBlank()) {
            throw new RuntimeException("Mã hợp đồng không hợp lệ");
        }
        boolean exists = excludeId == null
                ? hopDongRepository.existsByMaHopDong(maHopDong)
                : hopDongRepository.existsByMaHopDongAndIdNot(maHopDong, excludeId);
        if (exists) {
            throw new RuntimeException("Mã hợp đồng đã tồn tại");
        }
    }

    private void ensureNoOverlappingOccupancy(UUID phongId, LocalDate ngayBatDau, LocalDate ngayKetThuc, UUID excludeId,
            TrangThaiHopDong trangThai) {
        if (!isOccupyingStatus(trangThai)) return;
        List<HopDong> conflicts = hopDongRepository.findOverlappingRoomContracts(
                phongId, OCCUPYING_STATUSES, ngayBatDau, ngayKetThuc, excludeId);
        if (!conflicts.isEmpty()) {
            throw new RuntimeException("Phòng này đã có hợp đồng chờ kích hoạt hoặc đang hoạt động trong khoảng thời gian này");
        }
    }

    private boolean isOccupyingStatus(TrangThaiHopDong trangThai) {
        return trangThai == TrangThaiHopDong.PENDING || trangThai == TrangThaiHopDong.ACTIVE;
    }

    private void syncRoomStatus(UUID phongId) {
        if (phongId == null) return;
        Phong phong = phongRepository.findById(phongId).orElse(null);
        if (phong == null || phong.getXoaLuc() != null) return;
        if (phong.getTrangThai() == TrangThaiPhong.MAINTENANCE || phong.getTrangThai() == TrangThaiPhong.INACTIVE) {
            return;
        }

        List<HopDong> occupying = hopDongRepository.findRoomOccupyingContracts(phongId, OCCUPYING_STATUSES).stream()
                .sorted(Comparator.comparing((HopDong hd) -> hd.getTrangThai() == TrangThaiHopDong.ACTIVE ? 0 : 1)
                        .thenComparing(HopDong::getNgayBatDau, Comparator.nullsLast(Comparator.reverseOrder())))
                .toList();
        if (occupying.stream().anyMatch(hd -> hd.getTrangThai() == TrangThaiHopDong.ACTIVE)) {
            phong.setTrangThai(TrangThaiPhong.RENTED);
        } else if (!occupying.isEmpty()) {
            phong.setTrangThai(TrangThaiPhong.RESERVED);
        } else if (phong.getTrangThai() == TrangThaiPhong.RENTED || phong.getTrangThai() == TrangThaiPhong.RESERVED) {
            phong.setTrangThai(TrangThaiPhong.AVAILABLE);
        }
        phongRepository.save(phong);
    }

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;

    private void logAudit(HopDong hd, String hanhDong) {
        if (auditLogRepository == null) return;
        com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
            .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .hanhDong(hanhDong)
            .bangTacDong("hop_dong")
            .banGhiId(hd.getId())
            .taoLuc(java.time.ZonedDateTime.now())
            .build();
        auditLogRepository.save(log);
    }

    @Transactional
    public com.example.quanlyphongtro.dto.HopDongResponse terminateContract(java.util.UUID id, com.example.quanlyphongtro.dto.KetThucHopDongRequest req) {
        HopDong hd = hopDongRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay hop dong"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        
        hd.setTrangThai(TrangThaiHopDong.TERMINATED);
        hd.setNgayKetThucThucTe(req.getNgayKetThucThucTe() != null ? req.getNgayKetThucThucTe() : java.time.LocalDate.now());
        if (req.getTrangThaiCoc() != null) {
            hd.setTrangThaiCoc(parseCocStatus(req.getTrangThaiCoc()));
        }
        if (req.getGhiChu() != null) {
            hd.setGhiChu(req.getGhiChu());
        }
        hd = hopDongRepository.save(hd);
        syncRoomStatus(hd.getPhong().getId());
        logAudit(hd, "TERMINATE");
        return com.example.quanlyphongtro.dto.HopDongResponse.fromEntity(hd);
    }

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.PhuLucHopDongRepository phuLucHopDongRepository;

    @Transactional
    public com.example.quanlyphongtro.dto.HopDongResponse extendContract(java.util.UUID id, com.example.quanlyphongtro.dto.GiaHanHopDongRequest req) {
        HopDong hd = hopDongRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay hop dong"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        
        if (req.getNgayKetThucMoi() == null) {
            throw new RuntimeException("Ngay ket thuc moi khong duoc de trong");
        }
        if (req.getNgayHieuLuc() == null) {
            throw new RuntimeException("Ngay hieu luc khong duoc de trong");
        }
        if (req.getNgayKetThucMoi().isBefore(hd.getNgayBatDau())) {
            throw new RuntimeException("Ngay ket thuc phai sau ngay bat dau");
        }
        
        ensureNoOverlappingOccupancy(hd.getPhong().getId(), hd.getNgayBatDau(), req.getNgayKetThucMoi(), id, hd.getTrangThai());

        com.example.quanlyphongtro.entity.PhuLucHopDong pl = com.example.quanlyphongtro.entity.PhuLucHopDong.builder()
            .hopDong(hd)
            .loai("GIA_HAN")
            .noiDung(req.getNoiDung() != null ? req.getNoiDung() : "Gia han hop dong")
            .ngayHieuLuc(req.getNgayHieuLuc())
            .ngayKetThucMoi(req.getNgayKetThucMoi())
            .giaThueMoi(req.getGiaThueMoi())
            .nguoiTao(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .build();
        phuLucHopDongRepository.save(pl);

        hd.setNgayKetThuc(req.getNgayKetThucMoi());
        if (req.getGiaThueMoi() != null) {
            hd.setGiaThueHopDong(req.getGiaThueMoi());
        }
        hd = hopDongRepository.save(hd);
        logAudit(hd, "EXTEND");
        
        return com.example.quanlyphongtro.dto.HopDongResponse.fromEntity(hd);
    }
}
