package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
public class TaoNhomRequest {

    @NotBlank(message = "Nhom phai co ten")
    @Size(max = 120, message = "Ten nhom toi da 120 ky tu")
    private String ten;

    /**
     * Nguoi duoc moi. Nguoi tao tu dong la thanh vien nen khong can liet ke.
     * Moi nguoi trong day deu phai cung pham vi nha tro voi nguoi tao.
     */
    @NotEmpty(message = "Phai chon it nhat mot thanh vien")
    private List<UUID> thanhVienIds;

    /** Pham vi nha tro cua nhom. Bo trong thi lay nha tro dau tien cua nguoi tao. */
    private UUID nhaTroId;
}
