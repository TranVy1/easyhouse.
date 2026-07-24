package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.NguoiDungNhaTro;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NguoiDungNhaTroRepository extends JpaRepository<NguoiDungNhaTro, UUID> {
    List<NguoiDungNhaTro> findByNguoiDungId(UUID nguoiDungId);
    Optional<NguoiDungNhaTro> findByNguoiDungIdAndNhaTroId(UUID nguoiDungId, UUID nhaTroId);

    /** Module tin nhan: nhan vien quan ly cua mot nhom nha tro, de dua vao kenh ho tro. */
    List<NguoiDungNhaTro> findByNhaTroIdIn(List<UUID> nhaTroIds);
}
