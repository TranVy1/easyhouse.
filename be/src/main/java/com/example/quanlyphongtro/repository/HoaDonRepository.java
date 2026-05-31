package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.TrangThaiHoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HoaDonRepository extends JpaRepository<HoaDon, UUID> {

    List<HoaDon> findByXoaLucIsNullOrderByTaoLucDesc();

    @Query("SELECT h FROM HoaDon h LEFT JOIN h.khachThue k LEFT JOIN h.phong p " +
           "WHERE h.xoaLuc IS NULL AND (:isAdmin = true OR k.nguoiDung.id = :userId OR p.nhaTro.id IN :nhaTroIds) " +
           "AND (cast(:hopDongId as string) IS NULL OR h.hopDong.id = :hopDongId) " +
           "AND (cast(:trangThai as string) IS NULL OR cast(h.trangThai as string) = :trangThai) " +
           "AND (:kyThang IS NULL OR h.kyThang = :kyThang) " +
           "AND (:kyNam IS NULL OR h.kyNam = :kyNam) " +
           "AND (cast(:search as string) IS NULL OR LOWER(COALESCE(h.maHoaDon, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(h.ghiChu, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(k.hoTen, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(p.ten, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')))")
    Page<HoaDon> findAllAccessible(
            @Param("isAdmin") boolean isAdmin,
            @Param("userId") UUID userId,
            @Param("nhaTroIds") List<UUID> nhaTroIds,
            @Param("hopDongId") UUID hopDongId,
            @Param("trangThai") String trangThai,
            @Param("search") String search,
            @Param("kyThang") Integer kyThang,
            @Param("kyNam") Integer kyNam,
            Pageable pageable);

    List<HoaDon> findByPhongIdAndXoaLucIsNull(UUID phongId);

    List<HoaDon> findByHopDongIdAndXoaLucIsNull(UUID hopDongId);

    List<HoaDon> findByKhachThueIdAndXoaLucIsNullOrderByKyNamDescKyThangDesc(UUID khachThueId);

    @Query("SELECT h FROM HoaDon h WHERE h.hopDong.id = :hopDongId AND h.xoaLuc IS NULL ORDER BY h.kyNam DESC, h.kyThang DESC")
    List<HoaDon> findLatestByHopDong(@Param("hopDongId") UUID hopDongId);

    List<HoaDon> findByTrangThaiAndXoaLucIsNull(TrangThaiHoaDon trangThai);

    Optional<HoaDon> findByHopDongIdAndKyNamAndKyThang(UUID hopDongId, Integer kyNam, Integer kyThang);

    Optional<HoaDon> findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(UUID hopDongId, Integer kyNam, Integer kyThang);

    Optional<HoaDon> findByHopDongIdAndKyNamAndKyThangAndIdNotAndXoaLucIsNull(UUID hopDongId, Integer kyNam, Integer kyThang, UUID id);

    @Query("SELECT COUNT(h) FROM HoaDon h WHERE h.trangThai IN :trangThaiList AND h.hanTra >= :start AND h.hanTra <= :end AND h.xoaLuc IS NULL")
    long countUnpaidInvoicesDueBetween(
        @Param("trangThaiList") List<TrangThaiHoaDon> trangThaiList,
        @Param("start") LocalDate start,
        @Param("end") LocalDate end
    );

    @Query("SELECT COALESCE(SUM(h.tongTien - h.daTra), 0) FROM HoaDon h WHERE h.trangThai IN :trangThaiList AND h.xoaLuc IS NULL")
    java.math.BigDecimal sumUnpaidAmount(@Param("trangThaiList") List<TrangThaiHoaDon> trangThaiList);

    List<HoaDon> findByTaoLucBetweenAndXoaLucIsNull(java.time.ZonedDateTime start, java.time.ZonedDateTime end);

    @Query("SELECT h FROM HoaDon h WHERE h.trangThai IN :trangThaiList AND h.hanTra < :today AND h.xoaLuc IS NULL")
    List<HoaDon> findOverdueInvoices(
        @Param("trangThaiList") List<TrangThaiHoaDon> trangThaiList,
        @Param("today") java.time.LocalDate today
    );

    @Query("SELECT h FROM HoaDon h WHERE h.trangThai IN :trangThaiList AND h.hanTra = :targetDate AND h.xoaLuc IS NULL")
    List<HoaDon> findUnpaidInvoicesDueOn(
        @Param("trangThaiList") List<TrangThaiHoaDon> trangThaiList,
        @Param("targetDate") java.time.LocalDate targetDate
    );

    @Query("SELECT h.kyThang AS thang, h.kyNam AS nam, SUM(h.tongTien) AS doanhThu, SUM(h.daTra) AS daThu " +
           "FROM HoaDon h WHERE h.xoaLuc IS NULL AND (h.kyNam > :nam OR (h.kyNam = :nam AND h.kyThang >= :thang)) " +
           "GROUP BY h.kyNam, h.kyThang " +
           "ORDER BY h.kyNam DESC, h.kyThang DESC")
    List<com.example.quanlyphongtro.dto.DoanhThuTheoThang> getDoanhThuThongKe(@Param("nam") int nam, @Param("thang") int thang);

    @Query("SELECT COUNT(h) FROM HoaDon h WHERE h.trangThai IN :trangThaiList AND h.hanTra >= :start AND h.hanTra <= :end AND h.xoaLuc IS NULL AND h.hopDong.phong.nhaTro.id IN :nhaTroIds")
    long countUnpaidInvoicesDueBetweenAndNhaTroIdIn(
        @Param("trangThaiList") List<TrangThaiHoaDon> trangThaiList,
        @Param("start") LocalDate start,
        @Param("end") LocalDate end,
        @Param("nhaTroIds") List<UUID> nhaTroIds
    );

    @Query("SELECT COALESCE(SUM(h.tongTien - h.daTra), 0) FROM HoaDon h WHERE h.trangThai IN :trangThaiList AND h.xoaLuc IS NULL AND h.hopDong.phong.nhaTro.id IN :nhaTroIds")
    java.math.BigDecimal sumUnpaidAmountAndNhaTroIdIn(
        @Param("trangThaiList") List<TrangThaiHoaDon> trangThaiList,
        @Param("nhaTroIds") List<UUID> nhaTroIds
    );

    @Query("SELECT h.kyThang AS thang, h.kyNam AS nam, SUM(h.tongTien) AS doanhThu, SUM(h.daTra) AS daThu " +
           "FROM HoaDon h WHERE h.xoaLuc IS NULL AND (h.kyNam > :nam OR (h.kyNam = :nam AND h.kyThang >= :thang)) AND h.hopDong.phong.nhaTro.id IN :nhaTroIds " +
           "GROUP BY h.kyNam, h.kyThang " +
           "ORDER BY h.kyNam DESC, h.kyThang DESC")
    List<com.example.quanlyphongtro.dto.DoanhThuTheoThang> getDoanhThuThongKeAndNhaTroIdIn(@Param("nam") int nam, @Param("thang") int thang, @Param("nhaTroIds") List<UUID> nhaTroIds);
}
