package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.UUID;

@Data
public class GuiTinNhanRequest {

    @Size(max = 4000, message = "Noi dung tin nhan toi da 4000 ky tu")
    private String noiDung;

    /** TEXT (mac dinh) | IMAGE | FILE. Client khong duoc gui SYSTEM. */
    private String loai;

    /** File da upload san qua /api/upload. */
    private UUID fileMediaId;

    private UUID traLoiChoId;

    /**
     * Khoa chong gui trung do client sinh (vd: crypto.randomUUID()).
     * Khi mang chap chon va client retry, server tra lai dung tin cu.
     */
    @Size(max = 100)
    private String maClient;
}
