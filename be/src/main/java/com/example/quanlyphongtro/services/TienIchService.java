package com.example.quanlyphongtro.services;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TienIchService {

    private final JdbcTemplate jdbcTemplate;

    public List<String> listByPhong(UUID phongId) {
        if (phongId == null) return List.of();
        return jdbcTemplate.queryForList("""
                SELECT ti.ten
                FROM phong_tien_ich pti
                JOIN tien_ich ti ON ti.id = pti.tien_ich_id
                WHERE pti.phong_id = ?
                ORDER BY ti.ten
                """, String.class, phongId);
    }

    @Transactional
    public void replacePhongTienIch(UUID phongId, Collection<String> tienNghi) {
        if (phongId == null || tienNghi == null) return;

        jdbcTemplate.update("DELETE FROM phong_tien_ich WHERE phong_id = ?", phongId);
        tienNghi.stream()
                .filter(value -> value != null && !value.isBlank())
                .map(String::trim)
                .distinct()
                .forEach(ten -> {
                    UUID tienIchId = upsertTienIch(ten);
                    jdbcTemplate.update("""
                            INSERT INTO phong_tien_ich (phong_id, tien_ich_id)
                            VALUES (?, ?)
                            ON CONFLICT (phong_id, tien_ich_id) DO NOTHING
                            """, phongId, tienIchId);
                });
    }

    private UUID upsertTienIch(String ten) {
        return jdbcTemplate.queryForObject("""
                INSERT INTO tien_ich (ten)
                VALUES (?)
                ON CONFLICT (ten) DO UPDATE SET ten = EXCLUDED.ten
                RETURNING id
                """, UUID.class, ten);
    }
}
