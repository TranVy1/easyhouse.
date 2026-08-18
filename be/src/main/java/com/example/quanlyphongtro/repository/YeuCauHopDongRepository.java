package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.LoaiYeuCauHopDong;
import com.example.quanlyphongtro.entity.TrangThaiYeuCauHopDong;
import com.example.quanlyphongtro.entity.YeuCauHopDong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface YeuCauHopDongRepository extends JpaRepository<YeuCauHopDong, UUID> {

    List<YeuCauHopDong> findByHopDongIdOrderByTaoLucDesc(UUID hopDongId);

    Optional<YeuCauHopDong> findFirstByHopDongIdAndTrangThai(UUID hopDongId, TrangThaiYeuCauHopDong trangThai);

    Optional<YeuCauHopDong> findFirstByHopDongIdAndLoaiAndTrangThai(
            UUID hopDongId, LoaiYeuCauHopDong loai, TrangThaiYeuCauHopDong trangThai);

    List<YeuCauHopDong> findByTrangThaiOrderByTaoLucDesc(TrangThaiYeuCauHopDong trangThai);

    long countByTrangThai(TrangThaiYeuCauHopDong trangThai);

    /**
     * Hang doi duyet cho chu tro: chi lay yeu cau thuoc cac toa nha ma nguoi dung
     * nay so huu. Loc ngay o tang truy van thay vi tai het roi loc trong bo nho.
     */
    @Query("""
            SELECT y FROM YeuCauHopDong y
            JOIN y.hopDong hd
            JOIN hd.phong p
            JOIN p.nhaTro nt
            WHERE y.trangThai = :trangThai
              AND nt.chuTro.id = :chuTroId
              AND hd.xoaLuc IS NULL
            ORDER BY y.taoLuc DESC
            """)
    List<YeuCauHopDong> findChoDuyetTheoChuTro(TrangThaiYeuCauHopDong trangThai, UUID chuTroId);
}
