package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class HoaDonServiceTest {

    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private ChiTietHoaDonRepository chiTietHoaDonRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private KhachThueRepository khachThueRepository;
    @Mock private HopDongService hopDongService;
    @Mock private ChiSoDienNuocRepository chiSoDienNuocRepository;
    @Mock private CauHinhGiaRepository cauHinhGiaRepository;
    @Mock private DichVuHopDongRepository dichVuHopDongRepository;
    @Mock private ThanhVienHopDongRepository thanhVienHopDongRepository;
    @Mock private PermissionService permissionService;
    @Mock private EmailService emailService;

    private HoaDonService service;
    private UUID hopDongId;
    private UUID phongId;
    private UUID nhaTroId;
    private UUID ownerId;
    private HopDong hopDong;

    @BeforeEach
    void setUp() {
        service = new HoaDonService(
                hoaDonRepository,
                chiTietHoaDonRepository,
                phongRepository,
                hopDongRepository,
                khachThueRepository,
                hopDongService,
                chiSoDienNuocRepository,
                cauHinhGiaRepository,
                dichVuHopDongRepository,
                thanhVienHopDongRepository,
                permissionService,
                emailService
        );

        hopDongId = UUID.randomUUID();
        phongId = UUID.randomUUID();
        nhaTroId = UUID.randomUUID();

        ownerId = UUID.randomUUID();
        NguoiDung owner = NguoiDung.builder().id(ownerId).email("owner@example.com").hoTen("Owner").build();
        NhaTro nhaTro = NhaTro.builder().id(nhaTroId).chuTro(owner).ten("Nha A").diaChi("Dia chi").build();
        Phong phong = Phong.builder()
                .id(phongId)
                .nhaTro(nhaTro)
                .ten("P101")
                .dienTich(BigDecimal.valueOf(20))
                .soNguoiToiDa(2)
                .trangThai(TrangThaiPhong.RENTED)
                .giaHienTai(BigDecimal.valueOf(3_000_000))
                .tienCocMacDinh(BigDecimal.ZERO)
                .build();
        KhachThue khachThue = KhachThue.builder()
                .id(UUID.randomUUID())
                .chuTro(owner)
                .hoTen("Khach thue")
                .dangHoatDong(true)
                .build();
        hopDong = HopDong.builder()
                .id(hopDongId)
                .phong(phong)
                .khachThue(khachThue)
                .maHopDong("HD-P101")
                .ngayBatDau(LocalDate.of(2026, 1, 1))
                .ngayKetThuc(LocalDate.of(2026, 12, 31))
                .giaThueHopDong(BigDecimal.valueOf(3_000_000))
                .tienCoc(BigDecimal.ZERO)
                .trangThai(TrangThaiHopDong.ACTIVE)
                .chuKyThanhToan("MONTHLY")
                .ngayThanhToanHangThang(5)
                .tuDongGiaHan(false)
                .build();
    }

    @Test
    void createCalculatesInvoiceFromContractPricesAndReadings() {
        stubCanWriteInvoice();
        HoaDonRequest request = new HoaDonRequest();
        request.setHopDong(hopDongId);
        request.setThang(5);
        request.setNam(2026);
        request.setChiSoDienBanDau(100);
        request.setChiSoDienCuoiKy(120);
        request.setChiSoNuocBanDau(10);
        request.setChiSoNuocCuoiKy(15);

        DichVu internet = DichVu.builder()
                .id(UUID.randomUUID())
                .tenDichVu("Internet")
                .loaiTinhPhi(LoaiTinhPhi.FIXED)
                .donGiaMacDinh(BigDecimal.valueOf(100_000))
                .build();
        DichVuHopDong internetFee = DichVuHopDong.builder()
                .hopDong(hopDong)
                .dichVu(internet)
                .loaiTinhPhi(LoaiTinhPhi.FIXED)
                .donGiaApDung(BigDecimal.valueOf(100_000))
                .soLuong(BigDecimal.ONE)
                .batDauTu(LocalDate.of(2026, 1, 1))
                .build();

        when(hopDongRepository.findById(hopDongId)).thenReturn(Optional.of(hopDong));
        when(hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(hopDongId, 2026, 5))
                .thenReturn(Optional.empty());
        when(hoaDonRepository.save(any(HoaDon.class))).thenAnswer(invocation -> {
            HoaDon hoaDon = invocation.getArgument(0);
            if (hoaDon.getId() == null) hoaDon.setId(UUID.randomUUID());
            return hoaDon;
        });
        when(cauHinhGiaRepository.findApplicable(eq(nhaTroId), eq(LoaiMucHoaDon.ELECTRICITY), any(LocalDate.class)))
                .thenReturn(List.of(price(LoaiMucHoaDon.ELECTRICITY, BigDecimal.valueOf(3_500))));
        when(cauHinhGiaRepository.findApplicable(eq(nhaTroId), eq(LoaiMucHoaDon.WATER), any(LocalDate.class)))
                .thenReturn(List.of(price(LoaiMucHoaDon.WATER, BigDecimal.valueOf(15_000))));
        when(chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(phongId, LoaiChiSo.ELECTRICITY, 2026, 5))
                .thenReturn(Optional.empty());
        when(chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(phongId, LoaiChiSo.WATER, 2026, 5))
                .thenReturn(Optional.empty());
        when(chiSoDienNuocRepository.save(any(ChiSoDienNuoc.class))).thenAnswer(invocation -> {
            ChiSoDienNuoc reading = invocation.getArgument(0);
            if (reading.getId() == null) reading.setId(UUID.randomUUID());
            return reading;
        });
        when(dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(hopDongId)).thenReturn(List.of(internetFee));
        when(chiTietHoaDonRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        HoaDonResponse response = service.create(request);

        assertEquals(BigDecimal.valueOf(3_245_000), response.getTongTien());
        assertEquals(BigDecimal.valueOf(70_000), response.getChiTiet().stream()
                .filter(item -> "ELECTRICITY".equals(item.getLoai()))
                .findFirst()
                .orElseThrow()
                .getThanhTien());
        assertEquals(BigDecimal.valueOf(75_000), response.getChiTiet().stream()
                .filter(item -> "WATER".equals(item.getLoai()))
                .findFirst()
                .orElseThrow()
                .getThanhTien());
    }

    @Test
    void createRejectsDuplicateContractMonth() {
        stubCanWriteInvoice();
        HoaDonRequest request = new HoaDonRequest();
        request.setHopDong(hopDongId);
        request.setThang(5);
        request.setNam(2026);

        when(hopDongRepository.findById(hopDongId)).thenReturn(Optional.of(hopDong));
        when(hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(hopDongId, 2026, 5))
                .thenReturn(Optional.of(HoaDon.builder().id(UUID.randomUUID()).build()));

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.create(request));
        assertEquals("Hợp đồng đã có hóa đơn trong kỳ 5/2026", error.getMessage());
    }

    @Test
    void createRejectsMeterReadingWithoutUnitPrice() {
        stubCanWriteInvoice();
        HoaDonRequest request = new HoaDonRequest();
        request.setHopDong(hopDongId);
        request.setThang(5);
        request.setNam(2026);
        request.setChiSoDienBanDau(100);
        request.setChiSoDienCuoiKy(120);

        when(hopDongRepository.findById(hopDongId)).thenReturn(Optional.of(hopDong));
        when(hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(hopDongId, 2026, 5))
                .thenReturn(Optional.empty());
        when(hoaDonRepository.save(any(HoaDon.class))).thenAnswer(invocation -> {
            HoaDon hoaDon = invocation.getArgument(0);
            if (hoaDon.getId() == null) hoaDon.setId(UUID.randomUUID());
            return hoaDon;
        });
        when(cauHinhGiaRepository.findApplicable(eq(nhaTroId), eq(LoaiMucHoaDon.ELECTRICITY), any(LocalDate.class)))
                .thenReturn(List.of());
        when(dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(hopDongId)).thenReturn(List.of());

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.create(request));
        assertEquals("Chưa có đơn giá hợp lệ cho tiền điện", error.getMessage());
    }

    @Test
    void getByIdRejectsUnauthorizedUser() {
        UUID userId = UUID.randomUUID();
        UUID hoaDonId = UUID.randomUUID();
        HoaDon hoaDon = HoaDon.builder()
                .id(hoaDonId)
                .hopDong(hopDong)
                .phong(hopDong.getPhong())
                .khachThue(hopDong.getKhachThue())
                .build();

        when(hoaDonRepository.findById(hoaDonId)).thenReturn(Optional.of(hoaDon));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(false);
        when(permissionService.canReadNhaTro(userId, nhaTroId, ownerId)).thenReturn(false);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.getById(hoaDonId));
        assertEquals("Ban khong co quyen xem hoa don nay", error.getMessage());
    }

    private void stubCanWriteInvoice() {
        when(permissionService.requireCurrentUserId()).thenReturn(ownerId);
        when(permissionService.canWriteNhaTro(ownerId, nhaTroId, ownerId)).thenReturn(true);
    }

    private CauHinhGia price(LoaiMucHoaDon loai, BigDecimal donGia) {
        return CauHinhGia.builder()
                .id(UUID.randomUUID())
                .loai(loai)
                .donGia(donGia)
                .tenHienThi(loai.name())
                .hieuLucTu(LocalDate.of(2026, 1, 1))
                .dangApDung(true)
                .build();
    }
}
