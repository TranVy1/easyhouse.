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
import org.springframework.test.util.ReflectionTestUtils;

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
    @Mock private DebtReminderService debtReminderService;

    @InjectMocks
    private SchedulerService schedulerService;

    private KhachThue mockKhachThue;
    private Phong mockPhong;
    private NhaTro mockNhaTro;
    private NguoiDung mockChuTro;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(schedulerService, "debtReminderService", debtReminderService);
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
    void testCheckInvoices() {
        schedulerService.checkInvoices();
        verify(debtReminderService).runDailyDebtReminders();
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
