package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.BankTransactionResponse;
import com.example.quanlyphongtro.dto.DoiSoatRequest;
import com.example.quanlyphongtro.entity.BankTransaction;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.repository.BankTransactionRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class BankTransactionService {

    private final BankTransactionRepository bankTransactionRepository;
    private final HoaDonRepository hoaDonRepository;

    @Transactional(readOnly = true)
    public Page<BankTransactionResponse> getAll(UUID nhaTroId, Boolean daDoiSoat, Pageable pageable) {
        if (nhaTroId != null && daDoiSoat != null) {
            return bankTransactionRepository.findByNhaTroIdAndDaDoiSoat(nhaTroId, daDoiSoat, pageable).map(BankTransactionResponse::fromEntity);
        } else if (nhaTroId != null) {
            return bankTransactionRepository.findByNhaTroId(nhaTroId, pageable).map(BankTransactionResponse::fromEntity);
        } else if (daDoiSoat != null) {
            return bankTransactionRepository.findByDaDoiSoat(daDoiSoat, pageable).map(BankTransactionResponse::fromEntity);
        } else {
            return bankTransactionRepository.findAll(pageable).map(BankTransactionResponse::fromEntity);
        }
    }

    @Transactional
    public BankTransactionResponse manualMatch(DoiSoatRequest request) {
        BankTransaction transaction = bankTransactionRepository.findById(request.getTransactionId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy giao dịch ngân hàng"));

        if (transaction.getDaDoiSoat()) {
            throw new RuntimeException("Giao dịch này đã được đối soát");
        }

        HoaDon hoaDon = hoaDonRepository.findById(request.getHoaDonId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));

        // Cộng tiền đã trả cho hóa đơn
        BigDecimal currentDaTra = hoaDon.getDaTra() != null ? hoaDon.getDaTra() : BigDecimal.ZERO;
        hoaDon.setDaTra(currentDaTra.add(transaction.getSoTien()));

        // Cập nhật trạng thái giao dịch
        transaction.setHoaDon(hoaDon);
        transaction.setDaDoiSoat(true);

        hoaDonRepository.save(hoaDon);
        return BankTransactionResponse.fromEntity(bankTransactionRepository.save(transaction));
    }
}
