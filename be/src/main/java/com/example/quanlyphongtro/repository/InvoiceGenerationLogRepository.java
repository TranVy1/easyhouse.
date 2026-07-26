package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.InvoiceGenerationLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.UUID;

@Repository
public interface InvoiceGenerationLogRepository extends JpaRepository<InvoiceGenerationLog, UUID> {
    List<InvoiceGenerationLog> findByBatchId(UUID batchId);
}
