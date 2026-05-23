package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HopDongRepository extends JpaRepository<HopDong, UUID> {
    boolean existsByMaHopDong(String maHopDong);

    List<HopDong> findByXoaLucIsNullOrderByTaoLucDesc();

    List<HopDong> findByPhongIdAndXoaLucIsNull(UUID phongId);

    List<HopDong> findByKhachThueIdAndXoaLucIsNull(UUID khachThueId);

    @Query("SELECT hd FROM HopDong hd WHERE hd.phong.id = :phongId AND hd.trangThai = :trangThai AND hd.xoaLuc IS NULL ORDER BY hd.taoLuc DESC")
    List<HopDong> findByPhongIdAndTrangThai(@Param("phongId") UUID phongId, @Param("trangThai") TrangThaiHopDong trangThai);

    default Optional<HopDong> findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(UUID phongId, TrangThaiHopDong trangThai) {
        List<HopDong> list = findByPhongIdAndTrangThai(phongId, trangThai);
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    @Query("SELECT hd FROM HopDong hd WHERE hd.trangThai = 'ACTIVE' AND hd.xoaLuc IS NULL")
    List<HopDong> findAllActive();
}
