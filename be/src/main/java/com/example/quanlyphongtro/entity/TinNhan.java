package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Generated;
import org.hibernate.generator.EventType;

import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "tin_nhan")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TinNhan {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /**
     * So thu tu toan cuc, don dieu tang, do PostgreSQL cap phat (cot bigserial).
     *
     * Dung lam cursor phan trang, lam moc delta khi noi lai WebSocket, va de client
     * phat hien da lo mat tin (nhan seq 7 khi dang o seq 5 => goi bu).
     *
     * KHONG dung timestamp cho viec nay: hai tin gui cung mili giay se sai thu tu.
     */
    @Generated(event = EventType.INSERT)
    @Column(name = "so_thu_tu", insertable = false, updatable = false, columnDefinition = "bigserial")
    private Long soThuTu;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cuoc_tro_chuyen_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private CuocTroChuyen cuocTroChuyen;

    /** Null = tin he thong. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_gui_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiGui;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private LoaiTinNhan loai = LoaiTinNhan.TEXT;

    @Column(name = "noi_dung", columnDefinition = "text")
    private String noiDung;

    /** Tai dung luong upload Cloudinary san co thay vi lam duong upload rieng. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "file_media_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private FileMedia fileMedia;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tra_loi_cho_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private TinNhan traLoiCho;

    /**
     * Khoa chong gui trung do client sinh. Khi mang chap chon, client retry cung
     * maClient thi server tra lai dung tin cu thay vi tao tin thu hai.
     */
    @Column(name = "ma_client")
    private String maClient;

    @Column(nullable = false)
    @Builder.Default
    private Boolean daThuHoi = false;

    /**
     * Ghim tin — pham vi CA HOI THOAI, moi thanh vien cung nhin thay (giong
     * Messenger/Zalo). Khac han `ThanhVienCuocTroChuyen.ghim` la ghim HOI THOAI
     * trong danh sach cua rieng tung nguoi.
     */
    @Column(name = "ghim_luc")
    private ZonedDateTime ghimLuc;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_ghim_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiGhim;

    /** Tin goc neu day la ban chuyen tiep — de truy vet khi kiem duyet (P6). */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chuyen_tiep_tu_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private TinNhan chuyenTiepTu;

    public boolean dangGhim() {
        return ghimLuc != null;
    }

    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;
    private ZonedDateTime xoaLuc;
}
