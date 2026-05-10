package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.KhachThue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface KhachThueRepository extends JpaRepository<KhachThue, UUID> {

    Optional<KhachThue> findByNguoiDungId(UUID nguoiDungId);

    Optional<KhachThue> findBySoCccd(String soCccd);

    @Query("SELECT kt FROM KhachThue kt LEFT JOIN FETCH kt.nguoiDung WHERE kt.xoaLuc IS NULL")
    List<KhachThue> findAllWithNguoiDung();

    @Query("SELECT kt FROM KhachThue kt LEFT JOIN FETCH kt.nguoiDung WHERE kt.id = :id AND kt.xoaLuc IS NULL")
    Optional<KhachThue> findByIdWithNguoiDung(UUID id);
}