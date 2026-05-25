import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\CauHinhGiaService.java'
with open(service_file, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('CauHinhGia saved = cauHinhGiaRepository.save(chg);\n        return CauHinhGiaResponse.fromEntity(saved);', 'CauHinhGia saved = cauHinhGiaRepository.save(chg);\n        logAudit(saved, "CREATE");\n        return CauHinhGiaResponse.fromEntity(saved);')

content = content.replace('CauHinhGia saved = cauHinhGiaRepository.save(chg);\n        return CauHinhGiaResponse.fromEntity(saved);', 'CauHinhGia saved = cauHinhGiaRepository.save(chg);\n        logAudit(saved, "UPDATE");\n        return CauHinhGiaResponse.fromEntity(saved);')

content = content.replace('cauHinhGiaRepository.save(chg);\n    }', 'cauHinhGiaRepository.save(chg);\n        logAudit(chg, "DELETE");\n    }')

with open(service_file, 'w', encoding='utf-8') as f:
    f.write(content)

print('Modified CauHinhGiaService with audit log calls')
