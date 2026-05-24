package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.entity.TrangThaiThanhToan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface ThanhToanRepository extends JpaRepository<ThanhToan, UUID> {
    List<ThanhToan> findByHoaDonIdOrderByNgayThanhToanDesc(UUID hoaDonId);
    List<ThanhToan> findByHoaDonIdAndTrangThai(UUID hoaDonId, TrangThaiThanhToan trangThai);

    @Query("SELECT COALESCE(SUM(t.soTien), 0) FROM ThanhToan t WHERE t.trangThai = :trangThai AND t.ngayThanhToan >= :start AND t.ngayThanhToan < :end")
    BigDecimal sumSuccessfulPaymentsInPeriod(
        @Param("trangThai") TrangThaiThanhToan trangThai,
        @Param("start") ZonedDateTime start,
        @Param("end") ZonedDateTime end
    );
}
