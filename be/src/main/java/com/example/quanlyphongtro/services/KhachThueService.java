package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.KhachThueRequest;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import java.time.ZonedDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
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
public class KhachThueService {

    private final KhachThueRepository khachThueRepository;
    private final HopDongRepository hopDongRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final MediaService mediaService;
    private final PermissionService permissionService;
    private final PasswordEncoder passwordEncoder;

    public PaginatedResponse<KhachThueResponse> getAllKhachThue(String trangThai, String search, int page, int limit) {
        UUID userId = permissionService.requireCurrentUserId();
        boolean isAdmin = permissionService.isAdmin(userId);
        List<UUID> nhaTroIds = List.of(UUID.randomUUID());
        if (!isAdmin) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (!accessibleIds.isEmpty()) {
                nhaTroIds = accessibleIds;
            }
        }
        
        String filterTrangThai = (trangThai == null || trangThai.isBlank() || trangThai.equals("all")) ? null : trangThai;
        String normalizedSearch = search != null && !search.isBlank() ? search.trim() : "";

        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<KhachThue> pageResult = khachThueRepository.findAllAccessible(
                isAdmin, userId, nhaTroIds, filterTrangThai, normalizedSearch, pageable);
        
        // We still need active contracts to map correctly
        List<UUID> ktIds = pageResult.getContent().stream().map(KhachThue::getId).toList();
        List<HopDong> activeContracts = ktIds.isEmpty() ? List.of() : hopDongRepository.findAllActive().stream().filter(hd -> hd.getKhachThue() != null && ktIds.contains(hd.getKhachThue().getId())).toList();
        Map<UUID, HopDong> tenantContractMap = activeContracts.stream()
                .collect(Collectors.toMap(
                        hd -> hd.getKhachThue().getId(),
                        hd -> hd,
                        (first, second) -> first,
                        HashMap::new));

        List<KhachThueResponse> mappedList = pageResult.getContent().stream().map(kt -> {
            KhachThueResponse res = KhachThueResponse.fromEntity(kt);
            mapMedia(res, kt.getId());
            HopDong hd = tenantContractMap.get(kt.getId());
            if (hd != null) mapContractInfo(res, hd);
            return res;
        }).toList();
        
        return PaginatedResponse.of(pageResult, mappedList);
    }

    public KhachThueResponse getKhachThueById(UUID id) {
        KhachThue kt = khachThueRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay khach thue"));
        HopDong activeContract = findActiveContract(id);
        assertCanRead(kt, activeContract, permissionService.requireCurrentUserId());

        KhachThueResponse res = KhachThueResponse.fromEntity(kt);
        mapMedia(res, kt.getId());
        
        List<HopDong> allContracts = hopDongRepository.findByKhachThueIdAndXoaLucIsNull(id);
        if (!allContracts.isEmpty()) {
            List<KhachThueResponse.CurrentContractResponse> history = allContracts.stream()
                .map(this::toContractResponse)
                .toList();
            res.setLichSuThue(history);
        }
        
        if (activeContract != null) {
            res.setHopDongHienTai(toContractResponse(activeContract));
            res.setTrangThai("dangThue");
        }
        
        return res;
    }

    @Transactional
    public KhachThueResponse createKhachThue(KhachThueRequest req) {
        if (req.getHoTen() == null || req.getHoTen().trim().isEmpty()) {
            throw new RuntimeException("Họ tên không được để trống");
        }
        UUID userId = permissionService.requireCurrentUserId();
        NguoiDung owner = resolveOwnerForCreate(req, userId);

        KhachThue kt = KhachThue.builder()
                .chuTro(owner)
                .hoTen(req.getHoTen())
                .soDienThoai(req.getSoDienThoai())
                .email(req.getEmail())
                .soCccd(firstNonBlank(req.getSoCccd(), req.getCccd()))
                .ngaySinh(req.getNgaySinh())
                .gioiTinh(req.getGioiTinh())
                .diaChi(req.getDiaChi())
                .queQuan(req.getQueQuan())
                .ngheNghiep(req.getNgheNghiep())
                .ghiChu(req.getGhiChu())
                .dangHoatDong(true)
                .build();

        if (req.getNguoiDungId() != null) {
            NguoiDung nd = nguoiDungRepository.findById(req.getNguoiDungId())
                    .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung"));
            kt.setNguoiDung(nd);
        } else if (req.getSoDienThoai() != null && !req.getSoDienThoai().isBlank()) {
            NguoiDung nd = nguoiDungRepository.findBySoDienThoai(req.getSoDienThoai()).orElse(null);
            if (nd == null) {
                String ndEmail = req.getEmail();
                if (ndEmail == null || ndEmail.isBlank()) {
                    ndEmail = "tenant_" + req.getSoDienThoai() + "@easyhouse.local";
                }
                nd = NguoiDung.builder()
                        .id(UUID.randomUUID())
                        .hoTen(req.getHoTen())
                        .soDienThoai(req.getSoDienThoai())
                        .email(ndEmail)
                        .matKhau(passwordEncoder.encode("123456"))
                        .trangThai(com.example.quanlyphongtro.entity.TrangThaiNguoiDung.ACTIVE)
                        .soLanDangNhapSai(0)
                        .soCccd(firstNonBlank(req.getSoCccd(), req.getCccd()))
                        .ngaySinh(req.getNgaySinh())
                        .gioiTinh(req.getGioiTinh())
                        .diaChi(req.getDiaChi())
                        .queQuan(req.getQueQuan())
                        .build();
                nd = nguoiDungRepository.save(nd);
            }
            kt.setNguoiDung(nd);
        }

        KhachThue saved = khachThueRepository.save(kt);
        saveCccdMedia(saved.getId(), req.getAnhCCCD());
        KhachThueResponse response = KhachThueResponse.fromEntity(saved);
        mapMedia(response, saved.getId());
        return response;
    }

    @Transactional
    public KhachThueResponse updateKhachThue(UUID id, KhachThueRequest req) {
        KhachThue kt = khachThueRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay khach thue"));
        assertCanWrite(kt, findActiveContract(id), permissionService.requireCurrentUserId());

        if (req.getHoTen() != null) {
            if (req.getHoTen().trim().isEmpty()) {
                throw new RuntimeException("Họ tên không được để trống");
            }
            kt.setHoTen(req.getHoTen());
        }
        if (req.getSoDienThoai() != null) kt.setSoDienThoai(req.getSoDienThoai());
        if (req.getEmail() != null) kt.setEmail(req.getEmail());
        String soCccd = firstNonBlank(req.getSoCccd(), req.getCccd());
        if (soCccd != null) kt.setSoCccd(soCccd);
        if (req.getNgaySinh() != null) kt.setNgaySinh(req.getNgaySinh());
        if (req.getGioiTinh() != null) kt.setGioiTinh(req.getGioiTinh());
        if (req.getDiaChi() != null) kt.setDiaChi(req.getDiaChi());
        if (req.getQueQuan() != null) kt.setQueQuan(req.getQueQuan());
        if (req.getNgheNghiep() != null) kt.setNgheNghiep(req.getNgheNghiep());
        if (req.getGhiChu() != null) kt.setGhiChu(req.getGhiChu());
        if (req.getNguoiDungId() != null) {
            kt.setNguoiDung(nguoiDungRepository.findById(req.getNguoiDungId())
                    .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung")));
        } else if (kt.getNguoiDung() == null && req.getSoDienThoai() != null && !req.getSoDienThoai().isEmpty()) {
            Optional<NguoiDung> ndOpt = nguoiDungRepository.findBySoDienThoai(req.getSoDienThoai());
            NguoiDung nd;
            if (ndOpt.isPresent()) {
                nd = ndOpt.get();
            } else {
                nd = NguoiDung.builder()
                        .hoTen(kt.getHoTen())
                        .soDienThoai(kt.getSoDienThoai())
                        .email(kt.getEmail())
                        .soCccd(kt.getSoCccd())
                        .ngaySinh(kt.getNgaySinh())
                        .gioiTinh(kt.getGioiTinh())
                        .diaChi(kt.getDiaChi())
                        .queQuan(kt.getQueQuan())
                        .build();
                nd.setId(UUID.randomUUID());
                nd.setTrangThai(com.example.quanlyphongtro.entity.TrangThaiNguoiDung.ACTIVE);
                nd.setSoLanDangNhapSai(0);
                nd.setMatKhau(passwordEncoder.encode("123456"));
                nd = nguoiDungRepository.save(nd);
            }
            kt.setNguoiDung(nd);
        }

        KhachThue saved = khachThueRepository.save(kt);
        saveCccdMedia(saved.getId(), req.getAnhCCCD());
        KhachThueResponse response = KhachThueResponse.fromEntity(saved);
        mapMedia(response, saved.getId());
        return response;
    }

    @Transactional
    public void deleteKhachThue(UUID id) {
        KhachThue kt = khachThueRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay khach thue"));
        assertCanWrite(kt, findActiveContract(id), permissionService.requireCurrentUserId());
        kt.setXoaLuc(ZonedDateTime.now());
        khachThueRepository.save(kt);
        // VÃ´ hiá»‡u hÃ³a tÃ i khoáº£n Ä‘Äƒng nháº­p liÃªn káº¿t, trÃ¡nh ngÆ°á»i Ä‘Ã£ bá»‹ xÃ³a váº«n Ä‘Äƒng nháº­p Ä‘Æ°á»£c.
        if (kt.getNguoiDung() != null) {
            NguoiDung nguoiDung = kt.getNguoiDung();
            nguoiDung.setTrangThai(com.example.quanlyphongtro.entity.TrangThaiNguoiDung.INACTIVE);
            nguoiDung.setXoaLuc(ZonedDateTime.now());
            nguoiDungRepository.save(nguoiDung);
        }
    }

    @Transactional
    public KhachThue ensureTaiKhoanDangNhap(KhachThue khachThue) {
        if (khachThue == null) {
            throw new RuntimeException("Khong tim thay khach thue");
        }
        if (khachThue.getNguoiDung() != null) {
            NguoiDung nguoiDung = khachThue.getNguoiDung();
            if (nguoiDung.getMatKhau() == null || nguoiDung.getMatKhau().isBlank()) {
                nguoiDung.setMatKhau(passwordEncoder.encode("123456"));
                nguoiDungRepository.save(nguoiDung);
            }
            return khachThue;
        }
        if (khachThue.getSoDienThoai() == null || khachThue.getSoDienThoai().isBlank()) {
            throw new RuntimeException("Khach dai dien phai co so dien thoai de tao tai khoan dang nhap");
        }

        String soDienThoai = khachThue.getSoDienThoai().trim();
        NguoiDung nguoiDung = nguoiDungRepository.findBySoDienThoai(soDienThoai).orElse(null);
        if (nguoiDung == null) {
            String email = khachThue.getEmail();
            if (email == null || email.isBlank()) {
                email = "tenant_" + soDienThoai + "@easyhouse.local";
            }
            nguoiDung = NguoiDung.builder()
                    .id(UUID.randomUUID())
                    .hoTen(khachThue.getHoTen())
                    .soDienThoai(soDienThoai)
                    .email(email)
                    .matKhau(passwordEncoder.encode("123456"))
                    .trangThai(com.example.quanlyphongtro.entity.TrangThaiNguoiDung.ACTIVE)
                    .soLanDangNhapSai(0)
                    .soCccd(khachThue.getSoCccd())
                    .ngaySinh(khachThue.getNgaySinh())
                    .gioiTinh(khachThue.getGioiTinh())
                    .diaChi(khachThue.getDiaChi())
                    .queQuan(khachThue.getQueQuan())
                    .build();
            nguoiDung = nguoiDungRepository.save(nguoiDung);
        }
        khachThue.setNguoiDung(nguoiDung);
        return khachThueRepository.save(khachThue);
    }

    private NguoiDung resolveOwnerForCreate(KhachThueRequest req, UUID currentUserId) {
        UUID ownerId = req.getChuTroId();
        if (ownerId != null && permissionService.isAdmin(currentUserId)) {
            return nguoiDungRepository.findById(ownerId)
                    .orElseThrow(() -> new RuntimeException("Khong tim thay chu tro"));
        }
        return nguoiDungRepository.findById(currentUserId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai"));
    }

    private HopDong findActiveContract(UUID khachThueId) {
        return hopDongRepository.findAllActive().stream()
                .filter(hd -> hd.getKhachThue() != null && hd.getKhachThue().getId().equals(khachThueId))
                .findFirst()
                .orElse(null);
    }

    private void assertCanRead(KhachThue kt, HopDong activeContract, UUID userId) {
        if (!canReadKhachThue(kt, activeContract, userId)) {
            throw new RuntimeException("Ban khong co quyen xem khach thue nay");
        }
    }

    private void assertCanWrite(KhachThue kt, HopDong activeContract, UUID userId) {
        if (!canWriteKhachThue(kt, activeContract, userId)) {
            throw new RuntimeException("Ban khong co quyen sua khach thue nay");
        }
    }

    private boolean canReadKhachThue(KhachThue kt, HopDong activeContract, UUID userId) {
        if (permissionService.isAdmin(userId)) return true;
        if (kt.getNguoiDung() != null && userId.equals(kt.getNguoiDung().getId())) return true;
        if (kt.getChuTro() != null && userId.equals(kt.getChuTro().getId())) return true;
        return activeContract != null && canReadContractBuilding(activeContract, userId);
    }

    private boolean canWriteKhachThue(KhachThue kt, HopDong activeContract, UUID userId) {
        if (permissionService.isAdmin(userId)) return true;
        if (kt.getChuTro() != null && userId.equals(kt.getChuTro().getId())) return true;
        return activeContract != null && canWriteContractBuilding(activeContract, userId);
    }

    private boolean canReadContractBuilding(HopDong hopDong, UUID userId) {
        if (hopDong.getPhong() == null || hopDong.getPhong().getNhaTro() == null) return false;
        return permissionService.canReadNhaTro(
                userId,
                hopDong.getPhong().getNhaTro().getId(),
                ownerId(hopDong));
    }

    private boolean canWriteContractBuilding(HopDong hopDong, UUID userId) {
        if (hopDong.getPhong() == null || hopDong.getPhong().getNhaTro() == null) return false;
        return permissionService.canWriteNhaTro(
                userId,
                hopDong.getPhong().getNhaTro().getId(),
                ownerId(hopDong));
    }

    private UUID ownerId(HopDong hopDong) {
        return hopDong.getPhong() != null
                && hopDong.getPhong().getNhaTro() != null
                && hopDong.getPhong().getNhaTro().getChuTro() != null
                ? hopDong.getPhong().getNhaTro().getChuTro().getId()
                : null;
    }

    private KhachThueResponse.CurrentContractResponse toContractResponse(HopDong hd) {
        KhachThueResponse.CurrentContractResponse cr = KhachThueResponse.CurrentContractResponse.builder()
                .id(hd.getId())
                .maHopDong(hd.getMaHopDong())
                .ngayBatDau(hd.getNgayBatDau())
                .ngayKetThuc(hd.getNgayKetThuc())
                .trangThai(hd.getTrangThai() != null ? hd.getTrangThai().name() : null)
                .build();
        if (hd.getPhong() != null) {
            Phong p = hd.getPhong();
            KhachThueResponse.PhongInfo pi = KhachThueResponse.PhongInfo.builder()
                    .id(p.getId()).maPhong(p.getTen()).tang(p.getTang()).build();
            if (p.getNhaTro() != null) {
                pi.setToaNha(KhachThueResponse.ToaNhaInfo.builder()
                        .id(p.getNhaTro().getId()).tenToaNha(p.getNhaTro().getTen()).build());
            }
            cr.setPhong(pi);
        }
        return cr;
    }
    
    private void mapContractInfo(KhachThueResponse res, HopDong hd) {
        res.setTrangThai("dangThue");
        res.setHopDongHienTai(toContractResponse(hd));
    }

    private String firstNonBlank(String primary, String fallback) {
        if (primary != null && !primary.isBlank()) return primary;
        if (fallback != null && !fallback.isBlank()) return fallback;
        return null;
    }

    private void mapMedia(KhachThueResponse response, UUID khachThueId) {
        response.setAnhCCCD(KhachThueResponse.AnhCCCDResponse.builder()
                .matTruoc(mediaService.firstUrl(LoaiDoiTuongMedia.TENANT, khachThueId, MediaService.CCCD_FRONT))
                .matSau(mediaService.firstUrl(LoaiDoiTuongMedia.TENANT, khachThueId, MediaService.CCCD_BACK))
                .build());
    }

    private void saveCccdMedia(UUID khachThueId, Map<String, String> map) {
        if (map == null || map.isEmpty()) return;
        Object matTruoc = firstPresent(map, "matTruoc", "front", "anhCccdTruoc", "anh_cccd_truoc");
        Object matSau = firstPresent(map, "matSau", "back", "anhCccdSau", "anh_cccd_sau");
        mediaService.replaceUrl(LoaiDoiTuongMedia.TENANT, khachThueId, matTruoc != null ? matTruoc.toString() : "", MediaService.CCCD_FRONT);
        mediaService.replaceUrl(LoaiDoiTuongMedia.TENANT, khachThueId, matSau != null ? matSau.toString() : "", MediaService.CCCD_BACK);
    }

    private Object firstPresent(Map<?, ?> map, String... keys) {
        for (String key : keys) {
            Object value = map.get(key);
            if (value != null && !value.toString().isBlank()) return value;
        }
        return null;
    }
}

