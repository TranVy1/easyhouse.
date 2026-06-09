package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ContractSignRequest;
import com.example.quanlyphongtro.dto.ContractSignatureResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
@RequiredArgsConstructor
@Slf4j
public class ContractDocumentService {

    private final HopDongRepository hopDongRepository;
    private final ContractSignatureRepository contractSignatureRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final ThanhVienHopDongRepository thanhVienHopDongRepository;
    private final DichVuHopDongRepository dichVuHopDongRepository;
    private final CloudinaryService cloudinaryService;
    private final PermissionService permissionService;
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    @Lazy
    private ContractDocumentService self;

    @Transactional(readOnly = true)
    public List<ContractSignatureResponse> getSignatures(UUID hopDongId) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        
        List<ContractSignature> signatures = contractSignatureRepository.findByHopDongIdOrderBySignedAtAsc(hopDongId);
        List<ContractSignatureResponse> responses = new ArrayList<>();
        
        for (ContractSignature sig : signatures) {
            String signerName = "Không rõ";
            if (sig.getSignerId() != null) {
                NguoiDung nd = nguoiDungRepository.findById(sig.getSignerId()).orElse(null);
                if (nd != null) {
                    signerName = nd.getHoTen() != null ? nd.getHoTen() : nd.getEmail();
                }
            } else {
                signerName = sig.getSignerRole().equals("LANDLORD") && hd.getKhachThue() != null ? 
                        hd.getKhachThue().getHoTen() : "Chủ nhà";
            }
            
            responses.add(ContractSignatureResponse.builder()
                     .id(sig.getId())
                     .signerId(sig.getSignerId())
                     .signerName(signerName)
                     .signerRole(sig.getSignerRole())
                     .signatureImageUrl(sig.getSignatureImageUrl())
                     .signedAt(sig.getSignedAt())
                     .ipAddress(sig.getIpAddress())
                     .userAgent(sig.getUserAgent())
                     .build());
        }
        return responses;
    }

    @Transactional
    public HopDong generatePdfTho(UUID hopDongId) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        
        UUID currentUserId = permissionService.requireCurrentUserId();
        // Check quyền viết hợp đồng
        if (!permissionService.isAdmin(currentUserId)) {
            NhaTro nt = hd.getPhong().getNhaTro();
            if (nt != null && nt.getChuTro() != null && !nt.getChuTro().getId().equals(currentUserId)) {
                throw new RuntimeException("Bạn không có quyền sinh tài liệu cho hợp đồng này");
            }
        }

        try {
            // Render HTML thô chưa có chữ ký
            String htmlContent = buildContractHtml(hd, null, null);
            byte[] pdfBytes = renderPdfFromHtml(htmlContent);

            // Upload PDF nháp lên Cloudinary
            String fileName = "Contract_Draft_" + hd.getMaHopDong() + "_" + System.currentTimeMillis();
            Map<String, Object> uploadResult = cloudinaryService.uploadPdf(pdfBytes, fileName);
            String pdfUrl = (String) uploadResult.get("secure_url");

            hd.setFilePdf(pdfUrl);
            hd.setTemplateVersion("default-v2-esign");
            hd.setPreviewedAt(ZonedDateTime.now());
            if (hd.getTrangThai() == TrangThaiHopDong.DRAFT) {
                hd.setTrangThai(TrangThaiHopDong.PENDING); // Chờ ký
            }

            return hopDongRepository.save(hd);
        } catch (Exception e) {
            log.error("Lỗi khi sinh PDF nháp cho hợp đồng {}", hopDongId, e);
            throw new RuntimeException("Sinh tài liệu PDF thất bại: " + e.getMessage(), e);
        }
    }

    @Transactional
    public ContractSignature signContract(UUID hopDongId, ContractSignRequest request) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));

        if (hd.getLockedAt() != null) {
            throw new RuntimeException("Hợp đồng đã được khóa và hoàn tất ký, không thể ký lại");
        }

        UUID currentUserId = permissionService.requireCurrentUserId();
        String signerRole = determineSignerRole(hd, currentUserId);

        // Kiểm tra xem đã ký vai trò này chưa
        boolean alreadySigned = contractSignatureRepository.findByHopDongIdOrderBySignedAtAsc(hopDongId).stream()
                .anyMatch(sig -> sig.getSignerRole().equals(signerRole));
        if (alreadySigned) {
            throw new RuntimeException("Bạn đã ký hợp đồng này rồi");
        }

        try {
            // 1. Tải ảnh chữ ký canvas lên Cloudinary
            byte[] imageBytes = Base64.getDecoder().decode(
                    request.getSignatureBase64().replaceFirst("data:image/\\w+;base64,", "")
            );
            String signatureFileName = "Sig_" + signerRole + "_" + hd.getMaHopDong() + "_" + System.currentTimeMillis();
            Map<String, Object> uploadResult = cloudinaryService.uploadImage(imageBytes, signatureFileName);
            String signatureUrl = (String) uploadResult.get("secure_url");

            // 2. Lưu chữ ký vào DB
            ContractSignature sig = ContractSignature.builder()
                    .hopDong(hd)
                    .signerId(currentUserId)
                    .signerRole(signerRole)
                    .signatureImageUrl(signatureUrl)
                    .ipAddress(request.getIpAddress())
                    .userAgent(request.getUserAgent())
                    .signedAt(ZonedDateTime.now())
                    .build();
            ContractSignature savedSig = contractSignatureRepository.save(sig);

            // 3. Cập nhật thời gian ký trên HopDong
            if (signerRole.equals("LANDLORD")) {
                hd.setLandlordSignedAt(savedSig.getSignedAt());
                if (hd.getSignatureStatus().equals("UNSIGNED")) {
                    hd.setSignatureStatus("LANDLORD_SIGNED");
                } else if (hd.getSignatureStatus().equals("TENANT_SIGNED")) {
                    hd.setSignatureStatus("COMPLETED");
                }
            } else {
                hd.setTenantSignedAt(savedSig.getSignedAt());
                if (hd.getSignatureStatus().equals("UNSIGNED")) {
                    hd.setSignatureStatus("TENANT_SIGNED");
                } else if (hd.getSignatureStatus().equals("LANDLORD_SIGNED")) {
                    hd.setSignatureStatus("COMPLETED");
                }
            }

            // Ghi nhận lý do từ chối nếu có chuyển đổi
            if (hd.getSignatureStatus().equals("REJECTED")) {
                hd.setSignatureStatus(signerRole.equals("LANDLORD") ? "LANDLORD_SIGNED" : "TENANT_SIGNED");
            }

            hopDongRepository.save(hd);

            // 4. Nếu cả hai bên đã ký, kích hoạt quy trình tự động hoàn tất và sinh PDF đã ký bằng ĐA LUỒNG (Async)
            if (hd.getSignatureStatus().equals("COMPLETED")) {
                // Đẩy tác vụ sinh PDF và khóa hợp đồng ra background thread để HTTP trả về 200 nhanh chóng
                self.generateAndCompleteContractPdf(hopDongId);
            }

            return savedSig;
        } catch (Exception e) {
            log.error("Lỗi khi ký hợp đồng {}", hopDongId, e);
            throw new RuntimeException("Ký hợp đồng thất bại: " + e.getMessage(), e);
        }
    }

    @Transactional
    public HopDong rejectContract(UUID hopDongId, ContractSignRequest request) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));

        if (hd.getLockedAt() != null) {
            throw new RuntimeException("Hợp đồng đã hoàn tất ký, không thể từ chối");
        }

        UUID currentUserId = permissionService.requireCurrentUserId();
        // Chỉ khách thuê đại diện của hợp đồng mới được từ chối ký
        if (hd.getKhachThue() == null || hd.getKhachThue().getNguoiDung() == null ||
                !hd.getKhachThue().getNguoiDung().getId().equals(currentUserId)) {
            throw new RuntimeException("Bạn không có quyền từ chối ký hợp đồng này");
        }

        hd.setSignatureStatus("REJECTED");
        String reason = request.getRejectionReason() != null ? request.getRejectionReason() : "Không có lý do cụ thể";
        hd.setGhiChu("Khách thuê từ chối ký ngày " + 
                ZonedDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) + 
                ". Lý do: " + reason + (hd.getGhiChu() != null ? "\n" + hd.getGhiChu() : ""));
        
        return hopDongRepository.save(hd);
    }

    /**
     * Tác vụ chạy ĐA LUỒNG không đồng bộ để sinh file PDF chính thức chứa chữ ký,
     * khóa hợp đồng và sinh lịch thanh toán.
     */
    @Async("taskExecutor")
    @Transactional
    public CompletableFuture<Void> generateAndCompleteContractPdf(UUID hopDongId) {
        log.info("Chạy đa luồng: Bắt đầu sinh PDF hoàn tất cho hợp đồng ID: {}", hopDongId);
        try {
            // Chờ 1 chút để các transaction lưu chữ ký trước đó commit hoàn tất
            Thread.sleep(500);
            
            HopDong hd = hopDongRepository.findById(hopDongId).orElse(null);
            if (hd == null) {
                log.error("Không tìm thấy hợp đồng ID {} khi chạy async", hopDongId);
                return CompletableFuture.completedFuture(null);
            }

            // Lấy danh sách chữ ký
            List<ContractSignature> signatures = contractSignatureRepository.findByHopDongIdOrderBySignedAtAsc(hopDongId);
            String landlordSig = null;
            String tenantSig = null;
            
            for (ContractSignature sig : signatures) {
                if (sig.getSignerRole().equals("LANDLORD")) {
                    landlordSig = sig.getSignatureImageUrl();
                } else if (sig.getSignerRole().equals("TENANT")) {
                    tenantSig = sig.getSignatureImageUrl();
                }
            }

            // 1. Biên dịch PDF chứa cả hai chữ ký
            String htmlContent = buildContractHtml(hd, landlordSig, tenantSig);
            byte[] pdfBytes = renderPdfFromHtml(htmlContent);

            // 2. Upload PDF chính thức lên Cloudinary
            String fileName = "Contract_Signed_" + hd.getMaHopDong() + "_" + System.currentTimeMillis();
            Map<String, Object> uploadResult = cloudinaryService.uploadPdf(pdfBytes, fileName);
            String pdfUrl = (String) uploadResult.get("secure_url");

            // 3. Cập nhật thông tin hoàn tất trên HopDong
            ZonedDateTime now = ZonedDateTime.now();
            hd.setSignedPdfUrl(pdfUrl);
            hd.setFilePdf(pdfUrl); // Ghi đè file_pdf chính thức
            hd.setTrangThai(TrangThaiHopDong.ACTIVE);
            hd.setConfirmedAt(now);
            hd.setLockedAt(now);
            hopDongRepository.save(hd);

            // 4. Kích hoạt sinh lịch thanh toán hàng tháng qua Database function
            jdbcTemplate.queryForObject("SELECT public.tao_lich_thanh_toan_hang_thang(?::uuid)", Integer.class, hd.getId());
            
            log.info("Chạy đa luồng: Sinh PDF hoàn tất thành công cho hợp đồng ID: {}", hopDongId);
        } catch (Exception e) {
            log.error("Lỗi khi chạy không đồng bộ sinh PDF hoàn tất cho hợp đồng {}", hopDongId, e);
        }
        return CompletableFuture.completedFuture(null);
    }

    private String determineSignerRole(HopDong hd, UUID userId) {
        // Kiểm tra xem người dùng đăng nhập là Khách thuê đại diện của hợp đồng hay Chủ trọ/Admin
        if (hd.getKhachThue() != null && hd.getKhachThue().getNguoiDung() != null &&
                hd.getKhachThue().getNguoiDung().getId().equals(userId)) {
            return "TENANT";
        }
        // Mặc định, nếu là Admin hoặc người quản lý có quyền viết phòng, thì đóng vai trò chủ nhà ký
        NhaTro nt = hd.getPhong().getNhaTro();
        if (permissionService.isAdmin(userId) || 
                (nt != null && nt.getChuTro() != null && nt.getChuTro().getId().equals(userId))) {
            return "LANDLORD";
        }
        
        throw new RuntimeException("Tài khoản của bạn không thuộc đối tượng được ký hợp đồng này");
    }

    private byte[] renderPdfFromHtml(String htmlContent) throws Exception {
        try (ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            
            // Tải font Roboto-Regular từ classpath resources để vẽ tiếng Việt UTF-8
            try (InputStream fontStream = getClass().getResourceAsStream("/fonts/Roboto-Regular.ttf")) {
                if (fontStream == null) {
                    throw new RuntimeException("Không tìm thấy font Roboto-Regular.ttf trong resources/fonts");
                }
                byte[] fontBytes = fontStream.readAllBytes();
                builder.useFont(() -> new ByteArrayInputStream(fontBytes), "Roboto");
            }
            
            builder.withHtmlContent(htmlContent, "/");
            builder.toStream(os);
            builder.run();
            return os.toByteArray();
        }
    }

    private String buildContractHtml(HopDong hd, String landlordSig, String tenantSig) {
        Phong phong = hd.getPhong();
        NhaTro nhaTro = phong != null ? phong.getNhaTro() : null;
        NguoiDung chuTro = nhaTro != null ? nhaTro.getChuTro() : null;
        KhachThue khachDaiDien = hd.getKhachThue();

        String tenToaNha = nhaTro != null ? nhaTro.getTen() : "---";
        String diaChiToaNha = nhaTro != null ? nhaTro.getDiaChi() : "---";
        String tenPhong = phong != null ? phong.getTen() : "---";
        
        String tenChuTro = chuTro != null && chuTro.getHoTen() != null ? chuTro.getHoTen() : "---";
        String sdtChuTro = chuTro != null && chuTro.getSoDienThoai() != null ? chuTro.getSoDienThoai() : "---";
        String emailChuTro = chuTro != null ? chuTro.getEmail() : "---";

        String tenKhach = khachDaiDien != null ? khachDaiDien.getHoTen() : "---";
        String sdtKhach = khachDaiDien != null && khachDaiDien.getSoDienThoai() != null ? khachDaiDien.getSoDienThoai() : "---";
        String emailKhach = khachDaiDien != null && khachDaiDien.getEmail() != null ? khachDaiDien.getEmail() : "---";
        String cccdKhach = khachDaiDien != null && khachDaiDien.getSoCccd() != null ? khachDaiDien.getSoCccd() : "---";

        // Lấy danh sách thành viên ở cùng
        List<ThanhVienHopDong> members = thanhVienHopDongRepository.findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(hd.getId());
        StringBuilder membersHtml = new StringBuilder();
        if (members.isEmpty()) {
            membersHtml.append("<tr><td colspan='4' style='text-align:center; padding:8px;'>Chưa khai báo thành viên</td></tr>");
        } else {
            int idx = 1;
            for (ThanhVienHopDong m : members) {
                if (m.getLaNguoiDaiDien() != null && m.getLaNguoiDaiDien()) continue; // Bỏ qua đại diện đã khai báo ở trên
                membersHtml.append(String.format(
                    "<tr><td style='padding:6px; border:1px solid #ddd; text-align:center;'>%d</td>" +
                    "<td style='padding:6px; border:1px solid #ddd;'>%s</td>" +
                    "<td style='padding:6px; border:1px solid #ddd; text-align:center;'>%s</td>" +
                    "<td style='padding:6px; border:1px solid #ddd; text-align:center;'>%s</td></tr>",
                    idx++, m.getHoTen(), m.getSoDienThoai() != null ? m.getSoDienThoai() : "---", m.getSoCccd() != null ? m.getSoCccd() : "---"
                ));
            }
            if (idx == 1) {
                membersHtml.append("<tr><td colspan='4' style='text-align:center; padding:8px;'>Không có thành viên ở cùng</td></tr>");
            }
        }

        // Lấy danh sách phí dịch vụ
        List<DichVuHopDong> services = dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(hd.getId());
        StringBuilder servicesHtml = new StringBuilder();
        if (services.isEmpty()) {
            servicesHtml.append("<tr><td colspan='4' style='text-align:center; padding:8px;'>Chưa có phí dịch vụ đi kèm</td></tr>");
        } else {
            int idx = 1;
            for (DichVuHopDong s : services) {
                String kieuTinh = switch (s.getLoaiTinhPhi()) {
                    case FIXED -> "Cố định/Phòng";
                    case PER_PERSON -> "Theo người ở";
                    case PER_UNIT -> "Theo chỉ số sử dụng (Điện/Nước)";
                    default -> s.getLoaiTinhPhi().name();
                };
                servicesHtml.append(String.format(
                    "<tr><td style='padding:6px; border:1px solid #ddd; text-align:center;'>%d</td>" +
                    "<td style='padding:6px; border:1px solid #ddd;'>%s</td>" +
                    "<td style='padding:6px; border:1px solid #ddd; text-align:right;'>%,.0f đ</td>" +
                    "<td style='padding:6px; border:1px solid #ddd;'>%s</td></tr>",
                    idx++, s.getDichVu() != null ? s.getDichVu().getTenDichVu() : "Dịch vụ", s.getDonGiaApDung(), kieuTinh
                ));
            }
        }

        String formattedGia = String.format("%,.0f đ", hd.getGiaThueHopDong() != null ? hd.getGiaThueHopDong() : BigDecimal.ZERO);
        String formattedCoc = String.format("%,.0f đ", hd.getTienCoc() != null ? hd.getTienCoc() : BigDecimal.ZERO);

        // Chuẩn bị khung ký họa chữ ký
        String landlordSigHtml = landlordSig != null ? 
                String.format("<img src='%s' style='max-width:180px; max-height:80px; display:block; margin:5px auto;' />", landlordSig) : 
                "<div style='height:80px;'></div>";
        String tenantSigHtml = tenantSig != null ? 
                String.format("<img src='%s' style='max-width:180px; max-height:80px; display:block; margin:5px auto;' />", tenantSig) : 
                "<div style='height:80px;'></div>";

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        return """
            <html>
            <head>
                <meta charset="UTF-8">
                <style>
                    body {
                        font-family: 'Roboto', sans-serif;
                        font-size: 14px;
                        line-height: 1.5;
                        color: #333;
                        padding: 20px;
                    }
                    .header {
                        text-align: center;
                        margin-bottom: 30px;
                    }
                    .national-title {
                        font-weight: bold;
                        font-size: 15px;
                        margin-bottom: 2px;
                    }
                    .national-sub {
                        font-size: 13px;
                        text-decoration: underline;
                        margin-bottom: 15px;
                    }
                    .title {
                        font-size: 20px;
                        font-weight: bold;
                        margin-top: 20px;
                        margin-bottom: 5px;
                    }
                    .code {
                        font-style: italic;
                        font-size: 12px;
                        margin-bottom: 25px;
                    }
                    .section-title {
                        font-weight: bold;
                        font-size: 14px;
                        margin-top: 15px;
                        margin-bottom: 8px;
                        text-transform: uppercase;
                        border-bottom: 1px solid #333;
                        padding-bottom: 2px;
                    }
                    .field-label {
                        font-weight: bold;
                        display: inline-block;
                        width: 150px;
                    }
                    .table {
                        width: 100%%;
                        border-collapse: collapse;
                        margin-top: 10px;
                        margin-bottom: 15px;
                    }
                    .table th {
                        background-color: #f2f2f2;
                        font-weight: bold;
                        padding: 6px;
                        border: 1px solid #ddd;
                        text-align: center;
                    }
                    .signature-section {
                        margin-top: 40px;
                        width: 100%%;
                    }
                    .signature-box {
                        width: 45%%;
                        display: inline-block;
                        text-align: center;
                        vertical-align: top;
                    }
                </style>
            </head>
            <body>
                <div class="header">
                    <div class="national-title">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</div>
                    <div class="national-sub">Độc lập - Tự do - Hạnh phúc</div>
                    
                    <div class="title">HỢP ĐỒNG THUÊ PHÒNG TRỌ</div>
                    <div class="code">Mã số hợp đồng: %s</div>
                </div>

                <div class="section-title">BÊN A: BÊN CHO THUÊ (CHỦ TRỌ)</div>
                <div><span class="field-label">Họ và tên:</span> %s</div>
                <div><span class="field-label">Số điện thoại:</span> %s</div>
                <div><span class="field-label">Email:</span> %s</div>

                <div class="section-title">BÊN B: BÊN THUÊ PHÒNG (KHÁCH ĐẠI DIỆN)</div>
                <div><span class="field-label">Họ và tên:</span> %s</div>
                <div><span class="field-label">Số CCCD/Passport:</span> %s</div>
                <div><span class="field-label">Số điện thoại:</span> %s</div>
                <div><span class="field-label">Email:</span> %s</div>

                <div class="section-title">ĐIỀU 1: THÔNG TIN PHÒNG THUÊ</div>
                <div>Hai bên thống nhất Bên A cho Bên B thuê phòng số <strong>%s</strong> thuộc nhà trọ/tòa nhà <strong>%s</strong> tại địa chỉ: %s.</div>

                <div class="section-title">ĐIỀU 2: THỜI HẠN THUÊ</div>
                <div>Thời hạn thuê phòng là từ ngày <strong>%s</strong> đến hết ngày <strong>%s</strong>.</div>

                <div class="section-title">ĐIỀU 3: CHI PHÍ VÀ THANH TOÁN</div>
                <div>- <strong>Giá thuê phòng:</strong> %s / tháng.</div>
                <div>- <strong>Tiền đặt cọc:</strong> %s.</div>
                <div>- <strong>Chu kỳ đóng tiền:</strong> Đóng tiền định kỳ theo %s.</div>
                <div>- <strong>Ngày thanh toán hàng tháng:</strong> Ngày %d hàng tháng.</div>
                <div>- <strong>Chỉ số điện ban đầu:</strong> %s kWh.</div>
                <div>- <strong>Chỉ số nước ban đầu:</strong> %s m3.</div>

                <div class="section-title">ĐIỀU 4: DỊCH VỤ ĐI KÈM VÀ ĐƠN GIÁ</div>
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width:10%%;">STT</th>
                            <th style="width:40%%;">Tên Dịch Vụ</th>
                            <th style="width:25%%;">Đơn Giá Áp Dụng</th>
                            <th style="width:25%%;">Hình Thức Tính Phí</th>
                        </tr>
                    </thead>
                    <tbody>
                        %s
                    </tbody>
                </table>

                <div class="section-title">ĐIỀU 5: THÀNH VIÊN Ở CÙNG (NẾU CÓ)</div>
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width:10%%;">STT</th>
                            <th style="width:40%%;">Họ và Tên</th>
                            <th style="width:25%%;">Số Điện Thoại</th>
                            <th style="width:25%%;">Số CCCD/Passport</th>
                        </tr>
                    </thead>
                    <tbody>
                        %s
                    </tbody>
                </table>

                <div class="section-title">ĐIỀU 6: ĐIỀU KHOẢN CHUNG</div>
                <div style="font-size:12px; font-style:italic;">
                    Hai bên cam kết thực hiện nghiêm chỉnh các điều khoản ghi trong hợp đồng này. Mọi tranh chấp phát sinh sẽ được giải quyết bằng thương lượng, hòa giải. Hợp đồng có giá trị pháp lý sau khi đại diện hai bên ký xác nhận chữ ký số trên hệ thống EasyHouse.
                </div>

                <div class="signature-section">
                    <div class="signature-box" style="float: left;">
                        <strong>BÊN A (BÊN CHO THUÊ)</strong><br/>
                        <span style="font-size:11px; color:#888;">(Ký, ghi rõ họ tên)</span>
                        %s
                        <div style="font-weight: bold; margin-top:5px;">%s</div>
                    </div>
                    <div class="signature-box" style="float: right;">
                        <strong>BÊN B (BÊN THUÊ PHÒNG)</strong><br/>
                        <span style="font-size:11px; color:#888;">(Ký, ghi rõ họ tên)</span>
                        %s
                        <div style="font-weight: bold; margin-top:5px;">%s</div>
                    </div>
                    <div style="clear: both;"></div>
                </div>
            </body>
            </html>
            """.formatted(
                hd.getMaHopDong(),
                tenChuTro, sdtChuTro, emailChuTro,
                tenKhach, cccdKhach, sdtKhach, emailKhach,
                tenPhong, tenToaNha, diaChiToaNha,
                hd.getNgayBatDau().format(dtf), hd.getNgayKetThuc().format(dtf),
                formattedGia, formattedCoc,
                hd.getChuKyThanhToan().equals("MONTHLY") ? "tháng" : (hd.getChuKyThanhToan().equals("QUARTERLY") ? "quý" : "năm"),
                hd.getNgayThanhToanHangThang(),
                hd.getChiSoDienBanDau() != null ? hd.getChiSoDienBanDau() : "0",
                hd.getChiSoNuocBanDau() != null ? hd.getChiSoNuocBanDau() : "0",
                servicesHtml.toString(),
                membersHtml.toString(),
                landlordSigHtml, tenChuTro,
                tenantSigHtml, tenKhach
            );
    }
}
