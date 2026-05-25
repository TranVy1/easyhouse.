import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\ThongBaoService.java'
with open(service_file, 'rb') as f:
    data = f.read()

append_code = """
    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.services.PermissionService permissionService;

    @Transactional(readOnly = true)
    public List<ThongBaoResponse> getMyThongBao() {
        UUID currentUserId = permissionService.requireCurrentUserId();
        
        List<ThongBaoNguoiNhan> myRecipients = thongBaoNguoiNhanRepository.findByNguoiDungId(currentUserId);
        List<UUID> myThongBaoIds = myRecipients.stream().map(r -> r.getThongBao().getId()).toList();
        
        return thongBaoRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .filter(tb -> tb.isGuiTatCa() || myThongBaoIds.contains(tb.getId()))
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
}
"""
last_brace_idx = data.rfind(b'}')
if last_brace_idx != -1:
    new_data = data[:last_brace_idx] + append_code.encode('utf-8')
    with open(service_file, 'wb') as f:
        f.write(new_data)
    print('Added getMyThongBao to ThongBaoService.java')
