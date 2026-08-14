package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface NhaTroRepository extends JpaRepository<NhaTro, UUID> {
    List<NhaTro> findByChuTroIdAndXoaLucIsNull(UUID chuTroId);
    List<NhaTro> findByXoaLucIsNullOrderByTaoLucDesc();
    Optional<NhaTro> findByIdAndXoaLucIsNull(UUID id);

    @Query("""
            SELECT n.chuTro.id
            FROM NhaTro n
            WHERE n.id = :nhaTroId
              AND n.xoaLuc IS NULL
              AND n.chuTro.xoaLuc IS NULL
              AND n.chuTro.trangThai = :trangThai
            """)
    Optional<UUID> findChuTroIdTheoTrangThai(@Param("nhaTroId") UUID nhaTroId,
                                             @Param("trangThai") TrangThaiNguoiDung trangThai);
    
    @Query("SELECT n FROM NhaTro n WHERE n.xoaLuc IS NULL AND (:isAdmin = true OR n.id IN :nhaTroIds) " +
           "AND (cast(:search as string) IS NULL OR LOWER(COALESCE(n.ten, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(n.diaChi, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(n.phuong, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')) " +
           "OR LOWER(COALESCE(n.quan, '')) LIKE LOWER(CONCAT('%', cast(:search as string), '%')))")
    Page<NhaTro> findAllAccessible(
            @Param("isAdmin") boolean isAdmin,
            @Param("nhaTroIds") List<UUID> nhaTroIds,
            @Param("search") String search,
            Pageable pageable);
}
