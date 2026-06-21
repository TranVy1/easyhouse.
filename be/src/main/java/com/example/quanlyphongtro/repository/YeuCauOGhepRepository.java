package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.YeuCauOGhep;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface YeuCauOGhepRepository extends JpaRepository<YeuCauOGhep, UUID> {
    
    List<YeuCauOGhep> findByKhachThueIdOrderByTaoLucDesc(UUID khachThueId);
    
    List<YeuCauOGhep> findByHopDongIdOrderByTaoLucDesc(UUID hopDongId);

    @Query("SELECT y FROM YeuCauOGhep y WHERE y.hopDong.phong.nhaTro.id = :nhaTroId ORDER BY y.taoLuc DESC")
    List<YeuCauOGhep> findByNhaTroId(@Param("nhaTroId") UUID nhaTroId);
}
