package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.Tang;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface TangRepository extends JpaRepository<Tang, UUID> {
    List<Tang> findByNhaTroIdAndXoaLucIsNullOrderBySoTangAsc(UUID nhaTroId);
    Optional<Tang> findByNhaTroIdAndSoTangAndXoaLucIsNull(UUID nhaTroId, Integer soTang);
    Optional<Tang> findByIdAndXoaLucIsNull(UUID id);
}
