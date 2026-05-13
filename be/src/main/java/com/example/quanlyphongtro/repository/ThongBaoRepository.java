package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThongBao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ThongBaoRepository extends JpaRepository<ThongBao, UUID> {
    List<ThongBao> findAllByOrderByTaoLucDesc();
    List<ThongBao> findByNguoiDungIdOrderByTaoLucDesc(UUID nguoiDungId);
}
