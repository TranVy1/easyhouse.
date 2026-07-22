package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.BaoCaoTinNhan;
import com.example.quanlyphongtro.entity.TrangThaiBaoCao;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface BaoCaoTinNhanRepository extends JpaRepository<BaoCaoTinNhan, UUID> {

    boolean existsByTinNhanIdAndNguoiBaoCaoId(UUID tinNhanId, UUID nguoiBaoCaoId);

    /**
     * Danh sach bao cao cho admin xu ly.
     *
     * JOIN FETCH de tranh N+1 khi dung response — moi bao cao deu can hien noi dung
     * tin va ten nguoi bao cao.
     */
    @Query(value = """
            SELECT b FROM BaoCaoTinNhan b
            JOIN FETCH b.tinNhan t
            LEFT JOIN FETCH t.nguoiGui
            JOIN FETCH b.nguoiBaoCao
            JOIN FETCH b.cuocTroChuyen
            WHERE (cast(:trangThai as string) IS NULL OR cast(b.trangThai as string) = :trangThai)
            ORDER BY b.taoLuc DESC
            """,
            countQuery = """
            SELECT COUNT(b) FROM BaoCaoTinNhan b
            WHERE (cast(:trangThai as string) IS NULL OR cast(b.trangThai as string) = :trangThai)
            """)
    Page<BaoCaoTinNhan> danhSach(@Param("trangThai") String trangThai, Pageable pageable);

    long countByTrangThai(TrangThaiBaoCao trangThai);
}
