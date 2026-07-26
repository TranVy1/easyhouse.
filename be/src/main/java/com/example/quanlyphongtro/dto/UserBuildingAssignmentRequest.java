package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.VaiTroHeThong;
import lombok.Data;
import java.util.UUID;
import java.util.List;

@Data
public class UserBuildingAssignmentRequest {
    private List<BuildingAssignment> assignments;

    @Data
    public static class BuildingAssignment {
        private UUID nhaTroId;
        private VaiTroHeThong vaiTro;
        private Boolean coQuyenXem = true;
        private Boolean coQuyenSua = false;
        private Boolean coQuyenThuTien = false;
    }
}
