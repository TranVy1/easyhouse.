package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.ContractSignatureRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ContractDocumentService {

    private final HopDongRepository hopDongRepository;
    private final ContractSignatureRepository signatureRepository;
    private final CloudinaryService cloudinaryService;
    private final TemplateEngine templateEngine;
    private final ThongBaoService thongBaoService;

    private String formatMoney(BigDecimal amount) {
        if (amount == null) return "0";
        return String.format("%,.0f", amount);
    }

    @Transactional
    public HopDong generatePdf(UUID hopDongId) {
        HopDong hd = hopDongRepository.findById(hopDongId).orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        
        Context context = new Context();
        context.setVariable("maHopDong", hd.getMaHopDong());
        context.setVariable("ngayLap", hd.getTaoLuc() != null ? hd.getTaoLuc().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        
        if (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null) {
            NguoiDung chuTro = hd.getPhong().getNhaTro().getChuTro(); 
            context.setVariable("tenChuTro", chuTro.getHoTen() != null ? chuTro.getHoTen() : "Chủ trọ");
            context.setVariable("sdtChuTro", chuTro.getSoDienThoai() != null ? chuTro.getSoDienThoai() : "");
        } else {
            context.setVariable("tenChuTro", "Chưa xác định");
            context.setVariable("sdtChuTro", "Chưa xác định");
        }

        context.setVariable("tenKhachThue", hd.getKhachThue().getHoTen());
        context.setVariable("sdtKhachThue", hd.getKhachThue().getSoDienThoai());
        context.setVariable("cccdKhachThue", hd.getKhachThue().getSoCccd());

        context.setVariable("tenPhong", hd.getPhong().getTen());
        context.setVariable("diaChi", hd.getPhong().getNhaTro() != null ? hd.getPhong().getNhaTro().getDiaChi() : "Chưa xác định");
        
        long months = java.time.temporal.ChronoUnit.MONTHS.between(hd.getNgayBatDau(), hd.getNgayKetThuc());
        context.setVariable("thoiHan", months + " tháng");
        context.setVariable("ngayBatDau", hd.getNgayBatDau().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        context.setVariable("ngayKetThuc", hd.getNgayKetThuc().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        context.setVariable("giaThue", formatMoney(hd.getGiaThueHopDong()));
        context.setVariable("tienCoc", formatMoney(hd.getTienCoc()));
        context.setVariable("ngayThanhToan", hd.getNgayThanhToanHangThang());

        context.setVariable("tenantSignatureText", hd.getTenantSignedAt() != null ? "Đã ký điện tử bởi " + hd.getKhachThue().getHoTen() : "(Chưa ký)");
        context.setVariable("tenantSignedAt", hd.getTenantSignedAt() != null ? hd.getTenantSignedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null);
        
        String landlordName = (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null) ? hd.getPhong().getNhaTro().getChuTro().getHoTen() : "Chủ trọ";
        context.setVariable("landlordSignatureText", hd.getLandlordSignedAt() != null ? "Đã ký điện tử bởi " + landlordName : "(Chưa ký)");
        context.setVariable("landlordSignedAt", hd.getLandlordSignedAt() != null ? hd.getLandlordSignedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null);

        String htmlContent = templateEngine.process("contract-template", context);

        try {
            File tempPdf = File.createTempFile("contract_", ".pdf");
            try (FileOutputStream os = new FileOutputStream(tempPdf)) {
                PdfRendererBuilder builder = new PdfRendererBuilder();
                builder.useFastMode();
                builder.withHtmlContent(htmlContent, null);
                builder.toStream(os);
                builder.run();
            }

            // Upload to Cloudinary
            java.util.Map<String, Object> uploadResult = cloudinaryService.uploadPdf(Files.readAllBytes(tempPdf.toPath()), tempPdf.getName());
            String url = (String) uploadResult.get("secure_url");
            Files.deleteIfExists(tempPdf.toPath());

            if (hd.getSignatureStatus() == SignatureStatus.COMPLETED) {
                hd.setSignedPdfUrl(url);
            } else {
                hd.setFilePdf(url);
            }
            
            return hopDongRepository.save(hd);

        } catch (Exception e) {
            log.error("Lỗi sinh PDF cho hợp đồng {}: {}", hopDongId, e.getMessage());
            throw new RuntimeException("Không thể sinh file PDF: " + e.getMessage());
        }
    }

    @Transactional
    public ContractSignature signContract(UUID hopDongId, com.example.quanlyphongtro.dto.ContractSignRequest request) {
        HopDong hd = hopDongRepository.findById(hopDongId).orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        
        if (hd.getSignatureStatus() == SignatureStatus.COMPLETED) {
            throw new RuntimeException("Hợp đồng đã được ký hoàn tất");
        }

        String role = request.getRole() != null ? request.getRole() : "LANDLORD";
        
        ContractSignature signature = ContractSignature.builder()
                .hopDong(hd)
                .signerId(request.getSignerId())
                .signerRole(role)
                .ipAddress(request.getIpAddress())
                .userAgent(request.getUserAgent())
                .build();
        
        signature = signatureRepository.save(signature);

        if ("TENANT".equals(role)) {
            hd.setTenantSignedAt(ZonedDateTime.now());
            if (hd.getSignatureStatus() == SignatureStatus.LANDLORD_SIGNED) {
                hd.setSignatureStatus(SignatureStatus.COMPLETED);
                hd.setTrangThai(TrangThaiHopDong.ACTIVE);
                hd.setLockedAt(ZonedDateTime.now());
            } else {
                hd.setSignatureStatus(SignatureStatus.TENANT_SIGNED);
            }
        } else if ("LANDLORD".equals(role)) {
            hd.setLandlordSignedAt(ZonedDateTime.now());
            if (hd.getSignatureStatus() == SignatureStatus.TENANT_SIGNED) {
                hd.setSignatureStatus(SignatureStatus.COMPLETED);
                hd.setTrangThai(TrangThaiHopDong.ACTIVE);
                hd.setLockedAt(ZonedDateTime.now());
            } else {
                hd.setSignatureStatus(SignatureStatus.LANDLORD_SIGNED);
            }
        }

        hopDongRepository.save(hd);
        
        // Re-generate PDF to include signatures
        generatePdf(hd.getId());

        // Notify
        if (hd.getSignatureStatus() == SignatureStatus.COMPLETED) {
            thongBaoService.createSystemNotification(
                    "Hợp đồng đã được ký hoàn tất",
                    "Hợp đồng thuê phòng " + hd.getPhong().getTen() + " đã được cả hai bên ký xác nhận thành công.",
                    LoaiThongBao.CONTRACT,
                    List.of(hd.getKhachThue().getNguoiDung().getId(), hd.getPhong().getNhaTro().getChuTro().getId())
            );
        }
        return signature;
    }

    @Transactional
    public HopDong rejectContract(UUID hopDongId, com.example.quanlyphongtro.dto.ContractSignRequest request) {
        HopDong hd = hopDongRepository.findById(hopDongId).orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        hd.setSignatureStatus(SignatureStatus.REJECTED);
        hd.setGhiChu(hd.getGhiChu() != null ? hd.getGhiChu() + "\nTừ chối ký: " + request.getRejectionReason() : "Từ chối ký: " + request.getRejectionReason());
        return hopDongRepository.save(hd);
    }

    public List<com.example.quanlyphongtro.dto.ContractSignatureResponse> getSignatures(UUID hopDongId) {
        List<ContractSignature> sigs = signatureRepository.findByHopDongIdOrderBySignedAtAsc(hopDongId);
        return sigs.stream().map(sig -> com.example.quanlyphongtro.dto.ContractSignatureResponse.builder()
                .id(sig.getId())
                .signerId(sig.getSignerId())
                .signerRole(sig.getSignerRole())
                .signatureImageUrl(sig.getSignatureImageUrl())
                .signedAt(sig.getSignedAt())
                .ipAddress(sig.getIpAddress())
                .userAgent(sig.getUserAgent())
                .build()).toList();
    }
}
