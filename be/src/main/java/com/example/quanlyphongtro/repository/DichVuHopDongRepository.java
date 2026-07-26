package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.DichVuHopDong;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DichVuHopDongRepository extends JpaRepository<DichVuHopDong, UUID> {
    List<DichVuHopDong> findByHopDongIdOrderByTaoLucAsc(UUID hopDongId);
    void deleteByHopDongId(UUID hopDongId);
    boolean existsByDichVuId(UUID dichVuId);
}
