package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.DebtReminderLog;
import com.example.quanlyphongtro.entity.ReminderChannel;
import com.example.quanlyphongtro.entity.ReminderType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface DebtReminderLogRepository extends JpaRepository<DebtReminderLog, UUID> {
    
    boolean existsByHoaDonIdAndReminderTypeAndChannelAndRecipientContact(
            UUID hoaDonId, ReminderType type, ReminderChannel channel, String contact);
            
    List<DebtReminderLog> findByHoaDonIdOrderBySentAtDesc(UUID hoaDonId);
}
