package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.CuocTroChuyen;
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
public interface CuocTroChuyenRepository extends JpaRepository<CuocTroChuyen, UUID> {

    Optional<CuocTroChuyen> findByIdAndXoaLucIsNull(UUID id);

    /** Tra cuu theo khoa chong trung truoc khi tao moi. */
    Optional<CuocTroChuyen> findByKhoaDuyNhatAndXoaLucIsNull(String khoaDuyNhat);

    /**
     * Danh sach hoi thoai cua mot nguoi dung.
     *
     * Sap xep: ghim len dau, roi den hoi thoai co tin moi nhat. Dung COALESCE thay vi
     * NULLS LAST de hanh vi giong nhau giua PostgreSQL (that) va H2 (test).
     *
     * Truyen Pageable KHONG kem sort, neu khong Spring se noi them ORDER BY va ghi de
     * thu tu o day.
     *
     * Hai bo loc cua P8:
     * - {@code luuTru}: false = danh sach thuong, true = xem muc da luu tru.
     * - {@code tv.anDenSeq}: nguoi da "xoa" hoi thoai thi khong thay no nua CHO TOI KHI
     *   co tin moi hon moc da xoa — dung hanh vi cua Messenger. Dieu kien
     *   {@code tv.anDenSeq = 0} dat truoc de tuyet dai da so truong hop (chua bao gio
     *   xoa) khong phai chay subquery.
     */
    @Query(value = """
            SELECT c FROM CuocTroChuyen c
            JOIN ThanhVienCuocTroChuyen tv ON tv.cuocTroChuyen = c
            WHERE tv.nguoiDung.id = :nguoiDungId
              AND tv.roiLuc IS NULL
              AND c.xoaLuc IS NULL
              AND tv.luuTru = :luuTru
              AND (cast(:loai as string) IS NULL OR cast(c.loai as string) = :loai)
              AND (tv.anDenSeq = 0 OR EXISTS (
                    SELECT 1 FROM TinNhan m
                    WHERE m.cuocTroChuyen = c AND m.xoaLuc IS NULL AND m.soThuTu > tv.anDenSeq))
            ORDER BY tv.ghim DESC, COALESCE(c.tinNhanCuoiLuc, c.taoLuc) DESC
            """,
            countQuery = """
            SELECT COUNT(c) FROM CuocTroChuyen c
            JOIN ThanhVienCuocTroChuyen tv ON tv.cuocTroChuyen = c
            WHERE tv.nguoiDung.id = :nguoiDungId
              AND tv.roiLuc IS NULL
              AND c.xoaLuc IS NULL
              AND tv.luuTru = :luuTru
              AND (cast(:loai as string) IS NULL OR cast(c.loai as string) = :loai)
              AND (tv.anDenSeq = 0 OR EXISTS (
                    SELECT 1 FROM TinNhan m
                    WHERE m.cuocTroChuyen = c AND m.xoaLuc IS NULL AND m.soThuTu > tv.anDenSeq))
            """)
    Page<CuocTroChuyen> danhSachCuaToi(@Param("nguoiDungId") UUID nguoiDungId,
                                       @Param("loai") String loai,
                                       @Param("luuTru") boolean luuTru,
                                       Pageable pageable);

    /** Nap hang loat theo khoa chong trung — dung khi dong bo nhieu nhom mot luc. */
    List<CuocTroChuyen> findByKhoaDuyNhatInAndXoaLucIsNull(List<String> khoaDuyNhats);
}
