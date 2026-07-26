package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.TienIch;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface TienIchRepository extends JpaRepository<TienIch, UUID> {
    Optional<TienIch> findByTenIgnoreCase(String ten);
}
