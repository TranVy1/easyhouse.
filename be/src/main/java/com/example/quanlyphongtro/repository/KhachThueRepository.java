package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.KhachThue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface KhachThueRepository extends JpaRepository<KhachThue, UUID> {
    Optional<KhachThue> findByNguoiDungId(UUID nguoiDungId);
    List<KhachThue> findByChuTroIdAndXoaLucIsNull(UUID chuTroId);
    List<KhachThue> findByXoaLucIsNullOrderByTaoLucDesc();
    List<KhachThue> findByDangHoatDongTrueAndXoaLucIsNull();
    Optional<KhachThue> findByChuTroIdAndSoCccd(UUID chuTroId, String soCccd);
}