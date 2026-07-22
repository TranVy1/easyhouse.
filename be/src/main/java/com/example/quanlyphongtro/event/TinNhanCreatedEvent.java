package com.example.quanlyphongtro.event;

import com.example.quanlyphongtro.dto.TinNhanResponse;

import java.util.List;
import java.util.UUID;

/**
 * Mot tin nhan vua duoc ghi vao DB.
 *
 * Su kien mang theo DTO da dung san va danh sach id nguoi nhan, KHONG mang entity.
 * Ly do: listener chay sau khi transaction da commit, luc do entity co the da bi
 * detach — cham vao quan he lazy se nem LazyInitializationException.
 */
public record TinNhanCreatedEvent(TinNhanResponse tinNhan, List<UUID> nguoiNhanIds) {
}
