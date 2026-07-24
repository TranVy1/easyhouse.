package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.FileMedia;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class FileMediaResponse {
    @JsonProperty("_id")
    private UUID id;
    private String doiTuong;
    private UUID doiTuongId;
    private String url;
    private String publicId;
    private String loaiFile;
    private Long kichThuocBytes;
    private String metadata;
    private UUID nguoiTaiLenId;
    private ZonedDateTime taoLuc;

    public static FileMediaResponse fromEntity(FileMedia fileMedia) {
        if (fileMedia == null) return null;
        return FileMediaResponse.builder()
                .id(fileMedia.getId())
                .doiTuong(fileMedia.getDoiTuong() != null ? fileMedia.getDoiTuong().name() : null)
                .doiTuongId(fileMedia.getDoiTuongId())
                .url(fileMedia.getUrl())
                .publicId(fileMedia.getPublicId())
                .loaiFile(fileMedia.getLoaiFile())
                .kichThuocBytes(fileMedia.getKichThuocBytes())
                .metadata(fileMedia.getMetadata())
                .nguoiTaiLenId(fileMedia.getNguoiTaiLen() != null ? fileMedia.getNguoiTaiLen().getId() : null)
                .taoLuc(fileMedia.getTaoLuc())
                .build();
    }
}
