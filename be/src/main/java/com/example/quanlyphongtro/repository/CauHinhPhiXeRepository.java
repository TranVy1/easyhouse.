package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.CauHinhPhiXe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface CauHinhPhiXeRepository extends JpaRepository<CauHinhPhiXe, UUID> {
    @Query("""
            select p from CauHinhPhiXe p where p.nhaTro.id = :nhaTroId
              and (cast(:loaiXe as string) is null or lower(p.loaiXe) = lower(cast(:loaiXe as string)))
            order by lower(p.loaiXe), p.hieuLucTu desc
            """)
    List<CauHinhPhiXe> findAllForNhaTro(@Param("nhaTroId") UUID nhaTroId, @Param("loaiXe") String loaiXe);

    @Query("""
            select p from CauHinhPhiXe p where p.nhaTro.id = :nhaTroId
              and lower(p.loaiXe) = lower(cast(:loaiXe as string)) and p.dangApDung = true
              and p.hieuLucTu <= :denNgay and (p.hieuLucDen is null or p.hieuLucDen >= :tuNgay)
            order by p.hieuLucTu asc
            """)
    List<CauHinhPhiXe> findEffectiveInPeriod(@Param("nhaTroId") UUID nhaTroId, @Param("loaiXe") String loaiXe,
            @Param("tuNgay") LocalDate tuNgay, @Param("denNgay") LocalDate denNgay);

    @Query("""
            select p from CauHinhPhiXe p where p.nhaTro.id = :nhaTroId
              and lower(p.loaiXe) = lower(cast(:loaiXe as string)) and p.dangApDung = true
              and p.hieuLucTu <= :ngay and (p.hieuLucDen is null or p.hieuLucDen >= :ngay)
            order by p.hieuLucTu desc
            """)
    List<CauHinhPhiXe> findApplicable(@Param("nhaTroId") UUID nhaTroId, @Param("loaiXe") String loaiXe, @Param("ngay") LocalDate ngay);
}
