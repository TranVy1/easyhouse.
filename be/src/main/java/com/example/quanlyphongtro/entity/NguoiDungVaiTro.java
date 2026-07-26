package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "nguoi_dung_vai_tro")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@IdClass(NguoiDungVaiTroId.class)
public class NguoiDungVaiTro {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id")
    private NguoiDung nguoiDung;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vai_tro_id")
    private VaiTro vaiTro;

    private ZonedDateTime taoLuc;
}
