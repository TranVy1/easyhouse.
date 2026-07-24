package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaiSanPhongImportPreviewResponse {
    private List<TaiSanPhongImportRow> rows;
    private int totalRows;
    private int validRows;
    private int errorRows;
}
