package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.MeterAnomalyAlert;
import com.example.quanlyphongtro.entity.TrangThaiAlert;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface MeterAnomalyAlertRepository extends JpaRepository<MeterAnomalyAlert, UUID> {
    
    Optional<MeterAnomalyAlert> findByChiSoDienNuocId(UUID chiSoId);

    List<MeterAnomalyAlert> findByPhongIdOrderByTaoLucDesc(UUID phongId);

    List<MeterAnomalyAlert> findByTrangThai(TrangThaiAlert trangThai);

    @Query("SELECT a FROM MeterAnomalyAlert a JOIN a.phong p WHERE a.trangThai = :trangThai AND p.nhaTro.id IN :nhaTroIds ORDER BY a.taoLuc DESC")
    List<MeterAnomalyAlert> findByTrangThaiAndNhaTroIds(
        @Param("trangThai") TrangThaiAlert trangThai, 
        @Param("nhaTroIds") List<UUID> nhaTroIds
    );
}
