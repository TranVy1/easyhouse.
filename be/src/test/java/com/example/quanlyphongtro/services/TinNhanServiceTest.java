package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.GuiTinNhanRequest;
import com.example.quanlyphongtro.dto.TinNhanResponse;
import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiTinNhan;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.entity.TinNhan;
import com.example.quanlyphongtro.event.TinNhanCreatedEvent;
import com.example.quanlyphongtro.exception.ChatKhongCoQuyenException;
import com.example.quanlyphongtro.exception.ChatYeuCauKhongHopLeException;
import com.example.quanlyphongtro.repository.CuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.FileMediaRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.TinNhanRepository;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

@ExtendWith(MockitoExtension.class)
class TinNhanServiceTest {

    @Mock private TinNhanRepository tinNhanRepository;
    @Mock private CuocTroChuyenRepository cuocTroChuyenRepository;
    @Mock private ThanhVienCuocTroChuyenRepository thanhVienRepository;
    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private FileMediaRepository fileMediaRepository;
    @Mock private PermissionService permissionService;
    @Mock private ChatPermissionService chatPermissionService;
    @Mock private CuocTroChuyenService cuocTroChuyenService;
    @Mock private ChatRealtimeService chatRealtimeService;
    @Mock private CloudinaryService cloudinaryService;
    @Mock private ApplicationEventPublisher eventPublisher;

    /**
     * @InjectMocks: Lombok doi chu ky constructor moi lan them dependency. Mockito
     * khop theo KIEU nen test khong vo nua.
     */
    @InjectMocks
    private TinNhanService tinNhanService;

    private final UUID toi = UUID.randomUUID();
    private final UUID banChat = UUID.randomUUID();
    private final UUID hoiThoaiId = UUID.randomUUID();
    private CuocTroChuyen hoiThoai;

    @BeforeEach
    void setUp() {
        hoiThoai = CuocTroChuyen.builder()
                .id(hoiThoaiId)
                .loai(LoaiCuocTroChuyen.DIRECT)
                .khoaDuyNhat("direct_test")
                .build();
    }

    // ── Gui tin ────────────────────────────────────────────────────────────

    @Test
    void guiTinTaoBanGhiVaBanSuKienToiTatCaThanhVien() {
        chuanBiGui();
        chuanBiLuu();
        chuanBiThanhVien();

        GuiTinNhanRequest request = new GuiTinNhanRequest();
        request.setNoiDung("Chao ban");

        TinNhanResponse ketQua = tinNhanService.guiTinNhan(hoiThoaiId, request);

        assertEquals("Chao ban", ketQua.getNoiDung());
        assertEquals(1L, ketQua.getSoThuTu());

        ArgumentCaptor<TinNhanCreatedEvent> suKien = ArgumentCaptor.forClass(TinNhanCreatedEvent.class);
        verify(eventPublisher).publishEvent(suKien.capture());

        // Nguoi gui cung phai nhan su kien: cac tab/thiet bi khac cua ho phai thay tin.
        assertTrue(suKien.getValue().nguoiNhanIds().containsAll(List.of(toi, banChat)));
    }

    /**
     * Client mat mang roi gui lai cung maClient. Phai tra ve dung tin cu, khong
     * duoc tao ban sao thu hai.
     */
    @Test
    void guiLaiCungMaClientKhongTaoTinTrung() {
        chuanBiGui();

        TinNhan daCo = tinNhan(7L, "Tin da gui");
        daCo.setMaClient("abc-123");
        when(tinNhanRepository.findByCuocTroChuyenIdAndMaClient(hoiThoaiId, "abc-123"))
                .thenReturn(Optional.of(daCo));

        GuiTinNhanRequest request = new GuiTinNhanRequest();
        request.setNoiDung("Tin da gui");
        request.setMaClient("abc-123");

        TinNhanResponse ketQua = tinNhanService.guiTinNhan(hoiThoaiId, request);

        assertEquals(7L, ketQua.getSoThuTu());
        verify(tinNhanRepository, never()).saveAndFlush(any());
        verify(eventPublisher, never()).publishEvent(any(TinNhanCreatedEvent.class));
    }

    @Test
    void tuChoiTinRongKhongCoTepDinhKem() {
        chuanBiGui();

        GuiTinNhanRequest request = new GuiTinNhanRequest();
        request.setNoiDung("   ");

        assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> tinNhanService.guiTinNhan(hoiThoaiId, request));
        verify(tinNhanRepository, never()).saveAndFlush(any());
    }

    @Test
    void clientKhongDuocTuGuiTinHeThong() {
        chuanBiGui();

        GuiTinNhanRequest request = new GuiTinNhanRequest();
        request.setNoiDung("Gia mao tin he thong");
        request.setLoai("SYSTEM");

        assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> tinNhanService.guiTinNhan(hoiThoaiId, request));
    }

    @Test
    void tuChoiLoaiTinKhongHopLe() {
        chuanBiGui();

        GuiTinNhanRequest request = new GuiTinNhanRequest();
        request.setNoiDung("abc");
        request.setLoai("VIDEO_CALL");

        assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> tinNhanService.guiTinNhan(hoiThoaiId, request));
    }

    // ── Da doc ─────────────────────────────────────────────────────────────

    @Test
    void mocDaDocChiTangKhongLui() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        ThanhVienCuocTroChuyen thanhVien = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(toi).build())
                .docDenSeq(10L)
                .build();
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(thanhVien);

        tinNhanService.danhDauDaDoc(hoiThoaiId, 5L);

        assertEquals(10L, thanhVien.getDocDenSeq());
        verify(thanhVienRepository, never()).save(any());
    }

    @Test
    void danhDauDaDocCapNhatVaBaoChoNguoiConLai() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        ThanhVienCuocTroChuyen thanhVien = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(toi).build())
                .docDenSeq(3L)
                .build();
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(thanhVien);
        chuanBiThanhVien();

        tinNhanService.danhDauDaDoc(hoiThoaiId, 12L);

        assertEquals(12L, thanhVien.getDocDenSeq());
        verify(thanhVienRepository).save(thanhVien);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<UUID>> nguoiNhan = ArgumentCaptor.forClass(List.class);
        verify(chatRealtimeService).guiToiNhieuNguoi(nguoiNhan.capture(), any(), any());
        assertEquals(List.of(banChat), nguoiNhan.getValue(),
                "Chi bao cho nguoi khac, khong bao nguoc lai chinh minh");
    }

    // ── Thu hoi ────────────────────────────────────────────────────────────

    @Test
    void chiNguoiGuiMoiThuHoiDuoc() {
        when(permissionService.requireCurrentUserId()).thenReturn(banChat);
        when(tinNhanRepository.findById(any())).thenReturn(Optional.of(tinNhan(4L, "Cua nguoi khac")));

        assertThrows(ChatKhongCoQuyenException.class,
                () -> tinNhanService.thuHoi(UUID.randomUUID()));
    }

    @Test
    void thuHoiXoaHanNoiDungChuKhongChiAnDi() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        TinNhan cuaToi = tinNhan(4L, "Loi gui nham");
        when(tinNhanRepository.findById(any())).thenReturn(Optional.of(cuaToi));
        when(tinNhanRepository.saveAndFlush(any(TinNhan.class))).thenAnswer(inv -> inv.getArgument(0));
        chuanBiThanhVien();

        TinNhanResponse ketQua = tinNhanService.thuHoi(UUID.randomUUID());

        assertTrue(ketQua.getDaThuHoi());
        assertNull(ketQua.getNoiDung());
        assertNull(cuaToi.getNoiDung(), "Noi dung phai bi xoa khoi DB, khong chi an o tang hien thi");
    }

    // ── Tim kiem (P4) ──────────────────────────────────────────────────────

    @Test
    void tuChoiTuKhoaQuaNgan() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);

        assertThrows(ChatYeuCauKhongHopLeException.class, () -> tinNhanService.timKiem("a", null, 1, 20));
        assertThrows(ChatYeuCauKhongHopLeException.class, () -> tinNhanService.timKiem("  ", null, 1, 20));
        verify(tinNhanRepository, never()).timKiem(any(), any(), any(), any());
    }

    /**
     * Chi dinh hoi thoai khong phai cua minh phai bao 403 ro rang, khong duoc tra
     * ve danh sach rong khien nguoi dung tuong la khong co ket qua.
     */
    @Test
    void timKiemTrongHoiThoaiKhongThamGiaThiBaoLoi() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi))
                .thenThrow(new ChatKhongCoQuyenException("khong phai thanh vien"));

        assertThrows(ChatKhongCoQuyenException.class,
                () -> tinNhanService.timKiem("vòi nước", hoiThoaiId, 1, 20));
    }

    // ── Tuy chon hoi thoai (P4) ────────────────────────────────────────────

    @Test
    void capNhatTuyChonChiSuaTruongDuocGui() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        ThanhVienCuocTroChuyen thanhVien = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(toi).build())
                .ghim(false)
                .tatThongBao(true)
                .build();
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(thanhVien);

        tinNhanService.capNhatTuyChon(hoiThoaiId, true, null, null, null);

        assertTrue(thanhVien.getGhim());
        assertTrue(thanhVien.getTatThongBao(), "Truong khong gui len phai giu nguyen");
        verify(thanhVienRepository).save(thanhVien);
    }

    // ── Tat thong bao co thoi han ──────────────────────────────────────────

    @Test
    void tatThongBaoCoHanThiDatMocVaBoCoVoThoiHan() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        ThanhVienCuocTroChuyen thanhVien = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(toi).build())
                .tatThongBao(true)
                .build();
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(thanhVien);

        tinNhanService.capNhatTuyChon(hoiThoaiId, null, null, 60, null);

        assertNotNull(thanhVien.getTatThongBaoDen());
        assertTrue(thanhVien.getTatThongBaoDen().isAfter(ZonedDateTime.now().plusMinutes(59)));
        // Hai truong khong duoc mau thuan: da co han thi bo co vo thoi han.
        assertTrue(!thanhVien.getTatThongBao());
        assertTrue(thanhVien.dangTatThongBao());
    }

    /**
     * Bat lai ma khong xoa han cu thi nguoi dung bam "bat lai" van khong nhan duoc
     * thong bao cho toi khi han cu het — loi rat kho hieu tu goc nhin nguoi dung.
     */
    @Test
    void batLaiThongBaoPhaiXoaCaHanCu() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        ThanhVienCuocTroChuyen thanhVien = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(toi).build())
                .tatThongBao(false)
                .tatThongBaoDen(ZonedDateTime.now().plusHours(5))
                .build();
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(thanhVien);

        tinNhanService.capNhatTuyChon(hoiThoaiId, null, false, null, null);

        assertNull(thanhVien.getTatThongBaoDen());
        assertTrue(!thanhVien.dangTatThongBao());
    }

    /**
     * Chon "tat vinh vien" khi dang co han cu ma khong xoa han thi client doc
     * tatThongBaoDen se hien "tat den HH:mm" — sai voi lua chon cua nguoi dung.
     */
    @Test
    void tatVinhVienPhaiXoaHanCu() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        ThanhVienCuocTroChuyen thanhVien = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(toi).build())
                .tatThongBao(false)
                .tatThongBaoDen(ZonedDateTime.now().plusMinutes(60))
                .build();
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(thanhVien);

        tinNhanService.capNhatTuyChon(hoiThoaiId, null, true, null, null);

        assertTrue(thanhVien.getTatThongBao());
        assertNull(thanhVien.getTatThongBaoDen(), "Tat vinh vien thi khong duoc con moc het han");
        assertTrue(thanhVien.dangTatThongBao());
    }

    @Test
    void hanTatThongBaoDaQuaThiCoiNhuKhongTat() {
        ThanhVienCuocTroChuyen thanhVien = ThanhVienCuocTroChuyen.builder()
                .tatThongBao(false)
                .tatThongBaoDen(ZonedDateTime.now().minusMinutes(1))
                .build();
        assertTrue(!thanhVien.dangTatThongBao(), "Han da qua thi phai nhan thong bao lai");
    }

    // ── Trich URL cho tab Lien ket (P7) ────────────────────────────────────

    @Test
    void trichDuocNhieuUrlTrongMotTin() {
        var urls = TinNhanService.trichUrl(
                "Xem ở https://easyhouse.vn/phong/1 và http://vd.com/a?b=1&c=2 nhé");
        assertEquals(2, urls.size());
        assertEquals("https://easyhouse.vn/phong/1", urls.get(0));
        assertEquals("http://vd.com/a?b=1&c=2", urls.get(1));
    }

    /** Người ta hay viết "xem tại https://abc.com." — dấu chấm đó không thuộc URL. */
    @Test
    void catBoDauCauDinhCuoiUrl() {
        assertEquals("https://abc.com",
                TinNhanService.trichUrl("Xem tại https://abc.com.").get(0));
        assertEquals("https://abc.com/x",
                TinNhanService.trichUrl("Link (https://abc.com/x)").get(0));
        assertEquals("https://abc.com",
                TinNhanService.trichUrl("Vào https://abc.com!").get(0));
    }

    @Test
    void khongTrichUrlTrungLap() {
        var urls = TinNhanService.trichUrl("https://a.com rồi lại https://a.com nữa");
        assertEquals(1, urls.size());
    }

    @Test
    void noiDungKhongCoUrlThiTraRong() {
        assertTrue(TinNhanService.trichUrl("Chào anh, phòng em bị hỏng vòi nước").isEmpty());
        assertTrue(TinNhanService.trichUrl(null).isEmpty());
        assertTrue(TinNhanService.trichUrl("   ").isEmpty());
    }

    // ── Biet danh (P7) ─────────────────────────────────────────────────────

    @Test
    void datBietDanhGiongCuThiKhongSinhTinHeThong() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(cuocTroChuyenService.yeuCauHoiThoai(hoiThoaiId)).thenReturn(hoiThoai);

        ThanhVienCuocTroChuyen tv = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(banChat).hoTen("Ban").build())
                .bietDanh("Cu Ti")
                .build();
        when(chatPermissionService.thanhVienDangHoatDong(hoiThoaiId, banChat))
                .thenReturn(Optional.of(tv));

        tinNhanService.datBietDanh(hoiThoaiId, banChat, "  Cu Ti  ");

        // Không đổi thì không được ghi DB và không được sinh tin hệ thống rác.
        verify(thanhVienRepository, never()).save(any());
        verify(cuocTroChuyenService, never()).banTinHeThongCong(any(), anyString());
    }

    @Test
    void datBietDanhRongThiXoaBietDanh() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(cuocTroChuyenService.yeuCauHoiThoai(hoiThoaiId)).thenReturn(hoiThoai);
        when(nguoiDungRepository.findById(toi))
                .thenReturn(Optional.of(NguoiDung.builder().id(toi).hoTen("Toi").build()));

        ThanhVienCuocTroChuyen tv = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(banChat).hoTen("Ban").build())
                .bietDanh("Cu Ti")
                .build();
        when(chatPermissionService.thanhVienDangHoatDong(hoiThoaiId, banChat))
                .thenReturn(Optional.of(tv));

        tinNhanService.datBietDanh(hoiThoaiId, banChat, "   ");

        assertNull(tv.getBietDanh());
        verify(thanhVienRepository).save(tv);
    }

    // ── Helper ─────────────────────────────────────────────────────────────

    // ── Ghim tin nhan (P8) ─────────────────────────────────────────────────

    @Test
    void ghimTinDatMocVaGhiNhanNguoiGhim() {
        TinNhan tin = tinNhan(4L, "Nội quy khu trọ");
        chuanBiGhim(tin);
        chuanBiGhimThanhCong();
        when(tinNhanRepository.countByCuocTroChuyenIdAndGhimLucIsNotNullAndXoaLucIsNull(hoiThoaiId))
                .thenReturn(0L);

        TinNhanResponse ketQua = tinNhanService.datGhim(tin.getId(), true);

        assertNotNull(tin.getGhimLuc());
        assertTrue(ketQua.getDangGhim());
        verify(cuocTroChuyenService).banTinHeThongCong(any(), anyString());
    }

    /**
     * Vuot gioi han phai BAO LOI chu khong tu bo ghim tin cu nhat: tu y go ghim cua
     * nguoi khac la hanh vi kho doan.
     */
    @Test
    void ghimVuotGioiHanThiBaoLoiChuKhongTuBoGhimTinCu() {
        TinNhan tin = tinNhan(4L, "Tin thứ sáu");
        chuanBiGhim(tin);
        when(tinNhanRepository.countByCuocTroChuyenIdAndGhimLucIsNotNullAndXoaLucIsNull(hoiThoaiId))
                .thenReturn((long) TinNhanService.GIOI_HAN_GHIM);

        assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> tinNhanService.datGhim(tin.getId(), true));
        assertNull(tin.getGhimLuc());
        verify(tinNhanRepository, never()).saveAndFlush(any());
    }

    @Test
    void khongGhimDuocTinDaThuHoi() {
        TinNhan tin = tinNhan(4L, null);
        tin.setDaThuHoi(true);
        chuanBiGhim(tin);

        assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> tinNhanService.datGhim(tin.getId(), true));
    }

    /** Bam ghim tin dang ghim thi khong sinh tin he thong rac. */
    @Test
    void ghimLaiTinDaGhimThiKhongLamGi() {
        TinNhan tin = tinNhan(4L, "Đã ghim rồi");
        tin.setGhimLuc(ZonedDateTime.now());
        chuanBiGhim(tin);

        tinNhanService.datGhim(tin.getId(), true);

        verify(tinNhanRepository, never()).saveAndFlush(any());
        verify(cuocTroChuyenService, never()).banTinHeThongCong(any(), anyString());
    }

    @Test
    void boGhimXoaCaMocVaNguoiGhim() {
        TinNhan tin = tinNhan(4L, "Tin cũ");
        tin.setGhimLuc(ZonedDateTime.now());
        tin.setNguoiGhim(NguoiDung.builder().id(toi).build());
        chuanBiGhim(tin);
        // Bo ghim khong dat nguoiGhim moi nen khong can getReferenceById.
        when(tinNhanRepository.saveAndFlush(any(TinNhan.class))).thenAnswer(inv -> inv.getArgument(0));
        when(thanhVienRepository.dangHoatDong(hoiThoaiId)).thenReturn(List.of());

        tinNhanService.datGhim(tin.getId(), false);

        assertNull(tin.getGhimLuc());
        assertNull(tin.getNguoiGhim());
    }

    // ── Chuyen tiep (P8) ───────────────────────────────────────────────────

    /**
     * Cho de sai nhat cua chuyen tiep: doc duoc tin o A KHONG co nghia duoc phep ghi
     * vao B. Quyen phai kiem o hoi thoai DICH.
     */
    @Test
    void chuyenTiepKiemQuyenOHoiThoaiDich() {
        UUID dichId = UUID.randomUUID();
        CuocTroChuyen dich = CuocTroChuyen.builder().id(dichId).loai(LoaiCuocTroChuyen.GROUP).build();

        TinNhan goc = tinNhan(4L, "Tin gốc");
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(tinNhanRepository.findById(goc.getId())).thenReturn(Optional.of(goc));
        when(cuocTroChuyenService.yeuCauHoiThoai(dichId)).thenReturn(dich);
        org.mockito.Mockito.doThrow(new ChatKhongCoQuyenException("khong duoc gui"))
                .when(chatPermissionService).yeuCauCoTheGui(dich, toi);

        assertThrows(ChatKhongCoQuyenException.class,
                () -> tinNhanService.chuyenTiep(goc.getId(), List.of(dichId)));
        verify(tinNhanRepository, never()).saveAndFlush(any());
    }

    @Test
    void chuyenTiepSaoChepNoiDungVaGiuLienKetVeTinGoc() {
        UUID dichId = UUID.randomUUID();
        CuocTroChuyen dich = CuocTroChuyen.builder().id(dichId).loai(LoaiCuocTroChuyen.GROUP).build();

        TinNhan goc = tinNhan(4L, "Lịch thu tiền tháng 8");
        // Tin goc dang tra loi mot tin khac — ban chuyen tiep KHONG duoc keo theo.
        goc.setTraLoiCho(tinNhan(3L, "Tin được trả lời"));

        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(tinNhanRepository.findById(goc.getId())).thenReturn(Optional.of(goc));
        when(cuocTroChuyenService.yeuCauHoiThoai(dichId)).thenReturn(dich);
        when(thanhVienRepository.dangHoatDong(dichId)).thenReturn(List.of());
        chuanBiLuu();

        List<TinNhanResponse> ketQua = tinNhanService.chuyenTiep(goc.getId(), List.of(dichId));

        assertEquals(1, ketQua.size());
        assertEquals("Lịch thu tiền tháng 8", ketQua.get(0).getNoiDung());
        assertEquals(goc.getId(), ketQua.get(0).getChuyenTiepTuId());
        // Trich dan tro treo neu keo theo traLoiCho sang hoi thoai khac.
        assertNull(ketQua.get(0).getTraLoiChoId());
    }

    @Test
    void khongChuyenTiepDuocTinDaThuHoi() {
        TinNhan goc = tinNhan(4L, null);
        goc.setDaThuHoi(true);
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(tinNhanRepository.findById(goc.getId())).thenReturn(Optional.of(goc));

        assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> tinNhanService.chuyenTiep(goc.getId(), List.of(UUID.randomUUID())));
    }

    @Test
    void chuyenTiepKhongChonDichThiBaoLoi() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);

        assertThrows(ChatYeuCauKhongHopLeException.class,
                () -> tinNhanService.chuyenTiep(UUID.randomUUID(), List.of()));
    }

    // ── Chi tiet tin nhan (P8) ─────────────────────────────────────────────

    @Test
    void chiTietChiaDungNguoiDaXemVaChuaXem() {
        TinNhan tin = tinNhan(10L, "Ai đọc chưa?");
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(tinNhanRepository.findById(tin.getId())).thenReturn(Optional.of(tin));
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(
                ThanhVienCuocTroChuyen.builder().build());

        UUID nguoiC = UUID.randomUUID();
        when(thanhVienRepository.dangHoatDong(hoiThoaiId)).thenReturn(List.of(
                // Nguoi gui — phai bi loai khoi ca hai danh sach.
                ThanhVienCuocTroChuyen.builder()
                        .nguoiDung(NguoiDung.builder().id(toi).hoTen("Tôi").build())
                        .docDenSeq(10L).build(),
                ThanhVienCuocTroChuyen.builder()
                        .nguoiDung(NguoiDung.builder().id(banChat).hoTen("Bạn").build())
                        .docDenSeq(12L).build(),
                ThanhVienCuocTroChuyen.builder()
                        .nguoiDung(NguoiDung.builder().id(nguoiC).hoTen("Người C").build())
                        .docDenSeq(9L).build()));

        var chiTiet = tinNhanService.chiTiet(tin.getId());

        assertEquals(1, chiTiet.getDaXem().size());
        assertEquals(banChat, chiTiet.getDaXem().get(0).getNguoiDungId());
        assertEquals(1, chiTiet.getChuaXem().size());
        assertEquals(nguoiC, chiTiet.getChuaXem().get(0).getNguoiDungId());
    }

    /** Biet danh trong hoi thoai phai duoc uu tien hon ho ten that. */
    @Test
    void chiTietUuTienBietDanh() {
        TinNhan tin = tinNhan(10L, "Test");
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(tinNhanRepository.findById(tin.getId())).thenReturn(Optional.of(tin));
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(
                ThanhVienCuocTroChuyen.builder().build());
        when(thanhVienRepository.dangHoatDong(hoiThoaiId)).thenReturn(List.of(
                ThanhVienCuocTroChuyen.builder()
                        .nguoiDung(NguoiDung.builder().id(banChat).hoTen("Hồ Văn Linh").build())
                        .bietDanh("Em bé")
                        .docDenSeq(12L).build()));

        var chiTiet = tinNhanService.chiTiet(tin.getId());
        assertEquals("Em bé", chiTiet.getDaXem().get(0).getHoTen());
    }

    // ── Luu tru / xoa ban cua minh (P8) ────────────────────────────────────

    @Test
    void batLuuTruThiTuBoGhim() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        ThanhVienCuocTroChuyen tv = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(toi).build())
                .ghim(true)
                .build();
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(tv);

        tinNhanService.capNhatTuyChon(hoiThoaiId, null, null, null, true);

        assertTrue(tv.getLuuTru());
        assertTrue(!tv.getGhim(), "Ghim va luu tru mau thuan nhau");
    }

    /**
     * "Xoa" phai la an ban cua MINH — khong duoc xoa hang that, vi tin nhan la du
     * lieu chung cua nhieu nguoi.
     */
    @Test
    void xoaBanCuaToiChiDatConTroChuKhongXoaDuLieu() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        ThanhVienCuocTroChuyen tv = ThanhVienCuocTroChuyen.builder()
                .cuocTroChuyen(hoiThoai)
                .nguoiDung(NguoiDung.builder().id(toi).build())
                .docDenSeq(3L)
                .build();
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi)).thenReturn(tv);
        when(tinNhanRepository.seqLonNhat(hoiThoaiId)).thenReturn(42L);

        tinNhanService.xoaBanCuaToi(hoiThoaiId);

        assertEquals(42L, tv.getAnDenSeq());
        // Dat luon moc da doc de so tin chua doc ve 0 — da xoa thi khong con gi chua doc.
        assertEquals(42L, tv.getDocDenSeq());
        verify(tinNhanRepository, never()).delete(any());
        verify(tinNhanRepository, never()).deleteAll();
    }

    private void chuanBiGhim(TinNhan tin) {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(tinNhanRepository.findById(tin.getId())).thenReturn(Optional.of(tin));
        when(chatPermissionService.yeuCauLaThanhVien(hoiThoaiId, toi))
                .thenReturn(ThanhVienCuocTroChuyen.builder().build());
    }

    /** Cac ca ghim/bo ghim thanh cong con can luu duoc va co danh sach thanh vien. */
    private void chuanBiGhimThanhCong() {
        when(nguoiDungRepository.getReferenceById(toi))
                .thenReturn(NguoiDung.builder().id(toi).hoTen("Toi").build());
        when(tinNhanRepository.saveAndFlush(any(TinNhan.class))).thenAnswer(inv -> inv.getArgument(0));
        when(thanhVienRepository.dangHoatDong(hoiThoaiId)).thenReturn(List.of());
    }

    private void chuanBiGui() {
        when(permissionService.requireCurrentUserId()).thenReturn(toi);
        when(cuocTroChuyenService.yeuCauHoiThoai(hoiThoaiId)).thenReturn(hoiThoai);
    }

    private void chuanBiLuu() {
        when(nguoiDungRepository.getReferenceById(toi))
                .thenReturn(NguoiDung.builder().id(toi).hoTen("Toi").build());
        when(tinNhanRepository.saveAndFlush(any(TinNhan.class))).thenAnswer(inv -> {
            TinNhan t = inv.getArgument(0);
            t.setSoThuTu(1L); // PostgreSQL cap phat qua bigserial
            return t;
        });
    }

    private void chuanBiThanhVien() {
        when(thanhVienRepository.dangHoatDong(hoiThoaiId)).thenReturn(List.of(
                ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(hoiThoai)
                        .nguoiDung(NguoiDung.builder().id(toi).build())
                        .build(),
                ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(hoiThoai)
                        .nguoiDung(NguoiDung.builder().id(banChat).build())
                        .build()));
    }

    private TinNhan tinNhan(long seq, String noiDung) {
        return TinNhan.builder()
                .id(UUID.randomUUID())
                .soThuTu(seq)
                .cuocTroChuyen(hoiThoai)
                .nguoiGui(NguoiDung.builder().id(toi).hoTen("Toi").build())
                .loai(LoaiTinNhan.TEXT)
                .noiDung(noiDung)
                .build();
    }
}
