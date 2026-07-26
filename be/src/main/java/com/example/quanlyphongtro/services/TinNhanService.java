package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ChiTietTinNhanResponse;
import com.example.quanlyphongtro.dto.GuiTinNhanRequest;
import com.example.quanlyphongtro.dto.LienKetChatResponse;
import com.example.quanlyphongtro.dto.NguoiXemTinResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.dto.SuKienTrangThaiChat;
import com.example.quanlyphongtro.dto.TepDinhKemResponse;
import com.example.quanlyphongtro.dto.TinNhanResponse;
import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.FileMedia;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.entity.LoaiTinNhan;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.entity.TinNhan;
import com.example.quanlyphongtro.event.TinNhanCreatedEvent;
import com.example.quanlyphongtro.exception.ChatKhongCoQuyenException;
import com.example.quanlyphongtro.exception.ChatKhongTimThayException;
import com.example.quanlyphongtro.exception.ChatYeuCauKhongHopLeException;
import com.example.quanlyphongtro.repository.CuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.FileMediaRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.TinNhanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TinNhanService {

    /** Chan client keo ca nghin tin trong mot lan goi. */
    private static final int GIOI_HAN_TOI_DA = 100;
    private static final int DO_DAI_XEM_TRUOC = 120;

    private final TinNhanRepository tinNhanRepository;
    private final CuocTroChuyenRepository cuocTroChuyenRepository;
    private final ThanhVienCuocTroChuyenRepository thanhVienRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final FileMediaRepository fileMediaRepository;
    private final PermissionService permissionService;
    private final ChatPermissionService chatPermissionService;
    private final CuocTroChuyenService cuocTroChuyenService;
    private final ChatRealtimeService chatRealtimeService;
    private final CloudinaryService cloudinaryService;
    private final ApplicationEventPublisher eventPublisher;

    // ── Gui tin ────────────────────────────────────────────────────────────

    @Transactional
    public TinNhanResponse guiTinNhan(UUID hoiThoaiId, GuiTinNhanRequest request) {
        UUID toi = permissionService.requireCurrentUserId();
        CuocTroChuyen hoiThoai = cuocTroChuyenService.yeuCauHoiThoai(hoiThoaiId);
        chatPermissionService.yeuCauCoTheGui(hoiThoai, toi);

        LoaiTinNhan loai = phanTichLoai(request.getLoai());
        FileMedia file = napFile(request.getFileMediaId());

        boolean rongTuot = (request.getNoiDung() == null || request.getNoiDung().isBlank()) && file == null;
        if (rongTuot) {
            throw new ChatYeuCauKhongHopLeException("Tin nhan phai co noi dung hoac tep dinh kem");
        }

        // Idempotency: client retry sau khi mat mang se nhan lai dung tin cu,
        // thay vi tao ban sao thu hai.
        if (request.getMaClient() != null && !request.getMaClient().isBlank()) {
            var daCo = tinNhanRepository.findByCuocTroChuyenIdAndMaClient(hoiThoaiId, request.getMaClient());
            if (daCo.isPresent()) {
                return TinNhanResponse.fromEntity(daCo.get());
            }
        }

        TinNhan tinNhan = TinNhan.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiGui(nguoiDungRepository.getReferenceById(toi))
                .loai(loai)
                .noiDung(request.getNoiDung())
                .fileMedia(file)
                .traLoiCho(napTinTraLoi(request.getTraLoiChoId(), hoiThoaiId))
                .maClient(request.getMaClient())
                .build();

        // saveAndFlush de PostgreSQL cap phat so_thu_tu (cot bigserial) va Hibernate
        // doc nguoc gia tri do ve — DTO tra cho client bat buoc phai co so thu tu.
        tinNhan = tinNhanRepository.saveAndFlush(tinNhan);

        capNhatTomTat(hoiThoai, tinNhan);

        TinNhanResponse response = TinNhanResponse.fromEntity(tinNhan);
        // Gui cho CA nguoi gui: cac thiet bi/tab khac cua ho cung phai thay tin nay.
        // Tab dang gui tu khu trung bang maClient.
        eventPublisher.publishEvent(new TinNhanCreatedEvent(response, idThanhVienDangHoatDong(hoiThoaiId)));

        return response;
    }

    // ── Tep dinh kem ───────────────────────────────────────────────────────

    /** Ảnh tối đa 10MB — khớp với spring.servlet.multipart.max-file-size. */
    private static final long GIOI_HAN_TEP_BYTE = 10L * 1024 * 1024;

    /**
     * Tai tep len roi tra ve id de client gui kem trong tin nhan.
     *
     * Tach lam hai buoc (tai len -> gui tin) chu khong gop lam mot multipart, vi:
     *   - nguoi dung thay anh xem truoc ngay trong khi con dang go noi dung
     *   - gui lai khi loi mang khong phai tai lai tep
     *   - duong gui tin van thuan JSON, giu nguyen co che chong trung bang maClient
     *
     * KHONG dung /api/upload san co: endpoint do khong kiem tra nguoi goi co thuoc
     * hoi thoai nao khong, va khong tao ban ghi FileMedia de con doi soat/don dep.
     */
    @Transactional
    public TepDinhKemResponse taiTepLen(UUID hoiThoaiId, MultipartFile tep) {
        UUID toi = permissionService.requireCurrentUserId();
        CuocTroChuyen hoiThoai = cuocTroChuyenService.yeuCauHoiThoai(hoiThoaiId);
        chatPermissionService.yeuCauCoTheGui(hoiThoai, toi);

        if (tep == null || tep.isEmpty()) {
            throw new ChatYeuCauKhongHopLeException("Chua chon tep");
        }
        if (tep.getSize() > GIOI_HAN_TEP_BYTE) {
            throw new ChatYeuCauKhongHopLeException("Tep qua lon, toi da 10MB");
        }

        String contentType = tep.getContentType() != null ? tep.getContentType() : "";
        boolean laAnh = contentType.startsWith("image/");

        Map<String, Object> ketQua;
        try {
            ketQua = cloudinaryService.uploadFile(tep);
        } catch (IOException ex) {
            throw new ChatYeuCauKhongHopLeException("Khong tai duoc tep len: " + ex.getMessage());
        }

        String url = (String) (ketQua.get("secure_url") != null ? ketQua.get("secure_url") : ketQua.get("url"));

        FileMedia fileMedia = fileMediaRepository.save(FileMedia.builder()
                .doiTuong(LoaiDoiTuongMedia.MESSAGE)
                // Gan theo hoi thoai chu khong theo tin nhan: luc tai len tin nhan
                // chua ton tai. Nho vay van doi soat/don dep theo hoi thoai duoc.
                .doiTuongId(hoiThoaiId)
                .url(url)
                .publicId((String) ketQua.get("public_id"))
                .loaiFile(contentType)
                .kichThuocBytes(tep.getSize())
                .nguoiTaiLen(nguoiDungRepository.getReferenceById(toi))
                .build());

        return TepDinhKemResponse.fromEntity(
                fileMedia,
                laAnh ? LoaiTinNhan.IMAGE.name() : LoaiTinNhan.FILE.name(),
                tep.getOriginalFilename());
    }

    // ── Doc tin ────────────────────────────────────────────────────────────

    /**
     * Lich su tin nhan, cuon nguoc ve qua khu.
     *
     * @param truocSeq lay cac tin CU HON moc nay; null = bat dau tu tin moi nhat
     * @return sap xep tang dan theo so thu tu (cu truoc, moi sau)
     */
    @Transactional(readOnly = true)
    public List<TinNhanResponse> lichSu(UUID hoiThoaiId, Long truocSeq, int limit) {
        UUID toi = permissionService.requireCurrentUserId();
        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        List<TinNhan> tins = tinNhanRepository.lichSu(
                hoiThoaiId,
                truocSeq != null ? truocSeq : Long.MAX_VALUE,
                anDenSeq(thanhVien),
                PageRequest.of(0, chuanHoaLimit(limit)));

        return tins.stream()
                .sorted(Comparator.comparing(TinNhan::getSoThuTu))
                .map(TinNhanResponse::fromEntity)
                .toList();
    }

    /**
     * Tin moi hon mot moc — duong bu khi noi lai WebSocket, khi client phat hien
     * lo hong so thu tu, va la duong lui neu WebSocket khong noi duoc.
     */
    @Transactional(readOnly = true)
    public List<TinNhanResponse> delta(UUID hoiThoaiId, long sauSeq, int limit) {
        UUID toi = permissionService.requireCurrentUserId();
        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        return tinNhanRepository
                .delta(hoiThoaiId, sauSeq, anDenSeq(thanhVien), PageRequest.of(0, chuanHoaLimit(limit)))
                .stream()
                .map(TinNhanResponse::fromEntity)
                .toList();
    }

    /**
     * Moc "an den" cua thanh vien — moi duong DOC tin deu phai di qua day.
     *
     * Neu bo sot mot duong nao (tab Anh, tab Lien ket, tim kiem, bang ghim) thi
     * nguoi da xoa cuoc tro chuyen van thay lai tin cu o cho khac — dung la loi
     * ro ri kho phat hien.
     */
    private static long anDenSeq(ThanhVienCuocTroChuyen thanhVien) {
        Long moc = thanhVien.getAnDenSeq();
        return moc != null ? moc : 0L;
    }

    // ── Tim kiem ───────────────────────────────────────────────────────────

    /** Dưới 2 ký tự thì trigram gần như vô dụng và sẽ quét cả bảng. */
    private static final int DO_DAI_TU_KHOA_TOI_THIEU = 2;

    /**
     * Tim tin nhan theo noi dung, khong phan biet dau.
     *
     * @param hoiThoaiId bo trong = tim trong MOI hoi thoai nguoi goi dang tham gia
     */
    @Transactional(readOnly = true)
    public PaginatedResponse<TinNhanResponse> timKiem(String tuKhoa, UUID hoiThoaiId, int page, int limit) {
        UUID toi = permissionService.requireCurrentUserId();

        String tk = tuKhoa != null ? tuKhoa.trim() : "";
        if (tk.length() < DO_DAI_TU_KHOA_TOI_THIEU) {
            throw new ChatYeuCauKhongHopLeException(
                    "Tu khoa phai co it nhat " + DO_DAI_TU_KHOA_TOI_THIEU + " ky tu");
        }

        // Neu chi dinh hoi thoai thi phai la thanh vien — bao 403 ro rang thay vi
        // tra ve danh sach rong khien nguoi dung tuong la khong co ket qua.
        if (hoiThoaiId != null) {
            chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);
        }

        Page<TinNhan> trang = tinNhanRepository.timKiem(
                toi, tk,
                hoiThoaiId != null ? hoiThoaiId.toString() : null,
                PageRequest.of(page > 0 ? page - 1 : 0, chuanHoaLimit(limit)));

        return PaginatedResponse.of(trang, trang.getContent().stream()
                .map(TinNhanResponse::fromEntity)
                .toList());
    }

    // ── Tuy chon hoi thoai ─────────────────────────────────────────────────

    /**
     * Ghim / tat thong bao cho RIENG nguoi goi.
     *
     * Day la tuy chon ca nhan nen luu tren ban ghi thanh vien, khong phai tren hoi
     * thoai — moi nguoi ghim cai gi la viec cua ho.
     */
    @Transactional
    public void capNhatTuyChon(UUID hoiThoaiId, Boolean ghim, Boolean tatThongBao,
                               Integer tatThongBaoPhut, Boolean luuTru) {
        UUID toi = permissionService.requireCurrentUserId();
        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        if (ghim != null) thanhVien.setGhim(ghim);

        if (luuTru != null) {
            thanhVien.setLuuTru(luuTru);
            // Ghim va luu tru mau thuan nhau: ghim la "day len dau", luu tru la
            // "cat khoi danh sach". Bat luu tru thi bo ghim de danh sach khong co
            // muc vua bi an vua doi duoc uu tien.
            if (luuTru) thanhVien.setGhim(false);
        }

        if (tatThongBaoPhut != null) {
            if (tatThongBaoPhut <= 0) {
                throw new ChatYeuCauKhongHopLeException("So phut tat thong bao phai lon hon 0");
            }
            // Tat co han: xoa co vo thoi han de hai truong khong mau thuan nhau.
            thanhVien.setTatThongBao(false);
            thanhVien.setTatThongBaoDen(ZonedDateTime.now().plusMinutes(tatThongBaoPhut));

        } else if (tatThongBao != null) {
            thanhVien.setTatThongBao(tatThongBao);
            // Xoa han cu trong CA HAI chieu:
            //  - Bat lai: con han cu thi nguoi dung bam "bat lai" van khong nhan
            //    duoc thong bao cho toi khi han do het.
            //  - Tat vinh vien: con han cu thi client doc tatThongBaoDen se hien
            //    "tat den HH:mm" du nguoi dung da chon vinh vien.
            thanhVien.setTatThongBaoDen(null);
        }

        thanhVienRepository.save(thanhVien);
    }

    // ── Bang thong tin hoi thoai (P7) ──────────────────────────────────────

    /**
     * Anh hoac tep da trao doi trong hoi thoai.
     *
     * @param loai IMAGE hoac FILE — hai tab rieng vi cach hien thi khac han nhau
     *             (luoi thumbnail vs danh sach co ten tep)
     */
    @Transactional(readOnly = true)
    public PaginatedResponse<TinNhanResponse> tepDinhKem(UUID hoiThoaiId, String loai, int page, int limit) {
        UUID toi = permissionService.requireCurrentUserId();
        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        LoaiTinNhan loaiTin = phanTichLoaiDinhKem(loai);
        Page<TinNhan> trang = tinNhanRepository.tepDinhKem(
                hoiThoaiId, loaiTin, anDenSeq(thanhVien),
                PageRequest.of(page > 0 ? page - 1 : 0, chuanHoaLimit(limit)));

        return PaginatedResponse.of(trang, trang.getContent().stream()
                .map(TinNhanResponse::fromEntity)
                .toList());
    }

    /**
     * Cac lien ket da chia se trong hoi thoai.
     *
     * SQL loc tho nhung tin CO chua http(s); viec trich tung URL lam o day vi mot
     * tin co the chua nhieu URL. Khong luu bang link rieng: trich luc doc thi luon
     * khop voi noi dung hien tai, con bang rieng se lech khi tin bi thu hoi.
     */
    @Transactional(readOnly = true)
    public PaginatedResponse<LienKetChatResponse> lienKet(UUID hoiThoaiId, int page, int limit) {
        UUID toi = permissionService.requireCurrentUserId();
        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        Page<TinNhan> trang = tinNhanRepository.tinCoLienKet(
                hoiThoaiId, anDenSeq(thanhVien),
                PageRequest.of(page > 0 ? page - 1 : 0, chuanHoaLimit(limit)));

        List<LienKetChatResponse> lienKets = new ArrayList<>();
        for (TinNhan tin : trang.getContent()) {
            for (String url : trichUrl(tin.getNoiDung())) {
                lienKets.add(LienKetChatResponse.builder()
                        .url(url)
                        .tinNhanId(tin.getId())
                        .soThuTu(tin.getSoThuTu())
                        .tenNguoiGui(tin.getNguoiGui() != null ? tin.getNguoiGui().getHoTen() : null)
                        .ngayGui(tin.getTaoLuc())
                        .build());
            }
        }
        return PaginatedResponse.of(trang, lienKets);
    }

    /**
     * Dat biet danh cho mot thanh vien trong hoi thoai.
     *
     * Ai trong hoi thoai cung dat duoc va moi nguoi cung thay — giong Messenger.
     * Sinh tin he thong de nhom co ngu canh, giong nhu khi them/xoa thanh vien.
     */
    @Transactional
    public void datBietDanh(UUID hoiThoaiId, UUID nguoiDungId, String bietDanh) {
        UUID toi = permissionService.requireCurrentUserId();
        CuocTroChuyen hoiThoai = cuocTroChuyenService.yeuCauHoiThoai(hoiThoaiId);
        chatPermissionService.yeuCauCoTheGui(hoiThoai, toi);

        ThanhVienCuocTroChuyen thanhVien = chatPermissionService
                .thanhVienDangHoatDong(hoiThoaiId, nguoiDungId)
                .orElseThrow(() -> new ChatKhongTimThayException("Nguoi nay khong o trong cuoc tro chuyen"));

        String moi = bietDanh != null && !bietDanh.isBlank() ? bietDanh.trim() : null;
        if (java.util.Objects.equals(moi, thanhVien.getBietDanh())) {
            return; // khong doi thi khong sinh tin he thong rac
        }
        thanhVien.setBietDanh(moi);
        thanhVienRepository.save(thanhVien);

        String tenGoc = thanhVien.getNguoiDung() != null ? thanhVien.getNguoiDung().getHoTen() : "một thành viên";
        cuocTroChuyenService.banTinHeThongCong(
                hoiThoai,
                moi == null
                        ? tenNguoiDat(toi) + " đã xoá biệt danh của " + tenGoc
                        : tenNguoiDat(toi) + " đã đặt biệt danh cho " + tenGoc + " là \"" + moi + "\"");
    }

    private String tenNguoiDat(UUID nguoiDungId) {
        return nguoiDungRepository.findById(nguoiDungId)
                .map(nd -> nd.getHoTen())
                .filter(t -> t != null && !t.isBlank())
                .orElse("Một thành viên");
    }

    private LoaiTinNhan phanTichLoaiDinhKem(String loai) {
        if (loai == null || loai.isBlank()) return LoaiTinNhan.IMAGE;
        LoaiTinNhan ketQua;
        try {
            ketQua = LoaiTinNhan.valueOf(loai.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new ChatYeuCauKhongHopLeException("Loai dinh kem khong hop le: " + loai);
        }
        if (ketQua != LoaiTinNhan.IMAGE && ketQua != LoaiTinNhan.FILE) {
            throw new ChatYeuCauKhongHopLeException("Chi loc duoc IMAGE hoac FILE");
        }
        return ketQua;
    }

    /**
     * Trich cac URL http(s) trong noi dung.
     *
     * Cat bo dau cau dinh o cuoi (. , ) ] ...) vi nguoi ta hay viet
     * "xem tai https://abc.com." — dau cham do khong thuoc URL.
     */
    private static final java.util.regex.Pattern MAU_URL =
            java.util.regex.Pattern.compile("https?://\\S+", java.util.regex.Pattern.CASE_INSENSITIVE);

    static List<String> trichUrl(String noiDung) {
        if (noiDung == null || noiDung.isBlank()) return List.of();

        List<String> ketQua = new ArrayList<>();
        java.util.regex.Matcher m = MAU_URL.matcher(noiDung);
        while (m.find()) {
            String url = m.group();
            while (!url.isEmpty() && ".,;:!?)]}>\"'".indexOf(url.charAt(url.length() - 1)) >= 0) {
                url = url.substring(0, url.length() - 1);
            }
            if (!url.isEmpty() && !ketQua.contains(url)) ketQua.add(url);
        }
        return ketQua;
    }

    // ── Danh dau da doc ────────────────────────────────────────────────────

    @Transactional
    public void danhDauDaDoc(UUID hoiThoaiId, Long denSeq) {
        UUID toi = permissionService.requireCurrentUserId();
        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        long moc = denSeq != null ? denSeq : 0L;
        long hienTai = thanhVien.getDocDenSeq() != null ? thanhVien.getDocDenSeq() : 0L;
        if (moc <= hienTai) {
            return; // Moc chi tang, khong bao gio lui.
        }

        thanhVien.setDocDenSeq(moc);
        thanhVien.setDocDenLuc(ZonedDateTime.now());
        thanhVienRepository.save(thanhVien);

        // Bao cho nhung nguoi con lai de ho thay "da xem".
        List<UUID> nguoiKhac = idThanhVienDangHoatDong(hoiThoaiId).stream()
                .filter(id -> !id.equals(toi))
                .toList();
        chatRealtimeService.guiToiNhieuNguoi(
                nguoiKhac,
                ChatRealtimeService.KENH_TRANG_THAI,
                SuKienTrangThaiChat.daDoc(hoiThoaiId, toi, moc));
    }

    /** "Dang go" — chi day qua WebSocket, khong cham vao DB. */
    @Transactional(readOnly = true)
    public void baoDangGo(UUID hoiThoaiId, UUID nguoiDungId, boolean dangGo) {
        if (!chatPermissionService.coTheDoc(hoiThoaiId, nguoiDungId)) {
            return; // Im lang bo qua: day la kenh phu, khong dang de nem loi.
        }
        List<UUID> nguoiKhac = idThanhVienDangHoatDong(hoiThoaiId).stream()
                .filter(id -> !id.equals(nguoiDungId))
                .toList();
        chatRealtimeService.guiToiNhieuNguoi(
                nguoiKhac,
                ChatRealtimeService.KENH_TRANG_THAI,
                SuKienTrangThaiChat.dangGo(hoiThoaiId, nguoiDungId, dangGo));
    }

    // ── Thu hoi ────────────────────────────────────────────────────────────

    @Transactional
    public TinNhanResponse thuHoi(UUID tinNhanId) {
        UUID toi = permissionService.requireCurrentUserId();

        TinNhan tinNhan = tinNhanRepository.findById(tinNhanId)
                .filter(t -> t.getXoaLuc() == null)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay tin nhan"));

        if (tinNhan.getNguoiGui() == null || !tinNhan.getNguoiGui().getId().equals(toi)) {
            throw new ChatKhongCoQuyenException("Chi nguoi gui moi thu hoi duoc tin nhan nay");
        }

        // Xoa han noi dung chu khong chi an o tang hien thi — thu hoi phai la thu hoi that.
        tinNhan.setDaThuHoi(true);
        tinNhan.setNoiDung(null);
        tinNhan.setFileMedia(null);
        tinNhan = tinNhanRepository.saveAndFlush(tinNhan);

        UUID hoiThoaiId = tinNhan.getCuocTroChuyen().getId();
        TinNhanResponse response = TinNhanResponse.fromEntity(tinNhan);

        // Day lai chinh tin do; client thay trung id thi cap nhat tai cho.
        eventPublisher.publishEvent(new TinNhanCreatedEvent(response, idThanhVienDangHoatDong(hoiThoaiId)));
        return response;
    }

    // ── Ghim tin nhan (P8) ─────────────────────────────────────────────────

    /**
     * Signal va WhatsApp cho ghim 3 tin/doan chat. Chon 5 vi nhom "ca nha" thuong
     * ghim noi quy + lich thu tien + so lien he khan cung luc.
     */
    static final int GIOI_HAN_GHIM = 5;

    /**
     * Ghim / bo ghim mot tin nhan.
     *
     * Pham vi CA HOI THOAI: moi thanh vien deu thay, va bat ky thanh vien nao cung
     * ghim/bo ghim duoc — giong Messenger. Co tinh KHONG gioi han o nguoi gui, vi
     * cai dang duoc ghim thuong la thong bao cua chu tro ma khach thue can ghim lai.
     *
     * Vuot gioi han thi BAO LOI chu khong tu bo ghim tin cu nhat: tu y go ghim cua
     * nguoi khac la hanh vi kho doan, nguoi dung se khong hieu tin cua minh di dau.
     */
    @Transactional
    public TinNhanResponse datGhim(UUID tinNhanId, boolean ghim) {
        UUID toi = permissionService.requireCurrentUserId();

        TinNhan tinNhan = tinNhanRepository.findById(tinNhanId)
                .filter(t -> t.getXoaLuc() == null)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay tin nhan"));

        UUID hoiThoaiId = tinNhan.getCuocTroChuyen().getId();
        chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        if (ghim && Boolean.TRUE.equals(tinNhan.getDaThuHoi())) {
            throw new ChatYeuCauKhongHopLeException("Khong ghim duoc tin da thu hoi");
        }

        // Bam lai dung trang thai hien tai thi khong lam gi — tranh sinh tin he thong rac.
        if (ghim == tinNhan.dangGhim()) {
            return TinNhanResponse.fromEntity(tinNhan);
        }

        if (ghim) {
            long dangCo = tinNhanRepository
                    .countByCuocTroChuyenIdAndGhimLucIsNotNullAndXoaLucIsNull(hoiThoaiId);
            if (dangCo >= GIOI_HAN_GHIM) {
                throw new ChatYeuCauKhongHopLeException(
                        "Moi hoi thoai chi ghim duoc toi da " + GIOI_HAN_GHIM
                                + " tin — hay bo ghim bot truoc");
            }
            tinNhan.setGhimLuc(ZonedDateTime.now());
            tinNhan.setNguoiGhim(nguoiDungRepository.getReferenceById(toi));
        } else {
            tinNhan.setGhimLuc(null);
            tinNhan.setNguoiGhim(null);
        }

        tinNhan = tinNhanRepository.saveAndFlush(tinNhan);

        cuocTroChuyenService.banTinHeThongCong(
                tinNhan.getCuocTroChuyen(),
                tenNguoiDat(toi) + (ghim ? " đã ghim một tin nhắn" : " đã bỏ ghim một tin nhắn"));

        // Day lai chinh tin do de client cap nhat co ghim tai cho.
        TinNhanResponse response = TinNhanResponse.fromEntity(tinNhan);
        eventPublisher.publishEvent(new TinNhanCreatedEvent(response, idThanhVienDangHoatDong(hoiThoaiId)));
        return response;
    }

    /** Bang tin da ghim hien o dau khung chat. */
    @Transactional(readOnly = true)
    public List<TinNhanResponse> danhSachGhim(UUID hoiThoaiId) {
        UUID toi = permissionService.requireCurrentUserId();
        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        return tinNhanRepository.dangGhim(hoiThoaiId, anDenSeq(thanhVien)).stream()
                .map(TinNhanResponse::fromEntity)
                .toList();
    }

    // ── Chuyen tiep (P8) ───────────────────────────────────────────────────

    /**
     * Chuyen tiep mot tin sang nhieu hoi thoai khac.
     *
     * CHO DE SAI NHAT: quyen phai kiem o hoi thoai DICH, khong phai o nguon. Doc
     * duoc tin o A hoan toan khong co nghia la duoc phep ghi vao B. Vi vay moi dich
     * deu goi rieng {@code yeuCauCoTheGui}.
     *
     * Khong sao chep traLoiCho: tin duoc tra loi khong ton tai o hoi thoai dich nen
     * se thanh trich dan tro treo.
     */
    @Transactional
    public List<TinNhanResponse> chuyenTiep(UUID tinNhanId, List<UUID> hoiThoaiDichIds) {
        UUID toi = permissionService.requireCurrentUserId();

        if (hoiThoaiDichIds == null || hoiThoaiDichIds.isEmpty()) {
            throw new ChatYeuCauKhongHopLeException("Chua chon hoi thoai de chuyen tiep");
        }

        TinNhan goc = tinNhanRepository.findById(tinNhanId)
                .filter(t -> t.getXoaLuc() == null)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay tin nhan"));

        // Phai doc duoc tin nguon da.
        chatPermissionService.yeuCauLaThanhVien(goc.getCuocTroChuyen().getId(), toi);

        if (Boolean.TRUE.equals(goc.getDaThuHoi())) {
            throw new ChatYeuCauKhongHopLeException("Khong chuyen tiep duoc tin da thu hoi");
        }

        List<TinNhanResponse> ketQua = new ArrayList<>();
        for (UUID dichId : hoiThoaiDichIds.stream().filter(java.util.Objects::nonNull).distinct().toList()) {
            CuocTroChuyen dich = cuocTroChuyenService.yeuCauHoiThoai(dichId);
            chatPermissionService.yeuCauCoTheGui(dich, toi);

            TinNhan ban = TinNhan.builder()
                    .cuocTroChuyen(dich)
                    .nguoiGui(nguoiDungRepository.getReferenceById(toi))
                    .loai(goc.getLoai())
                    .noiDung(goc.getNoiDung())
                    .fileMedia(goc.getFileMedia())
                    .chuyenTiepTu(goc)
                    .build();

            ban = tinNhanRepository.saveAndFlush(ban);
            capNhatTomTat(dich, ban);

            TinNhanResponse response = TinNhanResponse.fromEntity(ban);
            eventPublisher.publishEvent(new TinNhanCreatedEvent(response, idThanhVienDangHoatDong(dichId)));
            ketQua.add(response);
        }

        return ketQua;
    }

    // ── Chi tiet tin nhan (P8) ─────────────────────────────────────────────

    /**
     * Ai da xem tin nay, luc nao.
     *
     * Suy tu {@code docDenSeq} san co — KHONG them bang "luot xem" rieng. Mot bang
     * nhu vay se sinh mot hang cho moi cap (tin x nguoi), phinh rat nhanh trong khi
     * du lieu do da nam san o moc da doc cua tung thanh vien.
     */
    @Transactional(readOnly = true)
    public ChiTietTinNhanResponse chiTiet(UUID tinNhanId) {
        UUID toi = permissionService.requireCurrentUserId();

        TinNhan tinNhan = tinNhanRepository.findById(tinNhanId)
                .filter(t -> t.getXoaLuc() == null)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay tin nhan"));

        UUID hoiThoaiId = tinNhan.getCuocTroChuyen().getId();
        chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        UUID nguoiGuiId = tinNhan.getNguoiGui() != null ? tinNhan.getNguoiGui().getId() : null;
        long seq = tinNhan.getSoThuTu() != null ? tinNhan.getSoThuTu() : Long.MAX_VALUE;

        List<NguoiXemTinResponse> daXem = new ArrayList<>();
        List<NguoiXemTinResponse> chuaXem = new ArrayList<>();

        for (ThanhVienCuocTroChuyen tv : thanhVienRepository.dangHoatDong(hoiThoaiId)) {
            if (tv.getNguoiDung() == null) continue;
            // Nguoi gui hien nhien da doc tin cua chinh ho — dua vao chi lam nhieu.
            if (tv.getNguoiDung().getId().equals(nguoiGuiId)) continue;

            NguoiXemTinResponse muc = NguoiXemTinResponse.builder()
                    .nguoiDungId(tv.getNguoiDung().getId())
                    .hoTen(tv.getBietDanh() != null && !tv.getBietDanh().isBlank()
                            ? tv.getBietDanh() : tv.getNguoiDung().getHoTen())
                    .anhDaiDien(tv.getNguoiDung().getAnhDaiDien())
                    .xemLuc(tv.getDocDenLuc())
                    .build();

            long docDen = tv.getDocDenSeq() != null ? tv.getDocDenSeq() : 0L;
            if (docDen >= seq) daXem.add(muc); else chuaXem.add(muc);
        }

        return ChiTietTinNhanResponse.builder()
                .tinNhan(TinNhanResponse.fromEntity(tinNhan))
                .daXem(daXem)
                .chuaXem(chuaXem)
                .build();
    }

    // ── Luu tru / xoa ban cua minh (P8) ────────────────────────────────────

    /**
     * "Xoa cuoc tro chuyen" kieu Messenger: chi xoa ban cua MINH.
     *
     * Ghi con tro seq lon nhat hien tai; tu do moi duong doc tin deu bo qua phan cu.
     * Nguoi kia khong bi anh huong, va co tin moi thi hoi thoai hien lai — nhung trong.
     *
     * Dat luon docDenSeq = anDenSeq de so tin chua doc ve 0: da xoa thi khong con gi
     * "chua doc" ca. Lam vay thi hai query dem chua doc khong phai biet ve anDenSeq.
     */
    @Transactional
    public void xoaBanCuaToi(UUID hoiThoaiId) {
        UUID toi = permissionService.requireCurrentUserId();
        ThanhVienCuocTroChuyen thanhVien = chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi);

        long moc = tinNhanRepository.seqLonNhat(hoiThoaiId);
        thanhVien.setAnDenSeq(moc);
        thanhVien.setDocDenSeq(Math.max(moc, thanhVien.getDocDenSeq() != null ? thanhVien.getDocDenSeq() : 0L));
        thanhVienRepository.save(thanhVien);
    }

    // ── Helper ─────────────────────────────────────────────────────────────

    private List<UUID> idThanhVienDangHoatDong(UUID hoiThoaiId) {
        List<UUID> ids = new ArrayList<>();
        for (ThanhVienCuocTroChuyen tv : thanhVienRepository.dangHoatDong(hoiThoaiId)) {
            if (tv.getNguoiDung() != null) ids.add(tv.getNguoiDung().getId());
        }
        return ids;
    }

    /** Cap nhat ban tom tat tren hoi thoai de danh sach sap xep duoc ma khong join. */
    private void capNhatTomTat(CuocTroChuyen hoiThoai, TinNhan tinNhan) {
        hoiThoai.setTinNhanCuoiLuc(tinNhan.getTaoLuc() != null ? tinNhan.getTaoLuc() : ZonedDateTime.now());
        hoiThoai.setXemTruoc(dungXemTruoc(tinNhan));
        cuocTroChuyenRepository.save(hoiThoai);
    }

    private String dungXemTruoc(TinNhan tinNhan) {
        return switch (tinNhan.getLoai()) {
            case IMAGE -> "[Hình ảnh]";
            case FILE -> "[Tệp đính kèm]";
            default -> catNgan(tinNhan.getNoiDung());
        };
    }

    private String catNgan(String text) {
        if (text == null) return null;
        String gon = text.strip().replaceAll("\\s+", " ");
        return gon.length() <= DO_DAI_XEM_TRUOC ? gon : gon.substring(0, DO_DAI_XEM_TRUOC) + "…";
    }

    private int chuanHoaLimit(int limit) {
        if (limit <= 0) return 30;
        return Math.min(limit, GIOI_HAN_TOI_DA);
    }

    /** Client khong duoc tu gui tin loai SYSTEM — do la kenh danh cho he thong. */
    private LoaiTinNhan phanTichLoai(String loai) {
        if (loai == null || loai.isBlank()) return LoaiTinNhan.TEXT;
        LoaiTinNhan ketQua;
        try {
            ketQua = LoaiTinNhan.valueOf(loai.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new ChatYeuCauKhongHopLeException("Loai tin nhan khong hop le: " + loai);
        }
        if (ketQua == LoaiTinNhan.SYSTEM) {
            throw new ChatYeuCauKhongHopLeException("Khong the tu gui tin he thong");
        }
        return ketQua;
    }

    private FileMedia napFile(UUID fileMediaId) {
        if (fileMediaId == null) return null;
        return fileMediaRepository.findById(fileMediaId)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay tep dinh kem"));
    }

    /** Chi cho tra loi tin nam trong CHINH hoi thoai nay. */
    private TinNhan napTinTraLoi(UUID traLoiChoId, UUID hoiThoaiId) {
        if (traLoiChoId == null) return null;
        TinNhan goc = tinNhanRepository.findById(traLoiChoId)
                .orElseThrow(() -> new ChatKhongTimThayException("Khong tim thay tin nhan duoc tra loi"));
        if (!goc.getCuocTroChuyen().getId().equals(hoiThoaiId)) {
            throw new ChatYeuCauKhongHopLeException("Tin nhan duoc tra loi khong thuoc cuoc tro chuyen nay");
        }
        return goc;
    }
}
