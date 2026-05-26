package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThongBaoNguoiNhan;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ThongBaoNguoiNhanRepository extends JpaRepository<ThongBaoNguoiNhan, UUID> {
    List<ThongBaoNguoiNhan> findByThongBaoId(UUID thongBaoId);

    Optional<ThongBaoNguoiNhan> findByThongBaoIdAndNguoiDungId(UUID thongBaoId, UUID nguoiDungId);

    void deleteByThongBaoId(UUID thongBaoId);

    List<ThongBaoNguoiNhan> findByNguoiDungId(UUID nguoiDungId);

    long countByNguoiDungIdAndDaDocFalse(UUID nguoiDungId);
}
