package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.FileMedia;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.repository.FileMediaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MediaService {

    public static final String ROOM_IMAGE = "ROOM_IMAGE";
    public static final String CCCD_FRONT = "CCCD_FRONT";
    public static final String CCCD_BACK = "CCCD_BACK";
    public static final String INCIDENT_IMAGE = "INCIDENT_IMAGE";
    public static final String PAYMENT_RECEIPT = "PAYMENT_RECEIPT";
    public static final String METER_IMAGE = "METER_IMAGE";

    private final FileMediaRepository fileMediaRepository;

    public List<String> listUrls(LoaiDoiTuongMedia doiTuong, UUID doiTuongId, String loaiFile) {
        if (doiTuongId == null) return Collections.emptyList();
        return fileMediaRepository.findByDoiTuongAndDoiTuongIdAndLoaiFileOrderByTaoLucAsc(doiTuong, doiTuongId, loaiFile)
                .stream()
                .map(FileMedia::getUrl)
                .toList();
    }

    public java.util.Map<UUID, List<String>> batchListUrls(LoaiDoiTuongMedia doiTuong, List<UUID> doiTuongIds, String loaiFile) {
        if (doiTuongIds == null || doiTuongIds.isEmpty()) return java.util.Collections.emptyMap();
        List<FileMedia> media = fileMediaRepository.findByDoiTuongAndDoiTuongIdInAndLoaiFileOrderByTaoLucAsc(doiTuong, doiTuongIds, loaiFile);
        
        java.util.Map<UUID, List<String>> map = new java.util.HashMap<>();
        for (FileMedia m : media) {
            map.computeIfAbsent(m.getDoiTuongId(), k -> new java.util.ArrayList<>()).add(m.getUrl());
        }
        return map;
    }

    public String firstUrl(LoaiDoiTuongMedia doiTuong, UUID doiTuongId, String loaiFile) {
        return listUrls(doiTuong, doiTuongId, loaiFile).stream().findFirst().orElse("");
    }

    @Transactional
    public void replaceUrls(LoaiDoiTuongMedia doiTuong, UUID doiTuongId, Collection<String> urls, String loaiFile) {
        if (doiTuongId == null || urls == null) return;

        fileMediaRepository.deleteByDoiTuongAndDoiTuongIdAndLoaiFile(doiTuong, doiTuongId, loaiFile);
        urls.stream()
                .filter(url -> url != null && !url.isBlank())
                .distinct()
                .map(url -> FileMedia.builder()
                        .doiTuong(doiTuong)
                        .doiTuongId(doiTuongId)
                        .url(url)
                        .loaiFile(loaiFile)
                        .build())
                .forEach(fileMediaRepository::save);
    }

    @Transactional
    public void replaceUrl(LoaiDoiTuongMedia doiTuong, UUID doiTuongId, String url, String loaiFile) {
        replaceUrls(doiTuong, doiTuongId, url == null ? List.of() : List.of(url), loaiFile);
    }
}
