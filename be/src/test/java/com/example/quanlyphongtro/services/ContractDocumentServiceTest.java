package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ContractSignRequest;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ContractDocumentServiceTest {

    @Mock
    private HopDongRepository hopDongRepository;
    @Mock
    private ContractSignatureRepository contractSignatureRepository;
    @Mock
    private NguoiDungRepository nguoiDungRepository;
    @Mock
    private ThanhVienHopDongRepository thanhVienHopDongRepository;
    @Mock
    private DichVuHopDongRepository dichVuHopDongRepository;
    @Mock
    private CloudinaryService cloudinaryService;
    @Mock
    private PermissionService permissionService;
    @Mock
    private JdbcTemplate jdbcTemplate;

    @InjectMocks
    private ContractDocumentService contractDocumentService;

    private HopDong hopDong;
    private UUID hopDongId;
    private UUID landlordUserId;
    private UUID tenantUserId;
    private KhachThue khachThue;
    private Phong phong;
    private NhaTro nhaTro;
    private NguoiDung landlordUser;
    private NguoiDung tenantUser;

    @BeforeEach
    void setUp() {
        hopDongId = UUID.randomUUID();
        landlordUserId = UUID.randomUUID();
        tenantUserId = UUID.randomUUID();

        landlordUser = NguoiDung.builder()
                .id(landlordUserId)
                .email("landlord@easyhouse.local")
                .hoTen("Chủ trọ Nguyễn Văn A")
                .build();

        tenantUser = NguoiDung.builder()
                .id(tenantUserId)
                .email("tenant@easyhouse.local")
                .hoTen("Khách thuê Nguyễn Văn B")
                .build();

        nhaTro = NhaTro.builder()
                .id(UUID.randomUUID())
                .ten("Nhà trọ A")
                .chuTro(landlordUser)
                .build();

        phong = Phong.builder()
                .id(UUID.randomUUID())
                .ten("Phòng 101")
                .nhaTro(nhaTro)
                .build();

        khachThue = KhachThue.builder()
                .id(UUID.randomUUID())
                .nguoiDung(tenantUser)
                .hoTen("Khách thuê Nguyễn Văn B")
                .soDienThoai("0987654321")
                .email("tenant@easyhouse.local")
                .dangHoatDong(true)
                .build();

        hopDong = HopDong.builder()
                .id(hopDongId)
                .maHopDong("HD-P101-2026")
                .phong(phong)
                .khachThue(khachThue)
                .ngayBatDau(LocalDate.now())
                .ngayKetThuc(LocalDate.now().plusMonths(6))
                .giaThueHopDong(BigDecimal.valueOf(3000000))
                .tienCoc(BigDecimal.valueOf(3000000))
                .trangThai(TrangThaiHopDong.DRAFT)
                .signatureStatus(SignatureStatus.UNSIGNED)
                .build();
    }

    @Test
    void signContract_LandlordSignsFirst_SavesSignatureAndUpdatesStatus() throws IOException {
        // Mock
        when(hopDongRepository.findById(hopDongId)).thenReturn(Optional.of(hopDong));
        when(permissionService.requireCurrentUserId()).thenReturn(landlordUserId);
        when(permissionService.isAdmin(landlordUserId)).thenReturn(false);
        
        // Mock upload chữ ký
        Map<String, Object> uploadResult = new HashMap<>();
        uploadResult.put("secure_url", "http://cloudinary.com/sig_landlord.png");
        when(cloudinaryService.uploadImage(any(byte[].class), anyString())).thenReturn(uploadResult);
        
        // Mock save signature
        ContractSignature expectedSig = ContractSignature.builder()
                .id(UUID.randomUUID())
                .hopDong(hopDong)
                .signerId(landlordUserId)
                .signerRole("LANDLORD")
                .signatureImageUrl("http://cloudinary.com/sig_landlord.png")
                .signedAt(ZonedDateTime.now())
                .build();
        when(contractSignatureRepository.save(any(ContractSignature.class))).thenReturn(expectedSig);
        when(hopDongRepository.save(any(HopDong.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // Execute
        ContractSignRequest request = new ContractSignRequest(
                "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==",
                "127.0.0.1",
                "Mozilla/5.0",
                null,
                null,
                null
        );
        ContractSignature signature = contractDocumentService.signContract(hopDongId, request);

        // Verify
        assertNotNull(signature);
        assertEquals("LANDLORD", signature.getSignerRole());
        assertEquals("http://cloudinary.com/sig_landlord.png", signature.getSignatureImageUrl());
        assertEquals("LANDLORD_SIGNED", hopDong.getSignatureStatus());
        assertNotNull(hopDong.getLandlordSignedAt());
        assertNull(hopDong.getTenantSignedAt());
        
        verify(contractSignatureRepository, times(1)).save(any(ContractSignature.class));
        verify(hopDongRepository, times(1)).save(hopDong);
    }

    @Test
    void signContract_TenantSignsFirst_SavesSignatureAndUpdatesStatus() throws IOException {
        // Mock
        when(hopDongRepository.findById(hopDongId)).thenReturn(Optional.of(hopDong));
        when(permissionService.requireCurrentUserId()).thenReturn(tenantUserId);
        
        // Mock upload chữ ký
        Map<String, Object> uploadResult = new HashMap<>();
        uploadResult.put("secure_url", "http://cloudinary.com/sig_tenant.png");
        when(cloudinaryService.uploadImage(any(byte[].class), anyString())).thenReturn(uploadResult);
        
        // Mock save signature
        ContractSignature expectedSig = ContractSignature.builder()
                .id(UUID.randomUUID())
                .hopDong(hopDong)
                .signerId(tenantUserId)
                .signerRole("TENANT")
                .signatureImageUrl("http://cloudinary.com/sig_tenant.png")
                .signedAt(ZonedDateTime.now())
                .build();
        when(contractSignatureRepository.save(any(ContractSignature.class))).thenReturn(expectedSig);
        when(hopDongRepository.save(any(HopDong.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // Execute
        ContractSignRequest request = new ContractSignRequest(
                "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==",
                "127.0.0.1",
                "Mozilla/5.0",
                null,
                null,
                null
        );
        ContractSignature signature = contractDocumentService.signContract(hopDongId, request);

        // Verify
        assertNotNull(signature);
        assertEquals("TENANT", signature.getSignerRole());
        assertEquals("http://cloudinary.com/sig_tenant.png", signature.getSignatureImageUrl());
        assertEquals("TENANT_SIGNED", hopDong.getSignatureStatus());
        assertNotNull(hopDong.getTenantSignedAt());
        assertNull(hopDong.getLandlordSignedAt());
        
        verify(contractSignatureRepository, times(1)).save(any(ContractSignature.class));
        verify(hopDongRepository, times(1)).save(hopDong);
    }

    @Test
    void rejectContract_UpdatesStatusToRejectedAndSavesReason() {
        // Mock
        when(hopDongRepository.findById(hopDongId)).thenReturn(Optional.of(hopDong));
        when(permissionService.requireCurrentUserId()).thenReturn(tenantUserId);
        when(hopDongRepository.save(any(HopDong.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // Execute
        ContractSignRequest request = new ContractSignRequest(null, "127.0.0.1", "Mozilla/5.0", "Sai thông tin tiền cọc", null, null);
        HopDong rejected = contractDocumentService.rejectContract(hopDongId, request);

        // Verify
        assertNotNull(rejected);
        assertEquals("REJECTED", rejected.getSignatureStatus());
        assertTrue(rejected.getGhiChu().contains("Lý do: Sai thông tin tiền cọc"));
        verify(hopDongRepository, times(1)).save(hopDong);
    }
}
