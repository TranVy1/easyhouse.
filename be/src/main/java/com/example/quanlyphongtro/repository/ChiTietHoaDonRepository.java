package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ChiTietHoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ChiTietHoaDonRepository extends JpaRepository<ChiTietHoaDon, UUID> {
    List<ChiTietHoaDon> findByHoaDonId(UUID hoaDonId);
    List<ChiTietHoaDon> findByHoaDonIdIn(List<UUID> hoaDonIds);
    void deleteByHoaDonId(UUID hoaDonId);
}
