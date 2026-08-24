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
    Page<KhachThue> findByXoaLucIsNullOrderByTaoLucDesc(Pageable pageable);
    List<KhachThue> findByDangHoatDongTrueAndXoaLucIsNull();
    long countByDangHoatDongTrueAndXoaLucIsNull();
    Optional<KhachThue> findByChuTroIdAndSoCccd(UUID chuTroId, String soCccd);

    @Query(value = "SELECT k FROM KhachThue k LEFT JOIN FETCH k.nguoiDung nd " +
           "WHERE k.xoaLuc IS NULL " +
           "AND (:isAdmin = true " +
           "     OR k.nguoiDung.id = :userId " +
           "     OR k.chuTro.id = :userId " +
           "     OR EXISTS (SELECT 1 FROM HopDong hd2 JOIN hd2.phong p2 WHERE hd2.khachThue = k AND p2.nhaTro.id IN :nhaTroIds AND hd2.xoaLuc IS NULL)) " +
           "AND (cast(:trangThai as string) IS NULL OR " +
           "    (cast(:trangThai as string) = 'dangThue' AND EXISTS (SELECT 1 FROM HopDong hd3 WHERE hd3.khachThue = k AND hd3.trangThai = com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE AND hd3.xoaLuc IS NULL)) OR " +
           "    (cast(:trangThai as string) = 'daKetThuc' AND NOT EXISTS (SELECT 1 FROM HopDong hd4 WHERE hd4.khachThue = k AND hd4.trangThai = com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE AND hd4.xoaLuc IS NULL))) " +
           "AND (:search = '' OR LOWER(COALESCE(k.hoTen, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.soDienThoai, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.soCccd, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.queQuan, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.queQuan, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.email, '')) LIKE LOWER(CONCAT('%', :search, '%')))",
           countQuery = "SELECT count(k) FROM KhachThue k " +
           "WHERE k.xoaLuc IS NULL " +
           "AND (:isAdmin = true " +
           "     OR k.nguoiDung.id = :userId " +
           "     OR k.chuTro.id = :userId " +
           "     OR EXISTS (SELECT 1 FROM HopDong hd2 JOIN hd2.phong p2 WHERE hd2.khachThue = k AND p2.nhaTro.id IN :nhaTroIds AND hd2.xoaLuc IS NULL)) " +
           "AND (cast(:trangThai as string) IS NULL OR " +
           "    (cast(:trangThai as string) = 'dangThue' AND EXISTS (SELECT 1 FROM HopDong hd3 WHERE hd3.khachThue = k AND hd3.trangThai = com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE AND hd3.xoaLuc IS NULL)) OR " +
           "    (cast(:trangThai as string) = 'daKetThuc' AND NOT EXISTS (SELECT 1 FROM HopDong hd4 WHERE hd4.khachThue = k AND hd4.trangThai = com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE AND hd4.xoaLuc IS NULL))) " +
           "AND (:search = '' OR LOWER(COALESCE(k.hoTen, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.soDienThoai, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.soCccd, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.queQuan, '')) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "    OR LOWER(COALESCE(k.email, '')) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<KhachThue> findAllAccessible(
            @Param("isAdmin") boolean isAdmin,
            @Param("userId") UUID userId,
            @Param("nhaTroIds") List<UUID> nhaTroIds,
            @Param("trangThai") String trangThai,
            @Param("search") String search,
            Pageable pageable);
}

