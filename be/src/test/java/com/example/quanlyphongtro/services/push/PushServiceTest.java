package com.example.quanlyphongtro.services.push;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.TinNhanResponse;
import com.example.quanlyphongtro.entity.DangKyPush;
import com.example.quanlyphongtro.entity.NenTangPush;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.repository.DangKyPushRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import com.example.quanlyphongtro.services.ChatPresenceService;

import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

/**
 * Toan bo gia tri cua P5 nam o ba bo loc trong PushService — gui push cho DUNG
 * nguoi kho hon nhieu so voi viec gui duoc push. Day la noi test ky nhat.
 */
@ExtendWith(MockitoExtension.class)
class PushServiceTest {

    @Mock private ThanhVienCuocTroChuyenRepository thanhVienRepository;
    @Mock private DangKyPushRepository dangKyPushRepository;
    @Mock private KenhGuiPush kenhGui;

    private ChatPresenceService presence;
    private PushService pushService;

    private final UUID nguoiGui = UUID.randomUUID();
    private final UUID nguoiNhan = UUID.randomUUID();
    private final UUID hoiThoaiId = UUID.randomUUID();

    @BeforeEach
    void setUp() {
        // Dung ChatPresenceService that (khong mock) vi no chi la cau truc du lieu
        // trong bo nho — mock lai chinh no thi test khong con kiem chung gi.
        presence = new ChatPresenceService();
        pushService = new PushService(thanhVienRepository, dangKyPushRepository, presence, List.of(kenhGui));
        lenient().when(kenhGui.hoTro(any())).thenReturn(true);
        lenient().when(kenhGui.gui(any(), any())).thenReturn(true);
    }

    private TinNhanResponse tin() {
        return TinNhanResponse.builder()
                .id(UUID.randomUUID())
                .soThuTu(1L)
                .cuocTroChuyenId(hoiThoaiId)
                .nguoiGuiId(nguoiGui)
                .tenNguoiGui("Hà Văn Linh")
                .loai("TEXT")
                .noiDung("Vòi nước hỏng rồi anh ơi")
                .build();
    }

    private void thanhVien(UUID nguoiDungId, boolean tatThongBao) {
        lenient().when(thanhVienRepository.dangHoatDong(hoiThoaiId)).thenReturn(List.of(
                ThanhVienCuocTroChuyen.builder()
                        .nguoiDung(NguoiDung.builder().id(nguoiDungId).build())
                        .tatThongBao(tatThongBao)
                        .build()));
    }

    private void coDangKyPush(UUID nguoiDungId) {
        lenient().when(dangKyPushRepository.dangDung(anyList())).thenReturn(List.of(
                DangKyPush.builder()
                        .id(UUID.randomUUID())
                        .nguoiDung(NguoiDung.builder().id(nguoiDungId).build())
                        .nenTang(NenTangPush.WEB)
                        .endpoint("https://vd.com/push/abc")
                        .khoaP256dh("p")
                        .khoaAuth("a")
                        .build()));
    }

    // ── Ba bộ lọc ──────────────────────────────────────────────────────────

    @Test
    void nguoiOfflineVaKhongTatThongBaoThiDuocGui() {
        thanhVien(nguoiNhan, false);
        coDangKyPush(nguoiNhan);

        pushService.guiChoTinNhan(tin(), List.of(nguoiGui, nguoiNhan));

        ArgumentCaptor<NoiDungPush> noiDung = ArgumentCaptor.forClass(NoiDungPush.class);
        verify(kenhGui).gui(any(), noiDung.capture());
        assertEquals("Hà Văn Linh", noiDung.getValue().tieuDe());
        assertTrue(noiDung.getValue().noiDung().contains("Vòi nước"));
    }

    /**
     * Người đang mở app đã thấy tin qua WebSocket rồi. Gửi thêm push là làm phiền —
     * và là lỗi dễ nhận thấy nhất của một hệ thống chat.
     */
    @Test
    void nguoiDangOnlineThiKhongGuiPush() {
        presence.ghiNhanKetNoi("phien-1", nguoiNhan);
        thanhVien(nguoiNhan, false);

        pushService.guiChoTinNhan(tin(), List.of(nguoiGui, nguoiNhan));

        verify(kenhGui, never()).gui(any(), any());
    }

    @Test
    void nguoiDaTatThongBaoHoiThoaiThiKhongGuiPush() {
        thanhVien(nguoiNhan, true);

        pushService.guiChoTinNhan(tin(), List.of(nguoiGui, nguoiNhan));

        verify(kenhGui, never()).gui(any(), any());
    }

    @Test
    void khongGuiPushVeChinhNguoiGui() {
        thanhVien(nguoiGui, false);

        pushService.guiChoTinNhan(tin(), List.of(nguoiGui));

        verify(kenhGui, never()).gui(any(), any());
    }

    // ── Dọn đăng ký chết ───────────────────────────────────────────────────

    @Test
    void endpointChetThiBiDanhDauNgungDung() {
        thanhVien(nguoiNhan, false);
        coDangKyPush(nguoiNhan);
        when(kenhGui.gui(any(), any())).thenReturn(false); // 404/410 tu nha cung cap

        pushService.guiChoTinNhan(tin(), List.of(nguoiGui, nguoiNhan));

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<DangKyPush>> daLuu = ArgumentCaptor.forClass(List.class);
        verify(dangKyPushRepository).saveAll(daLuu.capture());
        assertEquals(1, daLuu.getValue().size());
        assertNotNull(daLuu.getValue().get(0).getDungLuc(), "Phai co moc ngung dung");
    }

    // ── Trạng thái online đếm theo phiên ───────────────────────────────────

    /**
     * Một người mở nhiều tab. Đóng MỘT tab không được làm hệ thống tưởng họ đã
     * offline — nếu chỉ lưu cờ boolean thì sẽ sai đúng chỗ này.
     */
    @Test
    void dongMotTabVanConOnlineNeuTabKhacDangMo() {
        presence.ghiNhanKetNoi("tab-1", nguoiNhan);
        presence.ghiNhanKetNoi("tab-2", nguoiNhan);

        presence.ghiNhanNgatKetNoi("tab-1");
        assertTrue(presence.dangOnline(nguoiNhan), "Còn tab-2 nên vẫn phải online");

        presence.ghiNhanNgatKetNoi("tab-2");
        assertTrue(!presence.dangOnline(nguoiNhan), "Đóng hết thì mới offline");
    }

    @Test
    void cungMotPhienBaoKetNoiHaiLanKhongDemDoi() {
        presence.ghiNhanKetNoi("tab-1", nguoiNhan);
        presence.ghiNhanKetNoi("tab-1", nguoiNhan);

        presence.ghiNhanNgatKetNoi("tab-1");
        assertTrue(!presence.dangOnline(nguoiNhan), "Đếm đôi thì đóng một lần sẽ không hết");
    }
}
