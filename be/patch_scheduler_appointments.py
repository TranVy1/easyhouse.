import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\SchedulerService.java'
with open(service_file, 'rb') as f:
    data = f.read()

append_code = """
    /**
     * Chay moi gio de quet lich hen trong vong 24h toi de gui email nhac nho.
     */
    @Scheduled(cron = "0 0 * * * ?")
    @Transactional
    public void checkUpcomingAppointments() {
        log.info("Dang kiem tra lich hen sap dien ra...");
        java.time.ZonedDateTime now = java.time.ZonedDateTime.now();
        java.time.ZonedDateTime next24h = now.plusHours(24);
        
        List<com.example.quanlyphongtro.entity.LichHen> upcoming = lichHenRepository.findUpcomingAppointments(
            List.of(com.example.quanlyphongtro.entity.TrangThaiLichHen.PENDING, com.example.quanlyphongtro.entity.TrangThaiLichHen.CONFIRMED),
            now, next24h
        );
        
        for (com.example.quanlyphongtro.entity.LichHen lh : upcoming) {
            log.info("Gui nhac nho lich hen {} vao luc {}", lh.getId(), lh.getNgayHen());
            emailService.sendAppointmentReminderEmail(lh);
            lh.setDaGuiNhacNho(true);
            lichHenRepository.save(lh);
        }
    }
}
"""
last_brace_idx = data.rfind(b'}')
if last_brace_idx != -1:
    new_data = data[:last_brace_idx] + append_code.encode('utf-8')
    with open(service_file, 'wb') as f:
        f.write(new_data)
    print('Added checkUpcomingAppointments to SchedulerService.java')

with open(service_file, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace('private final HoaDonRepository hoaDonRepository;', 'private final HoaDonRepository hoaDonRepository;\n    private final com.example.quanlyphongtro.repository.LichHenRepository lichHenRepository;')
with open(service_file, 'w', encoding='utf-8') as f:
    f.write(content)
print('Injected LichHenRepository to SchedulerService.java')
