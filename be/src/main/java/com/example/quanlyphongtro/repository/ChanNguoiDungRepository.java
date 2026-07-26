package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.ChanNguoiDung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ChanNguoiDungRepository extends JpaRepository<ChanNguoiDung, UUID> {

    Optional<ChanNguoiDung> findByNguoiChanIdAndNguoiBiChanId(UUID nguoiChanId, UUID nguoiBiChanId);

    List<ChanNguoiDung> findByNguoiChanId(UUID nguoiChanId);

    /**
     * Co quan he chan theo BAT KY chieu nao giua hai nguoi khong.
     *
     * Chan la mot chieu, nhung khi MO chat 1-1 thi phai xet ca hai chieu: neu B da
     * chan A thi cho A mo cuoc tro chuyen roi gui vao khoang khong la lua nguoi dung.
     */
    @Query("""
            SELECT COUNT(c) > 0 FROM ChanNguoiDung c
            WHERE (c.nguoiChan.id = :nguoiA AND c.nguoiBiChan.id = :nguoiB)
               OR (c.nguoiChan.id = :nguoiB AND c.nguoiBiChan.id = :nguoiA)
            """)
    boolean coChanGiuaHaiNguoi(@Param("nguoiA") UUID nguoiA, @Param("nguoiB") UUID nguoiB);
}
