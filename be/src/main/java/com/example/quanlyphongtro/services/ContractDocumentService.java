package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.ContractSignatureRepository;
import com.example.quanlyphongtro.repository.DichVuHopDongRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.TaiSanPhongRepository;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ContractDocumentService {

    private final HopDongRepository hopDongRepository;
    private final PhongRepository phongRepository;
    private final ContractSignatureRepository signatureRepository;
    private final DichVuHopDongRepository dichVuHopDongRepository;
    private final com.example.quanlyphongtro.repository.ThanhVienHopDongRepository thanhVienHopDongRepository;
    private final com.example.quanlyphongtro.repository.NguoiDungRepository nguoiDungRepository;
    private final com.example.quanlyphongtro.repository.KhachThueRepository khachThueRepository;
    private final HopDongService hopDongService;
    private final PermissionService permissionService;
    private final CloudinaryService cloudinaryService;
    private final TaiSanPhongRepository taiSanPhongRepository;
    private final TienIchService tienIchService;
    private final TemplateEngine templateEngine;
    private final ThongBaoService thongBaoService;
    private final JdbcTemplate jdbcTemplate;

    private String formatMoney(BigDecimal amount) {
        if (amount == null) return "0";
        return String.format("%,.0f", amount);
    }

    private String chuKyThanhToanLabel(String chuKy) {
        if (chuKy == null) return "Hàng tháng";
        return switch (chuKy.trim().toUpperCase()) {
            case "QUARTERLY", "QUY" -> "Hàng quý (03 tháng/lần)";
            case "YEARLY", "ANNUAL", "NAM" -> "Hàng năm (12 tháng/lần)";
            default -> "Hàng tháng";
        };
    }

    // Dien va Nuoc trong bang dich_vu dang co don_vi NULL. Thay vi de trong o
    // giua hop dong, suy ra don vi do luong chuan theo ten dich vu.
    private String donViMacDinh(String tenDichVu) {
        if (tenDichVu == null) return "";
        String t = tenDichVu.toLowerCase();
        if (t.contains("điện")) return "kWh";
        if (t.contains("nước")) return "m³";
        return "";
    }

    private String getBase64Image(String urlStr) {
        if (urlStr == null || urlStr.isEmpty()) return null;
        try {
            java.net.URL url = new java.net.URL(urlStr);
            try (java.io.InputStream is = url.openStream()) {
                byte[] bytes = is.readAllBytes();
                String base64 = java.util.Base64.getEncoder().encodeToString(bytes);
                return "data:image/png;base64," + base64;
            }
        } catch (Exception e) {
            log.warn("Could not fetch image for PDF: " + urlStr, e);
            return null;
        }
    }

    public String getDefaultTerms() {
        return """
                <p>1. <strong>Bên cho thuê (Bên A):</strong> Cung cấp phòng ở và các trang thiết bị kèm theo (nếu có) đúng thỏa thuận; bảo đảm quyền sử dụng phòng ổn định và hợp pháp của Bên B.</p>
                <p>2. <strong>Bên thuê (Bên B):</strong> Thanh toán đầy đủ và đúng hạn tiền thuê phòng và các khoản chi phí dịch vụ; sử dụng phòng đúng mục đích, chấp hành nghiêm túc quy định an ninh trật tự, phòng cháy chữa cháy và vệ sinh chung; bảo quản tài sản trong phòng.</p>
                <p>3. <strong>Tiền đặt cọc:</strong> Tiền cọc được bên A giữ để bảo đảm thực hiện hợp đồng và sẽ được hoàn trả cho Bên B sau khi thanh lý hợp đồng và khấu trừ các chi phí/thiệt hại phát sinh (nếu có).</p>
                <p>4. <strong>Chấm dứt và gia hạn hợp đồng:</strong> Khi hợp đồng hết hạn, nếu hai bên có nhu cầu tiếp tục thuê thì tiến hành gia hạn hợp đồng. Trường hợp một trong hai bên muốn chấm dứt hợp đồng trước hạn phải thông báo trước cho bên kia ít nhất 30 ngày.</p>
                <p>5. <strong>Điều khoản chung:</strong> Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận trong hợp đồng. Mọi tranh chấp phát sinh sẽ được giải quyết trên tinh thần thiện chí và thương lượng.</p>
                """;
    }

    public Context buildContractContext(HopDong hd) {
        Context context = new Context();
        context.setVariable("maHopDong", hd.getMaHopDong());
        // Ngay lap phai co dinh theo du lieu hop dong. KHONG dung LocalDate.now()
        // lam gia tri du phong: PDF duoc sinh lai moi lan mo, nen ngay lap se nhay
        // theo ngay xem — cung mot hop dong hom nay in ra mot ngay, mai mot ngay khac.
        String ngayLap;
        if (hd.getTaoLuc() != null) {
            ngayLap = hd.getTaoLuc().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        } else if (hd.getNgayBatDau() != null) {
            ngayLap = hd.getNgayBatDau().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        } else {
            ngayLap = "…../…../……….";
        }
        context.setVariable("ngayLap", ngayLap);

        if (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null) {
            NguoiDung chuTro = hd.getPhong().getNhaTro().getChuTro();
            context.setVariable("tenChuTro", chuTro.getHoTen() != null ? chuTro.getHoTen() : "Chủ trọ");
            context.setVariable("sdtChuTro", chuTro.getSoDienThoai() != null ? chuTro.getSoDienThoai() : "");
            context.setVariable("cccdChuTro", chuTro.getSoCccd() != null ? chuTro.getSoCccd() : "");
            context.setVariable("emailChuTro", chuTro.getEmail() != null ? chuTro.getEmail() : "");
            context.setVariable("diaChiChuTro", chuTro.getDiaChi() != null ? chuTro.getDiaChi() : "");
        } else {
            context.setVariable("tenChuTro", "Chưa xác định");
            context.setVariable("sdtChuTro", "Chưa xác định");
            context.setVariable("cccdChuTro", "");
            context.setVariable("emailChuTro", "");
            context.setVariable("diaChiChuTro", "");
        }

        if (hd.getKhachThue() != null) {
            context.setVariable("tenKhachThue", hd.getKhachThue().getHoTen());
            context.setVariable("sdtKhachThue", hd.getKhachThue().getSoDienThoai());
            context.setVariable("cccdKhachThue", hd.getKhachThue().getSoCccd());
            context.setVariable("ngaySinhKhachThue", hd.getKhachThue().getNgaySinh() != null
                    ? hd.getKhachThue().getNgaySinh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "");
            context.setVariable("emailKhachThue", hd.getKhachThue().getEmail() != null ? hd.getKhachThue().getEmail() : "");
            context.setVariable("gioiTinhKhachThue", hd.getKhachThue().getGioiTinh() != null ? hd.getKhachThue().getGioiTinh() : "");
            context.setVariable("diaChiKhachThue", hd.getKhachThue().getDiaChi() != null ? hd.getKhachThue().getDiaChi() : "");
        } else {
            context.setVariable("tenKhachThue", "Chưa xác định");
            context.setVariable("sdtKhachThue", "");
            context.setVariable("cccdKhachThue", "");
            context.setVariable("ngaySinhKhachThue", "");
            context.setVariable("emailKhachThue", "");
            context.setVariable("gioiTinhKhachThue", "");
            context.setVariable("diaChiKhachThue", "");
        }

        context.setVariable("tenPhong", hd.getPhong() != null ? hd.getPhong().getTen() : "Chưa xác định");
        context.setVariable("diaChi", hd.getPhong() != null && hd.getPhong().getNhaTro() != null
                ? hd.getPhong().getNhaTro().getDiaChi() : "Chưa xác định");
        context.setVariable("dienTich", hd.getPhong() != null ? hd.getPhong().getDienTich() : null);
        context.setVariable("soNguoiToiDa", hd.getPhong() != null ? hd.getPhong().getSoNguoiToiDa() : null);

        long months = (hd.getNgayBatDau() != null && hd.getNgayKetThuc() != null)
                ? java.time.temporal.ChronoUnit.MONTHS.between(hd.getNgayBatDau(), hd.getNgayKetThuc()) : 0;
        context.setVariable("thoiHan", months + " tháng");
        context.setVariable("ngayBatDau", hd.getNgayBatDau() != null
                ? hd.getNgayBatDau().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "");
        context.setVariable("ngayKetThuc", hd.getNgayKetThuc() != null
                ? hd.getNgayKetThuc().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "");
        context.setVariable("giaThue", formatMoney(hd.getGiaThueHopDong()));
        context.setVariable("tienCoc", formatMoney(hd.getTienCoc()));
        context.setVariable("ngayThanhToan", hd.getNgayThanhToanHangThang() != null ? hd.getNgayThanhToanHangThang() : 5);
        context.setVariable("chuKyThanhToanLabel", chuKyThanhToanLabel(hd.getChuKyThanhToan()));

        String noiDung = hd.getNoiDungHopDong();
        if (noiDung == null || noiDung.trim().isEmpty()) {
            noiDung = getDefaultTerms();
        }
        context.setVariable("noiDungHopDong", chuanHoaDieuKhoan(noiDung));

        context.setVariable("chiSoDienBanDau", hd.getChiSoDienBanDau() != null ? hd.getChiSoDienBanDau() : 0);
        context.setVariable("chiSoNuocBanDau", hd.getChiSoNuocBanDau() != null ? hd.getChiSoNuocBanDau() : 0);

        if (hd.getPhong() != null && hd.getPhong().getId() != null) {
            var tienIchs = tienIchService.listByPhong(hd.getPhong().getId());
            context.setVariable("tienIchList", tienIchs);
            List<TaiSanPhong> taiSanList = taiSanPhongRepository.findByPhongId(hd.getPhong().getId());
            context.setVariable("taiSanList", taiSanList);
        } else {
            context.setVariable("tienIchList", List.of());
            context.setVariable("taiSanList", List.of());
        }

        List<java.util.Map<String, String>> dichVuList = new ArrayList<>();
        if (hd.getId() != null) {
            for (DichVuHopDong dv : dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(hd.getId())) {
                java.util.Map<String, String> row = new java.util.LinkedHashMap<>();
                row.put("ten", dv.getDichVu() != null && dv.getDichVu().getTenDichVu() != null
                        ? dv.getDichVu().getTenDichVu() : "");
                row.put("donGia", dv.getDonGiaApDung() != null
                        ? formatMoney(dv.getDonGiaApDung()) : "Theo quy định của tòa nhà");
                String tenDv = row.get("ten");
                String donVi = dv.getDichVu() != null && dv.getDichVu().getDonVi() != null
                        ? dv.getDichVu().getDonVi() : "";
                // Dien/Nuoc trong DB khong co don_vi, de trong thi bang gia trong hop
                // dong bi hong. Suy ra don vi chuan tu ten dich vu.
                if (donVi.isBlank()) {
                    donVi = donViMacDinh(tenDv);
                }
                row.put("donVi", donVi.isBlank() ? "—" : donVi);
                dichVuList.add(row);
            }
        }
        context.setVariable("dichVuList", dichVuList);

        List<java.util.Map<String, String>> thanhVienList = new ArrayList<>();
        if (hd.getId() != null) {
            for (ThanhVienHopDong tv : thanhVienHopDongRepository
                    .findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(hd.getId())) {
                if (Boolean.FALSE.equals(tv.getDangO())) {
                    continue;
                }
                java.util.Map<String, String> row = new java.util.LinkedHashMap<>();
                row.put("hoTen", tv.getHoTen() != null ? tv.getHoTen() : "");
                row.put("soCccd", tv.getSoCccd() != null && !tv.getSoCccd().isBlank() ? tv.getSoCccd() : "—");
                row.put("soDienThoai", tv.getSoDienThoai() != null && !tv.getSoDienThoai().isBlank()
                        ? tv.getSoDienThoai() : "—");
                row.put("vaiTro", Boolean.TRUE.equals(tv.getLaNguoiDaiDien()) ? "Người đại diện" : "Thành viên");
                thanhVienList.add(row);
            }
        }
        context.setVariable("thanhVienList", thanhVienList);

        String landlordName = (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null)
                ? hd.getPhong().getNhaTro().getChuTro().getHoTen() : "Chủ trọ";
        context.setVariable("landlordSignatureText", hd.getLandlordSignedAt() != null
                ? "Đã ký điện tử bởi " + landlordName : "(Chưa ký)");
        context.setVariable("landlordSignedAt", hd.getLandlordSignedAt() != null
                ? hd.getLandlordSignedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null);

        String tenantName = hd.getKhachThue() != null ? hd.getKhachThue().getHoTen() : "Khách thuê";
        context.setVariable("tenantSignatureText", hd.getTenantSignedAt() != null
                ? "Đã ký điện tử bởi " + tenantName : "(Chưa ký)");
        context.setVariable("tenantSignedAt", hd.getTenantSignedAt() != null
                ? hd.getTenantSignedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null);

        String tenantImg = null;
        String landlordImg = null;
        if (hd.getId() != null) {
            List<ContractSignature> signatures = signatureRepository.findByHopDongIdOrderBySignedAtAsc(hd.getId());
            for (ContractSignature sig : signatures) {
                if ("TENANT".equals(sig.getSignerRole()) && sig.getSignatureImageUrl() != null && !sig.getSignatureImageUrl().isEmpty()) {
                    tenantImg = sig.getSignatureImageUrl();
                }
                if ("LANDLORD".equals(sig.getSignerRole()) && sig.getSignatureImageUrl() != null && !sig.getSignatureImageUrl().isEmpty()) {
                    landlordImg = sig.getSignatureImageUrl();
                }
            }
        }
        context.setVariable("tenantSignatureImg", getBase64Image(tenantImg));
        context.setVariable("landlordSignatureImg", getBase64Image(landlordImg));

        return context;
    }

    public String renderHtml(HopDong hd) {
        Context context = buildContractContext(hd);
        return templateEngine.process("contract-template", context);
    }

    // Phai chay trong transaction: buildContractContext duyet cac quan he lazy
    // (phong -> nha_tro -> chu_tro, khach_thue...) nen session phai con mo.
    @Transactional(readOnly = true)
    public String renderHtml(UUID hopDongId) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        return renderHtml(hd);
    }

    public byte[] generatePdfBytes(HopDong hd) {
        String htmlContent = renderHtml(hd);
        try (ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();

            try (java.io.InputStream fontStream = new org.springframework.core.io.ClassPathResource("fonts/Roboto-Regular.ttf").getInputStream()) {
                File fontFile = File.createTempFile("Roboto", ".ttf");
                fontFile.deleteOnExit();
                java.nio.file.Files.copy(fontStream, fontFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                builder.useFont(fontFile, "Roboto");
            } catch (Exception fontEx) {
                log.warn("Could not load custom font", fontEx);
            }

            builder.withHtmlContent(htmlContent, null);
            builder.toStream(os);
            builder.run();
            return os.toByteArray();
        } catch (Exception e) {
            log.error("Lỗi sinh PDF cho hợp đồng {}: {}", hd.getId(), e.getMessage());
            throw new RuntimeException("Không thể sinh file PDF: " + e.getMessage(), e);
        }
    }

    // Xem ghi chu o renderHtml(UUID): can transaction cho cac quan he lazy.
    @Transactional(readOnly = true)
    public byte[] generatePdfBytes(UUID hopDongId) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        return generatePdfBytes(hd);
    }

    @Transactional
    public HopDong generatePdf(UUID hopDongId) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));

        byte[] pdfBytes = generatePdfBytes(hd);

        try {
            String fileName = "contract_" + hd.getId() + "_" + System.currentTimeMillis() + ".pdf";
            java.util.Map<String, Object> uploadResult = cloudinaryService.uploadPdf(pdfBytes, fileName);
            String url = (String) uploadResult.get("secure_url");

            hd.setFilePdf(url);
            if (hd.getSignatureStatus() == SignatureStatus.COMPLETED) {
                hd.setSignedPdfUrl(url);
            }

            return hopDongRepository.save(hd);
        } catch (Exception e) {
            log.error("Lỗi tải lên PDF cho hợp đồng {}: {}", hopDongId, e.getMessage());
            throw new RuntimeException("Không thể tải lên file PDF: " + e.getMessage(), e);
        }
    }

    @Transactional
    public ContractSignature signContract(UUID hopDongId, com.example.quanlyphongtro.dto.ContractSignRequest request) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));

        if (hd.getSignatureStatus() == SignatureStatus.COMPLETED) {
            throw new RuntimeException("Hợp đồng đã được ký hoàn tất");
        }

        // Khong cho ky khi ho so con thieu: ky xong hop dong bi khoa du lieu
        // (lockedAt) nen sau do khong the bo sung CCCD/dia chi... duoc nua.
        List<com.example.quanlyphongtro.dto.ThieuThongTinResponse> thieu = thieuThongTin(hd);
        if (!thieu.isEmpty()) {
            String moTa = thieu.stream()
                    .map(t -> benLabel(t.getBen()) + ": " + t.getNhan())
                    .collect(java.util.stream.Collectors.joining("; "));
            throw new RuntimeException("Chưa thể ký hợp đồng, còn thiếu thông tin bắt buộc: " + moTa);
        }

        String role = request.getRole() != null ? request.getRole() : "LANDLORD";

        String secureUrl = "";
        try {
            String base64Data = request.getSignatureBase64();
            if (base64Data != null && base64Data.contains(",")) {
                base64Data = base64Data.split(",")[1];
            }
            if (base64Data != null && !base64Data.isEmpty()) {
                byte[] imageBytes = java.util.Base64.getDecoder().decode(base64Data);
                String fileName = "signature_" + hd.getId() + "_" + role + "_" + System.currentTimeMillis();
                java.util.Map<String, Object> uploadResult = cloudinaryService.uploadImage(imageBytes, fileName);
                secureUrl = (String) uploadResult.get("secure_url");
            }
        } catch (Exception e) {
            log.error("Failed to upload signature image to Cloudinary", e);
            throw new RuntimeException("Lỗi khi tải lên chữ ký: " + e.getMessage());
        }

        ContractSignature signature = ContractSignature.builder()
                .hopDong(hd)
                .signerId(request.getSignerId())
                .signerRole(role)
                .signatureImageUrl(secureUrl)
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

        boolean completed = hd.getSignatureStatus() == SignatureStatus.COMPLETED;
        if (completed) {
            ZonedDateTime now = ZonedDateTime.now();
            hd.setTrangThai(TrangThaiHopDong.ACTIVE);
            hd.setConfirmedAt(hd.getConfirmedAt() != null ? hd.getConfirmedAt() : now);
            hd.setLockedAt(hd.getLockedAt() != null ? hd.getLockedAt() : now);
        }

        hopDongRepository.save(hd);
        if (completed) {
            syncRoomRented(hd);
            jdbcTemplate.queryForObject("SELECT public.tao_lich_thanh_toan_hang_thang(?::uuid)", Integer.class, hd.getId());
        }

        // Re-generate PDF to include signatures on Cloudinary
        generatePdf(hd.getId());

        // Notify
        if (hd.getSignatureStatus() == SignatureStatus.COMPLETED) {
            List<UUID> recipients = new ArrayList<>();
            if (hd.getKhachThue() != null && hd.getKhachThue().getNguoiDung() != null && hd.getKhachThue().getNguoiDung().getId() != null) {
                recipients.add(hd.getKhachThue().getNguoiDung().getId());
            }
            if (hd.getPhong() != null && hd.getPhong().getNhaTro() != null && hd.getPhong().getNhaTro().getChuTro() != null
                    && hd.getPhong().getNhaTro().getChuTro().getId() != null) {
                recipients.add(hd.getPhong().getNhaTro().getChuTro().getId());
            }
            if (!recipients.isEmpty()) {
                thongBaoService.createSystemNotification(
                        "Hợp đồng đã được ký hoàn tất",
                        "Hợp đồng thuê phòng " + hd.getPhong().getTen() + " đã được cả hai bên ký xác nhận thành công.",
                        LoaiThongBao.CONTRACT,
                        recipients
                );
            }
        }
        return signature;
    }

    private void syncRoomRented(HopDong hd) {
        if (hd.getPhong() == null || hd.getPhong().getId() == null) {
            return;
        }
        Phong phong = phongRepository.findById(hd.getPhong().getId()).orElse(null);
        if (phong == null || phong.getXoaLuc() != null) {
            return;
        }
        if (phong.getTrangThai() == TrangThaiPhong.MAINTENANCE || phong.getTrangThai() == TrangThaiPhong.INACTIVE) {
            return;
        }
        phong.setTrangThai(TrangThaiPhong.RENTED);
        phongRepository.save(phong);
    }

    /**
     * Liet ke cac truong bat buoc con thieu de hop dong du dieu kien ky.
     * Danh sach rong = day du. Dung chung cho ca viec chan ky o backend lan
     * hien canh bao tren giao dien truoc khi nguoi dung dat but ky.
     */
    /**
     * Kiem tra quyen doc hop dong BEN TRONG transaction.
     *
     * Controller khong duoc tu findById roi goi assertCanRead: canReadHopDong
     * duyet quan he lazy (khachThue -> nguoiDung) nen se nem
     * LazyInitializationException khi session da dong. Admin khong dinh loi nay
     * vi isAdmin() tra true truoc khi cham toi khachThue — chi khach thue moi vap.
     */
    @Transactional(readOnly = true)
    public String kiemTraQuyenDoc(UUID hopDongId, UUID userId) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        hopDongService.assertCanRead(hd, userId);
        // Tra ve ma hop dong luon de controller dat ten file tai xuong cho de doc,
        // thay vi phai cham lai entity ben ngoai transaction.
        return hd.getMaHopDong() != null ? hd.getMaHopDong() : hopDongId.toString();
    }

    @Transactional(readOnly = true)
    public List<com.example.quanlyphongtro.dto.ThieuThongTinResponse> kiemTraThongTinBatBuoc(UUID hopDongId) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        return thieuThongTin(hd);
    }

    private com.example.quanlyphongtro.dto.ThieuThongTinResponse muc(
            String ma, String nhan, String ben, boolean suaTaiCho) {
        return com.example.quanlyphongtro.dto.ThieuThongTinResponse.builder()
                .ma(ma).nhan(nhan).ben(ben).suaTaiCho(suaTaiCho).build();
    }

    private List<com.example.quanlyphongtro.dto.ThieuThongTinResponse> thieuThongTin(HopDong hd) {
        List<com.example.quanlyphongtro.dto.ThieuThongTinResponse> thieu = new ArrayList<>();

        NguoiDung chuTro = (hd.getPhong() != null && hd.getPhong().getNhaTro() != null)
                ? hd.getPhong().getNhaTro().getChuTro() : null;
        if (chuTro == null) {
            thieu.add(muc("BEN_A_THIEU", "Chưa xác định được chủ trọ của tòa nhà", "BEN_A", false));
        } else {
            if (isBlank(chuTro.getHoTen())) thieu.add(muc("BEN_A_HO_TEN", "Họ và tên", "BEN_A", true));
            if (isBlank(chuTro.getSoCccd())) thieu.add(muc("BEN_A_SO_CCCD", "Số CCCD/CMND", "BEN_A", true));
            if (isBlank(chuTro.getDiaChi())) thieu.add(muc("BEN_A_DIA_CHI", "Địa chỉ thường trú", "BEN_A", true));
            if (isBlank(chuTro.getSoDienThoai())) thieu.add(muc("BEN_A_SO_DIEN_THOAI", "Số điện thoại", "BEN_A", true));
        }

        KhachThue kt = hd.getKhachThue();
        if (kt == null) {
            thieu.add(muc("BEN_B_THIEU", "Chưa gán khách thuê cho hợp đồng", "BEN_B", false));
        } else {
            if (isBlank(kt.getHoTen())) thieu.add(muc("BEN_B_HO_TEN", "Họ và tên", "BEN_B", true));
            if (isBlank(kt.getSoCccd())) thieu.add(muc("BEN_B_SO_CCCD", "Số CCCD/CMND", "BEN_B", true));
            if (isBlank(kt.getSoDienThoai())) thieu.add(muc("BEN_B_SO_DIEN_THOAI", "Số điện thoại", "BEN_B", true));
            if (kt.getNgaySinh() == null) thieu.add(muc("BEN_B_NGAY_SINH", "Ngày sinh", "BEN_B", true));
            if (isBlank(kt.getDiaChi())) thieu.add(muc("BEN_B_DIA_CHI", "Địa chỉ thường trú", "BEN_B", true));
        }

        // Cac muc duoi thuoc ve hop dong, phai sua o form hop dong nen suaTaiCho = false.
        if (hd.getNgayBatDau() == null || hd.getNgayKetThuc() == null) {
            thieu.add(muc("HD_THOI_HAN", "Thời hạn thuê", "HOP_DONG", false));
        }
        if (hd.getGiaThueHopDong() == null || hd.getGiaThueHopDong().signum() <= 0) {
            thieu.add(muc("HD_GIA_THUE", "Giá thuê", "HOP_DONG", false));
        }
        if (hd.getTienCoc() == null) {
            thieu.add(muc("HD_TIEN_COC", "Tiền đặt cọc", "HOP_DONG", false));
        }
        if (hd.getNgayThanhToanHangThang() == null) {
            thieu.add(muc("HD_NGAY_THANH_TOAN", "Ngày thanh toán hằng tháng", "HOP_DONG", false));
        }

        return thieu;
    }

    /**
     * Bo sung cac truong bat buoc con thieu ngay tu dialog ky, thay vi bat admin
     * vao tung man hinh khac (hoac vao DB) de them tay.
     *
     * Chi ghi de truong nao duoc gui len va khac rong, nen goi mot phan an toan.
     * Tra ve danh sach con thieu sau khi luu de giao dien cap nhat ngay.
     */
    @Transactional
    public List<com.example.quanlyphongtro.dto.ThieuThongTinResponse> boSungThongTin(
            UUID hopDongId, com.example.quanlyphongtro.dto.BoSungThongTinRequest req) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        hopDongService.assertCanWrite(hd, permissionService.requireCurrentUserId());

        NguoiDung chuTro = (hd.getPhong() != null && hd.getPhong().getNhaTro() != null)
                ? hd.getPhong().getNhaTro().getChuTro() : null;
        if (chuTro != null) {
            if (coGiaTri(req.getBenAHoTen())) chuTro.setHoTen(req.getBenAHoTen().trim());
            if (coGiaTri(req.getBenASoCccd())) chuTro.setSoCccd(req.getBenASoCccd().trim());
            if (coGiaTri(req.getBenASoDienThoai())) chuTro.setSoDienThoai(req.getBenASoDienThoai().trim());
            if (coGiaTri(req.getBenADiaChi())) chuTro.setDiaChi(req.getBenADiaChi().trim());
            nguoiDungRepository.save(chuTro);
        }

        KhachThue kt = hd.getKhachThue();
        if (kt != null) {
            if (coGiaTri(req.getBenBHoTen())) kt.setHoTen(req.getBenBHoTen().trim());
            if (coGiaTri(req.getBenBSoCccd())) kt.setSoCccd(req.getBenBSoCccd().trim());
            if (coGiaTri(req.getBenBSoDienThoai())) kt.setSoDienThoai(req.getBenBSoDienThoai().trim());
            if (coGiaTri(req.getBenBDiaChi())) kt.setDiaChi(req.getBenBDiaChi().trim());
            if (req.getBenBNgaySinh() != null) kt.setNgaySinh(req.getBenBNgaySinh());
            khachThueRepository.save(kt);
        }

        return thieuThongTin(hd);
    }

    private boolean coGiaTri(String s) {
        return s != null && !s.trim().isEmpty();
    }

    private String benLabel(String ben) {
        if (ben == null) return "";
        return switch (ben) {
            case "BEN_A" -> "Bên A";
            case "BEN_B" -> "Bên B";
            default -> "Hợp đồng";
        };
    }

    /**
     * Dieu khoan duoc luu vao noi_dung_hop_dong duoi dang plain text (moi muc cach
     * nhau bang dong trong), nhung template render bang th:utext nen HTML nuot het
     * xuong dong va tat ca don thanh mot khoi lien tuc.
     *
     * Neu chuoi da co san the HTML thi giu nguyen; nguoc lai thi escape roi boc moi
     * doan vao <p> de moi muc nam mot dong rieng.
     */
    private String chuanHoaDieuKhoan(String noiDung) {
        if (noiDung == null || noiDung.isBlank()) return "";
        if (noiDung.contains("<p") || noiDung.contains("<ul") || noiDung.contains("<div")) {
            return noiDung;
        }
        StringBuilder sb = new StringBuilder();
        for (String doan : noiDung.trim().split("\\r?\\n\\s*\\r?\\n|\\r?\\n")) {
            String t = doan.trim();
            if (t.isEmpty()) continue;
            String an = t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
            sb.append("<p style=\"margin:0 0 6px 0\">").append(an).append("</p>");
        }
        return sb.toString();
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    @Transactional
    public HopDong rejectContract(UUID hopDongId, com.example.quanlyphongtro.dto.ContractSignRequest request) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        hd.setSignatureStatus(SignatureStatus.REJECTED);
        hd.setGhiChu(hd.getGhiChu() != null
                ? hd.getGhiChu() + "\nTừ chối ký: " + request.getRejectionReason()
                : "Từ chối ký: " + request.getRejectionReason());
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
