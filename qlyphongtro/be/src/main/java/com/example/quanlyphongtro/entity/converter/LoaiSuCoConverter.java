package com.example.quanlyphongtro.entity.converter;

import com.example.quanlyphongtro.entity.LoaiSuCo;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class LoaiSuCoConverter implements AttributeConverter<LoaiSuCo, String> {
    @Override
    public String convertToDatabaseColumn(LoaiSuCo attribute) {
        return attribute == null ? null : attribute.getDbValue();
    }

    @Override
    public LoaiSuCo convertToEntityAttribute(String dbData) {
        return LoaiSuCo.fromDbValue(dbData);
    }
}
