package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.HopDong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HopDongRepository extends JpaRepository<HopDong, UUID> {
    boolean existsByMaHopDong(String maHopDong);
    Optional<HopDong> findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(UUID phongId, TrangThaiHopDong trangThai);
}
