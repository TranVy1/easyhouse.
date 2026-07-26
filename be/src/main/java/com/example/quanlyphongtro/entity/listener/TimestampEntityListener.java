package com.example.quanlyphongtro.entity.listener;

import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;

import java.lang.reflect.Field;
import java.time.ZonedDateTime;

public class TimestampEntityListener {

    @PrePersist
    public void prePersist(Object entity) {
        ZonedDateTime now = ZonedDateTime.now();
        setIfNull(entity, "taoLuc", now);
        setIfNull(entity, "capNhatLuc", now);
        setIfNull(entity, "createdAt", now);
        setIfNull(entity, "updatedAt", now);
        setIfNull(entity, "ngayLapHoaDon", now);
        setIfNull(entity, "ngayThanhToan", now);
        setIfNull(entity, "guiLuc", now);
    }

    @PreUpdate
    public void preUpdate(Object entity) {
        ZonedDateTime now = ZonedDateTime.now();
        set(entity, "capNhatLuc", now);
        set(entity, "updatedAt", now);
    }

    private void setIfNull(Object target, String fieldName, ZonedDateTime value) {
        Field field = findField(target.getClass(), fieldName);
        if (field == null) {
            return;
        }
        try {
            field.setAccessible(true);
            if (field.get(target) == null) {
                field.set(target, value);
            }
        } catch (IllegalAccessException ignored) {
            // Entity lifecycle should not fail because an optional timestamp is absent.
        }
    }

    private void set(Object target, String fieldName, ZonedDateTime value) {
        Field field = findField(target.getClass(), fieldName);
        if (field == null) {
            return;
        }
        try {
            field.setAccessible(true);
            field.set(target, value);
        } catch (IllegalAccessException ignored) {
            // Entity lifecycle should not fail because an optional timestamp is absent.
        }
    }

    private Field findField(Class<?> type, String fieldName) {
        Class<?> current = type;
        while (current != null && current != Object.class) {
            try {
                return current.getDeclaredField(fieldName);
            } catch (NoSuchFieldException ignored) {
                current = current.getSuperclass();
            }
        }
        return null;
    }
}
