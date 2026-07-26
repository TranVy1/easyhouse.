package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "tien_ich")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TienIch {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private String ten;

    private String bieuTuong;

    @Column(name = "tao_luc")
    private ZonedDateTime taoLuc;
}
