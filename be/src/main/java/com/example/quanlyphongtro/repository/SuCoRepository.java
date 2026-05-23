package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.SuCo;
import com.example.quanlyphongtro.entity.TrangThaiSuCo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface SuCoRepository extends JpaRepository<SuCo, UUID> {
    List<SuCo> findAllByOrderByTaoLucDesc();
    List<SuCo> findByTrangThaiOrderByTaoLucDesc(TrangThaiSuCo trangThai);
    List<SuCo> findByPhongIdOrderByTaoLucDesc(UUID phongId);
    long countByTrangThai(TrangThaiSuCo trangThai);
}
