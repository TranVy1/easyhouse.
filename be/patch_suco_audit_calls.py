import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\SuCoService.java'
with open(service_file, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('SuCo saved = suCoRepository.save(sc);\n        mediaService.replaceUrl(LoaiDoiTuongMedia.INCIDENT, saved.getId(), req.getHinhAnh(), MediaService.INCIDENT_PHOTO);\n        return toResponse(saved);', 'SuCo saved = suCoRepository.save(sc);\n        mediaService.replaceUrl(LoaiDoiTuongMedia.INCIDENT, saved.getId(), req.getHinhAnh(), MediaService.INCIDENT_PHOTO);\n        logAudit(saved, "CREATE");\n        return toResponse(saved);')

content = content.replace('SuCo saved = suCoRepository.save(sc);\n        if (req.getHinhAnh() != null) {\n            mediaService.replaceUrl(LoaiDoiTuongMedia.INCIDENT, saved.getId(), req.getHinhAnh(), MediaService.INCIDENT_PHOTO);\n        }\n        return toResponse(saved);', 'SuCo saved = suCoRepository.save(sc);\n        if (req.getHinhAnh() != null) {\n            mediaService.replaceUrl(LoaiDoiTuongMedia.INCIDENT, saved.getId(), req.getHinhAnh(), MediaService.INCIDENT_PHOTO);\n        }\n        logAudit(saved, "UPDATE");\n        return toResponse(saved);')

content = content.replace('sc.setXoaLuc(ZonedDateTime.now());\n        suCoRepository.save(sc);\n    }', 'sc.setXoaLuc(ZonedDateTime.now());\n        suCoRepository.save(sc);\n        logAudit(sc, "DELETE");\n    }')

with open(service_file, 'w', encoding='utf-8') as f:
    f.write(content)

print('Modified SuCoService with audit log calls')
