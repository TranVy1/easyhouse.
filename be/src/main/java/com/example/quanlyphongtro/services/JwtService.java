package com.example.quanlyphongtro.services;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

/**
 * JWT utility – signs access tokens (short-lived) and refresh tokens (long-lived).
 * Secret and TTLs are configured via application.properties / application-secrets.properties.
 */
@Service
public class JwtService {

    private final SecretKey key;
    private final long accessTtlMs;
    private final long refreshTtlMs;

    public JwtService(
            // FIX #4: Bỏ fallback default — app sẽ fail-fast khi khởi động nếu jwt.secret chưa được cấu hình
            // Để tạo secret an toàn: openssl rand -base64 48
            @Value("${jwt.secret}") String secret,
            @Value("${jwt.access-ttl-minutes:60}") long accessMinutes,
            @Value("${jwt.refresh-ttl-days:30}") long refreshDays) {
        if (secret == null || secret.isBlank() || secret.length() < 32) {
            throw new IllegalStateException(
                "[Security] jwt.secret phải có ít nhất 32 ký tự. " +
                "Thêm vào application-secrets.properties. " +
                "Dùng lệnh sau để sinh secret: openssl rand -base64 48"
            );
        }
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.accessTtlMs = accessMinutes * 60 * 1000;
        this.refreshTtlMs = refreshDays * 24 * 60 * 60 * 1000;
    }

    /* ---- Access Token -------------------------------------------------- */

    public String generateAccessToken(UUID userId, String email, String role) {
        return Jwts.builder()
                .subject(userId.toString())
                .claims(Map.of("email", email, "role", role))
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + accessTtlMs))
                .signWith(key)
                .compact();
    }

    /* ---- Refresh Token ------------------------------------------------- */

    public String generateRefreshToken(UUID userId) {
        return Jwts.builder()
                .subject(userId.toString())
                .id(UUID.randomUUID().toString())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + refreshTtlMs))
                .signWith(key)
                .compact();
    }

    /* ---- Validation / Parsing ------------------------------------------ */

    /**
     * Parse and validate a JWT. Returns null if the token is invalid / expired.
     */
    public Claims parseToken(String token) {
        try {
            return Jwts.parser().verifyWith(key).build()
                    .parseSignedClaims(token).getPayload();
        } catch (JwtException | IllegalArgumentException e) {
            return null;
        }
    }

    public UUID getUserId(Claims claims) {
        return UUID.fromString(claims.getSubject());
    }

    public String getEmail(Claims claims) {
        return claims.get("email", String.class);
    }

    public String getRole(Claims claims) {
        return claims.get("role", String.class);
    }

    public Date getRefreshExpiration() {
        return new Date(System.currentTimeMillis() + refreshTtlMs);
    }
}
