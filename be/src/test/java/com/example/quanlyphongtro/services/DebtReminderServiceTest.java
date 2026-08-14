package com.example.quanlyphongtro.services;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.entity.DebtReminderLog;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.ReminderChannel;
import com.example.quanlyphongtro.entity.ReminderType;
import com.example.quanlyphongtro.repository.DebtReminderLogRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class DebtReminderServiceTest {
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private DebtReminderLogRepository debtReminderLogRepository;
    @Mock private EmailService emailService;
    @Mock private ThongBaoService thongBaoService;
    private DebtReminderService service;
    private HoaDon invoice;

    @BeforeEach
    void setUp() {
        service = new DebtReminderService(hoaDonRepository, debtReminderLogRepository, emailService, thongBaoService);
        invoice = HoaDon.builder().id(UUID.randomUUID()).maHoaDon("HD-001")
                .khachThue(KhachThue.builder().email("tenant@example.com").hoTen("Khách thuê").build()).build();
    }

    @Test
    void doesNotDeliverTheSameSuccessfulReminderTwice() {
        DebtReminderLog sent = DebtReminderLog.builder().status("SENT").build();
        when(debtReminderLogRepository.findFirstByHoaDonIdAndReminderTypeAndChannelAndRecipientContactOrderBySentAtDesc(
                eq(invoice.getId()), eq(ReminderType.DUE_TOMORROW), eq(ReminderChannel.EMAIL), eq("tenant@example.com")))
                .thenReturn(Optional.of(sent));

        service.processReminder(invoice, ReminderType.DUE_TOMORROW);

        verify(emailService, never()).sendInvoiceUpcomingReminderEmail(any(), any(), anyInt());
        verify(debtReminderLogRepository, never()).save(any());
    }

    @Test
    void retriesFailedDeliveryUsingTheSameLogRow() {
        DebtReminderLog failed = DebtReminderLog.builder().status("FAILED").errorMessage("SMTP unavailable").build();
        when(debtReminderLogRepository.findFirstByHoaDonIdAndReminderTypeAndChannelAndRecipientContactOrderBySentAtDesc(
                eq(invoice.getId()), eq(ReminderType.DUE_IN_3_DAYS), eq(ReminderChannel.EMAIL), eq("tenant@example.com")))
                .thenReturn(Optional.of(failed));
        when(debtReminderLogRepository.save(any(DebtReminderLog.class))).thenAnswer(invocation -> invocation.getArgument(0));

        service.processReminder(invoice, ReminderType.DUE_IN_3_DAYS);

        verify(emailService).sendInvoiceUpcomingReminderEmail(invoice, invoice.getKhachThue(), 3);
        ArgumentCaptor<DebtReminderLog> logCaptor = ArgumentCaptor.forClass(DebtReminderLog.class);
        verify(debtReminderLogRepository, times(2)).save(logCaptor.capture());
        org.junit.jupiter.api.Assertions.assertEquals("SENT", logCaptor.getAllValues().get(1).getStatus());
    }

    @Test
    void sendsDueDateReminderOnTheDueDate() {
        when(debtReminderLogRepository.findFirstByHoaDonIdAndReminderTypeAndChannelAndRecipientContactOrderBySentAtDesc(
                eq(invoice.getId()), eq(ReminderType.DUE_TODAY), eq(ReminderChannel.EMAIL), eq("tenant@example.com")))
                .thenReturn(Optional.empty());
        when(debtReminderLogRepository.save(any(DebtReminderLog.class))).thenAnswer(invocation -> invocation.getArgument(0));

        service.processReminder(invoice, ReminderType.DUE_TODAY);

        verify(emailService).sendInvoiceUpcomingReminderEmail(invoice, invoice.getKhachThue(), 0);
    }
}
