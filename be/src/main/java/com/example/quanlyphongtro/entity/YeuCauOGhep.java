package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "yeu_cau_o_ghep")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class YeuCauOGhep {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_thue_id", nullable = false)
    private KhachThue khachThue; // Khách hàng nộp yêu cầu

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hop_dong_id", nullable = false)
    private HopDong hopDong; // Hợp đồng muốn tham gia

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrangThaiYeuCauOGhep trangThai = TrangThaiYeuCauOGhep.PENDING_TENANT;

    private String loiNhan; // Lời nhắn gửi chủ trọ / khách đại diện
    
    private String ghiChuTuChoi;

    @Column(nullable = false)
    private ZonedDateTime taoLuc;

    private ZonedDateTime capNhatLuc;
}
