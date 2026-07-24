package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.KhachThueRequest;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

@ExtendWith(MockitoExtension.class)
class KhachThueServiceTest {

    @Mock private KhachThueRepository khachThueRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private MediaService mediaService;
    @Mock private PermissionService permissionService;
    @Mock private PasswordEncoder passwordEncoder;

    private KhachThueService service;

    @BeforeEach
    void setUp() {
        service = new KhachThueService(
                khachThueRepository,
                hopDongRepository,
                nguoiDungRepository,
                mediaService,
                permissionService,
                passwordEncoder
        );
    }

    @Test
    void createUsesAuthenticatedUserAsOwner() {
        UUID userId = UUID.randomUUID();
        NguoiDung owner = NguoiDung.builder().id(userId).email("owner@example.com").hoTen("Owner").build();
        KhachThueRequest request = new KhachThueRequest();
        request.setHoTen("Nguyen Van A");
        request.setSoDienThoai("0900000000");

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(nguoiDungRepository.findById(userId)).thenReturn(Optional.of(owner));
        when(passwordEncoder.encode(any())).thenReturn("encodedPassword");
        when(khachThueRepository.save(any(KhachThue.class))).thenAnswer(invocation -> {
            KhachThue khachThue = invocation.getArgument(0);
            khachThue.setId(UUID.randomUUID());
            return khachThue;
        });

        service.createKhachThue(request);

        verify(khachThueRepository).save(org.mockito.ArgumentMatchers.argThat(khachThue -> owner.equals(khachThue.getChuTro())));
    }

    @Test
    void getByIdRejectsUnauthorizedUser() {
        UUID userId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        UUID khachThueId = UUID.randomUUID();
        KhachThue khachThue = KhachThue.builder()
                .id(khachThueId)
                .chuTro(NguoiDung.builder().id(ownerId).build())
                .hoTen("Nguyen Van B")
                .build();

        when(khachThueRepository.findById(khachThueId)).thenReturn(Optional.of(khachThue));
        when(hopDongRepository.findAllActive()).thenReturn(List.of());
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(false);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.getKhachThueById(khachThueId));
        assertEquals("Ban khong co quyen xem khach thue nay", error.getMessage());
    }

    @Test
    void getAllPassesNormalizedSearchToRepository() {
        UUID userId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(true);
        when(khachThueRepository.findAllAccessible(
                eq(true), eq(userId), org.mockito.ArgumentMatchers.<List<UUID>>any(),
                eq("dangThue"), eq("Nguyen A"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        service.getAllKhachThue("dangThue", " Nguyen A ", 1, 10);

        verify(khachThueRepository).findAllAccessible(
                eq(true), eq(userId), org.mockito.ArgumentMatchers.<List<UUID>>any(),
                eq("dangThue"), eq("Nguyen A"), any(Pageable.class));
    }
}
