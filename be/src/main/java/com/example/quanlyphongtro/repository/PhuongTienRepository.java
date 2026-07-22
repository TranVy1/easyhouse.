package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.PhuongTien;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface PhuongTienRepository extends JpaRepository<PhuongTien, UUID>, JpaSpecificationExecutor<PhuongTien> {
    
    Optional<PhuongTien> findByIdAndChuTroId(UUID id, UUID chuTroId);
    
    boolean existsByMaPtAndChuTroId(String maPt, UUID chuTroId);
    
    boolean existsByBienSoAndTrangThaiAndChuTroId(String bienSo, com.example.quanlyphongtro.entity.TrangThaiPhuongTien trangThai, UUID chuTroId);
    
    java.util.List<PhuongTien> findByPhongIdAndTrangThai(UUID phongId, com.example.quanlyphongtro.entity.TrangThaiPhuongTien trangThai);
    
    // Custom spec query can be used for filtering by nhaTro, phong, trangThai, keyword
}
