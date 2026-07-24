package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.VaiTroHeThong;
import lombok.Data;
import java.util.UUID;
import java.util.List;

@Data
public class UserRoleAssignmentRequest {
    private List<VaiTroHeThong> roles;
}
