package com.example.quanlyphongtro.util;

import com.example.quanlyphongtro.dto.PaginatedResponse;
import java.util.List;

public class PaginationUtils {
    
    public static <T> PaginatedResponse<T> paginate(List<T> list) {
        if (list == null) return null;
        return PaginatedResponse.<T>builder()
                .data(list)
                .total(list.size())
                .page(1)
                .limit(list.size() > 0 ? list.size() : 10)
                .totalPages(1)
                .build();
    }
}
