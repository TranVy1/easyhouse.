package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.BankTransaction;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface BankTransactionRepository extends JpaRepository<BankTransaction, UUID> {
    Page<BankTransaction> findByNhaTroId(UUID nhaTroId, Pageable pageable);
    Page<BankTransaction> findByDaDoiSoat(Boolean daDoiSoat, Pageable pageable);
    Page<BankTransaction> findByNhaTroIdAndDaDoiSoat(UUID nhaTroId, Boolean daDoiSoat, Pageable pageable);
}
