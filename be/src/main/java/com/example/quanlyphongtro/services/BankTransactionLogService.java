package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.BankTransactionRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * Service xử lý lưu log BankTransaction cho VNPay.
 *
 * Lý do tách thành Bean riêng (KHÔNG để private method trong VNPayService):
 *
 * Nếu để private method trong @Transactional class:
 *   - bankTransactionRepository.save() throws DataIntegrityViolationException
 *   - Hibernate đánh dấu transaction cha là "rollback-only"
 *   - Dù catch Exception trong Java, Spring vẫn rollback toàn bộ
 *   - Mất cả ThanhToan và cập nhật HoaDon!
 *
 * Với REQUIRES_NEW:
 *   - Tạo transaction MỚI, độc lập với transaction cha
 *   - Nếu lưu log thất bại → chỉ transaction log bị rollback
 *   - Transaction cha (ThanhToan + HoaDon) vẫn commit bình thường
 *   - Đây là pattern chuẩn cho "non-critical logging" trong Spring
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class BankTransactionLogService {

    private final BankTransactionRepository bankTransactionRepository;
    private final HoaDonRepository hoaDonRepository;
    private final NhaTroRepository nhaTroRepository;

    /**
     * Lưu log giao dịch VNPay vào bảng bank_transaction.
     *
     * @Transactional(propagation = REQUIRES_NEW):
     *   - Suspend transaction hiện tại (transaction của processIpn)
     *   - Tạo transaction MỚI chỉ cho method này
     *   - Nếu method này fail → rollback transaction mới, KHÔNG ảnh hưởng transaction cha
     *   - Sau khi method return → commit transaction mới, resume transaction cha
     *
     * Lưu ý: Bean PHẢI được inject vào VNPayService (không gọi trực tiếp this.method())
     * vì Spring AOP proxy chỉ intercept lời gọi từ ngoài Bean.
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void saveVNPayLog(Map<String, String> vnpParams,
                             HoaDon hoaDon,
                             String txnRef,
                             long amount) {
        try {
            // Lấy nhaTroId qua JPQL query (tránh LAZY load chain)
            UUID nhaTroId = hoaDonRepository.findNhaTroIdByHoaDonId(hoaDon.getId()).orElse(null);

            // getReferenceById: tạo JPA Proxy (không SELECT), vẫn là managed entity
            NhaTro nhaTroRef = nhaTroId != null
                    ? nhaTroRepository.getReferenceById(nhaTroId)
                    : null;

            // Serialize toàn bộ params VNPay thành JSON lưu vào payload
            StringBuilder payloadJson = new StringBuilder("{");
            boolean firstEntry = true;
            for (Map.Entry<String, String> e : vnpParams.entrySet()) {
                if (!firstEntry) payloadJson.append(",");
                payloadJson.append("\"")
                           .append(e.getKey().replace("\"", "\\\""))
                           .append("\":\"")
                           .append(e.getValue().replace("\"", "\\\""))
                           .append("\"");
                firstEntry = false;
            }
            payloadJson.append("}");

            // Ngân hàng từ vnp_BankCode
            String nganHang = vnpParams.getOrDefault("vnp_BankCode", "VNPAY");

            // Nội dung giao dịch
            String noiDung = "VNPay | TxnRef: " + txnRef
                    + " | HD: " + hoaDon.getMaHoaDon()
                    + " | " + vnpParams.getOrDefault("vnp_OrderInfo", "");

            BankTransaction bankTransaction = BankTransaction.builder()
                    .nhaTro(nhaTroRef)
                    .hoaDon(hoaDon)
                    .soTien(BigDecimal.valueOf(amount))
                    .noiDungChuyenKhoan(noiDung)
                    .maGiaoDich(txnRef)
                    .nganHang(nganHang)
                    .thoiGianGiaoDich(ZonedDateTime.now())
                    .payload(payloadJson.toString())
                    .daDoiSoat(true) // VNPay đã xác nhận → đã đối soát
                    .build();

            bankTransactionRepository.save(bankTransaction);
            log.info("BankTransaction: Đã lưu log VNPay - txnRef={}, hoaDon={}, amount={}",
                    txnRef, hoaDon.getId(), amount);

        } catch (Exception e) {
            // Exception này chỉ rollback transaction REQUIRES_NEW (transaction log)
            // Transaction cha (ThanhToan + HoaDon) KHÔNG bị ảnh hưởng
            log.warn("BankTransaction: Không thể lưu log VNPay - txnRef={}, lý do: {}",
                    txnRef, e.getMessage());
            // Re-throw nếu muốn Spring rollback REQUIRES_NEW transaction (cleanup đúng)
            // Không cần throw ra ngoài vì processIpn đã catch Exception rồi xử lý riêng
        }
    }
}
