package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThanhVienHopDong;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ThanhVienHopDongRepository extends JpaRepository<ThanhVienHopDong, UUID> {
    List<ThanhVienHopDong> findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(UUID hopDongId);
    void deleteByHopDongId(UUID hopDongId);
}
