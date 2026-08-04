package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.NguoiDungNhaTro;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface NguoiDungNhaTroRepository extends JpaRepository<NguoiDungNhaTro, UUID> {
    List<NguoiDungNhaTro> findByNguoiDungId(UUID nguoiDungId);
    Optional<NguoiDungNhaTro> findByNguoiDungIdAndNhaTroId(UUID nguoiDungId, UUID nhaTroId);

    /** Module tin nhan: nhan vien quan ly cua mot nhom nha tro, de dua vao kenh ho tro. */
    List<NguoiDungNhaTro> findByNhaTroIdIn(List<UUID> nhaTroIds);

    @Query("""
            SELECT DISTINCT q.nguoiDung.id
            FROM NguoiDungNhaTro q
            WHERE q.nhaTro.id = :nhaTroId
              AND (q.coQuyenXem = true OR q.coQuyenSua = true)
              AND q.nguoiDung.xoaLuc IS NULL
              AND q.nguoiDung.trangThai = :trangThai
            """)
    List<UUID> findNguoiDungIdsCoQuyenTheoTrangThai(
            @Param("nhaTroId") UUID nhaTroId,
            @Param("trangThai") TrangThaiNguoiDung trangThai);
}
