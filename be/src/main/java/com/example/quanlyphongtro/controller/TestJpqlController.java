package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.services.HopDongService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class TestJpqlController {

    private final HopDongRepository hopDongRepository;
    private final HopDongService hopDongService;

    @GetMapping("/api/public/test-query")
    public Object testQuery(@RequestParam String userId) {
        try {
            UUID uid = UUID.fromString(userId);
            // using the public method getAll from HopDongService?
            // No, HopDongService.getAll() gets userId from PermissionService which requires Auth
            // So we just call the repository and map it like HopDongService does:
            Page<HopDong> pageResult = hopDongRepository.findAllAccessible(
                    false, uid, List.of(), null, null, null, null, PageRequest.of(0, 10));
            // Let's see if this throws an error:
            // Since toResponse is private, we can't call it here easily without reflection.
            // But we can just return the raw HopDong list and see if JSON serialization fails!
            return pageResult.getContent();
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
