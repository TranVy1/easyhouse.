package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.HopDong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HopDongRepository extends JpaRepository<HopDong, UUID> {
    boolean existsByMaHopDong(String maHopDong);
    @Query("SELECT hd FROM HopDong hd " +
           "LEFT JOIN FETCH hd.nguoiDaiDien kt " +
           "LEFT JOIN FETCH kt.nguoiDung " +
           "LEFT JOIN FETCH hd.phong p " +
           "LEFT JOIN FETCH p.nhaTro " +
           "WHERE hd.phong.id = :phongId AND hd.trangThai = :trangThai " +
           "ORDER BY hd.taoLuc DESC")
    Optional<HopDong> findFirstByPhongIdAndTrangThaiWithDetails(UUID phongId, TrangThaiHopDong trangThai);

    default Optional<HopDong> findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(UUID phongId, TrangThaiHopDong trangThai) {
        return findFirstByPhongIdAndTrangThaiWithDetails(phongId, trangThai);
    }

    @Query("SELECT hd FROM HopDong hd " +
           "LEFT JOIN FETCH hd.phong p " +
           "LEFT JOIN FETCH p.nhaTro " +
           "WHERE hd.trangThai = 'ACTIVE' AND hd.xoaLuc IS NULL")
    java.util.List<HopDong> findAllActiveWithPhongAndToaNha();
}
