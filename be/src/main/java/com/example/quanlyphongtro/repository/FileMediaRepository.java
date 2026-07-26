package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.FileMedia;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface FileMediaRepository extends JpaRepository<FileMedia, UUID> {
    List<FileMedia> findByDoiTuongAndDoiTuongIdOrderByTaoLucAsc(LoaiDoiTuongMedia doiTuong, UUID doiTuongId);

    List<FileMedia> findByDoiTuongAndDoiTuongIdAndLoaiFileOrderByTaoLucAsc(
            LoaiDoiTuongMedia doiTuong,
            UUID doiTuongId,
            String loaiFile);

    void deleteByDoiTuongAndDoiTuongIdAndLoaiFile(LoaiDoiTuongMedia doiTuong, UUID doiTuongId, String loaiFile);
}
