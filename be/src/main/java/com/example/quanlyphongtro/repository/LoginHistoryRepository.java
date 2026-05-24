package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.LoginHistory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface LoginHistoryRepository extends JpaRepository<LoginHistory, UUID> {
    Page<LoginHistory> findByNguoiDungId(UUID nguoiDungId, Pageable pageable);
    Page<LoginHistory> findByEmail(String email, Pageable pageable);
}
