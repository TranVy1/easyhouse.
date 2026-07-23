package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class InvoiceGenerationService {

    private final NguoiDungRepository nguoiDungRepository;
    private final HopDongRepository hopDongRepository;
    private final HoaDonRepository hoaDonRepository;
    private final ChiSoDienNuocRepository chiSoDienNuocRepository;
    private final DichVuHopDongRepository dichVuHopDongRepository;
    private final ThanhVienHopDongRepository thanhVienHopDongRepository;
    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final NhaTroRepository nhaTroRepository;
    private final InvoiceGenerationBatchRepository invoiceGenerationBatchRepository;
    private final InvoiceGenerationLogRepository invoiceGenerationLogRepository;
    private final HoaDonService hoaDonService;
    private final PermissionService permissionService;

    @Transactional(readOnly = true)
    public InvoiceGenerationPreviewResponse preview(UUID nhaTroId, Integer kyThang, Integer kyNam, Boolean requireConfirmedReadings) {
        UUID userId = permissionService.requireCurrentUserId();
        
        List<HopDong> activeContracts = hopDongRepository.findAllActive();
        List<UUID> accessibleNhaTroIds = permissionService.getAllAccessibleNhaTroIds(userId);
        boolean isAdmin = permissionService.isAdmin(userId);
        
        List<InvoiceCandidateResponse> candidates = new ArrayList<>();
        int tongHopDong = 0;
        int tongReady = 0;
        BigDecimal tongEstimatedAmount = BigDecimal.ZERO;
        
        for (HopDong hd : activeContracts) {
            Phong phong = hd.getPhong();
            if (phong == null || phong.getNhaTro() == null) continue;
            
            UUID contractNhaTroId = phong.getNhaTro().getId();
            
            if (nhaTroId != null && !nhaTroId.equals(contractNhaTroId)) continue;
            
            if (!isAdmin && accessibleNhaTroIds != null && !accessibleNhaTroIds.contains(contractNhaTroId)) {
                continue;
            }
            
            tongHopDong++;
            
            InvoiceCandidateResponse.InvoiceCandidateResponseBuilder candidateBuilder = InvoiceCandidateResponse.builder()
                    .hopDongId(hd.getId())
                    .maHopDong(hd.getMaHopDong())
                    .phongId(phong.getId())
                    .maPhong(phong.getTen())
                    .khachThueId(hd.getKhachThue() != null ? hd.getKhachThue().getId() : null)
                    .tenKhachThue(hd.getKhachThue() != null ? hd.getKhachThue().getHoTen() : "Không có tên");
            
            List<String> warnings = new ArrayList<>();
            String status = "READY";
            
            Optional<HoaDon> existing = hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(hd.getId(), kyNam, kyThang);
            if (existing.isPresent()) {
                status = "EXISTS";
                warnings.add("Hợp đồng đã có hóa đơn trong kỳ " + kyThang + "/" + kyNam);
            }
            
            if ("READY".equals(status)) {
                boolean missingElectric = chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(phong.getId(), LoaiChiSo.ELECTRICITY, kyNam, kyThang).isEmpty();
                boolean missingWater = chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(phong.getId(), LoaiChiSo.WATER, kyNam, kyThang).isEmpty();
                
                if (missingElectric || missingWater) {
                    if (Boolean.TRUE.equals(requireConfirmedReadings)) {
                        status = "MISSING_READING";
                        warnings.add("Thiếu chỉ số điện nước trong kỳ " + kyThang + "/" + kyNam);
                    } else {
                        warnings.add("Không có chỉ số điện nước (chỉ tính tiền phòng và dịch vụ cố định)");
                    }
                }
            }
            
            BigDecimal estimatedAmount = BigDecimal.ZERO;
            if ("READY".equals(status)) {
                LocalDate startOfMonth = LocalDate.of(kyNam, kyThang, 1);
                LocalDate endOfMonth = startOfMonth.plusMonths(1).minusDays(1);
                estimatedAmount = estimatedAmount.add(HoaDonService.calculateProratedRoomRent(
                        hd.getGiaThueHopDong(), hd, startOfMonth, endOfMonth));

                List<DichVuHopDong> services = dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(hd.getId());
                
                for (DichVuHopDong service : services) {
                    LocalDate serviceStart = service.getBatDauTu();
                    LocalDate serviceEnd = service.getKetThucLuc();
                    boolean active = (serviceStart == null || !serviceStart.isAfter(endOfMonth)) && (serviceEnd == null || !serviceEnd.isBefore(startOfMonth));
                    if (!active) continue;
                    
                    String serviceName = service.getDichVu() != null ? service.getDichVu().getTenDichVu() : "";
                    boolean isMeterService = isMeterServiceName(serviceName);
                    
                    if (!isMeterService) {
                        BigDecimal serviceQty = BigDecimal.ONE;
                        if (service.getLoaiTinhPhi() == LoaiTinhPhi.PER_PERSON) {
                            serviceQty = BigDecimal.valueOf(Math.max(1, countActiveMembers(hd, startOfMonth, endOfMonth)));
                        } else if (service.getSoLuong() != null) {
                            serviceQty = service.getSoLuong();
                        }
                        estimatedAmount = estimatedAmount.add(service.getDonGiaApDung().multiply(serviceQty));
                    }
                }
                
                Optional<ChiSoDienNuoc> electric = chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(phong.getId(), LoaiChiSo.ELECTRICITY, kyNam, kyThang);
                if (electric.isPresent()) {
                    int tieuThu = electric.get().getChiSoMoi() - electric.get().getChiSoCu();
                    if (tieuThu > 0) {
                        BigDecimal electricPrice = findMeterPrice(hd, phong.getNhaTro().getId(), LoaiMucHoaDon.ELECTRICITY, startOfMonth);
                        estimatedAmount = estimatedAmount.add(electricPrice.multiply(BigDecimal.valueOf(tieuThu)));
                    }
                }
                
                Optional<ChiSoDienNuoc> water = chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(phong.getId(), LoaiChiSo.WATER, kyNam, kyThang);
                if (water.isPresent()) {
                    int tieuThu = water.get().getChiSoMoi() - water.get().getChiSoCu();
                    if (tieuThu > 0) {
                        BigDecimal waterPrice = findMeterPrice(hd, phong.getNhaTro().getId(), LoaiMucHoaDon.WATER, startOfMonth);
                        estimatedAmount = estimatedAmount.add(waterPrice.multiply(BigDecimal.valueOf(tieuThu)));
                    }
                }
                
                BigDecimal previousDebt = calculatePreviousDebt(hd.getId(), kyThang, kyNam);
                estimatedAmount = estimatedAmount.add(previousDebt);
                
                tongReady++;
                tongEstimatedAmount = tongEstimatedAmount.add(estimatedAmount);
            }
            
            candidates.add(candidateBuilder
                    .status(status)
                    .estimatedAmount(estimatedAmount)
                    .warnings(warnings)
                    .build());
        }
        
        return InvoiceGenerationPreviewResponse.builder()
                .kyThang(kyThang)
                .kyNam(kyNam)
                .candidates(candidates)
                .tongHopDong(tongHopDong)
                .tongReady(tongReady)
                .tongEstimatedAmount(tongEstimatedAmount)
                .build();
    }

    @Transactional
    public InvoiceGenerationResultResponse generate(InvoiceGenerationRequest request) {
        UUID userId = permissionService.requireCurrentUserId();
        NguoiDung currentUser = nguoiDungRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng hiện tại"));
        
        Integer kyThang = request.getKyThang();
        Integer kyNam = request.getKyNam();
        UUID nhaTroId = request.getNhaTroId();
        Boolean requireConfirmedReadings = request.getRequireConfirmedReadings();
        
        InvoiceGenerationPreviewResponse preview = preview(nhaTroId, kyThang, kyNam, requireConfirmedReadings);
        
        InvoiceGenerationBatch batch = InvoiceGenerationBatch.builder()
                .nhaTro(nhaTroId != null ? nhaTroRepository.findById(nhaTroId).orElse(null) : null)
                .kyThang(kyThang)
                .kyNam(kyNam)
                .trangThai("RUNNING")
                .tongHopDong(preview.getTongHopDong())
                .taoThanhCong(0)
                .boQua(0)
                .loi(0)
                .nguoiTao(currentUser)
                .taoLuc(ZonedDateTime.now())
                .build();
        batch = invoiceGenerationBatchRepository.save(batch);
        
        int createdCount = 0;
        int skippedCount = 0;
        int errorCount = 0;
        List<InvoiceGenerationResultResponse.GenerationLogDto> resultLogs = new ArrayList<>();
        
        for (InvoiceCandidateResponse candidate : preview.getCandidates()) {
            HopDong hd = hopDongRepository.findById(candidate.getHopDongId()).orElse(null);
            if (hd == null) continue;
            
            InvoiceGenerationLog.InvoiceGenerationLogBuilder logBuilder = InvoiceGenerationLog.builder()
                    .batch(batch)
                    .hopDong(hd)
                    .taoLuc(ZonedDateTime.now());
            
            if ("EXISTS".equals(candidate.getStatus())) {
                skippedCount++;
                logBuilder.status("SKIPPED").reason("Hợp đồng đã có hóa đơn trong kỳ này");
                invoiceGenerationLogRepository.save(logBuilder.build());
                resultLogs.add(InvoiceGenerationResultResponse.GenerationLogDto.builder()
                        .hopDongId(hd.getId())
                        .maPhong(candidate.getMaPhong())
                        .status("SKIPPED")
                        .reason("Hợp đồng đã có hóa đơn trong kỳ này")
                        .build());
                continue;
            }
            
            if ("MISSING_READING".equals(candidate.getStatus())) {
                skippedCount++;
                logBuilder.status("SKIPPED").reason("Thiếu chỉ số điện nước trong kỳ");
                invoiceGenerationLogRepository.save(logBuilder.build());
                resultLogs.add(InvoiceGenerationResultResponse.GenerationLogDto.builder()
                        .hopDongId(hd.getId())
                        .maPhong(candidate.getMaPhong())
                        .status("SKIPPED")
                        .reason("Thiếu chỉ số điện nước trong kỳ")
                        .build());
                continue;
            }
            
            try {
                HoaDonRequest req = new HoaDonRequest();
                req.setHopDongId(hd.getId());
                req.setKyNam(kyNam);
                req.setKyThang(kyThang);
                req.setTuNgay(LocalDate.of(kyNam, kyThang, 1));
                req.setDenNgay(LocalDate.of(kyNam, kyThang, 1).plusMonths(1).minusDays(1));
                
                BigDecimal previousDebt = calculatePreviousDebt(hd.getId(), kyThang, kyNam);
                req.setSoDuDauKy(previousDebt);
                
                req.setTrangThai("chuaThanhToan");
                
                Optional<ChiSoDienNuoc> electric = chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(hd.getPhong().getId(), LoaiChiSo.ELECTRICITY, kyNam, kyThang);
                if (electric.isPresent()) {
                    req.setChiSoDienBanDau(electric.get().getChiSoCu());
                    req.setChiSoDienCuoiKy(electric.get().getChiSoMoi());
                }
                
                Optional<ChiSoDienNuoc> water = chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(hd.getPhong().getId(), LoaiChiSo.WATER, kyNam, kyThang);
                if (water.isPresent()) {
                    req.setChiSoNuocBanDau(water.get().getChiSoCu());
                    req.setChiSoNuocCuoiKy(water.get().getChiSoMoi());
                }
                
                HoaDonResponse createdInvoiceResponse = hoaDonService.create(req);
                
                HoaDon invoiceEntity = hoaDonRepository.findById(createdInvoiceResponse.getId()).orElse(null);
                if (invoiceEntity != null) {
                    invoiceEntity.setAutoGenerated(true);
                    invoiceEntity.setGenerationBatchId(batch.getId());
                    hoaDonRepository.save(invoiceEntity);
                }
                
                createdCount++;
                logBuilder.status("SUCCESS").hoaDon(invoiceEntity);
                invoiceGenerationLogRepository.save(logBuilder.build());
                resultLogs.add(InvoiceGenerationResultResponse.GenerationLogDto.builder()
                        .hopDongId(hd.getId())
                        .maPhong(candidate.getMaPhong())
                        .status("SUCCESS")
                        .build());
                
            } catch (Exception e) {
                errorCount++;
                logBuilder.status("ERROR").reason(e.getMessage());
                invoiceGenerationLogRepository.save(logBuilder.build());
                resultLogs.add(InvoiceGenerationResultResponse.GenerationLogDto.builder()
                        .hopDongId(hd.getId())
                        .maPhong(candidate.getMaPhong())
                        .status("ERROR")
                        .reason(e.getMessage())
                        .build());
            }
        }
        
        batch.setTrangThai("COMPLETED");
        batch.setTaoThanhCong(createdCount);
        batch.setBoQua(skippedCount);
        batch.setLoi(errorCount);
        invoiceGenerationBatchRepository.save(batch);
        
        return InvoiceGenerationResultResponse.builder()
                .batchId(batch.getId())
                .createdCount(createdCount)
                .skippedCount(skippedCount)
                .errorCount(errorCount)
                .logs(resultLogs)
                .build();
    }

    private boolean isMeterServiceName(String name) {
        if (name == null) return false;
        String normalized = java.text.Normalizer.normalize(name, java.text.Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('\u0111', 'd')
                .replace('\u0110', 'D')
                .toLowerCase(java.util.Locale.ROOT);
        return normalized.contains("dien") || normalized.contains("electricity")
                || normalized.contains("nuoc") || normalized.contains("water");
    }

    private long countActiveMembers(HopDong hopDong, LocalDate tuNgay, LocalDate denNgay) {
        List<ThanhVienHopDong> members = thanhVienHopDongRepository.findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(hopDong.getId());
        long count = members.stream()
                .filter(member -> !Boolean.FALSE.equals(member.getDangO()))
                .filter(member -> member.getNgayVao() == null || !member.getNgayVao().isAfter(denNgay))
                .filter(member -> member.getNgayRoi() == null || !member.getNgayRoi().isBefore(tuNgay))
                .count();
        return count > 0 ? count : 1;
    }

    private BigDecimal findMeterPrice(HopDong hopDong, UUID nhaTroId, LoaiMucHoaDon loai, LocalDate tuNgay) {
        List<CauHinhGia> configPrices = cauHinhGiaRepository.findApplicable(nhaTroId, loai, tuNgay);
        if (!configPrices.isEmpty() && configPrices.get(0).getDonGia() != null) {
            return configPrices.get(0).getDonGia();
        }
        
        String keyword = loai == LoaiMucHoaDon.ELECTRICITY ? "dien" : "nuoc";
        String english = loai == LoaiMucHoaDon.ELECTRICITY ? "electricity" : "water";
        return dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(hopDong.getId()).stream()
                .filter(item -> item.getDichVu() != null)
                .filter(item -> containsNormalized(item.getDichVu().getTenDichVu(), keyword)
                        || containsNormalized(item.getDichVu().getTenDichVu(), english))
                .map(DichVuHopDong::getDonGiaApDung)
                .filter(value -> value != null && value.compareTo(BigDecimal.ZERO) > 0)
                .findFirst()
                .orElse(BigDecimal.ZERO);
    }

    private boolean containsNormalized(String value, String keyword) {
        if (value == null || keyword == null) return false;
        String normalized = java.text.Normalizer.normalize(value, java.text.Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('\u0111', 'd')
                .replace('\u0110', 'D')
                .toLowerCase(java.util.Locale.ROOT);
        return normalized.contains(keyword.toLowerCase(java.util.Locale.ROOT));
    }

    private BigDecimal calculatePreviousDebt(UUID hopDongId, int kyThang, int kyNam) {
        BigDecimal totalDebt = BigDecimal.ZERO;
        List<HoaDon> invoices = hoaDonRepository.findByHopDongIdAndXoaLucIsNull(hopDongId);
        for (HoaDon invoice : invoices) {
            if (invoice.getKyNam() < kyNam || (invoice.getKyNam() == kyNam && invoice.getKyThang() < kyThang)) {
                BigDecimal unpaid = invoice.getTongTien().subtract(invoice.getDaTra());
                if (unpaid.compareTo(BigDecimal.ZERO) > 0) {
                    totalDebt = totalDebt.add(unpaid);
                }
            }
        }
        return totalDebt;
    }
}
