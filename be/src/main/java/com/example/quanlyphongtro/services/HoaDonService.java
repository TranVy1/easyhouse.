package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class HoaDonService {

    private final HoaDonRepository hoaDonRepository;
    private final ChiTietHoaDonRepository chiTietHoaDonRepository;
    private final PhongRepository phongRepository;
    private final HopDongRepository hopDongRepository;
    private final KhachThueRepository khachThueRepository;
    private final ThanhToanRepository thanhToanRepository;

    // ========== MAP TRANG THAI ==========
    private TrangThaiHoaDon mapTrangThai(String frontendStatus) {
        if (frontendStatus == null) return TrangThaiHoaDon.UNPAID;
        switch (frontendStatus) {
            case "daThanhToan": return TrangThaiHoaDon.PAID;
            case "daThanhToanMotPhan": return TrangThaiHoaDon.PARTIAL;
            case "chuaThanhToan": return TrangThaiHoaDon.UNPAID;
            default: return TrangThaiHoaDon.UNPAID;
        }
    }

    // ========== GET ALL ==========
    public List<HoaDonResponse> getAll() {
        List<HoaDon> hoaDons = hoaDonRepository.findByXoaLucIsNullOrderByTaoLucDesc();
        List<HoaDonResponse> responses = new ArrayList<>();
        for (HoaDon hd : hoaDons) {
            List<ChiTietHoaDon> chiTiet = chiTietHoaDonRepository.findByHoaDonId(hd.getId());
            responses.add(HoaDonResponse.fromEntity(hd, chiTiet));
        }
        return responses;
    }

    // ========== GET BY ID ==========
    public HoaDonResponse getById(UUID id) {
        HoaDon hoaDon = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        List<ChiTietHoaDon> chiTiet = chiTietHoaDonRepository.findByHoaDonId(id);
        return HoaDonResponse.fromEntity(hoaDon, chiTiet);
    }

    // ========== CREATE ==========
    @Transactional
    public HoaDonResponse create(HoaDonRequest request) {
        // Lookup references
        Phong phong = null;
        if (request.getPhong() != null) {
            phong = phongRepository.findById(request.getPhong())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
        }

        HopDong hopDong = null;
        if (request.getHopDong() != null) {
            hopDong = hopDongRepository.findById(request.getHopDong())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        }

        KhachThue khachThue = null;
        if (request.getKhachThue() != null) {
            khachThue = khachThueRepository.findById(request.getKhachThue())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê"));
        }

        // Tạo thangHoaDon từ tháng/năm
        int thang = request.getThang() != null ? request.getThang() : LocalDate.now().getMonthValue();
        int nam = request.getNam() != null ? request.getNam() : LocalDate.now().getYear();
        LocalDate thangHoaDon = LocalDate.of(nam, thang, 1);

        // Tính tổng tiền
        BigDecimal tongTien = request.getTongTien() != null ? request.getTongTien() : BigDecimal.ZERO;
        BigDecimal daTra = request.getDaThanhToan() != null ? request.getDaThanhToan() : BigDecimal.ZERO;

        // Hạn thanh toán
        LocalDate hanTra = request.getHanThanhToan() != null ? request.getHanThanhToan()
                : thangHoaDon.plusMonths(1);

        // Xác định trạng thái
        TrangThaiHoaDon trangThai;
        if (daTra.compareTo(BigDecimal.ZERO) == 0) {
            trangThai = TrangThaiHoaDon.UNPAID;
        } else if (daTra.compareTo(tongTien) >= 0) {
            trangThai = TrangThaiHoaDon.PAID;
        } else {
            trangThai = TrangThaiHoaDon.PARTIAL;
        }

        HoaDon hoaDon = HoaDon.builder()
                .phong(phong)
                .hopDong(hopDong)
                .khachThue(khachThue)
                .thangHoaDon(thangHoaDon)
                .tongTien(tongTien)
                .daTra(daTra)
                .trangThai(trangThai)
                .hanTra(hanTra)
                .ghiChu(request.getGhiChu())
                .build();

        HoaDon saved = hoaDonRepository.save(hoaDon);

        // Tạo chi tiết hóa đơn
        List<ChiTietHoaDon> chiTietList = new ArrayList<>();

        // 1. Tiền phòng
        if (request.getTienPhong() != null && request.getTienPhong().compareTo(BigDecimal.ZERO) > 0) {
            chiTietList.add(ChiTietHoaDon.builder()
                    .hoaDon(saved)
                    .loai(LoaiMucHoaDon.ROOM)
                    .moTa("Tiền phòng")
                    .soLuong(BigDecimal.ONE)
                    .donGia(request.getTienPhong())
                    .thanhTien(request.getTienPhong())
                    .build());
        }

        // 2. Tiền điện
        if (request.getTienDien() != null && request.getTienDien().compareTo(BigDecimal.ZERO) > 0) {
            int soDien = request.getSoDien() != null ? request.getSoDien() : 0;
            int dienBanDau = request.getChiSoDienBanDau() != null ? request.getChiSoDienBanDau() : 0;
            int dienCuoiKy = request.getChiSoDienCuoiKy() != null ? request.getChiSoDienCuoiKy() : 0;
            BigDecimal donGia = soDien > 0 ? request.getTienDien().divide(BigDecimal.valueOf(soDien), 2, java.math.RoundingMode.HALF_UP) : BigDecimal.ZERO;

            chiTietList.add(ChiTietHoaDon.builder()
                    .hoaDon(saved)
                    .loai(LoaiMucHoaDon.ELECTRICITY)
                    .moTa(dienBanDau + "-" + dienCuoiKy) // Lưu chỉ số
                    .soLuong(BigDecimal.valueOf(soDien))
                    .donGia(donGia)
                    .thanhTien(request.getTienDien())
                    .build());
        }

        // 3. Tiền nước
        if (request.getTienNuoc() != null && request.getTienNuoc().compareTo(BigDecimal.ZERO) > 0) {
            int soNuoc = request.getSoNuoc() != null ? request.getSoNuoc() : 0;
            int nuocBanDau = request.getChiSoNuocBanDau() != null ? request.getChiSoNuocBanDau() : 0;
            int nuocCuoiKy = request.getChiSoNuocCuoiKy() != null ? request.getChiSoNuocCuoiKy() : 0;
            BigDecimal donGia = soNuoc > 0 ? request.getTienNuoc().divide(BigDecimal.valueOf(soNuoc), 2, java.math.RoundingMode.HALF_UP) : BigDecimal.ZERO;

            chiTietList.add(ChiTietHoaDon.builder()
                    .hoaDon(saved)
                    .loai(LoaiMucHoaDon.WATER)
                    .moTa(nuocBanDau + "-" + nuocCuoiKy)
                    .soLuong(BigDecimal.valueOf(soNuoc))
                    .donGia(donGia)
                    .thanhTien(request.getTienNuoc())
                    .build());
        }

        // 4. Phí dịch vụ
        if (request.getPhiDichVu() != null) {
            for (HoaDonRequest.PhiDichVuItem phi : request.getPhiDichVu()) {
                if (phi.getGia() != null && phi.getGia().compareTo(BigDecimal.ZERO) > 0) {
                    chiTietList.add(ChiTietHoaDon.builder()
                            .hoaDon(saved)
                            .loai(LoaiMucHoaDon.SERVICE)
                            .moTa(phi.getTen())
                            .soLuong(BigDecimal.ONE)
                            .donGia(phi.getGia())
                            .thanhTien(phi.getGia())
                            .build());
                }
            }
        }

        chiTietHoaDonRepository.saveAll(chiTietList);

        return HoaDonResponse.fromEntity(saved, chiTietList);
    }

    // ========== UPDATE ==========
    @Transactional
    public HoaDonResponse update(UUID id, HoaDonRequest request) {
        HoaDon hoaDon = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));

        // Cập nhật references nếu có
        if (request.getPhong() != null) {
            Phong phong = phongRepository.findById(request.getPhong())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
            hoaDon.setPhong(phong);
        }
        if (request.getHopDong() != null) {
            HopDong hopDong = hopDongRepository.findById(request.getHopDong())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
            hoaDon.setHopDong(hopDong);
        }
        if (request.getKhachThue() != null) {
            KhachThue khachThue = khachThueRepository.findById(request.getKhachThue())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê"));
            hoaDon.setKhachThue(khachThue);
        }

        // Cập nhật thang/nam
        if (request.getThang() != null && request.getNam() != null) {
            hoaDon.setThangHoaDon(LocalDate.of(request.getNam(), request.getThang(), 1));
        }

        if (request.getTongTien() != null) hoaDon.setTongTien(request.getTongTien());
        if (request.getDaThanhToan() != null) hoaDon.setDaTra(request.getDaThanhToan());
        if (request.getHanThanhToan() != null) hoaDon.setHanTra(request.getHanThanhToan());
        if (request.getGhiChu() != null) hoaDon.setGhiChu(request.getGhiChu());

        // Cập nhật trạng thái tự động
        BigDecimal daTra = hoaDon.getDaTra() != null ? hoaDon.getDaTra() : BigDecimal.ZERO;
        BigDecimal tongTien = hoaDon.getTongTien() != null ? hoaDon.getTongTien() : BigDecimal.ZERO;
        if (daTra.compareTo(BigDecimal.ZERO) == 0) {
            hoaDon.setTrangThai(TrangThaiHoaDon.UNPAID);
        } else if (daTra.compareTo(tongTien) >= 0) {
            hoaDon.setTrangThai(TrangThaiHoaDon.PAID);
        } else {
            hoaDon.setTrangThai(TrangThaiHoaDon.PARTIAL);
        }

        // Override bằng trạng thái frontend nếu được chỉ định
        if (request.getTrangThai() != null) {
            hoaDon.setTrangThai(mapTrangThai(request.getTrangThai()));
        }

        HoaDon saved = hoaDonRepository.save(hoaDon);

        // Xóa chi tiết cũ và tạo mới (nếu có gửi chi tiết)
        if (request.getTienPhong() != null) {
            chiTietHoaDonRepository.deleteByHoaDonId(id);

            List<ChiTietHoaDon> chiTietList = new ArrayList<>();

            // Tiền phòng
            if (request.getTienPhong().compareTo(BigDecimal.ZERO) > 0) {
                chiTietList.add(ChiTietHoaDon.builder()
                        .hoaDon(saved)
                        .loai(LoaiMucHoaDon.ROOM)
                        .moTa("Tiền phòng")
                        .soLuong(BigDecimal.ONE)
                        .donGia(request.getTienPhong())
                        .thanhTien(request.getTienPhong())
                        .build());
            }

            // Tiền điện
            if (request.getTienDien() != null && request.getTienDien().compareTo(BigDecimal.ZERO) > 0) {
                int soDien = request.getSoDien() != null ? request.getSoDien() : 0;
                int dienBanDau = request.getChiSoDienBanDau() != null ? request.getChiSoDienBanDau() : 0;
                int dienCuoiKy = request.getChiSoDienCuoiKy() != null ? request.getChiSoDienCuoiKy() : 0;
                BigDecimal donGia = soDien > 0 ? request.getTienDien().divide(BigDecimal.valueOf(soDien), 2, java.math.RoundingMode.HALF_UP) : BigDecimal.ZERO;
                chiTietList.add(ChiTietHoaDon.builder()
                        .hoaDon(saved).loai(LoaiMucHoaDon.ELECTRICITY)
                        .moTa(dienBanDau + "-" + dienCuoiKy)
                        .soLuong(BigDecimal.valueOf(soDien))
                        .donGia(donGia)
                        .thanhTien(request.getTienDien())
                        .build());
            }

            // Tiền nước
            if (request.getTienNuoc() != null && request.getTienNuoc().compareTo(BigDecimal.ZERO) > 0) {
                int soNuoc = request.getSoNuoc() != null ? request.getSoNuoc() : 0;
                int nuocBanDau = request.getChiSoNuocBanDau() != null ? request.getChiSoNuocBanDau() : 0;
                int nuocCuoiKy = request.getChiSoNuocCuoiKy() != null ? request.getChiSoNuocCuoiKy() : 0;
                BigDecimal donGia = soNuoc > 0 ? request.getTienNuoc().divide(BigDecimal.valueOf(soNuoc), 2, java.math.RoundingMode.HALF_UP) : BigDecimal.ZERO;
                chiTietList.add(ChiTietHoaDon.builder()
                        .hoaDon(saved).loai(LoaiMucHoaDon.WATER)
                        .moTa(nuocBanDau + "-" + nuocCuoiKy)
                        .soLuong(BigDecimal.valueOf(soNuoc))
                        .donGia(donGia)
                        .thanhTien(request.getTienNuoc())
                        .build());
            }

            // Phí dịch vụ
            if (request.getPhiDichVu() != null) {
                for (HoaDonRequest.PhiDichVuItem phi : request.getPhiDichVu()) {
                    if (phi.getGia() != null && phi.getGia().compareTo(BigDecimal.ZERO) > 0) {
                        chiTietList.add(ChiTietHoaDon.builder()
                                .hoaDon(saved).loai(LoaiMucHoaDon.SERVICE)
                                .moTa(phi.getTen())
                                .soLuong(BigDecimal.ONE)
                                .donGia(phi.getGia())
                                .thanhTien(phi.getGia())
                                .build());
                    }
                }
            }

            chiTietHoaDonRepository.saveAll(chiTietList);
            return HoaDonResponse.fromEntity(saved, chiTietList);
        }

        List<ChiTietHoaDon> existingChiTiet = chiTietHoaDonRepository.findByHoaDonId(id);
        return HoaDonResponse.fromEntity(saved, existingChiTiet);
    }

    // ========== DELETE (SOFT) ==========
    @Transactional
    public void delete(UUID id) {
        HoaDon hoaDon = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        hoaDon.setXoaLuc(java.time.ZonedDateTime.now());
        hoaDonRepository.save(hoaDon);
    }

    // ========== GET FORM DATA ==========
    public Map<String, Object> getFormData() {
        Map<String, Object> result = new HashMap<>();

        // Lấy danh sách hợp đồng hoạt động
        List<HopDong> hopDongs = hopDongRepository.findAll();
        List<KhachThue> allTenants = khachThueRepository.findAll();
        List<com.example.quanlyphongtro.dto.HopDongResponse> hopDongResponses = new ArrayList<>();
        for (HopDong hd : hopDongs) {
            hopDongResponses.add(com.example.quanlyphongtro.dto.HopDongResponse.fromEntity(hd, allTenants));
        }
        result.put("hopDongList", hopDongResponses);

        // Lấy danh sách phòng
        List<Phong> phongs = phongRepository.findAll();
        List<com.example.quanlyphongtro.dto.PhongResponse> phongResponses = new ArrayList<>();
        for (Phong p : phongs) {
            phongResponses.add(com.example.quanlyphongtro.dto.PhongResponse.fromEntity(p));
        }
        result.put("phongList", phongResponses);

        // Lấy danh sách khách thuê
        List<com.example.quanlyphongtro.dto.KhachThueResponse> khachThueResponses = new ArrayList<>();
        for (KhachThue kt : allTenants) {
            khachThueResponses.add(com.example.quanlyphongtro.dto.KhachThueResponse.fromEntity(kt));
        }
        result.put("khachThueList", khachThueResponses);

        return result;
    }

    // ========== GET LATEST READING ==========
    public Map<String, Object> getLatestReading(UUID hopDongId, int thang, int nam) {
        Map<String, Object> result = new HashMap<>();
        result.put("isFirstInvoice", true);
        result.put("lastInvoiceMonth", null);
        result.put("chiSoDienBanDau", 0);
        result.put("chiSoNuocBanDau", 0);

        // Tìm hóa đơn gần nhất của hợp đồng này
        List<HoaDon> latestInvoices = hoaDonRepository.findLatestByHopDong(hopDongId);

        if (!latestInvoices.isEmpty()) {
            // Có hóa đơn trước đó → lấy chỉ số cuối kỳ làm chỉ số ban đầu
            HoaDon lastInvoice = latestInvoices.get(0);
            List<ChiTietHoaDon> chiTietList = chiTietHoaDonRepository.findByHoaDonId(lastInvoice.getId());

            for (ChiTietHoaDon ct : chiTietList) {
                if (ct.getLoai() == LoaiMucHoaDon.ELECTRICITY && ct.getMoTa() != null && ct.getMoTa().contains("-")) {
                    try {
                        String[] parts = ct.getMoTa().split("-");
                        result.put("chiSoDienBanDau", Integer.parseInt(parts[1].trim()));
                    } catch (NumberFormatException e) { /* ignore */ }
                }
                if (ct.getLoai() == LoaiMucHoaDon.WATER && ct.getMoTa() != null && ct.getMoTa().contains("-")) {
                    try {
                        String[] parts = ct.getMoTa().split("-");
                        result.put("chiSoNuocBanDau", Integer.parseInt(parts[1].trim()));
                    } catch (NumberFormatException e) { /* ignore */ }
                }
            }

            result.put("isFirstInvoice", false);
            int lastMonth = lastInvoice.getThangHoaDon().getMonthValue();
            int lastYear = lastInvoice.getThangHoaDon().getYear();
            result.put("lastInvoiceMonth", lastMonth + "/" + lastYear);
        } else {
            // Hóa đơn đầu tiên → lấy từ hợp đồng
            HopDong hopDong = hopDongRepository.findById(hopDongId).orElse(null);
            if (hopDong != null) {
                result.put("chiSoDienBanDau", hopDong.getChiSoDienBanDau() != null ? hopDong.getChiSoDienBanDau() : 0);
                result.put("chiSoNuocBanDau", hopDong.getChiSoNuocBanDau() != null ? hopDong.getChiSoNuocBanDau() : 0);
            }
        }

        return result;
    }

    // ========== THANH TOÁN ==========
    @Transactional
    public HoaDonResponse thanhToan(UUID id, BigDecimal soTien, String phuongThuc, String ghiChu, String maThamChieu) {
        HoaDon hoaDon = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));

        // 1. Lưu bản ghi thanh toán
        ThanhToan thanhToan = ThanhToan.builder()
                .hoaDon(hoaDon)
                .soTien(soTien)
                .phuongThuc(phuongThuc)
                .ghiChu(ghiChu)
                .maThamChieu(maThamChieu)
                .ngayThanhToan(java.time.ZonedDateTime.now())
                .trangThai("SUCCESS")
                .build();
        thanhToanRepository.save(thanhToan);

        // 2. Cập nhật số tiền đã trả trên hóa đơn
        BigDecimal daTra = (hoaDon.getDaTra() != null ? hoaDon.getDaTra() : BigDecimal.ZERO).add(soTien);
        hoaDon.setDaTra(daTra);

        if (daTra.compareTo(hoaDon.getTongTien()) >= 0) {
            hoaDon.setTrangThai(TrangThaiHoaDon.PAID);
        } else {
            hoaDon.setTrangThai(TrangThaiHoaDon.PARTIAL);
        }

        HoaDon saved = hoaDonRepository.save(hoaDon);
        List<ChiTietHoaDon> chiTiet = chiTietHoaDonRepository.findByHoaDonId(id);
        return HoaDonResponse.fromEntity(saved, chiTiet);
    }
}
