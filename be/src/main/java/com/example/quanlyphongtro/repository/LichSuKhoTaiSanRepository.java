package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.LichSuKhoTaiSan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface LichSuKhoTaiSanRepository extends JpaRepository<LichSuKhoTaiSan, UUID> {
    List<LichSuKhoTaiSan> findByKhoTaiSanIdOrderByTaoLucDesc(UUID khoTaiSanId);
}
