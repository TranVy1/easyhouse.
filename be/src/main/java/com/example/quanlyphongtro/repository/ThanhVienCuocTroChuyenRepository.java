package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ThanhVienCuocTroChuyenRepository extends JpaRepository<ThanhVienCuocTroChuyen, UUID> {

    Optional<ThanhVienCuocTroChuyen> findByCuocTroChuyenIdAndNguoiDungId(UUID cuocTroChuyenId, UUID nguoiDungId);

    /**
     * Thanh vien dang hoat dong cua mot hoi thoai — day chinh la danh sach nguoi nhan
     * khi fan-out WebSocket.
     */
    @Query("""
            SELECT tv FROM ThanhVienCuocTroChuyen tv
            JOIN FETCH tv.nguoiDung
            WHERE tv.cuocTroChuyen.id = :cuocTroChuyenId AND tv.roiLuc IS NULL
            """)
    List<ThanhVienCuocTroChuyen> dangHoatDong(@Param("cuocTroChuyenId") UUID cuocTroChuyenId);

    /**
     * Nap thanh vien cua NHIEU hoi thoai trong mot query.
     * Dung khi dung danh sach hoi thoai de tranh N+1.
     */
    @Query("""
            SELECT tv FROM ThanhVienCuocTroChuyen tv
            JOIN FETCH tv.nguoiDung
            WHERE tv.cuocTroChuyen.id IN :cuocTroChuyenIds AND tv.roiLuc IS NULL
            """)
    List<ThanhVienCuocTroChuyen> dangHoatDongTheoDanhSach(@Param("cuocTroChuyenIds") List<UUID> cuocTroChuyenIds);

    /**
     * Cac nhom TU DONG (theo nha tro / theo tang) ma nguoi nay dang tham gia.
     *
     * Dung khi dong bo: so voi pham vi thue hien tai de biet phai them vao nhom nao
     * va phai cho roi nhom nao. Khong dung cho GROUP tu tao — nhom do do nguoi dung
     * tu quan ly, he thong khong duoc tu y day ai ra.
     */
    @Query("""
            SELECT tv FROM ThanhVienCuocTroChuyen tv
            JOIN FETCH tv.cuocTroChuyen c
            WHERE tv.nguoiDung.id = :nguoiDungId
              AND tv.roiLuc IS NULL
              AND c.xoaLuc IS NULL
              AND c.loai IN (com.example.quanlyphongtro.entity.LoaiCuocTroChuyen.BUILDING,
                             com.example.quanlyphongtro.entity.LoaiCuocTroChuyen.FLOOR)
            """)
    List<ThanhVienCuocTroChuyen> nhomTuDongDangThamGia(@Param("nguoiDungId") UUID nguoiDungId);

    /** Ban ghi thanh vien ke ca da roi — de tai kich hoat thay vi tao ban ghi trung. */
    @Query("""
            SELECT tv FROM ThanhVienCuocTroChuyen tv
            WHERE tv.cuocTroChuyen.id IN :cuocTroChuyenIds AND tv.nguoiDung.id = :nguoiDungId
            """)
    List<ThanhVienCuocTroChuyen> timTheoHoiThoaiVaNguoiDung(@Param("cuocTroChuyenIds") List<UUID> cuocTroChuyenIds,
                                                            @Param("nguoiDungId") UUID nguoiDungId);

    /**
     * Cac kenh SUPPORT ma nguoi dung dang thay. Dung de thu hoi quyen cua admin/
     * nhan vien khong con quan ly, nhung van giu kenh do chinh nguoi thue tao.
     */
    @Query("""
            SELECT tv FROM ThanhVienCuocTroChuyen tv
            JOIN FETCH tv.cuocTroChuyen c
            LEFT JOIN FETCH c.nguoiTao
            WHERE tv.nguoiDung.id = :nguoiDungId
              AND tv.roiLuc IS NULL
              AND c.xoaLuc IS NULL
              AND c.loai = com.example.quanlyphongtro.entity.LoaiCuocTroChuyen.SUPPORT
            """)
    List<ThanhVienCuocTroChuyen> kenhHoTroDangThamGia(@Param("nguoiDungId") UUID nguoiDungId);
}
