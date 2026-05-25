package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.SuCo;
import com.example.quanlyphongtro.entity.TrangThaiSuCo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

@Repository
public interface SuCoRepository extends JpaRepository<SuCo, UUID> {
    List<SuCo> findAllByOrderByTaoLucDesc();

    @org.springframework.data.jpa.repository.Query("SELECT s FROM SuCo s LEFT JOIN s.phong p " +
           "WHERE (:isAdmin = true OR p.nhaTro.id IN :nhaTroIds) " +
           "AND (:phongId IS NULL OR p.id = cast(:phongId as uuid)) " +
           "AND (:trangThai IS NULL OR s.trangThai = :trangThai)")
    Page<SuCo> findAllAccessible(@org.springframework.data.repository.query.Param("isAdmin") boolean isAdmin, @org.springframework.data.repository.query.Param("nhaTroIds") List<UUID> nhaTroIds, @org.springframework.data.repository.query.Param("phongId") String phongId, @org.springframework.data.repository.query.Param("trangThai") TrangThaiSuCo trangThai, Pageable pageable);
    List<SuCo> findByTrangThaiOrderByTaoLucDesc(TrangThaiSuCo trangThai);
    List<SuCo> findByPhongIdOrderByTaoLucDesc(UUID phongId);
    long countByTrangThai(TrangThaiSuCo trangThai);

    @org.springframework.data.jpa.repository.Query("SELECT COUNT(s) FROM SuCo s WHERE s.trangThai = :trangThai AND s.phong.nhaTro.id IN :nhaTroIds")
    long countByTrangThaiAndPhong_NhaTro_IdIn(@org.springframework.data.repository.query.Param("trangThai") TrangThaiSuCo trangThai, @org.springframework.data.repository.query.Param("nhaTroIds") List<UUID> nhaTroIds);
}
