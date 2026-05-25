import os
import re

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\ThanhToanService.java'
with open(service_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the delete method
old_delete = """    @Transactional
    public void delete(UUID id) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));
        assertCanWriteHoaDon(tt.getHoaDon(), permissionService.requireCurrentUserId());
        UUID hdId = tt.getHoaDon() != null ? tt.getHoaDon().getId() : null;
        thanhToanRepository.delete(tt);
        if (hdId != null) recalculate(hdId);
    }"""

new_delete = """    @Transactional
    public void delete(UUID id) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));
        assertCanWriteHoaDon(tt.getHoaDon(), permissionService.requireCurrentUserId());
        UUID hdId = tt.getHoaDon() != null ? tt.getHoaDon().getId() : null;
        
        // Chuyển delete vật lý thành cancel
        tt.setTrangThai(TrangThaiThanhToan.CANCELLED);
        tt.setXoaLuc(ZonedDateTime.now()); // Vẫn đánh dấu xóa mềm để ẩn khỏi các list thông thường nếu cần, hoặc chỉ dùng CANCELLED
        thanhToanRepository.save(tt);
        
        if (hdId != null) recalculate(hdId);
    }"""

content = content.replace(old_delete, new_delete)

with open(service_file, 'w', encoding='utf-8') as f:
    f.write(content)

print('Modified ThanhToanService.java')
