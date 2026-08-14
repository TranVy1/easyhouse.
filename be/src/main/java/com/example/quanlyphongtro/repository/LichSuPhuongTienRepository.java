package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.LichSuPhuongTien;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface LichSuPhuongTienRepository extends JpaRepository<LichSuPhuongTien, UUID> {
    Optional<LichSuPhuongTien> findFirstByPhuongTienIdAndHieuLucDenIsNullOrderByHieuLucTuDesc(UUID phuongTienId);

    @Query("""
            select ls from LichSuPhuongTien ls join fetch ls.phuongTien pt
             where ls.phong.id = :phongId and ls.hieuLucTu <= :denNgay
               and (ls.hieuLucDen is null or ls.hieuLucDen >= :tuNgay)
            """)
    List<LichSuPhuongTien> findBillableInPeriod(@Param("phongId") UUID phongId,
            @Param("tuNgay") LocalDate tuNgay, @Param("denNgay") LocalDate denNgay);
}
