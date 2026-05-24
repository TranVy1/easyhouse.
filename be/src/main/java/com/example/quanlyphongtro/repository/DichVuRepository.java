package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.DichVu;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DichVuRepository extends JpaRepository<DichVu, UUID> {
    Optional<DichVu> findByChuTroIdAndTenDichVuIgnoreCase(UUID chuTroId, String tenDichVu);

    List<DichVu> findByChuTroId(UUID chuTroId);
}
