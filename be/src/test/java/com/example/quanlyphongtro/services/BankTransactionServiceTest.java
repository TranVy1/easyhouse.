package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.DoiSoatRequest;
import com.example.quanlyphongtro.entity.BankTransaction;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.repository.BankTransactionRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageRequest;

@ExtendWith(MockitoExtension.class)
class BankTransactionServiceTest {

    @Mock private BankTransactionRepository bankTransactionRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private PermissionService permissionService;
    @Mock private ThanhToanService thanhToanService;

    @InjectMocks private BankTransactionService service;

    @Test
    void getAllReturnsEmptyWhenUserHasNoAccessibleBuilding() {
        UUID userId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(List.of());

        assertEquals(0, service.getAll(null, null, PageRequest.of(0, 20)).getTotalElements());
        verify(bankTransactionRepository, never()).findAll(PageRequest.of(0, 20));
    }

    @Test
    void manualMatchRejectsTransactionOutsideWriteScope() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        DoiSoatRequest request = request();
        NhaTro nhaTro = NhaTro.builder().id(nhaTroId).build();
        BankTransaction transaction = BankTransaction.builder()
                .id(request.getTransactionId()).nhaTro(nhaTro).daDoiSoat(false).build();
        HoaDon hoaDon = HoaDon.builder().id(request.getHoaDonId()).build();
        when(bankTransactionRepository.findById(request.getTransactionId())).thenReturn(Optional.of(transaction));
        when(hoaDonRepository.findById(request.getHoaDonId())).thenReturn(Optional.of(hoaDon));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWriteNhaTro(userId, nhaTroId, null)).thenReturn(false);

        assertThrows(RuntimeException.class, () -> service.manualMatch(request));
        verify(thanhToanService, never()).recordBankTransactionMatch(transaction, hoaDon);
    }

    @Test
    void manualMatchThrowsWhenAlreadyMatched() {
        DoiSoatRequest request = request();
        BankTransaction transaction = BankTransaction.builder()
                .id(request.getTransactionId()).daDoiSoat(true).build();
        
        when(bankTransactionRepository.findById(request.getTransactionId())).thenReturn(Optional.of(transaction));

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.manualMatch(request));
        assertEquals("Giao dich nay da duoc doi soat", error.getMessage());
    }

    @Test
    void manualMatchCreatesPaymentThroughThanhToanService() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        DoiSoatRequest request = request();
        NhaTro nhaTro = NhaTro.builder().id(nhaTroId).build();
        BankTransaction transaction = BankTransaction.builder()
                .id(request.getTransactionId()).nhaTro(nhaTro).soTien(BigDecimal.TEN).daDoiSoat(false).build();
        HoaDon hoaDon = HoaDon.builder()
                .id(request.getHoaDonId())
                .phong(Phong.builder().nhaTro(nhaTro).build())
                .build();
        when(bankTransactionRepository.findById(request.getTransactionId())).thenReturn(Optional.of(transaction));
        when(hoaDonRepository.findById(request.getHoaDonId())).thenReturn(Optional.of(hoaDon));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWriteNhaTro(userId, nhaTroId, null)).thenReturn(true);
        when(permissionService.canWriteHoaDon(userId, hoaDon.getId())).thenReturn(true);
        when(bankTransactionRepository.save(transaction)).thenReturn(transaction);

        service.manualMatch(request);

        verify(thanhToanService).recordBankTransactionMatch(transaction, hoaDon);
        assertEquals(true, transaction.getDaDoiSoat());
        assertEquals(hoaDon, transaction.getHoaDon());
    }

    private DoiSoatRequest request() {
        DoiSoatRequest request = new DoiSoatRequest();
        request.setTransactionId(UUID.randomUUID());
        request.setHoaDonId(UUID.randomUUID());
        return request;
    }
}
