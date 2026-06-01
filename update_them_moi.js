const fs = require('fs');
const path = 'frontend/src/app/(dashboard)/dashboard/hop-dong/them-moi/page.tsx';
let content = fs.readFileSync(path, 'utf8');

// 1. Thêm import
const importDocx = "import { generateAndDownloadHopDong } from '@/lib/export-hop-dong';\n";
if (!content.includes('generateAndDownloadHopDong')) {
  content = content.replace("import { HopDong, Phong, KhachThue, ToaNha } from '@/types';", importDocx + "import { HopDong, Phong, KhachThue, ToaNha } from '@/types';");
}

// 2. Thêm state openPreviewModal
if (!content.includes('openPreviewModal')) {
  content = content.replace('const [openAddKhachThue, setOpenAddKhachThue] = useState(false);', 'const [openAddKhachThue, setOpenAddKhachThue] = useState(false);\n  const [openPreviewModal, setOpenPreviewModal] = useState(false);');
}

// 3. Sửa handleSubmit -> handleConfirmAndSave
const handleSubmitStr = 'const handleSubmit = async (e: React.FormEvent) => {';
const newHandleSubmitStr = `const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!validateContractForm()) return;
    setOpenPreviewModal(true);
  };

  const handleConfirmAndSave = async () => {`;
content = content.replace(handleSubmitStr, newHandleSubmitStr);

// Thay thế đoạn e.preventDefault() và validateContractForm trong handleConfirmAndSave
content = content.replace('e.preventDefault();\n    if (!validateContractForm()) return;\n\n    setSubmitting(true);', 'setSubmitting(true);');

// 4. Cập nhật logic sau khi tạo Hợp đồng thành công
const successStr = "toast.success(result.message || 'Thêm hợp đồng thành công');\n        router.push('/dashboard/hop-dong');";
const newSuccessStr = `toast.success(result.message || 'Thêm hợp đồng thành công');
        try {
          const phongObj = phongList.find(p => p._id === formData.phong);
          const toaNhaObj = nhaTroList.find(t => t._id === selectedNhaTro);
          const phongInfo = {
            maPhong: phongObj?.maPhong || '',
            toaNha: toaNhaObj?.tenToaNha || ''
          };
          const nguoiDaiDienObj = khachThueList.find(k => k._id === formData.nguoiDaiDien);
          const nguoiDaiDienName = nguoiDaiDienObj?.hoTen || '';
          
          await generateAndDownloadHopDong(
            { ...formData, ...result.data, ngayTao: new Date().toISOString() }, 
            phongInfo,
            nguoiDaiDienName,
            nguoiDaiDienObj,
            formatCurrency
          );
        } catch (err) {
          console.error("Error exporting docx", err);
          toast.error("Lưu thành công nhưng lỗi tạo file Hợp đồng");
        }
        setOpenPreviewModal(false);
        router.push('/dashboard/hop-dong');`;
content = content.replace(successStr, newSuccessStr);

// 5. Đổi text nút Tạo hợp đồng mới -> Xem trước hợp đồng
content = content.replace("Tạo hợp đồng mới", "Xem trước hợp đồng");
// Replace text in button
content = content.replace(/{submitting \? \(\n\s*<>\n\s*<Loader2 className="h-4 w-4 mr-2 animate-spin" \/>\n\s*Đang lưu...\n\s*<\/>\n\s*\) : \(\n\s*<>\n\s*<Save className="h-4 w-4 mr-2" \/>\n\s*Tạo hợp đồng mới\n\s*<\/>\n\s*\)}/g, 
  `{submitting ? (
                  <>
                    <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                    Đang xử lý...
                  </>
                ) : (
                  <>
                    <Save className="h-4 w-4 mr-2" />
                    Xem trước hợp đồng
                  </>
                )}`
);

// 6. Thêm Modal JSX
const modalStr = `      {/* Modal Preview Hop Dong */}
      <Dialog open={openPreviewModal} onOpenChange={setOpenPreviewModal}>
        <DialogContent className="sm:max-w-[800px] h-[80vh] flex flex-col">
          <DialogHeader>
            <DialogTitle>Xem trước Hợp đồng</DialogTitle>
          </DialogHeader>
          <div className="flex-1 overflow-y-auto p-4 border rounded-md bg-white text-black">
            <div className="max-w-2xl mx-auto space-y-4 font-serif text-sm">
              <div className="text-center font-bold">
                CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM<br/>
                Độc lập - Tự do - Hạnh phúc
              </div>
              <h2 className="text-xl font-bold text-center mt-6 mb-4">HỢP ĐỒNG THUÊ PHÒNG TRỌ</h2>
              <p className="font-bold">1. Đại diện bên cho thuê (Bên A):</p>
              <p>Ban Quản Lý Tòa Nhà</p>
              
              <p className="font-bold mt-4">2. Bên thuê phòng trọ (Bên B):</p>
              <p>Ông/Bà: {khachThueList.find(k => k._id === formData.nguoiDaiDien)?.hoTen || '[Chưa chọn]'}</p>
              <p>SĐT: {khachThueList.find(k => k._id === formData.nguoiDaiDien)?.soDienThoai}</p>
              <p>CCCD: {khachThueList.find(k => k._id === formData.nguoiDaiDien)?.cccd}</p>
              
              <div className="font-bold mt-4">3. Điều khoản thỏa thuận:</div>
              <p>- Cho thuê phòng: <strong>{phongList.find(p => p._id === formData.phong)?.maPhong}</strong> tại {nhaTroList.find(t => t._id === selectedNhaTro)?.tenToaNha}</p>
              <p>- Giá thuê: <strong>{formatCurrency(Number(formData.giaThue))}</strong> /tháng (Thanh toán vào ngày {formData.ngayThanhToan} hàng tháng)</p>
              <p>- Tiền đặt cọc: <strong>{formatCurrency(Number(formData.tienCoc))}</strong></p>
              <p>- Tiền điện: {formatCurrency(Number(formData.giaDien))}/kWh</p>
              <p>- Tiền nước: {formatCurrency(Number(formData.giaNuoc))}</p>
              {formData.phiDichVu.length > 0 && (
                <div>
                  <p>- Phí dịch vụ bổ sung:</p>
                  <ul className="list-disc pl-5">
                    {formData.phiDichVu.map((phi, i) => (
                      <li key={i}>{phi.ten}: {formatCurrency(phi.gia)}</li>
                    ))}
                  </ul>
                </div>
              )}
              <p>- Thời hạn: Từ ngày {formData.ngayBatDau} đến {formData.ngayKetThuc}</p>
              <div className="mt-8 text-center text-xs text-muted-foreground italic border-t pt-4">
                (Nội dung đầy đủ chi tiết sẽ được xuất vào file Hợp Đồng DOCX sau khi Xác nhận)
              </div>
            </div>
          </div>
          <DialogFooter className="mt-4 gap-2">
            <Button type="button" variant="outline" onClick={() => setOpenPreviewModal(false)} disabled={submitting}>Quay lại chỉnh sửa</Button>
            <Button onClick={handleConfirmAndSave} disabled={submitting}>
              {submitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Xác nhận, Lưu & In Hợp đồng
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
`;

content = content.replace('{/* Modal Quick Add Khách Thuê */}', modalStr + '\n      {/* Modal Quick Add Khách Thuê */}');

fs.writeFileSync(path, content, 'utf8');
console.log('Updated them-moi/page.tsx');
