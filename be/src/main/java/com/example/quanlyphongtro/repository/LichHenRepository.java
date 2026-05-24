package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.LichHen;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface LichHenRepository extends JpaRepository<LichHen, UUID> {
    List<LichHen> findByNguoiDungId(UUID nguoiDungId);
    List<LichHen> findByPhongId(UUID phongId);
    List<LichHen> findByPhongNhaTroId(UUID nhaTroId);
}
