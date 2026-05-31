package com.example.quanlyphongtro.services;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.LichHenRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@ExtendWith(MockitoExtension.class)
class SchedulerServiceTest {

    @Mock private HopDongRepository hopDongRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private LichHenRepository lichHenRepository;
    @Mock private ThongBaoService thongBaoService;
    @Mock private EmailService emailService;

    @InjectMocks
    private SchedulerService schedulerService;

    private KhachThue mockKhachThue;
    private Phong mockPhong;
    private NhaTro mockNhaTro;
    private NguoiDung mockChuTro;

    @BeforeEach
    void setUp() {
        mockChuTro = NguoiDung.builder().id(UUID.randomUUID()).email("owner@easyhouse.local").hoTen("Chủ nhà A").build();
        mockNhaTro = NhaTro.builder().id(UUID.randomUUID()).ten("Nhà trọ A").chuTro(mockChuTro).build();
        mockPhong = Phong.builder().id(UUID.randomUUID()).ten("Phòng 101").nhaTro(mockNhaTro).build();
        mockKhachThue = KhachThue.builder().id(UUID.randomUUID()).hoTen("Nguyễn Văn A").email("tenant@example.com").build();
    }

    @Test
    void testCheckExpiringContracts_Alert7DaysShortTerm() {
        LocalDate today = LocalDate.now();
        // Hợp đồng ngắn hạn (dưới 180 ngày), hết hạn sau đúng 7 ngày
        HopDong hd = HopDong.builder()
                .id(UUID.randomUUID())
                .maHopDong("HD-SHORT-7")
                .ngayBatDau(today.minusDays(30))
                .ngayKetThuc(today.plusDays(7))
                .phong(mockPhong)
                .khachThue(mockKhachThue)
                .build();

        when(hopDongRepository.findAllActive()).thenReturn(List.of(hd));

        schedulerService.checkExpiringContracts();

        // Xác thực thông báo In-app cho chủ trọ và khách thuê
        verify(thongBaoService).createSystemNotification(
                eq("Cảnh báo: Hợp đồng phòng " + mockPhong.getTen() + " sắp hết hạn"),
                anyString(),
                eq(LoaiThongBao.CONTRACT),
                eq(List.of(mockChuTro.getId()))
        );

        verify(thongBaoService).createSystemNotification(
                eq("Thông báo: Hợp đồng thuê phòng sắp hết hạn"),
                anyString(),
                eq(LoaiThongBao.CONTRACT),
                eq(List.of(mockKhachThue.getId()))
        );

        // Xác thực email được gửi cho khách thuê
        verify(emailService).sendContractExpiringEmail(eq(hd), eq(mockKhachThue), eq(7));
    }

    @Test
    void testCheckExpiringContracts_Alert15DaysMediumTerm() {
        LocalDate today = LocalDate.now();
        // Hợp đồng trung hạn (6-12 tháng, ví dụ 200 ngày), hết hạn sau đúng 15 ngày
        HopDong hd = HopDong.builder()
                .id(UUID.randomUUID())
                .maHopDong("HD-MED-15")
                .ngayBatDau(today.minusDays(185))
                .ngayKetThuc(today.plusDays(15))
                .phong(mockPhong)
                .khachThue(mockKhachThue)
                .build();

        when(hopDongRepository.findAllActive()).thenReturn(List.of(hd));

        schedulerService.checkExpiringContracts();

        verify(emailService).sendContractExpiringEmail(eq(hd), eq(mockKhachThue), eq(15));
    }

    @Test
    void testCheckExpiringContracts_Alert30DaysLongTerm() {
        LocalDate today = LocalDate.now();
        // Hợp đồng dài hạn (>= 365 ngày), hết hạn sau đúng 30 ngày
        HopDong hd = HopDong.builder()
                .id(UUID.randomUUID())
                .maHopDong("HD-LONG-30")
                .ngayBatDau(today.minusDays(350))
                .ngayKetThuc(today.plusDays(30))
                .phong(mockPhong)
                .khachThue(mockKhachThue)
                .build();

        when(hopDongRepository.findAllActive()).thenReturn(List.of(hd));

        schedulerService.checkExpiringContracts();

        verify(emailService).sendContractExpiringEmail(eq(hd), eq(mockKhachThue), eq(30));
    }

    @Test
    void testCheckExpiringContracts_NoAlert() {
        LocalDate today = LocalDate.now();
        // Hợp đồng dài hạn nhưng còn 29 ngày nữa mới hết hạn (không trúng mốc 30 ngày)
        HopDong hd = HopDong.builder()
                .id(UUID.randomUUID())
                .maHopDong("HD-LONG-29")
                .ngayBatDau(today.minusDays(350))
                .ngayKetThuc(today.plusDays(29))
                .phong(mockPhong)
                .khachThue(mockKhachThue)
                .build();

        when(hopDongRepository.findAllActive()).thenReturn(List.of(hd));

        schedulerService.checkExpiringContracts();

        // Không gửi thông báo nào cả
        verify(emailService, never()).sendContractExpiringEmail(any(), any(), anyInt());
        verify(thongBaoService, never()).createSystemNotification(any(), any(), any(), any());
    }

    @Test
    void testCheckOverdueInvoices() {
        LocalDate today = LocalDate.now();
        HoaDon hd = HoaDon.builder()
                .id(UUID.randomUUID())
                .maHoaDon("HD-OVERDUE-01")
                .kyThang(5)
                .kyNam(2026)
                .tongTien(BigDecimal.valueOf(3000000))
                .daTra(BigDecimal.ZERO)
                .hanTra(today.minusDays(1)) // đã quá hạn 1 ngày
                .phong(mockPhong)
                .khachThue(mockKhachThue)
                .trangThai(TrangThaiHoaDon.UNPAID)
                .build();

        when(hoaDonRepository.findOverdueInvoices(anyList(), eq(today))).thenReturn(List.of(hd));

        schedulerService.checkOverdueInvoices();

        // Trạng thái hóa đơn được cập nhật sang OVERDUE
        verify(hoaDonRepository).save(eq(hd));
        assert hd.getTrangThai() == TrangThaiHoaDon.OVERDUE;

        // Xác thực thông báo In-app cho chủ trọ và khách thuê
        verify(thongBaoService).createSystemNotification(
                eq("Cảnh báo quá hạn: Hóa đơn phòng " + mockPhong.getTen()),
                anyString(),
                eq(LoaiThongBao.INVOICE),
                eq(List.of(mockChuTro.getId()))
        );

        verify(thongBaoService).createSystemNotification(
                eq("Cảnh báo: Hóa đơn tiền phòng quá hạn thanh toán"),
                anyString(),
                eq(LoaiThongBao.INVOICE),
                eq(List.of(mockKhachThue.getId()))
        );

        // Xác thực gửi email quá hạn
        verify(emailService).sendInvoiceOverdueEmail(eq(hd), eq(mockKhachThue));
    }

    @Test
    void testCheckUpcomingInvoices() {
        LocalDate today = LocalDate.now();
        LocalDate targetDate = today.plusDays(2);
        HoaDon hd = HoaDon.builder()
                .id(UUID.randomUUID())
                .maHoaDon("HD-UPCOMING-01")
                .kyThang(6)
                .kyNam(2026)
                .tongTien(BigDecimal.valueOf(3000000))
                .daTra(BigDecimal.ZERO)
                .hanTra(targetDate) // hạn trả là 2 ngày tới
                .phong(mockPhong)
                .khachThue(mockKhachThue)
                .trangThai(TrangThaiHoaDon.UNPAID)
                .build();

        when(hoaDonRepository.findUnpaidInvoicesDueOn(anyList(), eq(targetDate))).thenReturn(List.of(hd));

        schedulerService.checkUpcomingInvoices();

        // Xác thực thông báo In-app cho khách thuê
        verify(thongBaoService).createSystemNotification(
                eq("Thông báo: Hóa đơn tiền phòng sắp đến hạn thanh toán"),
                anyString(),
                eq(LoaiThongBao.INVOICE),
                eq(List.of(mockKhachThue.getId()))
        );

        // Xác thực gửi email nhắc nhở sắp đến hạn
        verify(emailService).sendInvoiceUpcomingReminderEmail(eq(hd), eq(mockKhachThue), eq(2));
    }

    @Test
    void testCheckUpcomingAppointments() {
        ZonedDateTime now = ZonedDateTime.now();
        LichHen lh = LichHen.builder()
                .id(UUID.randomUUID())
                .hoTen("Khách xem phòng B")
                .email("visitor@example.com")
                .ngayHen(now.plusHours(4))
                .trangThai(TrangThaiLichHen.CONFIRMED)
                .daGuiNhacNho(false)
                .phong(mockPhong)
                .build();

        when(lichHenRepository.findUpcomingAppointments(anyList(), any(), any())).thenReturn(List.of(lh));

        schedulerService.checkUpcomingAppointments();

        // Đánh dấu đã gửi nhắc nhở và lưu
        verify(lichHenRepository).save(eq(lh));
        assert lh.getDaGuiNhacNho();

        // Xác thực gửi email nhắc nhở lịch hẹn
        verify(emailService).sendAppointmentReminderEmail(eq(lh));
    }
}
