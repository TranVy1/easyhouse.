package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;
import java.util.UUID;

/** Chuyen tiep mot tin sang mot hoac nhieu hoi thoai khac. */
@Data
public class ChuyenTiepRequest {

    /**
     * Gioi han 20 dich mot lan: chuyen tiep hang loat la duong spam re nhat, va
     * moi dich deu sinh mot tin + mot lan ban WebSocket.
     */
    @NotEmpty(message = "Phai chon it nhat mot hoi thoai")
    @Size(max = 20, message = "Chi chuyen tiep toi da 20 hoi thoai mot lan")
    private List<UUID> hoiThoaiIds;
}
