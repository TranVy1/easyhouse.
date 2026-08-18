package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.DuyetYeuCauHopDongRequest;
import com.example.quanlyphongtro.dto.YeuCauHopDongRequest;
import com.example.quanlyphongtro.dto.YeuCauHopDongResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.YeuCauHopDongRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Yeu cau huy / gia han hop dong do khach thue gui, chu tro duyet.
 *
 * Nguyen tac: service nay KHONG tu dong dung vao tien. Duyet mot yeu cau HUY chi
 * mo duong sang buoc quyet toan tra phong chu khong tu tao ban ghi tai chinh —
 * viec tru coc phai di qua bien ban ban giao co chu ky hai ben.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class YeuCauHopDongService {

    private final YeuCauHopDongRepository yeuCauRepository;
    private final HopDongRepository hopDongRepository;
    private final HopDongService hopDongService;
    private final PermissionService permissionService;
    private final ThongBaoService thongBaoService;

    /* ------------------------------------------------------------------ */
    /*  Khach thue gui yeu cau                                             */
    /* ------------------------------------------------------------------ */

    @Transactional
    public YeuCauHopDongResponse tao(UUID hopDongId, YeuCauHopDongRequest req) {
        UUID userId = permissionService.requireCurrentUserId();
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        // Khach thue cua chinh hop dong, chu tro so huu phong, hoac admin.
        hopDongService.assertCanRead(hd, userId);

        LoaiYeuCauHopDong loai = parseLoai(req.getLoai());

        if (hd.getTrangThai() != TrangThaiHopDong.ACTIVE) {
            throw new RuntimeException("Chỉ hợp đồng đang hiệu lực mới gửi được yêu cầu");
        }

        // Kiem tra o tang ung dung de bao loi de hieu; CSDL van co unique partial
        // index chan that su neu hai request vao cung luc.
        yeuCauRepository.findFirstByHopDongIdAndTrangThai(hopDongId, TrangThaiYeuCauHopDong.CHO_DUYET)
                .ifPresent(y -> {
                    throw new RuntimeException("Hợp đồng đã có một yêu cầu đang chờ duyệt, "
                            + "vui lòng chờ xử lý hoặc rút lại yêu cầu cũ");
                });

        Integer soThang = null;
        LocalDate ngayMongMuon = req.getNgayMongMuon();

        if (loai == LoaiYeuCauHopDong.GIA_HAN) {
            soThang = req.getSoThangGiaHan();
            if (soThang == null || soThang <= 0) {
                throw new RuntimeException("Vui lòng nhập số tháng muốn gia hạn");
            }
            if (soThang > 60) {
                throw new RuntimeException("Số tháng gia hạn tối đa là 60");
            }
            // Suy ra ngay ket thuc mong muon tu han hien tai neu khach khong nhap.
            if (ngayMongMuon == null && hd.getNgayKetThuc() != null) {
                ngayMongMuon = hd.getNgayKetThuc().plusMonths(soThang);
            }
        } else {
            // HUY: cot so_thang_gia_han phai null (CSDL co check constraint).
            if (ngayMongMuon == null) {
                throw new RuntimeException("Vui lòng chọn ngày mong muốn trả phòng");
            }
            if (ngayMongMuon.isBefore(LocalDate.now())) {
                throw new RuntimeException("Ngày trả phòng không được ở quá khứ");
            }
        }

        YeuCauHopDong y = YeuCauHopDong.builder()
                .hopDong(hd)
                .loai(loai)
                .trangThai(TrangThaiYeuCauHopDong.CHO_DUYET)
                .lyDo(req.getLyDo())
                .ngayMongMuon(ngayMongMuon)
                .soThangGiaHan(soThang)
                .nguoiTaoId(userId)
                .build();
        y = yeuCauRepository.save(y);

        baoChuTro(hd, loai == LoaiYeuCauHopDong.HUY
                        ? "Yêu cầu hủy hợp đồng mới"
                        : "Yêu cầu gia hạn hợp đồng mới",
                "Hợp đồng " + hd.getMaHopDong() + " (phòng "
                        + (hd.getPhong() != null ? hd.getPhong().getTen() : "?") + ") có yêu cầu "
                        + (loai == LoaiYeuCauHopDong.HUY ? "hủy" : "gia hạn") + " đang chờ duyệt.");

        return YeuCauHopDongResponse.from(y);
    }

    /** Khach thue rut lai yeu cau khi admin chua xu ly. */
    @Transactional
    public YeuCauHopDongResponse rutLai(UUID yeuCauId) {
        UUID userId = permissionService.requireCurrentUserId();
        YeuCauHopDong y = layVaKiemTraDoc(yeuCauId, userId);

        if (y.getTrangThai() != TrangThaiYeuCauHopDong.CHO_DUYET) {
            throw new RuntimeException("Chỉ rút lại được yêu cầu đang chờ duyệt");
        }
        y.setTrangThai(TrangThaiYeuCauHopDong.DA_HUY_YEU_CAU);
        return YeuCauHopDongResponse.from(yeuCauRepository.save(y));
    }

    /* ------------------------------------------------------------------ */
    /*  Admin duyet / tu choi                                              */
    /* ------------------------------------------------------------------ */

    @Transactional
    public YeuCauHopDongResponse duyet(UUID yeuCauId, DuyetYeuCauHopDongRequest req) {
        UUID userId = permissionService.requireCurrentUserId();
        YeuCauHopDong y = yeuCauRepository.findById(yeuCauId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy yêu cầu"));
        HopDong hd = y.getHopDong();
        hopDongService.assertCanWrite(hd, userId);

        if (y.getTrangThai() != TrangThaiYeuCauHopDong.CHO_DUYET) {
            throw new RuntimeException("Yêu cầu này đã được xử lý");
        }

        if (y.getLoai() == LoaiYeuCauHopDong.GIA_HAN) {
            // Admin duoc phep dieu chinh so thang / gia thue so voi de xuat.
            LocalDate ngayKetThucMoi = req.getNgayKetThucMoi();
            if (ngayKetThucMoi == null) {
                int soThang = req.getSoThangGiaHan() != null ? req.getSoThangGiaHan()
                        : (y.getSoThangGiaHan() != null ? y.getSoThangGiaHan() : 0);
                if (soThang <= 0 || hd.getNgayKetThuc() == null) {
                    throw new RuntimeException("Không xác định được ngày kết thúc mới");
                }
                ngayKetThucMoi = hd.getNgayKetThuc().plusMonths(soThang);
            }
            if (hd.getNgayKetThuc() != null && !ngayKetThucMoi.isAfter(hd.getNgayKetThuc())) {
                throw new RuntimeException("Ngày kết thúc mới phải sau ngày kết thúc hiện tại");
            }

            var giaHanReq = new com.example.quanlyphongtro.dto.GiaHanHopDongRequest();
            giaHanReq.setNgayKetThucMoi(ngayKetThucMoi);
            giaHanReq.setGiaThueMoi(req.getGiaThueMoi());
            giaHanReq.setNoiDung("Gia hạn theo yêu cầu của khách thuê ngày "
                    + y.getTaoLuc().toLocalDate());
            // extendContract tu tao phu luc va cap nhat han hop dong.
            hopDongService.extendContract(hd.getId(), giaHanReq);
        }
        // Voi HUY: chi danh dau da duyet. Buoc tiep theo la tao quyet toan tra
        // phong roi lap bien ban ban giao — co tinh tien nen khong tu dong chay.

        y.setTrangThai(TrangThaiYeuCauHopDong.DA_DUYET);
        y.setNguoiDuyetId(userId);
        y.setGhiChuDuyet(req.getGhiChuDuyet());
        y.setDuyetLuc(ZonedDateTime.now());
        y = yeuCauRepository.save(y);

        baoKhachThue(hd, "Yêu cầu đã được duyệt",
                (y.getLoai() == LoaiYeuCauHopDong.HUY
                        ? "Yêu cầu hủy hợp đồng " : "Yêu cầu gia hạn hợp đồng ")
                        + hd.getMaHopDong() + " đã được chủ trọ duyệt."
                        + (y.getLoai() == LoaiYeuCauHopDong.HUY
                        ? " Vui lòng phối hợp lập biên bản bàn giao trước khi trả phòng." : ""));

        return YeuCauHopDongResponse.from(y);
    }

    @Transactional
    public YeuCauHopDongResponse tuChoi(UUID yeuCauId, DuyetYeuCauHopDongRequest req) {
        UUID userId = permissionService.requireCurrentUserId();
        YeuCauHopDong y = yeuCauRepository.findById(yeuCauId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy yêu cầu"));
        HopDong hd = y.getHopDong();
        hopDongService.assertCanWrite(hd, userId);

        if (y.getTrangThai() != TrangThaiYeuCauHopDong.CHO_DUYET) {
            throw new RuntimeException("Yêu cầu này đã được xử lý");
        }
        if (req.getGhiChuDuyet() == null || req.getGhiChuDuyet().isBlank()) {
            throw new RuntimeException("Vui lòng nhập lý do từ chối để khách thuê nắm được");
        }

        y.setTrangThai(TrangThaiYeuCauHopDong.TU_CHOI);
        y.setNguoiDuyetId(userId);
        y.setGhiChuDuyet(req.getGhiChuDuyet());
        y.setDuyetLuc(ZonedDateTime.now());
        y = yeuCauRepository.save(y);

        baoKhachThue(hd, "Yêu cầu bị từ chối",
                "Yêu cầu của bạn cho hợp đồng " + hd.getMaHopDong()
                        + " đã bị từ chối. Lý do: " + req.getGhiChuDuyet());

        return YeuCauHopDongResponse.from(y);
    }

    /* ------------------------------------------------------------------ */
    /*  Truy van                                                           */
    /* ------------------------------------------------------------------ */

    @Transactional(readOnly = true)
    public List<YeuCauHopDongResponse> theoHopDong(UUID hopDongId) {
        UUID userId = permissionService.requireCurrentUserId();
        HopDong hd = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        hopDongService.assertCanRead(hd, userId);
        return yeuCauRepository.findByHopDongIdOrderByTaoLucDesc(hopDongId)
                .stream().map(YeuCauHopDongResponse::from).toList();
    }

    /** Hang doi duyet: admin thay tat ca, chu tro chi thay hop dong cua minh. */
    @Transactional(readOnly = true)
    public List<YeuCauHopDongResponse> hangDoiChoDuyet() {
        UUID userId = permissionService.requireCurrentUserId();
        List<YeuCauHopDong> ds = permissionService.isAdmin(userId)
                ? yeuCauRepository.findByTrangThaiOrderByTaoLucDesc(TrangThaiYeuCauHopDong.CHO_DUYET)
                : yeuCauRepository.findChoDuyetTheoChuTro(TrangThaiYeuCauHopDong.CHO_DUYET, userId);
        return ds.stream().map(YeuCauHopDongResponse::from).toList();
    }

    /* ------------------------------------------------------------------ */

    private YeuCauHopDong layVaKiemTraDoc(UUID yeuCauId, UUID userId) {
        YeuCauHopDong y = yeuCauRepository.findById(yeuCauId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy yêu cầu"));
        hopDongService.assertCanRead(y.getHopDong(), userId);
        return y;
    }

    private LoaiYeuCauHopDong parseLoai(String loai) {
        try {
            return LoaiYeuCauHopDong.valueOf(loai.trim().toUpperCase());
        } catch (Exception e) {
            throw new RuntimeException("Loại yêu cầu không hợp lệ, chỉ nhận HUY hoặc GIA_HAN");
        }
    }

    private void baoChuTro(HopDong hd, String tieuDe, String noiDung) {
        List<UUID> nguoiNhan = new ArrayList<>();
        if (hd.getPhong() != null && hd.getPhong().getNhaTro() != null
                && hd.getPhong().getNhaTro().getChuTro() != null) {
            nguoiNhan.add(hd.getPhong().getNhaTro().getChuTro().getId());
        }
        guiThongBao(tieuDe, noiDung, nguoiNhan);
    }

    private void baoKhachThue(HopDong hd, String tieuDe, String noiDung) {
        List<UUID> nguoiNhan = new ArrayList<>();
        if (hd.getKhachThue() != null && hd.getKhachThue().getNguoiDung() != null) {
            nguoiNhan.add(hd.getKhachThue().getNguoiDung().getId());
        }
        guiThongBao(tieuDe, noiDung, nguoiNhan);
    }

    private void guiThongBao(String tieuDe, String noiDung, List<UUID> nguoiNhan) {
        if (nguoiNhan.isEmpty()) {
            return;
        }
        try {
            thongBaoService.createSystemNotification(tieuDe, noiDung, LoaiThongBao.CONTRACT, nguoiNhan);
        } catch (Exception e) {
            // Gui thong bao that bai khong duoc lam hong nghiep vu chinh.
            log.warn("Khong gui duoc thong bao yeu cau hop dong: {}", e.getMessage());
        }
    }
}
