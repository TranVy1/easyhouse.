package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ChiTietBanGiaoTaiSan;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface ChiTietBanGiaoTaiSanRepository extends JpaRepository<ChiTietBanGiaoTaiSan, UUID> {
    List<ChiTietBanGiaoTaiSan> findByQuyetToanTraPhongIdOrderByTaoLucAsc(UUID quyetToanId);
}
