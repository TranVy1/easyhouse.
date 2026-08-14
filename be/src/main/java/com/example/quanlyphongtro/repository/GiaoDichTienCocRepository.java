package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.GiaoDichTienCoc;
import com.example.quanlyphongtro.entity.LoaiGiaoDichTienCoc;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface GiaoDichTienCocRepository extends JpaRepository<GiaoDichTienCoc, UUID> {
    List<GiaoDichTienCoc> findByHopDongIdOrderByThoiDiemAsc(UUID hopDongId);
    Optional<GiaoDichTienCoc> findByThanhToanId(UUID thanhToanId);
    Optional<GiaoDichTienCoc> findByQuyetToanTraPhongIdAndLoai(UUID quyetToanId, LoaiGiaoDichTienCoc loai);
}
