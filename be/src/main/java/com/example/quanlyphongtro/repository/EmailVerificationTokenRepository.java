package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.EmailVerificationToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface EmailVerificationTokenRepository extends JpaRepository<EmailVerificationToken, UUID> {
    Optional<EmailVerificationToken> findByTokenAndUsedFalse(String token);
    void deleteByNguoiDungId(UUID nguoiDungId);
}
