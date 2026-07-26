package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.CauHinhGia;
import com.example.quanlyphongtro.entity.LoaiMucHoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

@Repository
public interface CauHinhGiaRepository extends JpaRepository<CauHinhGia, UUID>, JpaSpecificationExecutor<CauHinhGia> {
    List<CauHinhGia> findByNhaTroIdOrderByHieuLucTuDesc(UUID nhaTroId);

    List<CauHinhGia> findByNhaTroIdAndLoaiAndDangApDungTrueOrderByHieuLucTuDesc(UUID nhaTroId, LoaiMucHoaDon loai);

    @Query("""
            select c
            from CauHinhGia c
            where (:nhaTroId is null or c.nhaTro.id = :nhaTroId)
              and (:loai is null or c.loai = :loai)
              and (:dangApDung is null or c.dangApDung = :dangApDung)
            order by c.nhaTro.ten asc, c.loai asc, c.hieuLucTu desc
            """)
    List<CauHinhGia> search(
            @Param("nhaTroId") UUID nhaTroId,
            @Param("loai") LoaiMucHoaDon loai,
            @Param("dangApDung") Boolean dangApDung
    );

    @Query("""
            select c
            from CauHinhGia c
            where c.nhaTro.id = :nhaTroId
              and c.loai = :loai
              and c.dangApDung = true
              and c.hieuLucTu <= :ngayApDung
              and (c.hieuLucDen is null or c.hieuLucDen >= :ngayApDung)
            order by c.hieuLucTu desc
            """)
    List<CauHinhGia> findApplicable(
            @Param("nhaTroId") UUID nhaTroId,
            @Param("loai") LoaiMucHoaDon loai,
            @Param("ngayApDung") LocalDate ngayApDung
    );

    @Query("""
            select c
            from CauHinhGia c
            where c.nhaTro.id = :nhaTroId
              and c.dichVuId is not null
              and c.dangApDung = true
              and c.hieuLucTu <= :ngayApDung
              and (c.hieuLucDen is null or c.hieuLucDen >= :ngayApDung)
            order by c.tenHienThi asc, c.hieuLucTu desc
            """)
    List<CauHinhGia> findApplicableServices(
            @Param("nhaTroId") UUID nhaTroId,
            @Param("ngayApDung") LocalDate ngayApDung
    );

    boolean existsByDichVuId(UUID dichVuId);
}
