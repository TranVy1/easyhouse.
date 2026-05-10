package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@Table(name = "nha_tro")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NhaTro {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "chu_tro_id")
    private UUID chuTroId;

    @Column(name = "ten", nullable = false, length = 255)
    private String ten;

    @Column(name = "dia_chi", columnDefinition = "TEXT", nullable = false)
    private String diaChi;

    @Column(name = "tinh", nullable = false, length = 100)
    private String tinh;

    @Column(name = "huyen", nullable = false, length = 100)
    private String huyen;

    @Column(name = "xa", nullable = false, length = 100)
    private String xa;

    @Column(name = "mo_ta", columnDefinition = "TEXT")
    private String moTa;

    @CreationTimestamp
    @Column(name = "tao_luc", updatable = false)
    private ZonedDateTime taoLuc;

    @UpdateTimestamp
    @Column(name = "cap_nhat_luc")
    private ZonedDateTime capNhatLuc;

    @Column(name = "xoa_luc")
    private ZonedDateTime xoaLuc;
}