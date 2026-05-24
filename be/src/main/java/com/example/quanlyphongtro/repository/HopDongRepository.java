package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HopDongRepository extends JpaRepository<HopDong, UUID> {
    boolean existsByMaHopDong(String maHopDong);

    boolean existsByMaHopDongAndIdNot(String maHopDong, UUID id);

    List<HopDong> findByXoaLucIsNullOrderByTaoLucDesc();

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
}
