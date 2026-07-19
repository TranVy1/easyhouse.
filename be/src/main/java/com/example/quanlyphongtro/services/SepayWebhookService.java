package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.SepayWebhookRequest;
import com.example.quanlyphongtro.entity.BankTransaction;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.TrangThaiHoaDon;
import com.example.quanlyphongtro.repository.BankTransactionRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
@Slf4j
public class SepayWebhookService {

    private final BankTransactionRepository bankTransactionRepository;
    private final HoaDonRepository hoaDonRepository;
    private final ThanhToanService thanhToanService;

    @Transactional
    public void processWebhook(SepayWebhookRequest request, String rawPayload) {
        // Prevent duplicate transaction processing using referenceNumber
        if (request.getReferenceNumber() != null && !request.getReferenceNumber().isBlank()) {
            if (bankTransactionRepository.existsByMaGiaoDich(request.getReferenceNumber())) {
                log.info("Webhook Sepay: Giao dịch {} đã tồn tại, bỏ qua.", request.getReferenceNumber());
                return;
            }
        }

        // Parse date
        ZonedDateTime transactionTime = ZonedDateTime.now();
        try {
            if (request.getTransactionDate() != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDateTime ldt = LocalDateTime.parse(request.getTransactionDate(), formatter);
                transactionTime = ldt.atZone(ZoneId.of("Asia/Ho_Chi_Minh"));
            }
        } catch (Exception e) {
            log.warn("Webhook Sepay: Lỗi parse ngày giao dịch {}", request.getTransactionDate());
        }

        BankTransaction bankTransaction = BankTransaction.builder()
                .soTien(request.getAmountIn())
                .noiDungChuyenKhoan(request.getTransactionContent())
                .maGiaoDich(request.getReferenceNumber())
                .nganHang(request.getGateway())
                .thoiGianGiaoDich(transactionTime)
                .payload(rawPayload)
                .daDoiSoat(false)
                .build();

        // Find invoice code in transaction content (e.g. HD202310-P101)
        HoaDon matchedHoaDon = null;
        if (request.getTransactionContent() != null) {
            Pattern pattern = Pattern.compile("HD\\d{6}-[A-Za-z0-9]+", Pattern.CASE_INSENSITIVE);
            Matcher matcher = pattern.matcher(request.getTransactionContent());
            if (matcher.find()) {
                String maHoaDon = matcher.group().toUpperCase();
                Optional<HoaDon> optionalHoaDon = hoaDonRepository.findByMaHoaDon(maHoaDon);
                if (optionalHoaDon.isPresent()) {
                    matchedHoaDon = optionalHoaDon.get();
                }
            }
        }

        if (matchedHoaDon != null) {
            bankTransaction.setHoaDon(matchedHoaDon);
            bankTransaction.setNhaTro(matchedHoaDon.getPhong().getNhaTro());
            
            // Only match if invoice is not fully paid and not deleted
            if (matchedHoaDon.getXoaLuc() == null && matchedHoaDon.getTrangThai() != TrangThaiHoaDon.PAID) {
                try {
                    // We run this without requiring current user ID because it's a webhook
                    thanhToanService.recordBankTransactionMatch(bankTransaction, matchedHoaDon);
                    bankTransaction.setDaDoiSoat(true);
                    log.info("Webhook Sepay: Đã tự động đối soát giao dịch {} cho hóa đơn {}", request.getReferenceNumber(), matchedHoaDon.getMaHoaDon());
                } catch (Exception e) {
                    log.error("Webhook Sepay: Lỗi khi tự động đối soát giao dịch {} cho hóa đơn {}: {}", request.getReferenceNumber(), matchedHoaDon.getMaHoaDon(), e.getMessage());
                }
            } else {
                log.info("Webhook Sepay: Tìm thấy hóa đơn {} nhưng hóa đơn đã thanh toán hoặc bị xóa.", matchedHoaDon.getMaHoaDon());
            }
        } else {
            log.info("Webhook Sepay: Không tìm thấy mã hóa đơn hợp lệ trong nội dung chuyển khoản: {}", request.getTransactionContent());
        }

        bankTransactionRepository.save(bankTransaction);
    }
}
