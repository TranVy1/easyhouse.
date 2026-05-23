package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface PhongRepository extends JpaRepository<Phong, UUID> {
    List<Phong> findByNhaTroIdAndXoaLucIsNull(UUID nhaTroId);
    List<Phong> findByXoaLucIsNull();
    List<Phong> findByTrangThaiAndXoaLucIsNull(TrangThaiPhong trangThai);
    List<Phong> findByNhaTroIdAndTrangThaiAndXoaLucIsNull(UUID nhaTroId, TrangThaiPhong trangThai);
    List<Phong> findByTrangThai(TrangThaiPhong trangThai);
    List<Phong> findByNhaTroIdAndTrangThai(UUID nhaTroId, TrangThaiPhong trangThai);
    List<Phong> findByNhaTroIdAndTangAndXoaLucIsNull(UUID nhaTroId, Integer tang);
    List<Phong> findByNhaTroIdAndKhuVucAndXoaLucIsNull(UUID nhaTroId, String khuVuc);
    long countByTrangThai(TrangThaiPhong trangThai);
    long countByNhaTroIdAndXoaLucIsNull(UUID nhaTroId);
    long countByNhaTroIdAndTrangThaiAndXoaLucIsNull(UUID nhaTroId, TrangThaiPhong trangThai);
    boolean existsByNhaTroIdAndTen(UUID nhaTroId, String ten);
    boolean existsByNhaTroIdAndTenAndIdNot(UUID nhaTroId, String ten, UUID id);
}
