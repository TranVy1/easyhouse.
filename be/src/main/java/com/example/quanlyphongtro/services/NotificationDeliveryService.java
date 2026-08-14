package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.LanGuiThongBao;
import com.example.quanlyphongtro.repository.LanGuiThongBaoRepository;
import java.time.LocalDate;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class NotificationDeliveryService {
    private final LanGuiThongBaoRepository repository;

    @Transactional
    public boolean deliverOnce(String aggregateType, UUID aggregateId, String ruleCode, LocalDate scheduledFor,
            String channel, UUID recipientId, Runnable delivery) {
        LanGuiThongBao record = repository.findByAggregateTypeAndAggregateIdAndRuleCodeAndScheduledForAndChannelAndRecipientId(
                aggregateType, aggregateId, ruleCode, scheduledFor, channel, recipientId).orElse(null);
        if (record != null && ("SENT".equals(record.getStatus()) || "PENDING".equals(record.getStatus()))) return false;
        if (record == null) {
            record = LanGuiThongBao.builder().aggregateType(aggregateType).aggregateId(aggregateId)
                    .ruleCode(ruleCode).scheduledFor(scheduledFor).channel(channel).recipientId(recipientId).status("PENDING").build();
        } else {
            record.setStatus("PENDING"); record.setErrorMessage(null);
        }
        record = repository.save(record);
        try {
            delivery.run();
            record.setStatus("SENT");
            repository.save(record);
            return true;
        } catch (RuntimeException exception) {
            record.setStatus("FAILED");
            record.setErrorMessage(exception.getMessage());
            repository.save(record);
            throw exception;
        }
    }
}
