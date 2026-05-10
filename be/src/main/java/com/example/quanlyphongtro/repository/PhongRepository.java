package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface PhongRepository extends JpaRepository<Phong, UUID> {
    List<Phong> findByNhaTroId(UUID nhaTroId);
    List<Phong> findByTrangThai(TrangThaiPhong trangThai);
    List<Phong> findByNhaTroIdAndTrangThai(UUID nhaTroId, TrangThaiPhong trangThai);
    long countByTrangThai(TrangThaiPhong trangThai);
    long countByNhaTroId(UUID nhaTroId);
    long countByNhaTroIdAndTrangThai(UUID nhaTroId, TrangThaiPhong trangThai);
}
