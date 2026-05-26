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
           "WHERE (:isAdmin = true OR p.nhaTro.id IN :nhaTroIds OR s.nguoiBao.id = :userId) " +
           "AND (cast(:nhaTroId as string) IS NULL OR p.nhaTro.id = :nhaTroId) " +
           "AND (cast(:phongId as string) IS NULL OR p.id = :phongId) " +
           "AND (cast(:trangThai as string) IS NULL OR cast(s.trangThai as string) = :trangThai) " +
           "AND (cast(:loaiSuCo as string) IS NULL OR cast(s.loaiSuCo as string) = :loaiSuCo) " +
           "AND (cast(:uuTien as string) IS NULL OR cast(s.uuTien as string) = :uuTien)")
    Page<SuCo> findAllAccessible(
            @org.springframework.data.repository.query.Param("isAdmin") boolean isAdmin,
            @org.springframework.data.repository.query.Param("userId") UUID userId,
            @org.springframework.data.repository.query.Param("nhaTroIds") List<UUID> nhaTroIds,
            @org.springframework.data.repository.query.Param("nhaTroId") UUID nhaTroId,
            @org.springframework.data.repository.query.Param("phongId") UUID phongId,
            @org.springframework.data.repository.query.Param("trangThai") String trangThai,
            @org.springframework.data.repository.query.Param("loaiSuCo") String loaiSuCo,
            @org.springframework.data.repository.query.Param("uuTien") String uuTien,
            Pageable pageable);
    List<SuCo> findByTrangThaiOrderByTaoLucDesc(TrangThaiSuCo trangThai);
    List<SuCo> findByPhongIdOrderByTaoLucDesc(UUID phongId);
    long countByTrangThai(TrangThaiSuCo trangThai);

    @org.springframework.data.jpa.repository.Query("SELECT COUNT(s) FROM SuCo s WHERE s.trangThai = :trangThai AND s.phong.nhaTro.id IN :nhaTroIds")
    long countByTrangThaiAndPhong_NhaTro_IdIn(@org.springframework.data.repository.query.Param("trangThai") TrangThaiSuCo trangThai, @org.springframework.data.repository.query.Param("nhaTroIds") List<UUID> nhaTroIds);

    long countByNguoiBaoIdAndTrangThaiIn(UUID nguoiBaoId, List<TrangThaiSuCo> trangThais);
}
