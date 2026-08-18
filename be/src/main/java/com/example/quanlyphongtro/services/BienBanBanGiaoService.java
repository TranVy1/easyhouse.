package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.ChiTietBanGiaoTaiSanRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.QuyetToanTraPhongRepository;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Bien ban ban giao khi khach tra phong — can cu phap ly cho viec tru tien coc
 * va boi thuong khau hao tai san.
 *
 * Ben A = chu tro (ben NHAN ban giao), Ben B = khach thue (ben BAN GIAO), dung
 * theo mau "Bien ban ban giao nha cho thue". Luu y chieu nay NGUOC voi hop dong
 * thue (o hop dong Ben A la ben cho thue, ky o cot phai).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class BienBanBanGiaoService {

    private static final DateTimeFormatter NGAY = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter NGAY_GIO = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final QuyetToanTraPhongRepository quyetToanRepository;
    private final ChiTietBanGiaoTaiSanRepository chiTietBanGiaoRepository;
    private final HopDongRepository hopDongRepository;
    private final HopDongService hopDongService;
    private final PermissionService permissionService;
    private final CloudinaryService cloudinaryService;
    private final TemplateEngine templateEngine;

    /* ------------------------------------------------------------------ */
    /*  Render                                                             */
    /* ------------------------------------------------------------------ */

    @Transactional(readOnly = true)
    public String renderHtml(UUID hopDongId) {
        return templateEngine.process("bien-ban-ban-giao", buildContext(layQuyetToan(hopDongId)));
    }

    @Transactional(readOnly = true)
    public byte[] renderPdf(UUID hopDongId) {
        String html = templateEngine.process("bien-ban-ban-giao", buildContext(layQuyetToan(hopDongId)));
        return htmlSangPdf(html, hopDongId);
    }

    /** Kiem tra quyen doc trong transaction; tra ve ma hop dong de dat ten file. */
    @Transactional(readOnly = true)
    public String kiemTraQuyenDoc(UUID hopDongId, UUID userId) {
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        hopDongService.assertCanRead(hd, userId);
        return hd.getMaHopDong() != null ? hd.getMaHopDong() : hopDongId.toString();
    }

    /* ------------------------------------------------------------------ */
    /*  Ky bien ban                                                        */
    /* ------------------------------------------------------------------ */

    /**
     * @param vaiTro BEN_A (chu tro) hoac BEN_B (khach thue)
     */
    @Transactional
    public QuyetToanTraPhong ky(UUID hopDongId, String vaiTro, String chuKyBase64) {
        UUID userId = permissionService.requireCurrentUserId();
        QuyetToanTraPhong qt = layQuyetToan(hopDongId);
        HopDong hd = qt.getHopDong();
        hopDongService.assertCanRead(hd, userId);

        if (qt.getBienBanTrangThai() == TrangThaiBienBanBanGiao.HOAN_TAT) {
            throw new RuntimeException("Biên bản đã được ký đủ hai bên");
        }
        // Chi ky duoc khi da kiem ke xong tung tai san — bien ban khong duoc phep
        // chot khi hien trang tai san con bo trong.
        List<ChiTietBanGiaoTaiSan> ds = chiTietBanGiaoRepository
                .findByQuyetToanTraPhongIdOrderByTaoLucAsc(qt.getId());
        if (ds.stream().anyMatch(x -> x.getSoLuongThucTe() == null
                || x.getTinhTrangThucTe() == null || x.getTinhTrangThucTe().isBlank())) {
            throw new RuntimeException("Cần kiểm kê đầy đủ số lượng và tình trạng thực tế "
                    + "của từng tài sản trước khi ký biên bản");
        }

        String benChuanHoa = vaiTro == null ? "" : vaiTro.trim().toUpperCase();
        if (!"BEN_A".equals(benChuanHoa) && !"BEN_B".equals(benChuanHoa)) {
            throw new RuntimeException("Vai trò ký không hợp lệ, chỉ nhận BEN_A hoặc BEN_B");
        }

        String url = taiChuKyLen(chuKyBase64, hopDongId, benChuanHoa);
        ZonedDateTime now = ZonedDateTime.now();

        if ("BEN_A".equals(benChuanHoa)) {
            if (qt.getBenAKyLuc() != null) {
                throw new RuntimeException("Bên A đã ký biên bản này");
            }
            qt.setBenAChuKyUrl(url);
            qt.setBenAKyLuc(now);
        } else {
            if (qt.getBenBKyLuc() != null) {
                throw new RuntimeException("Bên B đã ký biên bản này");
            }
            qt.setBenBChuKyUrl(url);
            qt.setBenBKyLuc(now);
        }

        boolean duHai = qt.getBenAKyLuc() != null && qt.getBenBKyLuc() != null;
        qt.setBienBanTrangThai(duHai ? TrangThaiBienBanBanGiao.HOAN_TAT
                : ("BEN_A".equals(benChuanHoa) ? TrangThaiBienBanBanGiao.BEN_A_DA_KY
                                               : TrangThaiBienBanBanGiao.BEN_B_DA_KY));
        if (qt.getGioBanGiao() == null || qt.getGioBanGiao().isBlank()) {
            qt.setGioBanGiao(now.format(DateTimeFormatter.ofPattern("HH:mm")));
        }
        quyetToanRepository.save(qt);

        // Sinh lai PDF de ban luu tru co chu ky moi nhat.
        try {
            byte[] pdf = htmlSangPdf(templateEngine.process("bien-ban-ban-giao", buildContext(qt)), hopDongId);
            Map<String, Object> kq = cloudinaryService.uploadPdf(pdf, "bien-ban-" + hopDongId);
            qt.setBienBanPdfUrl((String) kq.get("secure_url"));
            quyetToanRepository.save(qt);
        } catch (Exception e) {
            // Khong chan viec ky neu upload that bai: bien ban van xem duoc qua
            // endpoint render truc tiep.
            log.warn("Khong upload duoc PDF bien ban {}: {}", hopDongId, e.getMessage());
        }
        return qt;
    }

    /* ------------------------------------------------------------------ */

    private QuyetToanTraPhong layQuyetToan(UUID hopDongId) {
        return quyetToanRepository.findByHopDongId(hopDongId)
                .orElseThrow(() -> new RuntimeException(
                        "Chưa có quyết toán trả phòng, cần lập quyết toán trước khi làm biên bản"));
    }

    private Context buildContext(QuyetToanTraPhong qt) {
        HopDong hd = qt.getHopDong();
        Context c = new Context();

        c.setVariable("maHopDong", hd.getMaHopDong());
        c.setVariable("ngayKyHopDong", hd.getTaoLuc() != null ? hd.getTaoLuc().format(NGAY) : "…");
        c.setVariable("ngayLapBienBan", qt.getNgayTraPhong() != null
                ? qt.getNgayTraPhong().format(NGAY) : ZonedDateTime.now().format(NGAY));
        c.setVariable("gioBanGiao", qt.getGioBanGiao() != null ? qt.getGioBanGiao() : "…….");

        Phong phong = hd.getPhong();
        c.setVariable("tenPhong", phong != null ? phong.getTen() : "…");
        c.setVariable("diaChi", phong != null && phong.getNhaTro() != null
                ? phong.getNhaTro().getDiaChi() : "…");

        NguoiDung chuTro = (phong != null && phong.getNhaTro() != null)
                ? phong.getNhaTro().getChuTro() : null;
        c.setVariable("tenChuTro", chuTro != null && chuTro.getHoTen() != null ? chuTro.getHoTen() : "…");
        c.setVariable("sdtChuTro", chuTro != null && chuTro.getSoDienThoai() != null ? chuTro.getSoDienThoai() : "…");
        c.setVariable("cccdChuTro", chuTro != null && chuTro.getSoCccd() != null ? chuTro.getSoCccd() : "…");
        c.setVariable("emailChuTro", chuTro != null && chuTro.getEmail() != null ? chuTro.getEmail() : "…");
        c.setVariable("diaChiChuTro", chuTro != null && chuTro.getDiaChi() != null ? chuTro.getDiaChi() : "…");

        KhachThue kt = hd.getKhachThue();
        c.setVariable("tenKhachThue", kt != null && kt.getHoTen() != null ? kt.getHoTen() : "…");
        c.setVariable("sdtKhachThue", kt != null && kt.getSoDienThoai() != null ? kt.getSoDienThoai() : "…");
        c.setVariable("cccdKhachThue", kt != null && kt.getSoCccd() != null ? kt.getSoCccd() : "…");
        c.setVariable("ngaySinhKhachThue", kt != null && kt.getNgaySinh() != null
                ? kt.getNgaySinh().format(NGAY) : "…");
        c.setVariable("diaChiKhachThue", kt != null && kt.getDiaChi() != null ? kt.getDiaChi() : "…");

        // Bang hien trang tai san + ly do khau tru.
        List<Map<String, String>> taiSanList = new ArrayList<>();
        List<String> lyDoList = new ArrayList<>();
        for (ChiTietBanGiaoTaiSan ts : chiTietBanGiaoRepository
                .findByQuyetToanTraPhongIdOrderByTaoLucAsc(qt.getId())) {
            Map<String, String> row = new LinkedHashMap<>();
            row.put("ten", nvl(ts.getTenTaiSan()));
            row.put("soLuongBanDau", ts.getSoLuongBanDau() != null ? String.valueOf(ts.getSoLuongBanDau()) : "—");
            row.put("tinhTrangBanDau", nvl(ts.getTinhTrangBanDau()));
            row.put("soLuongThucTe", ts.getSoLuongThucTe() != null ? String.valueOf(ts.getSoLuongThucTe()) : "—");
            row.put("tinhTrangThucTe", nvl(ts.getTinhTrangThucTe()));
            row.put("mucKhauTru", tien(ts.getMucKhauTru()));
            taiSanList.add(row);

            if (ts.getMucKhauTru() != null && ts.getMucKhauTru().signum() > 0) {
                lyDoList.add(nvl(ts.getTenTaiSan()) + ": " + tien(ts.getMucKhauTru()) + " VNĐ"
                        + (ts.getLyDoKhauTru() != null && !ts.getLyDoKhauTru().isBlank()
                        ? " — " + ts.getLyDoKhauTru() : ""));
            }
        }
        c.setVariable("taiSanList", taiSanList);
        c.setVariable("lyDoKhauTruList", lyDoList);

        c.setVariable("chiSoDienCuoi", hd.getChiSoDienBanDau() != null ? hd.getChiSoDienBanDau() : "—");
        c.setVariable("chiSoNuocCuoi", hd.getChiSoNuocBanDau() != null ? hd.getChiSoNuocBanDau() : "—");

        c.setVariable("tienCocBanDau", tien(qt.getTienCocBanDau()));
        c.setVariable("tienCocDaCanTru", tien(qt.getTienCocDaCanTru()));
        c.setVariable("tienCocCanHoan", tien(qt.getTienCocCanHoan()));
        c.setVariable("tienPhaiThuThem", tien(qt.getTienPhaiThuThem()));
        c.setVariable("coPhaiThuThem", qt.getTienPhaiThuThem() != null
                && qt.getTienPhaiThuThem().signum() > 0);
        c.setVariable("ghiChu", qt.getGhiChu());

        c.setVariable("benAKyText", qt.getBenAKyLuc() != null
                ? "Đã ký điện tử" : "(Chưa ký)");
        c.setVariable("benBKyText", qt.getBenBKyLuc() != null
                ? "Đã ký điện tử" : "(Chưa ký)");
        c.setVariable("benAKyLuc", qt.getBenAKyLuc() != null ? qt.getBenAKyLuc().format(NGAY_GIO) : null);
        c.setVariable("benBKyLuc", qt.getBenBKyLuc() != null ? qt.getBenBKyLuc().format(NGAY_GIO) : null);
        c.setVariable("benAChuKyImg", anhBase64(qt.getBenAChuKyUrl()));
        c.setVariable("benBChuKyImg", anhBase64(qt.getBenBChuKyUrl()));

        return c;
    }

    private byte[] htmlSangPdf(String html, UUID hopDongId) {
        try (ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            try (var fontStream = new org.springframework.core.io.ClassPathResource(
                    "fonts/Roboto-Regular.ttf").getInputStream()) {
                File fontFile = File.createTempFile("Roboto", ".ttf");
                fontFile.deleteOnExit();
                java.nio.file.Files.copy(fontStream, fontFile.toPath(),
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                builder.useFont(fontFile, "Roboto");
            } catch (Exception fontEx) {
                log.warn("Khong nap duoc font cho bien ban", fontEx);
            }
            builder.withHtmlContent(html, null);
            builder.toStream(os);
            builder.run();
            return os.toByteArray();
        } catch (Exception e) {
            log.error("Loi sinh PDF bien ban cho hop dong {}: {}", hopDongId, e.getMessage());
            throw new RuntimeException("Không thể sinh biên bản: " + e.getMessage(), e);
        }
    }

    private String taiChuKyLen(String base64, UUID hopDongId, String ben) {
        try {
            String data = base64;
            if (data != null && data.contains(",")) {
                data = data.split(",")[1];
            }
            if (data == null || data.isEmpty()) {
                throw new RuntimeException("Chữ ký trống");
            }
            byte[] bytes = java.util.Base64.getDecoder().decode(data);
            Map<String, Object> kq = cloudinaryService.uploadImage(bytes,
                    "bienban_" + hopDongId + "_" + ben + "_" + System.currentTimeMillis());
            return (String) kq.get("secure_url");
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tải lên chữ ký: " + e.getMessage(), e);
        }
    }

    private String anhBase64(String url) {
        if (url == null || url.isEmpty()) return null;
        try (var is = new java.net.URL(url).openStream()) {
            return "data:image/png;base64,"
                    + java.util.Base64.getEncoder().encodeToString(is.readAllBytes());
        } catch (Exception e) {
            log.warn("Khong tai duoc anh chu ky cho bien ban: {}", url);
            return null;
        }
    }

    private String tien(BigDecimal v) {
        return v == null ? "0" : String.format("%,.0f", v);
    }

    private String nvl(String s) {
        return s == null || s.isBlank() ? "—" : s;
    }
}
