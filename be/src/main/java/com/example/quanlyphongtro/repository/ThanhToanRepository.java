package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.entity.TrangThaiThanhToan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;
import java.util.Optional;

@Repository
public interface ThanhToanRepository extends JpaRepository<ThanhToan, UUID> {
    List<ThanhToan> findByHoaDonIdOrderByNgayThanhToanDesc(UUID hoaDonId);
    Optional<ThanhToan> findByExternalTransactionId(String externalTransactionId);

    @Query("SELECT t FROM ThanhToan t LEFT JOIN t.hoaDon h LEFT JOIN h.khachThue k LEFT JOIN h.phong p " +
           "WHERE (:isAdmin = true OR k.nguoiDung.id = :userId OR p.nhaTro.id IN :nhaTroIds) " +
           "AND (cast(:hoaDonId as string) IS NULL OR h.id = :hoaDonId) " +
           "AND (cast(:trangThai as string) IS NULL OR cast(t.trangThai as string) = :trangThai)")
    Page<ThanhToan> findAllAccessible(@Param("isAdmin") boolean isAdmin, @Param("userId") UUID userId, @Param("nhaTroIds") List<UUID> nhaTroIds, @Param("hoaDonId") UUID hoaDonId, @Param("trangThai") String trangThai, Pageable pageable);
    List<ThanhToan> findByHoaDonIdAndTrangThai(UUID hoaDonId, TrangThaiThanhToan trangThai);

    @Query("SELECT COALESCE(SUM(t.soTien), 0) FROM ThanhToan t WHERE t.trangThai = :trangThai AND t.ngayThanhToan >= :start AND t.ngayThanhToan < :end")
    BigDecimal sumSuccessfulPaymentsInPeriod(
        @Param("trangThai") TrangThaiThanhToan trangThai,
        @Param("start") ZonedDateTime start,
        @Param("end") ZonedDateTime end
    );

    @Query("SELECT COALESCE(SUM(t.soTien), 0) FROM ThanhToan t WHERE t.trangThai = :trangThai AND t.ngayThanhToan >= :start AND t.ngayThanhToan < :end AND t.hoaDon.hopDong.phong.nhaTro.id IN :nhaTroIds")
    BigDecimal sumSuccessfulPaymentsInPeriodAndNhaTroIdIn(
        @Param("trangThai") TrangThaiThanhToan trangThai,
        @Param("start") ZonedDateTime start,
        @Param("end") ZonedDateTime end,
        @Param("nhaTroIds") List<UUID> nhaTroIds
    );
}
