package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.LanGuiThongBao;
import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LanGuiThongBaoRepository extends JpaRepository<LanGuiThongBao, UUID> {
    Optional<LanGuiThongBao> findByAggregateTypeAndAggregateIdAndRuleCodeAndScheduledForAndChannelAndRecipientId(
            String aggregateType, UUID aggregateId, String ruleCode, LocalDate scheduledFor, String channel, UUID recipientId);
}
