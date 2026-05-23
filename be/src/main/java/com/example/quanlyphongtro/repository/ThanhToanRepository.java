package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.entity.TrangThaiThanhToan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ThanhToanRepository extends JpaRepository<ThanhToan, UUID> {
    List<ThanhToan> findByHoaDonIdOrderByNgayThanhToanDesc(UUID hoaDonId);
    List<ThanhToan> findByHoaDonIdAndTrangThai(UUID hoaDonId, TrangThaiThanhToan trangThai);
}
