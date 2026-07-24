package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.DatCocPhong;
import com.example.quanlyphongtro.entity.TrangThaiDatCoc;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface DatCocPhongRepository extends JpaRepository<DatCocPhong, UUID>, JpaSpecificationExecutor<DatCocPhong> {

    List<DatCocPhong> findByPhongIdAndTrangThaiIn(UUID phongId, List<TrangThaiDatCoc> trangThais);

    List<DatCocPhong> findByHopDongId(UUID hopDongId);
}
