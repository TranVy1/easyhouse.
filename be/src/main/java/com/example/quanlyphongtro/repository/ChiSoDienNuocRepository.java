package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ChiSoDienNuoc;
import com.example.quanlyphongtro.entity.LoaiChiSo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

@Repository
public interface ChiSoDienNuocRepository extends JpaRepository<ChiSoDienNuoc, UUID>, JpaSpecificationExecutor<ChiSoDienNuoc> {
    List<ChiSoDienNuoc> findByPhongIdOrderByKyNamDescKyThangDesc(UUID phongId);
    Optional<ChiSoDienNuoc> findByPhongIdAndLoaiAndKyNamAndKyThang(UUID phongId, LoaiChiSo loai, Integer kyNam, Integer kyThang);
    List<ChiSoDienNuoc> findByPhongIdAndLoaiOrderByKyNamDescKyThangDesc(UUID phongId, LoaiChiSo loai);
}
