package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.ZonedDateTime;
import java.util.UUID;

/**
 * Thanh vien cua mot cuoc tro chuyen.
 *
 * Nguoi tham gia LUON la {@link NguoiDung} (giong thong_bao_nguoi_nhan) chu khong
 * phai KhachThue, vi chu tro va nhan vien quan ly cung tham gia chat.
 */
@Entity
@Table(name = "thanh_vien_cuoc_tro_chuyen",
        uniqueConstraints = @UniqueConstraint(
                name = "uq_thanh_vien_cuoc_tro_chuyen",
                columnNames = {"cuoc_tro_chuyen_id", "nguoi_dung_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ThanhVienCuocTroChuyen {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cuoc_tro_chuyen_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private CuocTroChuyen cuocTroChuyen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private NguoiDung nguoiDung;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private VaiTroThanhVienChat vaiTro = VaiTroThanhVienChat.MEMBER;

    @Column(nullable = false)
    @Builder.Default
    private ZonedDateTime thamGiaLuc = ZonedDateTime.now();

    /**
     * Null = dang hoat dong. Khach thue het hop dong thi set roiLuc thay vi xoa row,
     * de tin nhan cu van con ngu canh nguoi gui.
     */
    private ZonedDateTime roiLuc;

    /**
     * Da doc den tin co so thu tu nay. La co so tinh so tin chua doc va trang thai
     * "da xem" ma khong can bang read-receipt rieng.
     */
    @Column(nullable = false)
    @Builder.Default
    private Long docDenSeq = 0L;

    private ZonedDateTime docDenLuc;

    /**
     * Ten hien thi rieng trong hoi thoai nay. Ai trong hoi thoai cung sua duoc va
     * moi nguoi cung thay — giong Messenger.
     *
     * Dat o day chu khong phai tren NguoiDung vi biet danh chi co nghia trong pham
     * vi mot hoi thoai.
     */
    @Column(name = "biet_danh", columnDefinition = "text")
    private String bietDanh;

    /** Tat thong bao VO THOI HAN (den khi nguoi dung tu bat lai). */
    @Column(nullable = false)
    @Builder.Default
    private Boolean tatThongBao = false;

    /**
     * Tat thong bao toi thoi diem nay.
     *
     * Tach khoi co tatThongBao thay vi dung mot cot voi gia tri "xa tit" lam moc
     * vo han: moc gia kieu do luon gay nham khi doc du lieu va khi so sanh.
     */
    private ZonedDateTime tatThongBaoDen;

    /**
     * Dang tat thong bao hay khong — CHI dung ham nay, dung doc thang tatThongBao,
     * neu khong se bo sot truong hop tat co thoi han.
     */
    public boolean dangTatThongBao() {
        if (Boolean.TRUE.equals(tatThongBao)) return true;
        return tatThongBaoDen != null && tatThongBaoDen.isAfter(ZonedDateTime.now());
    }

    /** Ghim HOI THOAI len dau danh sach cua rieng nguoi nay. */
    @Column(nullable = false)
    @Builder.Default
    private Boolean ghim = false;

    /**
     * Luu tru: an khoi danh sach nhung giu nguyen lich su, co tin moi thi hien lai.
     * Dao nguoc duoc — khac han xoa.
     */
    @Column(name = "luu_tru", nullable = false)
    @Builder.Default
    private Boolean luuTru = false;

    /**
     * "Xoa cuoc tro chuyen" kieu Messenger: chi xoa ban cua MINH.
     *
     * Ghi lai so_thu_tu lon nhat tai thoi diem xoa; tu do chi hien tin co
     * so_thu_tu > gia tri nay. Khong dong toi du lieu cua nguoi khac, va van giu
     * duoc duong truy vet cho kiem duyet.
     */
    @Column(name = "an_den_seq", nullable = false)
    @Builder.Default
    private Long anDenSeq = 0L;

    public boolean dangHoatDong() {
        return roiLuc == null;
    }
}
