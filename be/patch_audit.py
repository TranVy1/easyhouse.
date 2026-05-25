import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\HopDongService.java'
with open(service_file, 'rb') as f:
    data = f.read()

append_code = """
    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;

    private void logAudit(HopDong hd, String hanhDong) {
        if (auditLogRepository == null) return;
        com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
            .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .hanhDong(hanhDong)
            .bangTacDong("hop_dong")
            .banGhiId(hd.getId())
            .taoLuc(java.time.ZonedDateTime.now())
            .build();
        auditLogRepository.save(log);
    }
}
"""
last_brace_idx = data.rfind(b'}')
if last_brace_idx != -1:
    new_data = data[:last_brace_idx] + append_code.encode('utf-8')
    with open(service_file, 'wb') as f:
        f.write(new_data)
    print('Modified HopDongService.java with audit log')
