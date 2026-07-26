package com.example.quanlyphongtro.entity;

public enum TrangThaiYeuCauOGhep {
    PENDING_TENANT, // Chờ khách thuê (đại diện phòng) duyệt
    PENDING_ADMIN,  // Chờ chủ trọ duyệt
    APPROVED,       // Đã duyệt (Được thêm vào phòng)
    REJECTED        // Bị từ chối
}
