import os
service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\ThanhToanService.java'
with open(service_file, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('return toResponse(saved, chiTietHoaDonRepository.findByHoaDonId(hoaDon.getId()));', 'logAudit(saved, "CREATE");\n        return toResponse(saved, chiTietHoaDonRepository.findByHoaDonId(hoaDon.getId()));')

content = content.replace('return toResponse(saved, newHoaDonId != null ? chiTietHoaDonRepository.findByHoaDonId(newHoaDonId) : Collections.emptyList());', 'logAudit(saved, "UPDATE");\n        return toResponse(saved, newHoaDonId != null ? chiTietHoaDonRepository.findByHoaDonId(newHoaDonId) : Collections.emptyList());')

content = content.replace('thanhToanRepository.save(tt);\n        \n        if (hdId != null) recalculate(hdId);', 'thanhToanRepository.save(tt);\n        logAudit(tt, "CANCEL");\n        if (hdId != null) recalculate(hdId);')

with open(service_file, 'w', encoding='utf-8') as f:
    f.write(content)

print('Modified ThanhToanService with audit log calls')
