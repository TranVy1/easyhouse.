package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.InvoiceGenerationBatch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.UUID;

@Repository
public interface InvoiceGenerationBatchRepository extends JpaRepository<InvoiceGenerationBatch, UUID> {
}
