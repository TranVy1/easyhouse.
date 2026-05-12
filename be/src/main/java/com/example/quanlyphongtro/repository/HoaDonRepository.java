package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.TrangThaiHoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HoaDonRepository extends JpaRepository<HoaDon, UUID> {

    // Tìm hóa đơn chưa xóa
    List<HoaDon> findByXoaLucIsNullOrderByTaoLucDesc();

    // Tìm theo phòng
    List<HoaDon> findByPhongIdAndXoaLucIsNull(UUID phongId);

    // Tìm theo hợp đồng
    List<HoaDon> findByHopDongIdAndXoaLucIsNull(UUID hopDongId);

    // Tìm hóa đơn gần nhất theo hợp đồng (để lấy chỉ số điện nước cuối kỳ)
    @Query("SELECT h FROM HoaDon h WHERE h.hopDong.id = :hopDongId AND h.xoaLuc IS NULL ORDER BY h.thangHoaDon DESC")
    List<HoaDon> findLatestByHopDong(@Param("hopDongId") UUID hopDongId);

    // Tìm theo trạng thái
    List<HoaDon> findByTrangThaiAndXoaLucIsNull(TrangThaiHoaDon trangThai);
}
