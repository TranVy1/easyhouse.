package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.dto.HoanTatQuyetToanTraPhongRequest;
import com.example.quanlyphongtro.entity.ChiTietBanGiaoTaiSan;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.QuyetToanTraPhong;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.entity.TrangThaiQuyetToanTraPhong;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.ChiTietBanGiaoTaiSanRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.QuyetToanTraPhongRepository;
import com.example.quanlyphongtro.repository.TaiSanPhongRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class QuyetToanTraPhongServiceTest {

    @Mock private QuyetToanTraPhongRepository quyetToanRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private HoaDonService hoaDonService;
    @Mock private PermissionService permissionService;
    @Mock private ObjectMapper objectMapper;
    @Mock private GiaoDichTienCocService giaoDichTienCocService;
    @Mock private AuditLogRepository auditLogRepository;
    @Mock private TaiSanPhongRepository taiSanPhongRepository;
    @Mock private ChiTietBanGiaoTaiSanRepository chiTietBanGiaoRepository;
    @InjectMocks private QuyetToanTraPhongService service;

    private UUID userId;
    private UUID hopDongId;
    private Phong phong;
    private HopDong hopDong;
    private QuyetToanTraPhong quyetToan;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        hopDongId = UUID.randomUUID();
        phong = Phong.builder().id(UUID.randomUUID()).trangThai(TrangThaiPhong.RENTED).build();
        hopDong = HopDong.builder().id(hopDongId).phong(phong).trangThai(TrangThaiHopDong.ACTIVE).build();
        quyetToan = QuyetToanTraPhong.builder().id(UUID.randomUUID()).hopDong(hopDong)
                .hoaDon(HoaDon.builder().id(UUID.randomUUID()).build())
                .tienPhaiThuThem(BigDecimal.ZERO).tienCocCanHoan(BigDecimal.ZERO)
                .tienCocDaCanTru(BigDecimal.ZERO).trangThai(TrangThaiQuyetToanTraPhong.READY_FOR_HANDOVER).build();

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWriteHopDong(userId, hopDongId)).thenReturn(true);
        when(hopDongRepository.findById(hopDongId)).thenReturn(Optional.of(hopDong));
        when(quyetToanRepository.findByHopDongId(hopDongId)).thenReturn(Optional.of(quyetToan));
    }

    @Test
    void releasesRoomAndCompletesSettlement() {
        when(hopDongRepository.findRoomOccupyingContracts(eq(phong.getId()), any())).thenReturn(List.of(hopDong));

        service.hoanTat(hopDongId, completionRequest());

        assertEquals(TrangThaiHopDong.TERMINATED, hopDong.getTrangThai());
        assertEquals(TrangThaiPhong.AVAILABLE, phong.getTrangThai());
        assertEquals(TrangThaiQuyetToanTraPhong.COMPLETED, quyetToan.getTrangThai());
        verify(phongRepository).save(phong);
        verify(giaoDichTienCocService).ghiNhanQuyetToan(quyetToan, null, null);
    }

    @Test
    void earlyTerminationForfeitsDeposit() {
        com.example.quanlyphongtro.dto.TaoQuyetToanTraPhongRequest req = new com.example.quanlyphongtro.dto.TaoQuyetToanTraPhongRequest();
        req.setNgayTraPhong(java.time.LocalDate.now());
        req.setHuyTruocHan(true);
        hopDong.setNgayKetThuc(java.time.LocalDate.now().plusMonths(6));

        when(quyetToanRepository.findByHopDongId(hopDongId)).thenReturn(Optional.empty());
        when(giaoDichTienCocService.soDu(hopDongId)).thenReturn(new BigDecimal("3000000"));

        com.example.quanlyphongtro.dto.HoaDonResponse hoaDonResponse = com.example.quanlyphongtro.dto.HoaDonResponse.builder()
                .id(UUID.randomUUID())
                .tongTien(BigDecimal.ZERO)
                .trangThai("ISSUED")
                .build();
        com.example.quanlyphongtro.dto.HoaDonQuyetToanResult finalResult = com.example.quanlyphongtro.dto.HoaDonQuyetToanResult.builder()
                .hoaDon(hoaDonResponse)
                .tienCocDaCanTru(new BigDecimal("1000000"))
                .build();
        when(hoaDonService.createFinalSettlement(any(), any(), any())).thenReturn(finalResult);
        when(hoaDonRepository.findById(any())).thenReturn(Optional.of(HoaDon.builder().id(hoaDonResponse.getId()).build()));
        when(quyetToanRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(hoaDonService.getById(any())).thenReturn(hoaDonResponse);

        var response = service.tao(hopDongId, req);

        // Under early termination, remaining deposit is forfeited -> tienCocCanHoan = 0
        assertEquals(BigDecimal.ZERO, response.getTienCocCanHoan());
        assertEquals(new BigDecimal("3000000"), response.getTienCocBanDau());
        assertEquals(new BigDecimal("1000000"), response.getTienCocDaCanTru());
    }

    private HoanTatQuyetToanTraPhongRequest completionRequest() {
        HoanTatQuyetToanTraPhongRequest request = new HoanTatQuyetToanTraPhongRequest();
        request.setBanGiaoDaXacNhan(true);
        request.setVeSinhKiemTraXong(true);
        return request;
    }
}
