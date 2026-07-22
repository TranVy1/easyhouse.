package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.CuocTroChuyen;
import com.example.quanlyphongtro.entity.LoaiCuocTroChuyen;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class CuocTroChuyenResponse {

    @JsonProperty("_id")
    private UUID id;

    private String loai;

    /**
     * Ten hien thi. Voi nhom la ten nhom; voi DIRECT/SUPPORT la ten doi phuong,
     * do server tinh san de client khoi phai tu suy.
     */
    private String ten;
    private String anh;

    private UUID nhaTroId;
    private String trangThai;

    private ZonedDateTime tinNhanCuoiLuc;
    private String xemTruoc;

    private Long soTinChuaDoc;
    private Boolean ghim;

    /** Đang tắt thông báo hay không — đã gộp cả tắt vô thời hạn lẫn tắt có hạn. */
    private Boolean tatThongBao;

    /** Mốc hết hạn tắt thông báo. Null mà tatThongBao=true nghĩa là tắt vô thời hạn. */
    private ZonedDateTime tatThongBaoDen;

    /** Đang lưu trữ (ẩn khỏi danh sách chính) hay không. */
    private Boolean luuTru;

    /** Moc da doc cua chinh nguoi dang goi API. */
    private Long docDenSeq;

    private List<ThanhVienChatResponse> thanhVien;

    /**
     * @param thanhVienDangHoatDong thanh vien con hoat dong cua hoi thoai
     * @param nguoiXem              nguoi dang goi API, dung de suy ten hien thi cho chat 1-1
     */
    public static CuocTroChuyenResponse fromEntity(CuocTroChuyen c,
                                                   List<ThanhVienCuocTroChuyen> thanhVienDangHoatDong,
                                                   UUID nguoiXem,
                                                   long soTinChuaDoc) {
        if (c == null) return null;

        List<ThanhVienChatResponse> dsThanhVien = thanhVienDangHoatDong.stream()
                .map(ThanhVienChatResponse::fromEntity)
                .filter(java.util.Objects::nonNull)
                .toList();

        ThanhVienCuocTroChuyen cuaToi = thanhVienDangHoatDong.stream()
                .filter(tv -> tv.getNguoiDung() != null && tv.getNguoiDung().getId().equals(nguoiXem))
                .findFirst()
                .orElse(null);

        return CuocTroChuyenResponse.builder()
                .id(c.getId())
                .loai(c.getLoai() != null ? c.getLoai().name() : null)
                .ten(tenHienThi(c, dsThanhVien, nguoiXem))
                .anh(c.getAnh())
                .nhaTroId(c.getNhaTro() != null ? c.getNhaTro().getId() : null)
                .trangThai(c.getTrangThai() != null ? c.getTrangThai().name() : null)
                .tinNhanCuoiLuc(c.getTinNhanCuoiLuc())
                .xemTruoc(c.getXemTruoc())
                .soTinChuaDoc(soTinChuaDoc)
                .ghim(cuaToi != null ? cuaToi.getGhim() : Boolean.FALSE)
                // Dung dangTatThongBao() de client khong phai tu tinh lai han.
                .tatThongBao(cuaToi != null && cuaToi.dangTatThongBao())
                .tatThongBaoDen(cuaToi != null ? cuaToi.getTatThongBaoDen() : null)
                .luuTru(cuaToi != null && Boolean.TRUE.equals(cuaToi.getLuuTru()))
                .docDenSeq(cuaToi != null ? cuaToi.getDocDenSeq() : 0L)
                .thanhVien(dsThanhVien)
                .build();
    }

    /**
     * Nhom co ten rieng. Chat 1-1 va kenh ho tro thi lay ten nhung nguoi con lai,
     * vi voi moi ben thi "ten cuoc tro chuyen" la mot chuoi khac nhau.
     */
    private static String tenHienThi(CuocTroChuyen c, List<ThanhVienChatResponse> thanhVien, UUID nguoiXem) {
        if (c.getTen() != null && !c.getTen().isBlank()) return c.getTen();
        if (c.getLoai() != null && c.getLoai().laNhom()) return c.getTen();

        String ten = thanhVien.stream()
                .filter(tv -> !tv.getNguoiDungId().equals(nguoiXem))
                .map(ThanhVienChatResponse::getHoTen)
                .filter(java.util.Objects::nonNull)
                .distinct()
                .reduce((a, b) -> a + ", " + b)
                .orElse(null);

        if (ten != null) return ten;
        return c.getLoai() == LoaiCuocTroChuyen.SUPPORT ? "Ban quan ly" : "Cuoc tro chuyen";
    }
}
