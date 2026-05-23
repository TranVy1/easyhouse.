package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.DichVuResponse;
import com.example.quanlyphongtro.repository.DichVuRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DichVuService {

    private final DichVuRepository dichVuRepository;

    public List<DichVuResponse> getAll() {
        return dichVuRepository.findAll().stream()
                .map(DichVuResponse::fromEntity)
                .collect(Collectors.toList());
    }
}
