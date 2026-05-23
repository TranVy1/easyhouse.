package com.example.quanlyphongtro.entity.converter;

import com.example.quanlyphongtro.entity.UuTien;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class UuTienConverter implements AttributeConverter<UuTien, String> {
    @Override
    public String convertToDatabaseColumn(UuTien attribute) {
        return attribute == null ? null : attribute.getDbValue();
    }

    @Override
    public UuTien convertToEntityAttribute(String dbData) {
        return UuTien.fromDbValue(dbData);
    }
}
