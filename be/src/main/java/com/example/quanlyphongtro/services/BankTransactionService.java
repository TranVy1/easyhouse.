package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.BankTransactionResponse;
import com.example.quanlyphongtro.dto.DoiSoatRequest;
import com.example.quanlyphongtro.entity.BankTransaction;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.repository.BankTransactionRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class BankTransactionService {

    private final BankTransactionRepository bankTransactionRepository;
    private final HoaDonRepository hoaDonRepository;
    private final PermissionService permissionService;
    private final ThanhToanService thanhToanService;

    @Transactional(readOnly = true)
    public Page<BankTransactionResponse> getAll(UUID nhaTroId, Boolean daDoiSoat, Pageable pageable) {
        UUID userId = permissionService.requireCurrentUserId();
        List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
        if (accessibleIds != null) {
            if (nhaTroId != null && !accessibleIds.contains(nhaTroId)) {
                throw new RuntimeException("Khong co quyen xem giao dich cua nha tro nay");
            }
            if (accessibleIds.isEmpty()) {
                return Page.empty(pageable);
            }
            if (nhaTroId == null && daDoiSoat != null) {
                return bankTransactionRepository.findByNhaTroIdInAndDaDoiSoat(accessibleIds, daDoiSoat, pageable)
                        .map(BankTransactionResponse::fromEntity);
            }
            if (nhaTroId == null) {
                return bankTransactionRepository.findByNhaTroIdIn(accessibleIds, pageable)
                        .map(BankTransactionResponse::fromEntity);
            }
        }
        if (nhaTroId != null && daDoiSoat != null) {
            return bankTransactionRepository.findByNhaTroIdAndDaDoiSoat(nhaTroId, daDoiSoat, pageable)
                    .map(BankTransactionResponse::fromEntity);
        }
        if (nhaTroId != null) {
            return bankTransactionRepository.findByNhaTroId(nhaTroId, pageable).map(BankTransactionResponse::fromEntity);
        }
        if (daDoiSoat != null) {
            return bankTransactionRepository.findByDaDoiSoat(daDoiSoat, pageable).map(BankTransactionResponse::fromEntity);
        }
        return bankTransactionRepository.findAll(pageable).map(BankTransactionResponse::fromEntity);
    }

    @Transactional
    public BankTransactionResponse manualMatch(DoiSoatRequest request) {
        BankTransaction transaction = bankTransactionRepository.findById(request.getTransactionId())
                .orElseThrow(() -> new RuntimeException("Khong tim thay giao dich ngan hang"));
        if (Boolean.TRUE.equals(transaction.getDaDoiSoat())) {
            throw new RuntimeException("Giao dich nay da duoc doi soat");
        }
        HoaDon hoaDon = hoaDonRepository.findById(request.getHoaDonId())
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));

        UUID userId = permissionService.requireCurrentUserId();
        if (transaction.getNhaTro() == null
                || !permissionService.canWriteNhaTro(userId, transaction.getNhaTro().getId(),
                        transaction.getNhaTro().getChuTro() != null ? transaction.getNhaTro().getChuTro().getId() : null)
                || !permissionService.canWriteHoaDon(userId, hoaDon.getId())) {
            throw new RuntimeException("Khong co quyen doi soat giao dich nay");
        }
        if (hoaDon.getPhong() == null || hoaDon.getPhong().getNhaTro() == null
                || !transaction.getNhaTro().getId().equals(hoaDon.getPhong().getNhaTro().getId())) {
            throw new RuntimeException("Giao dich va hoa don khong thuoc cung nha tro");
        }

        thanhToanService.recordBankTransactionMatch(transaction, hoaDon);
        transaction.setHoaDon(hoaDon);
        transaction.setDaDoiSoat(true);
        return BankTransactionResponse.fromEntity(bankTransactionRepository.save(transaction));
    }
}
