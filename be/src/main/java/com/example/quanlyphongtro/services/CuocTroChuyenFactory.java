package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiTinNhan;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.Tang;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.example.quanlyphongtro.entity.TinNhan;
import com.example.quanlyphongtro.entity.VaiTroThanhVienChat;
import com.example.quanlyphongtro.repository.CuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.ThanhVienCuocTroChuyenRepository;
import com.example.quanlyphongtro.repository.TinNhanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Tao cuoc tro chuyen trong MOT TRANSACTION RIENG.
 *
 * Vi sao tach thanh bean rieng thay vi de trong CuocTroChuyenService:
 * cot khoa_duy_nhat co rang buoc UNIQUE de chong tao trung hoi thoai. Khi hai
 * nguoi bam "nhan tin" voi nhau cung luc, mot ben se dinh loi rang buoc. Neu
 * lenh INSERT do chay chung transaction voi ham goi, ca transaction bi danh dau
 * rollback-only va ham goi khong the doc lai ban ghi vua duoc ben kia tao.
 *
 * Voi REQUIRES_NEW, chi transaction ben trong bi huy; ham goi bat exception roi
 * doc lai binh thuong. Dieu nay chi hoat dong khi goi qua proxy Spring, tuc la
 * PHAI nam o bean khac — goi this.tao(...) trong cung bean se khong co tac dung.
 */
@Service
@RequiredArgsConstructor
public class CuocTroChuyenFactory {

    private final CuocTroChuyenRepository cuocTroChuyenRepository;
    private final ThanhVienCuocTroChuyenRepository thanhVienRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final TinNhanRepository tinNhanRepository;

    /**
     * Ham tao dung chung cho MOI loai hoi thoai.
     *
     * Chat 1-1 chi la truong hop hai thanh vien, nen khi mo rong sang nhom
     * (GROUP / BUILDING / FLOOR) khong can them duong tao moi — chi can truyen
     * danh sach thanh vien dai hon va vai tro tuong ung.
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public CuocTroChuyen tao(LoaiCuocTroChuyen loai,
                             String khoaDuyNhat,
                             String ten,
                             NhaTro nhaTro,
                             Tang tang,
                             NguoiDung nguoiTao,
                             Collection<UUID> thanhVienIds,
                             Map<UUID, VaiTroThanhVienChat> vaiTroTheoNguoi) {

        CuocTroChuyen hoiThoai = cuocTroChuyenRepository.save(CuocTroChuyen.builder()
                .loai(loai)
                .ten(ten)
                .nhaTro(nhaTro)
                .tang(tang)
                .nguoiTao(nguoiTao)
                .khoaDuyNhat(khoaDuyNhat)
                .build());

        List<NguoiDung> nguoiDungs = nguoiDungRepository.findAllById(thanhVienIds);

        List<ThanhVienCuocTroChuyen> thanhViens = nguoiDungs.stream()
                .map(nd -> ThanhVienCuocTroChuyen.builder()
                        .cuocTroChuyen(hoiThoai)
                        .nguoiDung(nd)
                        .vaiTro(vaiTroTheoNguoi.getOrDefault(nd.getId(), VaiTroThanhVienChat.MEMBER))
                        .build())
                .toList();

        thanhVienRepository.saveAll(thanhViens);
        return hoiThoai;
    }

    /**
     * Tin he thong ("A da tham gia nhom"). nguoiGui = null.
     *
     * Dat o day thay vi TinNhanService de tranh phu thuoc vong:
     * TinNhanService da phu thuoc CuocTroChuyenService, nen CuocTroChuyenService
     * khong the phu thuoc nguoc lai TinNhanService.
     */
    @Transactional
    public TinNhan taoTinHeThong(CuocTroChuyen hoiThoai, String noiDung) {
        // saveAndFlush de PostgreSQL cap so_thu_tu truoc khi dung DTO.
        TinNhan tin = tinNhanRepository.saveAndFlush(TinNhan.builder()
                .cuocTroChuyen(hoiThoai)
                .loai(LoaiTinNhan.SYSTEM)
                .noiDung(noiDung)
                .build());

        hoiThoai.setTinNhanCuoiLuc(tin.getTaoLuc() != null ? tin.getTaoLuc() : ZonedDateTime.now());
        hoiThoai.setXemTruoc(noiDung);
        cuocTroChuyenRepository.save(hoiThoai);

        return tin;
    }
}
