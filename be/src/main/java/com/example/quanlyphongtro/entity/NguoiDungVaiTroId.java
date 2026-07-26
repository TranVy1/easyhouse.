package com.example.quanlyphongtro.entity;

import java.io.Serializable;
import java.util.UUID;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NguoiDungVaiTroId implements Serializable {
    private UUID nguoiDung;
    private UUID vaiTro;
}
