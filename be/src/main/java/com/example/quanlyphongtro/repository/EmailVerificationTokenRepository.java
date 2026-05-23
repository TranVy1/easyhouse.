package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.EmailVerificationToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface EmailVerificationTokenRepository extends JpaRepository<EmailVerificationToken, UUID> {
    Optional<EmailVerificationToken> findByToken(String token);

    @Modifying
    @Query("DELETE FROM EmailVerificationToken e WHERE e.nguoiDung.id = :userId")
    void deleteByNguoiDungId(UUID userId);

    @Modifying
    @Query("DELETE FROM EmailVerificationToken e WHERE e.ngayHetHan < CURRENT_TIMESTAMP")
    void deleteExpired();
}
