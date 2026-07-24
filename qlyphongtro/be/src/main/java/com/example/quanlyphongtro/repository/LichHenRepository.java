package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.LichHen;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface LichHenRepository extends JpaRepository<LichHen, UUID>, JpaSpecificationExecutor<LichHen> {
    List<LichHen> findByNguoiDungId(UUID nguoiDungId);
    List<LichHen> findByPhongId(UUID phongId);
    List<LichHen> findByPhongNhaTroId(UUID nhaTroId);
    
    @org.springframework.data.jpa.repository.Query("SELECT l FROM LichHen l WHERE l.trangThai IN :statuses AND l.ngayHen BETWEEN :start AND :end AND l.daGuiNhacNho = false")
    List<LichHen> findUpcomingAppointments(
        @org.springframework.data.repository.query.Param("statuses") List<com.example.quanlyphongtro.entity.TrangThaiLichHen> statuses,
        @org.springframework.data.repository.query.Param("start") java.time.ZonedDateTime start,
        @org.springframework.data.repository.query.Param("end") java.time.ZonedDateTime end
    );

    long countBySoDienThoaiAndTrangThai(String soDienThoai, com.example.quanlyphongtro.entity.TrangThaiLichHen trangThai);
}
