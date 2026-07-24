package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "vai_tro")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VaiTro {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, unique = true)
    private VaiTroHeThong ten;

    private String moTa;

    private ZonedDateTime taoLuc;
}
