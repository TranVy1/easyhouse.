package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.entity.LanGuiThongBao;
import com.example.quanlyphongtro.repository.LanGuiThongBaoRepository;
import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class NotificationDeliveryServiceTest {
    @Mock private LanGuiThongBaoRepository repository;

    @Test
    void skipsAnAlreadySuccessfulDelivery() {
        NotificationDeliveryService service = new NotificationDeliveryService(repository);
        when(repository.findByAggregateTypeAndAggregateIdAndRuleCodeAndScheduledForAndChannelAndRecipientId(
                any(), any(), any(), any(), any(), any())).thenReturn(Optional.of(LanGuiThongBao.builder().status("SENT").build()));

        boolean delivered = service.deliverOnce("CONTRACT", UUID.randomUUID(), "EXPIRING", LocalDate.now(), "IN_APP",
                UUID.randomUUID(), () -> { throw new AssertionError("must not run"); });

        assertFalse(delivered);
        verify(repository, never()).save(any());
    }

    @Test
    void retriesAFailedDeliveryUsingTheExistingRecord() {
        NotificationDeliveryService service = new NotificationDeliveryService(repository);
        LanGuiThongBao failed = LanGuiThongBao.builder().status("FAILED").build();
        when(repository.findByAggregateTypeAndAggregateIdAndRuleCodeAndScheduledForAndChannelAndRecipientId(
                any(), any(), any(), any(), any(), any())).thenReturn(Optional.of(failed));
        when(repository.save(any(LanGuiThongBao.class))).thenAnswer(invocation -> invocation.getArgument(0));

        boolean delivered = service.deliverOnce("CONTRACT", UUID.randomUUID(), "EXPIRING", LocalDate.now(), "IN_APP",
                UUID.randomUUID(), () -> { });

        assertTrue(delivered);
        org.junit.jupiter.api.Assertions.assertEquals("SENT", failed.getStatus());
    }
}
