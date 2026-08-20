package com.example.quanlyphongtro.services;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.example.quanlyphongtro.dto.PaginatedResponse;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TienIchService {

    private final JdbcTemplate jdbcTemplate;
    private final com.example.quanlyphongtro.repository.TienIchRepository tienIchRepository;

    public PaginatedResponse<com.example.quanlyphongtro.dto.TienIchResponse> getAll(Pageable pageable) {
        Page<com.example.quanlyphongtro.entity.TienIch> page = tienIchRepository.findAll(pageable);
        List<com.example.quanlyphongtro.dto.TienIchResponse> data = page.getContent().stream()
                .map(com.example.quanlyphongtro.dto.TienIchResponse::fromEntity)
                .collect(java.util.stream.Collectors.toList());
        return PaginatedResponse.of(page, data);
    }

    public com.example.quanlyphongtro.dto.TienIchResponse getById(UUID id) {
        com.example.quanlyphongtro.entity.TienIch tienIch = tienIchRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tiện ích"));
        return com.example.quanlyphongtro.dto.TienIchResponse.fromEntity(tienIch);
    }

    @Transactional
    public com.example.quanlyphongtro.dto.TienIchResponse create(com.example.quanlyphongtro.dto.TienIchRequest req) {
        com.example.quanlyphongtro.entity.TienIch tienIch = new com.example.quanlyphongtro.entity.TienIch();
        tienIch.setTen(req.getTen());
        tienIch.setBieuTuong(req.getBieuTuong());
        return com.example.quanlyphongtro.dto.TienIchResponse.fromEntity(tienIchRepository.save(tienIch));
    }

    @Transactional
    public com.example.quanlyphongtro.dto.TienIchResponse update(UUID id, com.example.quanlyphongtro.dto.TienIchRequest req) {
        com.example.quanlyphongtro.entity.TienIch tienIch = tienIchRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tiện ích"));
        tienIch.setTen(req.getTen());
        tienIch.setBieuTuong(req.getBieuTuong());
        return com.example.quanlyphongtro.dto.TienIchResponse.fromEntity(tienIchRepository.save(tienIch));
    }

    @Transactional
    public void delete(UUID id) {
        tienIchRepository.deleteById(id);
    }

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

    public java.util.Map<UUID, List<String>> batchListByPhong(List<UUID> phongIds) {
        if (phongIds == null || phongIds.isEmpty()) return java.util.Collections.emptyMap();
        
        String inSql = String.join(",", java.util.Collections.nCopies(phongIds.size(), "?"));
        List<java.util.Map<String, Object>> results = jdbcTemplate.queryForList(
                "SELECT pti.phong_id, ti.ten FROM phong_tien_ich pti " +
                "JOIN tien_ich ti ON ti.id = pti.tien_ich_id " +
                "WHERE pti.phong_id IN (" + inSql + ") ORDER BY ti.ten",
                phongIds.toArray()
        );
        
        java.util.Map<UUID, List<String>> map = new java.util.HashMap<>();
        for (java.util.Map<String, Object> row : results) {
            UUID pId = (UUID) row.get("phong_id");
            String ten = (String) row.get("ten");
            map.computeIfAbsent(pId, k -> new java.util.ArrayList<>()).add(ten);
        }
        return map;
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

    @Transactional
    public void assignTienIchToRooms(List<UUID> phongIds, Collection<String> tienNghi) {
        if (phongIds == null || phongIds.isEmpty() || tienNghi == null || tienNghi.isEmpty()) return;

        List<UUID> tienIchIds = tienNghi.stream()
                .filter(value -> value != null && !value.isBlank())
                .map(String::trim)
                .distinct()
                .map(this::upsertTienIch)
                .toList();

        if (tienIchIds.isEmpty()) return;

        List<Object[]> batchArgs = new java.util.ArrayList<>();
        for (UUID phongId : phongIds) {
            for (UUID tienIchId : tienIchIds) {
                batchArgs.add(new Object[]{phongId, tienIchId});
            }
        }

        jdbcTemplate.batchUpdate("""
                INSERT INTO phong_tien_ich (phong_id, tien_ich_id)
                VALUES (?, ?)
                ON CONFLICT (phong_id, tien_ich_id) DO NOTHING
                """, batchArgs);
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
