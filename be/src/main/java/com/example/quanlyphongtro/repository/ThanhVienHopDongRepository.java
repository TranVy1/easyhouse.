package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThanhVienHopDong;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ThanhVienHopDongRepository extends JpaRepository<ThanhVienHopDong, UUID> {
    List<ThanhVienHopDong> findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(UUID hopDongId);
    List<ThanhVienHopDong> findByHopDongId(UUID hopDongId);

    @org.springframework.data.jpa.repository.Query("SELECT tv FROM ThanhVienHopDong tv WHERE tv.hopDong.id IN :hopDongIds ORDER BY tv.laNguoiDaiDien DESC, tv.taoLuc ASC")
    List<ThanhVienHopDong> findByHopDongIdInOrderByLaNguoiDaiDienDescTaoLucAsc(@org.springframework.data.repository.query.Param("hopDongIds") List<UUID> hopDongIds);

    void deleteByHopDongId(UUID hopDongId);
}
