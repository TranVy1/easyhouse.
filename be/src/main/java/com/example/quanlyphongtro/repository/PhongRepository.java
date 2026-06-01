package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
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
    List<Phong> findByTangEntityIdAndXoaLucIsNull(UUID tangId);
    List<Phong> findByNhaTroIdAndKhuVucAndXoaLucIsNull(UUID nhaTroId, String khuVuc);
    Optional<Phong> findByIdAndXoaLucIsNull(UUID id);
    long countByTrangThai(TrangThaiPhong trangThai);
    long countByNhaTroIdAndXoaLucIsNull(UUID nhaTroId);
    long countByNhaTroIdAndTrangThaiAndXoaLucIsNull(UUID nhaTroId, TrangThaiPhong trangThai);
    boolean existsByNhaTroIdAndTen(UUID nhaTroId, String ten);
    boolean existsByNhaTroIdAndTenAndIdNot(UUID nhaTroId, String ten, UUID id);

    @Query("SELECT p FROM Phong p LEFT JOIN p.nhaTro nt WHERE p.xoaLuc IS NULL " +
           "AND (cast(:nhaTroId as uuid) IS NULL OR p.nhaTro.id = :nhaTroId) " +
           "AND (cast(:trangThai as string) IS NULL OR cast(p.trangThai as string) = :trangThai) " +
           "AND (cast(:search as string) IS NULL OR LOWER(COALESCE(p.ten, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(p.khuVuc, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(p.moTa, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(nt.ten, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%'))) " +
           "AND (:isAdmin = true OR p.nhaTro.id IN :nhaTroIds)")
    Page<Phong> findAllAccessible(
            @Param("nhaTroId") UUID nhaTroId,
            @Param("trangThai") String trangThai,
            @Param("search") String search,
            @Param("isAdmin") boolean isAdmin,
            @Param("nhaTroIds") List<UUID> nhaTroIds,
            Pageable pageable);

    @Query("SELECT COUNT(p) FROM Phong p WHERE p.nhaTro.id IN :nhaTroIds")
    long countByNhaTroIdIn(@Param("nhaTroIds") List<UUID> nhaTroIds);

    @Query("SELECT COUNT(p) FROM Phong p WHERE p.trangThai = :trangThai AND p.nhaTro.id IN :nhaTroIds")
    long countByTrangThaiAndNhaTroIdIn(@Param("trangThai") com.example.quanlyphongtro.entity.TrangThaiPhong trangThai, @Param("nhaTroIds") List<UUID> nhaTroIds);

    @Query("SELECT p FROM Phong p LEFT JOIN p.nhaTro nt " +
           "WHERE p.xoaLuc IS NULL " +
           "AND p.trangThai = com.example.quanlyphongtro.entity.TrangThaiPhong.AVAILABLE " +
           "AND (cast(:nhaTroId as uuid) IS NULL OR nt.id = :nhaTroId) " +
           "AND (cast(:search as string) IS NULL OR LOWER(p.ten) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) OR LOWER(nt.ten) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) OR LOWER(nt.diaChi) LIKE LOWER(CONCAT('%', cast(:search as string), '%'))) " +
           "AND (cast(:minGia as bigdecimal) IS NULL OR p.giaHienTai >= :minGia) " +
           "AND (cast(:maxGia as bigdecimal) IS NULL OR p.giaHienTai <= :maxGia) " +
           "AND (cast(:minDienTich as bigdecimal) IS NULL OR p.dienTich >= :minDienTich)")
    Page<Phong> findPublicRooms(
            @Param("nhaTroId") UUID nhaTroId,
            @Param("search") String search,
            @Param("minGia") java.math.BigDecimal minGia,
            @Param("maxGia") java.math.BigDecimal maxGia,
            @Param("minDienTich") java.math.BigDecimal minDienTich,
            Pageable pageable);
}
