package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.TinNhan;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface TinNhanRepository extends JpaRepository<TinNhan, UUID> {

    /**
     * Lich su tin nhan, cuon nguoc ve qua khu.
     *
     * {@code truocSeq} luon khac null: service truyen {@link Long#MAX_VALUE} khi muon
     * lay tu tin moi nhat. Lam vay de tranh tham so null khong ro kieu trong HQL.
     */
    @Query("""
            SELECT m FROM TinNhan m
            LEFT JOIN FETCH m.nguoiGui
            LEFT JOIN FETCH m.fileMedia
            LEFT JOIN FETCH m.nguoiGhim
            WHERE m.cuocTroChuyen.id = :cuocTroChuyenId
              AND m.xoaLuc IS NULL
              AND m.soThuTu < :truocSeq
              AND m.soThuTu > :anDenSeq
            ORDER BY m.soThuTu DESC
            """)
    List<TinNhan> lichSu(@Param("cuocTroChuyenId") UUID cuocTroChuyenId,
                         @Param("truocSeq") long truocSeq,
                         @Param("anDenSeq") long anDenSeq,
                         Pageable pageable);

    /**
     * Tin moi hon mot moc so thu tu.
     *
     * Dung khi noi lai WebSocket (bu phan da lo), khi client phat hien lo hong seq,
     * va lam duong lui polling neu WebSocket khong noi duoc.
     */
    @Query("""
            SELECT m FROM TinNhan m
            LEFT JOIN FETCH m.nguoiGui
            LEFT JOIN FETCH m.fileMedia
            LEFT JOIN FETCH m.nguoiGhim
            WHERE m.cuocTroChuyen.id = :cuocTroChuyenId
              AND m.xoaLuc IS NULL
              AND m.soThuTu > :sauSeq
              AND m.soThuTu > :anDenSeq
            ORDER BY m.soThuTu ASC
            """)
    List<TinNhan> delta(@Param("cuocTroChuyenId") UUID cuocTroChuyenId,
                        @Param("sauSeq") long sauSeq,
                        @Param("anDenSeq") long anDenSeq,
                        Pageable pageable);

    /**
     * Tin dang duoc ghim trong hoi thoai — pham vi ca phong, khong rieng ai.
     * Dung index tung phan idx_tin_nhan_ghim.
     *
     * Van loc theo anDenSeq: nguoi da xoa ban cua minh thi khong nen thay lai tin cu
     * qua bang ghim.
     */
    @Query("""
            SELECT m FROM TinNhan m
            LEFT JOIN FETCH m.nguoiGui
            LEFT JOIN FETCH m.fileMedia
            LEFT JOIN FETCH m.nguoiGhim
            WHERE m.cuocTroChuyen.id = :cuocTroChuyenId
              AND m.ghimLuc IS NOT NULL
              AND m.xoaLuc IS NULL
              AND m.soThuTu > :anDenSeq
            ORDER BY m.ghimLuc DESC
            """)
    List<TinNhan> dangGhim(@Param("cuocTroChuyenId") UUID cuocTroChuyenId,
                           @Param("anDenSeq") long anDenSeq);

    /** Dem tin dang ghim de chan vuot gioi han. */
    long countByCuocTroChuyenIdAndGhimLucIsNotNullAndXoaLucIsNull(UUID cuocTroChuyenId);

    /** So thu tu lon nhat cua hoi thoai — dung lam moc khi xoa ban cua minh. */
    @Query("SELECT COALESCE(MAX(m.soThuTu), 0) FROM TinNhan m WHERE m.cuocTroChuyen.id = :cuocTroChuyenId")
    long seqLonNhat(@Param("cuocTroChuyenId") UUID cuocTroChuyenId);

    /** Idempotency: tra lai tin cu khi client retry cung maClient. */
    Optional<TinNhan> findByCuocTroChuyenIdAndMaClient(UUID cuocTroChuyenId, String maClient);

    /**
     * Tong so tin chua doc cua mot nguoi dung, tinh tren toan bo hoi thoai.
     * Mot query duy nhat — phuc vu badge nen duoc goi rat thuong xuyen.
     */
    @Query("""
            SELECT COUNT(m) FROM TinNhan m
            JOIN ThanhVienCuocTroChuyen tv ON tv.cuocTroChuyen = m.cuocTroChuyen
            WHERE tv.nguoiDung.id = :nguoiDungId
              AND tv.roiLuc IS NULL
              AND m.xoaLuc IS NULL
              AND m.soThuTu > tv.docDenSeq
              AND (m.nguoiGui IS NULL OR m.nguoiGui.id <> :nguoiDungId)
            """)
    long demTongChuaDoc(@Param("nguoiDungId") UUID nguoiDungId);

    /**
     * So tin chua doc theo tung hoi thoai, gop trong MOT query.
     * Tranh lap lai bug N+1 cua ThongBaoService khi dung danh sach hoi thoai.
     *
     * @return moi phan tu la {@code [cuocTroChuyenId (UUID), soTinChuaDoc (Long)]}
     */
    @Query("""
            SELECT m.cuocTroChuyen.id, COUNT(m) FROM TinNhan m
            JOIN ThanhVienCuocTroChuyen tv ON tv.cuocTroChuyen = m.cuocTroChuyen
            WHERE tv.nguoiDung.id = :nguoiDungId
              AND tv.roiLuc IS NULL
              AND m.cuocTroChuyen.id IN :cuocTroChuyenIds
              AND m.xoaLuc IS NULL
              AND m.soThuTu > tv.docDenSeq
              AND (m.nguoiGui IS NULL OR m.nguoiGui.id <> :nguoiDungId)
            GROUP BY m.cuocTroChuyen.id
            """)
    List<Object[]> demChuaDocTheoHoiThoai(@Param("nguoiDungId") UUID nguoiDungId,
                                          @Param("cuocTroChuyenIds") List<UUID> cuocTroChuyenIds);

    /**
     * Tim kiem noi dung tin nhan, KHONG phan biet dau va chu hoa/thuong.
     *
     * Dung native query chu khong phai JPQL vi can goi ham f_khong_dau() — chinh
     * ham duoc danh chi muc trigram trong migration 20260722_add_chat_search.sql.
     * Viet khac di mot chut la PostgreSQL se khong dung duoc index va quay ve quet
     * tuan tu toan bang.
     *
     * PHAM VI QUYEN nam ngay trong menh de JOIN, khong phai loc o tang tren: chi
     * tin thuoc hoi thoai ma nguoi goi dang la thanh vien moi lot qua. Doan dung
     * tu khoa cung khong the doc trom hoi thoai minh khong tham gia.
     *
     * Bo qua tin he thong ("A da tham gia nhom") vi do la nhieu, khong phai noi dung
     * nguoi dung viet ra.
     */
    @Query(value = """
            SELECT m.* FROM tin_nhan m
            JOIN thanh_vien_cuoc_tro_chuyen tv
              ON tv.cuoc_tro_chuyen_id = m.cuoc_tro_chuyen_id
             AND tv.nguoi_dung_id = :nguoiDungId
             AND tv.roi_luc IS NULL
            WHERE m.xoa_luc IS NULL
              AND m.so_thu_tu > tv.an_den_seq
              AND m.da_thu_hoi = false
              AND m.noi_dung IS NOT NULL
              AND m.loai <> 'SYSTEM'
              AND (CAST(:hoiThoaiId AS text) IS NULL
                   OR m.cuoc_tro_chuyen_id = CAST(:hoiThoaiId AS uuid))
              AND f_khong_dau(m.noi_dung) LIKE '%' || f_khong_dau(CAST(:tuKhoa AS text)) || '%'
            ORDER BY m.so_thu_tu DESC
            """,
            countQuery = """
            SELECT COUNT(*) FROM tin_nhan m
            JOIN thanh_vien_cuoc_tro_chuyen tv
              ON tv.cuoc_tro_chuyen_id = m.cuoc_tro_chuyen_id
             AND tv.nguoi_dung_id = :nguoiDungId
             AND tv.roi_luc IS NULL
            WHERE m.xoa_luc IS NULL
              AND m.so_thu_tu > tv.an_den_seq
              AND m.da_thu_hoi = false
              AND m.noi_dung IS NOT NULL
              AND m.loai <> 'SYSTEM'
              AND (CAST(:hoiThoaiId AS text) IS NULL
                   OR m.cuoc_tro_chuyen_id = CAST(:hoiThoaiId AS uuid))
              AND f_khong_dau(m.noi_dung) LIKE '%' || f_khong_dau(CAST(:tuKhoa AS text)) || '%'
            """,
            nativeQuery = true)
    Page<TinNhan> timKiem(@Param("nguoiDungId") UUID nguoiDungId,
                          @Param("tuKhoa") String tuKhoa,
                          @Param("hoiThoaiId") String hoiThoaiId,
                          Pageable pageable);

    /**
     * Tin co tep dinh kem, loc theo loai (IMAGE hoac FILE) — phuc vu tab Anh/Tep.
     * Dung index tung phan idx_tin_nhan_dinh_kem.
     */
    @Query("""
            SELECT m FROM TinNhan m
            LEFT JOIN FETCH m.nguoiGui
            LEFT JOIN FETCH m.fileMedia
            WHERE m.cuocTroChuyen.id = :cuocTroChuyenId
              AND m.fileMedia IS NOT NULL
              AND m.xoaLuc IS NULL
              AND m.daThuHoi = false
              AND m.loai = :loai
              AND m.soThuTu > :anDenSeq
            ORDER BY m.soThuTu DESC
            """)
    Page<TinNhan> tepDinhKem(@Param("cuocTroChuyenId") UUID cuocTroChuyenId,
                             @Param("loai") com.example.quanlyphongtro.entity.LoaiTinNhan loai,
                             @Param("anDenSeq") long anDenSeq,
                             Pageable pageable);

    /**
     * Tin co chua duong dan http(s) — SQL chi LOC THO, viec trich tung URL de o
     * tang Java vi mot tin co the chua nhieu URL va regex trich xuat viet trong
     * SQL vua kho doc vua khong test duoc.
     */
    @Query(value = """
            SELECT m.* FROM tin_nhan m
            WHERE m.cuoc_tro_chuyen_id = :cuocTroChuyenId
              AND m.noi_dung IS NOT NULL
              AND m.xoa_luc IS NULL
              AND m.da_thu_hoi = false
              AND m.so_thu_tu > :anDenSeq
              AND m.noi_dung ~* 'https?://'
            ORDER BY m.so_thu_tu DESC
            """,
            countQuery = """
            SELECT COUNT(*) FROM tin_nhan m
            WHERE m.cuoc_tro_chuyen_id = :cuocTroChuyenId
              AND m.noi_dung IS NOT NULL
              AND m.xoa_luc IS NULL
              AND m.da_thu_hoi = false
              AND m.so_thu_tu > :anDenSeq
              AND m.noi_dung ~* 'https?://'
            """,
            nativeQuery = true)
    Page<TinNhan> tinCoLienKet(@Param("cuocTroChuyenId") UUID cuocTroChuyenId,
                               @Param("anDenSeq") long anDenSeq,
                               Pageable pageable);
}
