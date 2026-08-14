package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.QuyetToanTraPhong;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface QuyetToanTraPhongRepository extends JpaRepository<QuyetToanTraPhong, UUID> {
    Optional<QuyetToanTraPhong> findByHopDongId(UUID hopDongId);
}
