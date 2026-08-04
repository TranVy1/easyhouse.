package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.NguoiDungVaiTro;
import com.example.quanlyphongtro.entity.NguoiDungVaiTroId;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.entity.VaiTroHeThong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface NguoiDungVaiTroRepository extends JpaRepository<NguoiDungVaiTro, NguoiDungVaiTroId> {

    @Query("SELECT ndvt FROM NguoiDungVaiTro ndvt JOIN FETCH ndvt.vaiTro WHERE ndvt.nguoiDung.id = :nguoiDungId")
    List<NguoiDungVaiTro> findByNguoiDungId(UUID nguoiDungId);

    @Query("""
            SELECT DISTINCT ndvt.nguoiDung.id
            FROM NguoiDungVaiTro ndvt
            WHERE ndvt.vaiTro.ten = :vaiTro
              AND ndvt.nguoiDung.trangThai = :trangThai
              AND ndvt.nguoiDung.xoaLuc IS NULL
            """)
    List<UUID> findNguoiDungIdsTheoVaiTroVaTrangThai(@Param("vaiTro") VaiTroHeThong vaiTro,
                                                      @Param("trangThai") TrangThaiNguoiDung trangThai);
}
