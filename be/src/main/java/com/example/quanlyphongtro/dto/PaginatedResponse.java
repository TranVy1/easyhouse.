package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaginatedResponse<T> {
    private List<T> data;
    private long total;
    private int page;
    private int limit;
    private int totalPages;

    public static <T> PaginatedResponse<T> of(Page<T> page) {
        return PaginatedResponse.<T>builder()
                .data(page.getContent())
                .total(page.getTotalElements())
                .page(page.getNumber() + 1) // Spring page is 0-indexed, FE usually 1-indexed
                .limit(page.getSize())
                .totalPages(page.getTotalPages())
                .build();
    }

    public static <T, U> PaginatedResponse<U> of(Page<T> page, List<U> mappedData) {
        return PaginatedResponse.<U>builder()
                .data(mappedData)
                .total(page.getTotalElements())
                .page(page.getNumber() + 1)
                .limit(page.getSize())
                .totalPages(page.getTotalPages())
                .build();
    }
}
