package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.VaiTro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface VaiTroRepository extends JpaRepository<VaiTro, UUID> {
    Optional<VaiTro> findByTen(String ten);
}
