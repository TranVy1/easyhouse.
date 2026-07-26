package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

/**
 * Quan he chan, MOT CHIEU.
 *
 * A chan B thi B khong nhan tin duoc cho A, nhung A van nhan tin duoc cho B neu
 * muon. Day la cach Messenger/Zalo lam va dung voi y nghia "toi khong muon nhan
 * tin tu nguoi nay".
 */
@Entity
@Table(name = "chan_nguoi_dung",
        uniqueConstraints = @UniqueConstraint(
                name = "uq_chan_nguoi_dung",
                columnNames = {"nguoi_chan_id", "nguoi_bi_chan_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChanNguoiDung {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_chan_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiChan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_bi_chan_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiBiChan;

    @Column(nullable = false)
    @Builder.Default
    private ZonedDateTime taoLuc = ZonedDateTime.now();
}
