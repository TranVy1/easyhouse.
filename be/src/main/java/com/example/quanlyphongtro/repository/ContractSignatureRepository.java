package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ContractSignature;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ContractSignatureRepository extends JpaRepository<ContractSignature, UUID> {
    List<ContractSignature> findByHopDongIdOrderBySignedAtAsc(UUID hopDongId);
    void deleteByHopDongId(UUID hopDongId);
}
