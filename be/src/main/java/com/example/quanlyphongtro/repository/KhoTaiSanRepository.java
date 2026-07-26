package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.KhoTaiSan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface KhoTaiSanRepository extends JpaRepository<KhoTaiSan, UUID> {
    List<KhoTaiSan> findByNhaTroId(UUID nhaTroId);
    List<KhoTaiSan> findByNhaTroIdAndTinhTrang(UUID nhaTroId, String tinhTrang);
}
