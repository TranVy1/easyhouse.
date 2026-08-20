package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.DichVuHopDong;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DichVuHopDongRepository extends JpaRepository<DichVuHopDong, UUID> {
    List<DichVuHopDong> findByHopDongIdOrderByTaoLucAsc(UUID hopDongId);

    @org.springframework.data.jpa.repository.Query("SELECT dvhd FROM DichVuHopDong dvhd LEFT JOIN FETCH dvhd.dichVu WHERE dvhd.hopDong.id IN :hopDongIds ORDER BY dvhd.taoLuc ASC")
    List<DichVuHopDong> findByHopDongIdInOrderByTaoLucAsc(@org.springframework.data.repository.query.Param("hopDongIds") List<UUID> hopDongIds);

    void deleteByHopDongId(UUID hopDongId);
    boolean existsByDichVuId(UUID dichVuId);
}
