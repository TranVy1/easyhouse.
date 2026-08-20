package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.TaiSanPhong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface TaiSanPhongRepository extends JpaRepository<TaiSanPhong, UUID> {
    List<TaiSanPhong> findByPhongId(UUID phongId);
    List<TaiSanPhong> findByPhongIdIn(List<UUID> phongIds);
    List<TaiSanPhong> findByKhoTaiSanId(UUID khoTaiSanId);
}
