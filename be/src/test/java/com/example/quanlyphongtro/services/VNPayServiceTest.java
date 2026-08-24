package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.math.BigDecimal;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class VNPayServiceTest {

    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private ThanhToanRepository thanhToanRepository;
    @Mock private BankTransactionLogService bankTransactionLogService;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private GiaoDichTienCocService giaoDichTienCocService;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private EmailService emailService;

    @Test
    void createPaymentUrlUsesInvoiceBalanceAndRoundsToWholeVnd() {
        UUID hoaDonId = UUID.randomUUID();
        HoaDon hoaDon = HoaDon.builder()
                .id(hoaDonId)
                .tongTien(new BigDecimal("3996775.19"))
                .daTra(BigDecimal.ZERO)
                .build();
        when(hoaDonRepository.findById(hoaDonId)).thenReturn(Optional.of(hoaDon));

        VNPayService service = new VNPayService(
            hoaDonRepository, 
            thanhToanRepository, 
            hopDongRepository,
            phongRepository,
            giaoDichTienCocService,
            jdbcTemplate,
            emailService,
            bankTransactionLogService
        );
        ReflectionTestUtils.setField(service, "vnp_TmnCode", "TEST");
        ReflectionTestUtils.setField(service, "vnp_HashSecret", "secret");
        ReflectionTestUtils.setField(service, "vnp_PayUrl", "https://sandbox.example/pay");
        ReflectionTestUtils.setField(service, "vnp_ReturnUrl", "https://example.test/return");

        String paymentUrl = service.createPaymentUrl(hoaDonId, "127.0.0.1");

        assertTrue(paymentUrl.contains("vnp_Amount=399677500"));
    }
}
