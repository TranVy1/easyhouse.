package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThongBao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface ThongBaoRepository extends JpaRepository<ThongBao, UUID> {
    List<ThongBao> findAllByOrderByTaoLucDesc();
    List<ThongBao> findByNguoiGuiIdOrderByTaoLucDesc(UUID nguoiGuiId);
    List<ThongBao> findByXoaLucIsNullOrderByTaoLucDesc();
    Page<ThongBao> findByXoaLucIsNullOrderByTaoLucDesc(Pageable pageable);

    @Query("SELECT t FROM ThongBao t WHERE t.xoaLuc IS NULL AND (t.guiTatCa = true OR t.id IN :ids) ORDER BY t.taoLuc DESC")
    Page<ThongBao> findMyThongBao(@Param("ids") List<UUID> ids, Pageable pageable);

    @Query("SELECT t FROM ThongBao t WHERE t.xoaLuc IS NULL AND t.guiTatCa = true ORDER BY t.taoLuc DESC")
    Page<ThongBao> findMyThongBaoGuiTatCa(Pageable pageable);

    @Query("""
        SELECT COUNT(t) FROM ThongBao t 
        WHERE t.xoaLuc IS NULL AND t.guiTatCa = true 
        AND NOT EXISTS (
            SELECT 1 FROM ThongBaoNguoiNhan tn 
            WHERE tn.thongBao = t AND tn.nguoiDung.id = :userId
        )
    """)
    long countUnreadGuiTatCa(@Param("userId") UUID userId);
}
