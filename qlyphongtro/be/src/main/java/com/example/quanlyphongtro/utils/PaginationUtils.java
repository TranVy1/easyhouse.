package com.example.quanlyphongtro.utils;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

public class PaginationUtils {
    
    public static Pageable createPageable(int page, int limit, String sortStr) {
        int pageIndex = page > 0 ? page - 1 : 0;
        
        if (sortStr == null || sortStr.isEmpty()) {
            return PageRequest.of(pageIndex, limit);
        }
        
        String[] parts = sortStr.split(",");
        String property = parts[0];
        Sort.Direction direction = Sort.Direction.ASC;
        
        if (parts.length > 1 && parts[1].equalsIgnoreCase("desc")) {
            direction = Sort.Direction.DESC;
        }
        
        return PageRequest.of(pageIndex, limit, Sort.by(direction, property));
    }
}
