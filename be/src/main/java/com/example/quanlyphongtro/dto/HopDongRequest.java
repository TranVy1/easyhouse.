package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Data
public class HopDongRequest {
    private String maHopDong;
    private UUID phongId;
    private UUID phong;
    private UUID khachThueId;    // Primary tenant / representative
    private List<UUID> khachThueIds = new ArrayList<>();
    private UUID nguoiDaiDien;
    private List<ThanhVienRequest> thanhVien = new ArrayList<>();
    @JsonIgnore
    private boolean khachThueIdsProvided;
    @JsonIgnore
    private boolean thanhVienProvided;
    private LocalDate ngayBatDau;
    private LocalDate ngayKetThuc;
    private BigDecimal giaThueHopDong;
    private BigDecimal giaThue;
    private BigDecimal tienCoc;
    private String trangThaiCoc; // NOT_PAID, KEPT, REFUNDED, DEDUCTED, FORFEITED
    private String trangThai;    // DRAFT, PENDING, ACTIVE, EXPIRED, TERMINATED, CANCELLED
    private String chuKyThanhToan;
    private Integer ngayThanhToanHangThang;
    private Integer ngayThanhToan;
    private Boolean tuDongGiaHan;
    private Integer chiSoDienBanDau;
    private Integer chiSoNuocBanDau;
    private String noiDungHopDong;
    private String dieuKhoan;
    private String filePdf;
    private String ghiChu;

    @JsonSetter("khachThueId")
    public void setKhachThueId(Object value) {
        this.khachThueIdsProvided = true;
        List<UUID> parsedIds = parseUuidList(value);
        if (!parsedIds.isEmpty()) {
            this.khachThueIds = parsedIds;
            this.khachThueId = parsedIds.get(0);
            return;
        }
        this.khachThueId = parseUuid(value);
    }

    public void setThanhVien(List<ThanhVienRequest> thanhVien) {
        this.thanhVienProvided = true;
        this.thanhVien = thanhVien != null ? thanhVien : new ArrayList<>();
    }

    @JsonIgnore
    public boolean hasMemberPayload() {
        return khachThueIdsProvided || thanhVienProvided || nguoiDaiDien != null || khachThueId != null;
    }

    @Data
    public static class ThanhVienRequest {
        private UUID khachThueId;
        private String hoTen;
        private String soCccd;
        private String soDienThoai;
        private LocalDate ngayVao;
        private LocalDate ngayRoi;
        private Boolean dangO;
        private Boolean laNguoiDaiDien;
        private String ghiChu;
    }

    private List<UUID> parseUuidList(Object value) {
        List<UUID> ids = new ArrayList<>();
        if (value instanceof Iterable<?> iterable) {
            for (Object item : iterable) {
                UUID id = parseUuid(item);
                if (id != null && !ids.contains(id)) ids.add(id);
            }
        }
        return ids;
    }

    private UUID parseUuid(Object value) {
        if (value == null) return null;
        if (value instanceof UUID uuid) return uuid;
        if (value instanceof Map<?, ?> map) {
            Object idValue = map.get("_id") != null ? map.get("_id") : map.get("id");
            return parseUuid(idValue);
        }
        try {
            String raw = value.toString();
            return raw.isBlank() ? null : UUID.fromString(raw);
        } catch (Exception e) {
            return null;
        }
    }
}
