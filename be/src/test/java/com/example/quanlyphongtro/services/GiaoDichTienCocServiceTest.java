package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.GiaoDichTienCoc;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.LoaiGiaoDichTienCoc;
import com.example.quanlyphongtro.repository.GiaoDichTienCocRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class GiaoDichTienCocServiceTest {
    @Mock private GiaoDichTienCocRepository giaoDichRepository;
    @Mock private HopDongRepository hopDongRepository;
    @InjectMocks private GiaoDichTienCocService service;

    @Test
    void soDuUsesLedgerMovementsInsteadOfContractDepositField() {
        UUID hopDongId = UUID.randomUUID();
        HopDong hopDong = HopDong.builder().id(hopDongId).tienCoc(BigDecimal.valueOf(9_999_999)).build();
        when(giaoDichRepository.findByHopDongIdOrderByThoiDiemAsc(hopDongId)).thenReturn(List.of(
                movement(hopDong, LoaiGiaoDichTienCoc.LEGACY_OPENING, 3_000_000),
                movement(hopDong, LoaiGiaoDichTienCoc.DEDUCTION, 800_000),
                movement(hopDong, LoaiGiaoDichTienCoc.REFUND, 2_200_000)));

        assertEquals(BigDecimal.ZERO, service.soDu(hopDongId));
    }

    private GiaoDichTienCoc movement(HopDong hopDong, LoaiGiaoDichTienCoc loai, long soTien) {
        return GiaoDichTienCoc.builder().hopDong(hopDong).loai(loai)
                .soTien(BigDecimal.valueOf(soTien)).thoiDiem(ZonedDateTime.now()).dienGiai("test").build();
    }
}
