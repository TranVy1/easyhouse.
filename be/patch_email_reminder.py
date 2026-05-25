import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\EmailService.java'
with open(service_file, 'rb') as f:
    data = f.read()

append_code = """
    public void sendAppointmentReminderEmail(com.example.quanlyphongtro.entity.LichHen lh) {
        if (lh == null || lh.getEmail() == null || lh.getEmail().isBlank()) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(lh.getEmail());
            message.setSubject("[EasyHouse] Nhac nho lich hen xem phong " + (lh.getPhong() != null ? lh.getPhong().getTen() : ""));
            
            String thoiGian = lh.getNgayHen() != null ? lh.getNgayHen().toString() : "";
            
            message.setText(
                "Xin chao " + lh.getHoTen() + ",\\n\\n" +
                "EasyHouse xin nhac nho ban co mot lich hen xem phong sap dien ra.\\n" +
                "Thong tin chi tiet:\\n" +
                "- Phong: " + (lh.getPhong() != null ? lh.getPhong().getTen() : "N/A") + "\\n" +
                "- Thoi gian: " + thoiGian + "\\n\\n" +
                "Vui long den dung gio de duoc ho tro tot nhat.\\n" +
                "Tran trong,\\nBan quan ly EasyHouse"
            );
            mailSender.send(message);
            log.info("Appointment reminder email sent to {}", lh.getEmail());
        } catch (Exception e) {
            log.error("Failed to send appointment reminder email to {}: {}", lh.getEmail(), e.getMessage());
        }
    }
}
"""
last_brace_idx = data.rfind(b'}')
if last_brace_idx != -1:
    new_data = data[:last_brace_idx] + append_code.encode('utf-8')
    with open(service_file, 'wb') as f:
        f.write(new_data)
    print('Added sendAppointmentReminderEmail to EmailService.java')
