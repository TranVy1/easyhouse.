package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.DangKyPush;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface DangKyPushRepository extends JpaRepository<DangKyPush, UUID> {

    Optional<DangKyPush> findByEndpoint(String endpoint);

    /**
     * Cac dang ky con dung duoc cua mot nhom nguoi.
     *
     * Lay hang loat trong MOT query thay vi lap theo tung nguoi: mot tin nhan gui
     * vao nhom 50 nguoi ma query 50 lan thi Hikari pool (15 ket noi) chiu khong noi.
     */
    @Query("""
            SELECT d FROM DangKyPush d
            WHERE d.nguoiDung.id IN :nguoiDungIds AND d.dungLuc IS NULL
            """)
    List<DangKyPush> dangDung(@Param("nguoiDungIds") List<UUID> nguoiDungIds);
}
