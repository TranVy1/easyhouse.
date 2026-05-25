import os

service_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\HopDongService.java'
with open(service_file, 'rb') as f:
    data = f.read()

append_code = """
    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.PhuLucHopDongRepository phuLucHopDongRepository;

    @Transactional
    public com.example.quanlyphongtro.dto.HopDongResponse extendContract(java.util.UUID id, com.example.quanlyphongtro.dto.GiaHanHopDongRequest req) {
        HopDong hd = hopDongRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay hop dong"));
        assertCanWriteNhaTro(hd.getPhong().getNhaTro(), permissionService.requireCurrentUserId());
        
        if (req.getNgayKetThucMoi() == null) {
            throw new RuntimeException("Ngay ket thuc moi khong duoc de trong");
        }
        if (req.getNgayHieuLuc() == null) {
            throw new RuntimeException("Ngay hieu luc khong duoc de trong");
        }
        if (req.getNgayKetThucMoi().isBefore(hd.getNgayBatDau())) {
            throw new RuntimeException("Ngay ket thuc phai sau ngay bat dau");
        }
        
        ensureNoOverlappingOccupancy(hd.getPhong().getId(), hd.getNgayBatDau(), req.getNgayKetThucMoi(), id, hd.getTrangThai());

        com.example.quanlyphongtro.entity.PhuLucHopDong pl = com.example.quanlyphongtro.entity.PhuLucHopDong.builder()
            .hopDong(hd)
            .loai("GIA_HAN")
            .noiDung(req.getNoiDung() != null ? req.getNoiDung() : "Gia han hop dong")
            .ngayHieuLuc(req.getNgayHieuLuc())
            .ngayKetThucMoi(req.getNgayKetThucMoi())
            .giaThueMoi(req.getGiaThueMoi())
            .nguoiTao(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .build();
        phuLucHopDongRepository.save(pl);

        hd.setNgayKetThuc(req.getNgayKetThucMoi());
        if (req.getGiaThueMoi() != null) {
            hd.setGiaThueHopDong(req.getGiaThueMoi());
        }
        hd = hopDongRepository.save(hd);
        logAudit(hd, "EXTEND");
        
        return com.example.quanlyphongtro.dto.HopDongResponse.fromEntity(hd);
    }
}
"""
last_brace_idx = data.rfind(b'}')
if last_brace_idx != -1:
    new_data = data[:last_brace_idx] + append_code.encode('utf-8')
    with open(service_file, 'wb') as f:
        f.write(new_data)
    print('Modified HopDongService.java to add extendContract')
