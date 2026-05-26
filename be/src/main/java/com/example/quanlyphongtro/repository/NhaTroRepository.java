package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.NhaTro;
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
    
    @Query("SELECT n FROM NhaTro n WHERE n.xoaLuc IS NULL AND (:isAdmin = true OR n.id IN :nhaTroIds)")
    Page<NhaTro> findAllAccessible(@Param("isAdmin") boolean isAdmin, @Param("nhaTroIds") List<UUID> nhaTroIds, Pageable pageable);
}
