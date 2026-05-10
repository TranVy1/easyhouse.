package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.NhaTro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface NhaTroRepository extends JpaRepository<NhaTro, UUID> {
}
