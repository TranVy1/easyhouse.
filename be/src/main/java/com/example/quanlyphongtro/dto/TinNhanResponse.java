package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TinNhan;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class TinNhanResponse {

    @JsonProperty("_id")
    private UUID id;

    /** Moc thu tu tuyet doi. Client dung lam cursor va de phat hien lo hong. */
    private Long soThuTu;

    private UUID cuocTroChuyenId;

    /** Null voi tin he thong. */
    private UUID nguoiGuiId;
    private String tenNguoiGui;
    private String anhNguoiGui;

    private String loai;
    private String noiDung;

    /** URL file dinh kem, lay san tu FileMedia de client khoi goi them API. */
    private String fileUrl;

    private UUID traLoiChoId;
    private String maClient;
    private Boolean daThuHoi;

    /** Tin nay dang duoc ghim hay khong — pham vi ca hoi thoai (P8). */
    private Boolean dangGhim;
    private ZonedDateTime ghimLuc;
    private String tenNguoiGhim;

    /** Co gia tri nghia la tin nay la ban chuyen tiep — client hien nhan "Đã chuyển tiếp". */
    private UUID chuyenTiepTuId;

    @JsonProperty("ngayTao")
    private ZonedDateTime taoLuc;

    public static TinNhanResponse fromEntity(TinNhan tn) {
        if (tn == null) return null;

        NguoiDung nguoiGui = tn.getNguoiGui();
        boolean thuHoi = Boolean.TRUE.equals(tn.getDaThuHoi());

        return TinNhanResponse.builder()
                .id(tn.getId())
                .soThuTu(tn.getSoThuTu())
                .cuocTroChuyenId(tn.getCuocTroChuyen() != null ? tn.getCuocTroChuyen().getId() : null)
                .nguoiGuiId(nguoiGui != null ? nguoiGui.getId() : null)
                .tenNguoiGui(nguoiGui != null ? nguoiGui.getHoTen() : null)
                .anhNguoiGui(nguoiGui != null ? nguoiGui.getAnhDaiDien() : null)
                .loai(tn.getLoai() != null ? tn.getLoai().name() : null)
                // Tin da thu hoi khong duoc lo noi dung/file cu ra ngoai.
                .noiDung(thuHoi ? null : tn.getNoiDung())
                .fileUrl(thuHoi || tn.getFileMedia() == null ? null : tn.getFileMedia().getUrl())
                .traLoiChoId(tn.getTraLoiCho() != null ? tn.getTraLoiCho().getId() : null)
                .maClient(tn.getMaClient())
                .daThuHoi(thuHoi)
                .dangGhim(tn.dangGhim())
                .ghimLuc(tn.getGhimLuc())
                .tenNguoiGhim(tn.getNguoiGhim() != null ? tn.getNguoiGhim().getHoTen() : null)
                .chuyenTiepTuId(tn.getChuyenTiepTu() != null ? tn.getChuyenTiepTu().getId() : null)
                .taoLuc(tn.getTaoLuc())
                .build();
    }
}
