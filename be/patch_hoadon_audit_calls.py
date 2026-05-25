import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\HoaDonService.java'
with open(service_file, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('HoaDon saved = hoaDonRepository.save(hd);\n        return toResponse(saved, ctSaved);', 'HoaDon saved = hoaDonRepository.save(hd);\n        logAudit(saved, "CREATE");\n        return toResponse(saved, ctSaved);')

content = content.replace('HoaDon saved = hoaDonRepository.save(hd);\n        return toResponse(saved, chiTietHoaDonRepository.findByHoaDonId(saved.getId()));', 'HoaDon saved = hoaDonRepository.save(hd);\n        logAudit(saved, "UPDATE");\n        return toResponse(saved, chiTietHoaDonRepository.findByHoaDonId(saved.getId()));')

content = content.replace('hoaDonRepository.save(hd);\n    }', 'hoaDonRepository.save(hd);\n        logAudit(hd, "CANCEL");\n    }')

with open(service_file, 'w', encoding='utf-8') as f:
    f.write(content)

print('Modified HoaDonService with audit log calls')
