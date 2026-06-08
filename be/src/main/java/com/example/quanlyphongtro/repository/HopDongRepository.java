package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HopDongRepository extends JpaRepository<HopDong, UUID> {
    boolean existsByMaHopDong(String maHopDong);

    boolean existsByMaHopDongAndIdNot(String maHopDong, UUID id);

    List<HopDong> findByXoaLucIsNullOrderByTaoLucDesc();

    @Query("SELECT hd FROM HopDong hd LEFT JOIN hd.khachThue k LEFT JOIN hd.phong p LEFT JOIN p.nhaTro nt " +
           "WHERE hd.xoaLuc IS NULL AND (:isAdmin = true OR k.nguoiDung.id = :userId OR p.nhaTro.id IN :nhaTroIds) " +
           "AND (cast(:phongId as string) IS NULL OR p.id = :phongId) " +
           "AND (cast(:nhaTroId as string) IS NULL OR nt.id = :nhaTroId) " +
           "AND (cast(:trangThai as string) IS NULL OR cast(hd.trangThai as string) = :trangThai) " +
           "AND (cast(:search as string) IS NULL OR LOWER(COALESCE(hd.maHopDong, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(hd.ghiChu, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(hd.noiDungHopDong, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(k.hoTen, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(p.ten, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(nt.ten, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')))")
    Page<HopDong> findAllAccessible(
            @Param("isAdmin") boolean isAdmin,
            @Param("userId") UUID userId,
            @Param("nhaTroIds") List<UUID> nhaTroIds,
            @Param("phongId") UUID phongId,
            @Param("nhaTroId") UUID nhaTroId,
            @Param("trangThai") String trangThai,
            @Param("search") String search,
            Pageable pageable);

    List<HopDong> findByPhongIdAndXoaLucIsNull(UUID phongId);

    List<HopDong> findByKhachThueIdAndXoaLucIsNull(UUID khachThueId);

    @Query("SELECT hd FROM HopDong hd WHERE hd.phong.id = :phongId AND hd.trangThai = :trangThai AND hd.xoaLuc IS NULL ORDER BY hd.taoLuc DESC")
    List<HopDong> findByPhongIdAndTrangThai(@Param("phongId") UUID phongId, @Param("trangThai") TrangThaiHopDong trangThai);

    @Query("""
            SELECT hd
            FROM HopDong hd
            WHERE hd.phong.id = :phongId
              AND hd.trangThai IN :trangThai
              AND hd.xoaLuc IS NULL
              AND (:excludeId IS NULL OR hd.id <> :excludeId)
              AND hd.ngayBatDau <= :ngayKetThuc
              AND hd.ngayKetThuc >= :ngayBatDau
            ORDER BY hd.ngayBatDau ASC
            """)
    List<HopDong> findOverlappingRoomContracts(
            @Param("phongId") UUID phongId,
            @Param("trangThai") List<TrangThaiHopDong> trangThai,
            @Param("ngayBatDau") java.time.LocalDate ngayBatDau,
            @Param("ngayKetThuc") java.time.LocalDate ngayKetThuc,
            @Param("excludeId") UUID excludeId
    );

    @Query("""
            SELECT hd
            FROM HopDong hd
            WHERE hd.phong.id = :phongId
              AND hd.trangThai IN :trangThai
              AND hd.xoaLuc IS NULL
            ORDER BY
              CASE hd.trangThai WHEN com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE THEN 0 ELSE 1 END,
              hd.ngayBatDau DESC
            """)
    List<HopDong> findRoomOccupyingContracts(
            @Param("phongId") UUID phongId,
            @Param("trangThai") List<TrangThaiHopDong> trangThai
    );

    default Optional<HopDong> findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(UUID phongId, TrangThaiHopDong trangThai) {
        List<HopDong> list = findByPhongIdAndTrangThai(phongId, trangThai);
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    @Query("SELECT hd FROM HopDong hd WHERE hd.trangThai = 'ACTIVE' AND hd.xoaLuc IS NULL")
    List<HopDong> findAllActive();

    @Query("SELECT COUNT(hd) FROM HopDong hd WHERE hd.trangThai = :trangThai AND hd.ngayKetThuc >= :start AND hd.ngayKetThuc <= :end AND hd.xoaLuc IS NULL")
    long countContractsExpiringBetween(
        @Param("trangThai") TrangThaiHopDong trangThai,
        @Param("start") java.time.LocalDate start,
        @Param("end") java.time.LocalDate end
    );

    @Query("SELECT hd FROM HopDong hd WHERE hd.trangThai = :trangThai AND hd.ngayKetThuc = :targetDate AND hd.xoaLuc IS NULL")
    List<HopDong> findActiveContractsExpiringOn(
        @Param("trangThai") TrangThaiHopDong trangThai,
        @Param("targetDate") java.time.LocalDate targetDate
    );

    @Query("SELECT COUNT(hd) FROM HopDong hd WHERE hd.trangThai = :trangThai AND hd.ngayKetThuc >= :start AND hd.ngayKetThuc <= :end AND hd.xoaLuc IS NULL AND hd.phong.nhaTro.id IN :nhaTroIds")
    long countContractsExpiringBetweenAndNhaTroIdIn(
        @Param("trangThai") TrangThaiHopDong trangThai,
        @Param("start") java.time.LocalDate start,
        @Param("end") java.time.LocalDate end,
        @Param("nhaTroIds") List<UUID> nhaTroIds
    );
    
    @Query("SELECT COUNT(DISTINCT hd.khachThue) FROM HopDong hd WHERE hd.trangThai = 'ACTIVE' AND hd.xoaLuc IS NULL AND hd.phong.nhaTro.id IN :nhaTroIds")
    long countActiveTenantsByNhaTroIdIn(@Param("nhaTroIds") List<UUID> nhaTroIds);

    boolean existsByPhongAndKhachThueAndNgayBatDauAfter(com.example.quanlyphongtro.entity.Phong phong, com.example.quanlyphongtro.entity.KhachThue khachThue, java.time.LocalDate date);
}
