package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.NguoiDungVaiTro;
import com.example.quanlyphongtro.entity.NguoiDungVaiTroId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface NguoiDungVaiTroRepository extends JpaRepository<NguoiDungVaiTro, NguoiDungVaiTroId> {

    @Query("SELECT ndvt FROM NguoiDungVaiTro ndvt JOIN FETCH ndvt.vaiTro WHERE ndvt.nguoiDung.id = :nguoiDungId")
    List<NguoiDungVaiTro> findByNguoiDungId(UUID nguoiDungId);
}
