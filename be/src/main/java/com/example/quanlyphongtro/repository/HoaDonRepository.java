package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.TrangThaiHoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HoaDonRepository extends JpaRepository<HoaDon, UUID> {

    List<HoaDon> findByXoaLucIsNullOrderByTaoLucDesc();

    List<HoaDon> findByPhongIdAndXoaLucIsNull(UUID phongId);

    List<HoaDon> findByHopDongIdAndXoaLucIsNull(UUID hopDongId);

    List<HoaDon> findByKhachThueIdAndXoaLucIsNullOrderByKyNamDescKyThangDesc(UUID khachThueId);

    @Query("SELECT h FROM HoaDon h WHERE h.hopDong.id = :hopDongId AND h.xoaLuc IS NULL ORDER BY h.kyNam DESC, h.kyThang DESC")
    List<HoaDon> findLatestByHopDong(@Param("hopDongId") UUID hopDongId);

    List<HoaDon> findByTrangThaiAndXoaLucIsNull(TrangThaiHoaDon trangThai);

    Optional<HoaDon> findByHopDongIdAndKyNamAndKyThang(UUID hopDongId, Integer kyNam, Integer kyThang);

    @Query("SELECT COUNT(h) FROM HoaDon h WHERE h.trangThai IN :trangThaiList AND h.hanTra >= :start AND h.hanTra <= :end AND h.xoaLuc IS NULL")
    long countUnpaidInvoicesDueBetween(
        @Param("trangThaiList") List<TrangThaiHoaDon> trangThaiList,
        @Param("start") LocalDate start,
        @Param("end") LocalDate end
    );
}
