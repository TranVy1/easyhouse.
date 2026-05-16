package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.SuCo;
import com.example.quanlyphongtro.entity.TrangThaiSuCo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SuCoRepository extends JpaRepository<SuCo, UUID> {

    @Query("SELECT sc FROM SuCo sc LEFT JOIN FETCH sc.phong LEFT JOIN FETCH sc.khachThue kt LEFT JOIN FETCH kt.nguoiDung ORDER BY sc.taoLuc DESC")
    List<SuCo> findAllWithDetails();

    @Query("SELECT sc FROM SuCo sc LEFT JOIN FETCH sc.phong LEFT JOIN FETCH sc.khachThue kt LEFT JOIN FETCH kt.nguoiDung WHERE sc.id = :id")
    Optional<SuCo> findByIdWithDetails(UUID id);

    List<SuCo> findByTrangThaiOrderByTaoLucDesc(TrangThaiSuCo trangThai);

    List<SuCo> findByPhongIdOrderByTaoLucDesc(UUID phongId);

    long countByTrangThai(TrangThaiSuCo trangThai);
}
