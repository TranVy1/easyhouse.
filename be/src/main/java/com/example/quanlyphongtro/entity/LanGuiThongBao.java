package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;
import lombok.*;

@Entity
@Table(name = "notification_delivery", uniqueConstraints = @UniqueConstraint(
        name = "uq_notification_delivery_rule", columnNames = { "aggregate_type", "aggregate_id", "rule_code", "scheduled_for", "channel", "recipient_id" }))
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LanGuiThongBao {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = "aggregate_type", nullable = false, length = 64) private String aggregateType;
    @Column(name = "aggregate_id", nullable = false) private UUID aggregateId;
    @Column(name = "rule_code", nullable = false, length = 128) private String ruleCode;
    @Column(name = "scheduled_for", nullable = false) private LocalDate scheduledFor;
    @Column(nullable = false, length = 32) private String channel;
    @Column(name = "recipient_id", nullable = false) private UUID recipientId;
    @Column(nullable = false, length = 16) private String status;
    @Column(name = "error_message") private String errorMessage;
    @Column(name = "tao_luc", nullable = false, updatable = false) private ZonedDateTime taoLuc;
    @Column(name = "cap_nhat_luc", nullable = false) private ZonedDateTime capNhatLuc;

    @PrePersist void prePersist() { ZonedDateTime now = ZonedDateTime.now(); if (taoLuc == null) taoLuc = now; if (capNhatLuc == null) capNhatLuc = now; if (status == null) status = "PENDING"; }
    @PreUpdate void preUpdate() { capNhatLuc = ZonedDateTime.now(); }
}
