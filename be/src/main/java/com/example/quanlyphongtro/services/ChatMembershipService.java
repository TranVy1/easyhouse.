package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.Tang;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.repository.CuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.TangRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Dong bo thanh vien cho cac nhom TU DONG: nhom theo nha tro (BUILDING) va nhom
 * theo tang (FLOOR).
 *
 * Vi sao khong moc vao HopDongService:
 * hop dong la vung nghiep vu rui ro cao (tien coc, hoa don, doi phong). Chen them
 * loi goi dong bo chat vao do la them mot duong hong cho mot tinh nang phu. Thay
 * vao do dung hai lop tu chua lanh:
 *
 *   1. LAZY  — moi lan nguoi dung mo danh sach hoi thoai thi doi chieu lai pham vi
 *              thue cua chinh ho. Vao o thi thay nhom, tra phong thi roi nhom.
 *   2. DINH KY — job hang ngay doi soat toan bo, xu ly nhung nguoi khong bao gio
 *              mo chat nen lop LAZY khong cham toi.
 *
 * Ca hai deu la phep "so sanh rồi sua cho khop", chay lai bao nhieu lan cung ra
 * cung ket qua.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatMembershipService {

    private final CuocTroChuyenRepository cuocTroChuyenRepository;
    private final ThanhVienCuocTroChuyenRepository thanhVienRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final NhaTroRepository nhaTroRepository;
    private final TangRepository tangRepository;
    private final HopDongRepository hopDongRepository;

    static String khoaNhaTro(UUID nhaTroId) {
        return "building_" + nhaTroId;
    }

    static String khoaTang(UUID tangId) {
        return "floor_" + tangId;
    }

    /**
     * Doi chieu va sua thanh vien nhom tu dong cho MOT nguoi dung.
     * Goi truoc khi tra ve danh sach hoi thoai.
     *
     * REQUIRES_NEW la BAT BUOC, khong phai tuy chon:
     * ham goi (danhSachCuaToi) la @Transactional(readOnly = true). Neu dung
     * propagation mac dinh, ham nay se NHAP vao transaction chi-doc do, ma trong
     * transaction chi-doc thi Hibernate tat flush — moi lenh save() se am tham
     * khong ghi gi vao DB va cung khong bao loi.
     *
     * Tach transaction rieng con mot loi nua: dong bo hong thi phan doc danh sach
     * hoi thoai van chay binh thuong.
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void dongBoChoNguoiDung(UUID nguoiDungId) {
        try {
            Set<String> khoaCanCo = khoaNhomTheoPhamViThue(nguoiDungId);
            List<CuocTroChuyen> hoiThoaiCanCo = layHoacTaoNhom(khoaCanCo);

            themVaoNhom(nguoiDungId, hoiThoaiCanCo);
            choRoiNhomKhongConThuoc(nguoiDungId, khoaCanCo);
        } catch (RuntimeException ex) {
            // Dong bo nhom hong khong duoc lam chet ca trang tin nhan: nguoi dung
            // van phai xem duoc cac cuoc tro chuyen 1-1 cua ho.
            log.warn("Dong bo nhom tu dong that bai cho nguoi dung {}: {}", nguoiDungId, ex.getMessage());
        }
    }

    /**
     * Nhung nguoi dang co hop dong ACTIVE — dau vao cho job doi soat.
     *
     * Job goi rieng dongBoChoNguoiDung cho TUNG nguoi de moi nguoi la mot transaction
     * ngan, thay vi gom ca nghin nguoi vao mot transaction dai giu ket noi DB lau.
     */
    @Transactional(readOnly = true)
    public List<UUID> danhSachNguoiDungDangThue() {
        return hopDongRepository.findToanBoPhamViDangThue().stream()
                .map(hang -> (UUID) hang[0])
                .filter(java.util.Objects::nonNull)
                .distinct()
                .toList();
    }

    // ── Cac buoc nho ───────────────────────────────────────────────────────

    /**
     * Khoa cua nhung nhom ma nguoi nay LE RA phai thuoc ve, suy tu hop dong ACTIVE.
     *
     * Phong chua gan tang thi bo qua nhom tang thay vi tao nhom rac — cot tang_id
     * nullable va con cot so tang cu song song, khong the tin tuyet doi.
     */
    private Set<String> khoaNhomTheoPhamViThue(UUID nguoiDungId) {
        Set<String> khoa = new HashSet<>();
        for (Object[] hang : hopDongRepository.findPhamViDangThue(nguoiDungId)) {
            UUID nhaTroId = (UUID) hang[0];
            UUID tangId = (UUID) hang[1];
            if (nhaTroId != null) khoa.add(khoaNhaTro(nhaTroId));
            if (tangId != null) khoa.add(khoaTang(tangId));
        }
        return khoa;
    }

    /** Tra ve hoi thoai ung voi tung khoa, tao moi neu chua co. */
    private List<CuocTroChuyen> layHoacTaoNhom(Set<String> khoas) {
        if (khoas.isEmpty()) return List.of();

        Map<String, CuocTroChuyen> daCo = cuocTroChuyenRepository
                .findByKhoaDuyNhatInAndXoaLucIsNull(new ArrayList<>(khoas)).stream()
                .collect(Collectors.toMap(CuocTroChuyen::getKhoaDuyNhat, Function.identity(), (a, b) -> a));

        List<CuocTroChuyen> ketQua = new ArrayList<>(daCo.values());

        for (String khoa : khoas) {
            if (daCo.containsKey(khoa)) continue;
            taoNhomTuDong(khoa).ifPresent(ketQua::add);
        }
        return ketQua;
    }

    private Optional<CuocTroChuyen> taoNhomTuDong(String khoa) {
        try {
            if (khoa.startsWith("building_")) {
                UUID nhaTroId = UUID.fromString(khoa.substring("building_".length()));
                NhaTro nhaTro = nhaTroRepository.findByIdAndXoaLucIsNull(nhaTroId).orElse(null);
                if (nhaTro == null) return Optional.empty();

                return Optional.of(cuocTroChuyenRepository.save(CuocTroChuyen.builder()
                        .loai(LoaiCuocTroChuyen.BUILDING)
                        .ten("Cả nhà " + nhaTro.getTen())
                        .nhaTro(nhaTro)
                        .khoaDuyNhat(khoa)
                        .build()));
            }

            if (khoa.startsWith("floor_")) {
                UUID tangId = UUID.fromString(khoa.substring("floor_".length()));
                Tang tang = tangRepository.findByIdAndXoaLucIsNull(tangId).orElse(null);
                if (tang == null) return Optional.empty();

                String tenTang = tang.getTenTang() != null && !tang.getTenTang().isBlank()
                        ? tang.getTenTang()
                        : "Tầng " + tang.getSoTang();

                return Optional.of(cuocTroChuyenRepository.save(CuocTroChuyen.builder()
                        .loai(LoaiCuocTroChuyen.FLOOR)
                        .ten(tenTang)
                        .nhaTro(tang.getNhaTro())
                        .tang(tang)
                        .khoaDuyNhat(khoa)
                        .build()));
            }
        } catch (DataIntegrityViolationException trungKhoa) {
            // Mot request khac vua tao dung nhom nay. Doc lai thay vi bao loi.
            return cuocTroChuyenRepository.findByKhoaDuyNhatAndXoaLucIsNull(khoa);
        } catch (IllegalArgumentException khoaSai) {
            log.warn("Khoa nhom tu dong khong hop le: {}", khoa);
        }
        return Optional.empty();
    }

    /** Them nguoi dung vao cac nhom, tai kich hoat neu truoc do ho da roi. */
    private void themVaoNhom(UUID nguoiDungId, List<CuocTroChuyen> hoiThoais) {
        if (hoiThoais.isEmpty()) return;

        List<UUID> ids = hoiThoais.stream().map(CuocTroChuyen::getId).toList();
        Map<UUID, ThanhVienCuocTroChuyen> banGhiCu = thanhVienRepository
                .timTheoHoiThoaiVaNguoiDung(ids, nguoiDungId).stream()
                .collect(Collectors.toMap(tv -> tv.getCuocTroChuyen().getId(), Function.identity(), (a, b) -> a));

        List<ThanhVienCuocTroChuyen> canLuu = new ArrayList<>();
        for (CuocTroChuyen hoiThoai : hoiThoais) {
            ThanhVienCuocTroChuyen cu = banGhiCu.get(hoiThoai.getId());
            if (cu == null) {
                canLuu.add(ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(hoiThoai)
                        .nguoiDung(nguoiDungRepository.getReferenceById(nguoiDungId))
                        .build());
            } else if (cu.getRoiLuc() != null) {
                // Thue lai phong cu: mo lai tu cach thanh vien thay vi tao ban ghi
                // thu hai (rang buoc UNIQUE se chan).
                cu.setRoiLuc(null);
                cu.setThamGiaLuc(ZonedDateTime.now());
                canLuu.add(cu);
            }
        }
        if (!canLuu.isEmpty()) thanhVienRepository.saveAll(canLuu);
    }

    /** Danh dau roi nhom voi nhung nhom tu dong nguoi nay khong con thuoc ve. */
    private void choRoiNhomKhongConThuoc(UUID nguoiDungId, Set<String> khoaCanCo) {
        List<ThanhVienCuocTroChuyen> canRoi = thanhVienRepository
                .nhomTuDongDangThamGia(nguoiDungId).stream()
                .filter(tv -> !khoaCanCo.contains(tv.getCuocTroChuyen().getKhoaDuyNhat()))
                .peek(tv -> tv.setRoiLuc(ZonedDateTime.now()))
                .toList();

        // Khong xoa ban ghi: giu lai de tin nhan cu van co ngu canh nguoi gui,
        // va de mo lai duoc neu ho thue lai.
        if (!canRoi.isEmpty()) thanhVienRepository.saveAll(canRoi);
    }
}
