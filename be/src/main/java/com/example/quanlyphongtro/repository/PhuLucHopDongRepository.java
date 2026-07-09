package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.PhuLucHopDong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface PhuLucHopDongRepository extends JpaRepository<PhuLucHopDong, UUID> {
    List<PhuLucHopDong> findByHopDongIdOrderByTaoLucDesc(UUID hopDongId);
    List<PhuLucHopDong> findByHopDongIdOrderByNgayHieuLucDescTaoLucDesc(UUID hopDongId);
}
