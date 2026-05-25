package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.KhachThue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface KhachThueRepository extends JpaRepository<KhachThue, UUID> {
    Optional<KhachThue> findByNguoiDungId(UUID nguoiDungId);
    List<KhachThue> findByChuTroIdAndXoaLucIsNull(UUID chuTroId);
    List<KhachThue> findByXoaLucIsNullOrderByTaoLucDesc();
    List<KhachThue> findByDangHoatDongTrueAndXoaLucIsNull();
    long countByDangHoatDongTrueAndXoaLucIsNull();
    Optional<KhachThue> findByChuTroIdAndSoCccd(UUID chuTroId, String soCccd);

    @Query("SELECT DISTINCT k FROM KhachThue k " +
           "LEFT JOIN HopDong hd ON hd.khachThue = k AND hd.trangThai = com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE AND hd.xoaLuc IS NULL " +
           "LEFT JOIN hd.phong p " +
           "WHERE k.xoaLuc IS NULL " +
           "AND (:isAdmin = true " +
           "     OR k.nguoiDung.id = :userId " +
           "     OR k.chuTro.id = :userId " +
           "     OR p.nhaTro.id IN :nhaTroIds) " +
           "AND (:trangThai IS NULL OR " +
           "    (:trangThai = 'dangThue' AND hd.id IS NOT NULL) OR " +
           "    (:trangThai = 'daKetThuc' AND hd.id IS NULL))")
    Page<KhachThue> findAllAccessible(@Param("isAdmin") boolean isAdmin, @Param("userId") UUID userId, @Param("nhaTroIds") List<UUID> nhaTroIds, @Param("trangThai") String trangThai, Pageable pageable);
}