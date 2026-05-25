import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\FileMediaService.java'
with open(service_file, 'rb') as f:
    data = f.read()

append_code = """
    private void validateFile(MultipartFile file) {
        if (file.isEmpty()) {
            throw new RuntimeException("Tep khong duoc de trong");
        }
        if (file.getSize() > 10 * 1024 * 1024) {
            throw new RuntimeException("Tep qua lon. Kich thuoc toi da la 10MB");
        }
        String contentType = file.getContentType();
        if (contentType == null || (!contentType.startsWith("image/") && !contentType.startsWith("application/"))) {
            throw new RuntimeException("Loai tep khong duoc ho tro. Chi chap nhan anh va tai lieu");
        }
    }
}
"""
last_brace_idx = data.rfind(b'}')
if last_brace_idx != -1:
    new_data = data[:last_brace_idx] + append_code.encode('utf-8')
    with open(service_file, 'wb') as f:
        f.write(new_data)
    print('Added validateFile to FileMediaService.java')

with open(service_file, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace('Map<String, Object> result = cloudinaryService.uploadFile(file);', 'validateFile(file);\n        Map<String, Object> result = cloudinaryService.uploadFile(file);')
with open(service_file, 'w', encoding='utf-8') as f:
    f.write(content)
print('Injected validateFile to FileMediaService.java')
