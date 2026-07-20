import sys

file_path = r'f:\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\HoaDonService.java'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

replacements = {
    'ThÃ¡ng hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡': 'Tháng hóa đơn không hợp lệ',
    'NÄƒm hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡': 'Năm hóa đơn không hợp lệ',
    'KhÃ´ng tÃ¬m tháº¥y hÃ³a Ä‘Æ¡n': 'Không tìm thấy hóa đơn',
    'HÃ³a Ä‘Æ¡n Ä‘Ã£ bá»‹ xÃ³a': 'Hóa đơn đã bị xóa',
    'Hoa don da bi xoa': 'Hóa đơn đã bị xóa',
    'KhÃ´ng thá»ƒ sá»­a hÃ³a Ä‘Æ¡n Ä‘Ã£ cÃ³ giao dá»‹ch thanh toÃ¡n': 'Không thể sửa hóa đơn đã có giao dịch thanh toán',
    'So tien da thanh toan chi duoc cap nhat qua module thanh toan': 'Số tiền đã thanh toán chỉ được cập nhật qua module thanh toán',
    'KhÃ´ng thá»ƒ xÃ³a hÃ³a Ä‘Æ¡n Ä‘Ã£ cÃ³ giao dá»‹ch thanh toÃ¡n': 'Không thể xóa hóa đơn đã có giao dịch thanh toán',
    'HÃ³a Ä‘Æ¡n báº¯t buá»™c chá» n há»£p Ä‘á»“ng há»£p lá»‡': 'Hóa đơn bắt buộc chọn hợp đồng hợp lệ',
    'Há»£p Ä‘á»“ng nhÃ¡p hoáº·c Ä‘Ã£ há»§y khÃ´ng Ä‘Æ°á»£c láºp hÃ³a Ä‘Æ¡n': 'Hợp đồng nháp hoặc đã hủy không được lập hóa đơn',
    'Há»£p Ä‘á»“ng thiáº¿u phÃ²ng hoáº·c khÃ¡ch thuÃª, khÃ´ng thá»ƒ láºp hÃ³a Ä‘Æ¡n': 'Hợp đồng thiếu phòng hoặc khách thuê, không thể lập hóa đơn',
    'Ban khong co quyen xem hoa don nay': 'Bạn không có quyền xem hóa đơn này',
    'Ban khong co quyen sua hoa don nay': 'Bạn không có quyền sửa hóa đơn này',
    'Ban khong co quyen xem hop dong nay': 'Bạn không có quyền xem hợp đồng này',
    'Ban khong co quyen lap hoa don cho hop dong nay': 'Bạn không có quyền lập hóa đơn cho hợp đồng này',
    'HÃ³a Ä‘Æ¡n pháº£i cÃ³ Ã­t nháº¥t má»™t dÃ²ng chi tiáº¿t': 'Hóa đơn phải có ít nhất một dòng chi tiết',
    'Cáº§n nháº­p Ä‘á»§ chá»‰ sá»‘ cÅ© vÃ má»›i cho ': 'Cần nhập đủ chỉ số cũ và mới cho ',
    'Chá»‰ sá»‘ Ä‘iá»‡n nÆ°á»›c khÃ´ng há»£p lá»‡': 'Chỉ số điện nước không hợp lệ',
    'Sá»‘ tiÃªu thá»¥ thá»±c táº¿ khÃ´ng há»£p lá»‡': 'Số tiêu thụ thực tế không hợp lệ',
    'ChÆ°a cÃ³ Ä‘Æ¡n giÃ¡ há»£p lá»‡ cho ': 'Chưa có đơn giá hợp lệ cho ',
    'Chá»‰ sá»‘ ': 'Chỉ số ',
    ' cá»§a phÃ²ng trong ká»³ nÃ y Ä‘Ã£ Ä‘Æ°á»£c ghi cho há»£p Ä‘á»“ng khÃ¡c': ' của phòng trong kỳ này đã được ghi cho hợp đồng khác',
    'Há»£p Ä‘á»“ng Ä‘Ã£ cÃ³ hÃ³a Ä‘Æ¡n trong ká»³ ': 'Hợp đồng đã có hóa đơn trong kỳ ',
    'HÃ³a Ä‘Æ¡n pháº£i Ä‘Ãºng ': 'Hóa đơn phải đúng ',
    ' cá»§a há»£p Ä‘á»“ng': ' của hợp đồng',
    'Ká»³ hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡': 'Kỳ hóa đơn không hợp lệ',
    'Vui lÃ²ng nháº­p Ä‘á»§ ngÃ y hÃ³a Ä‘Æ¡n': 'Vui lòng nhập đủ ngày hóa đơn',
    'Ä áº¿n ngÃ y pháº£i sau hoáº·c báº±ng tá»« ngÃ y': 'Đến ngày phải sau hoặc bằng từ ngày',
    'Háº¡n tráº£ khÃ´ng Ä‘Æ°á»£c trÆ°á»›c tá»« ngÃ y': 'Hạn trả không được trước từ ngày',
    'Ká»³ hÃ³a Ä‘Æ¡n náº±m trÆ°á»›c ngÃ y báº¯t Ä‘áº§u há»£p Ä‘á»“ng': 'Kỳ hóa đơn nằm trước ngày bắt đầu hợp đồng',
    'Ká»³ hÃ³a Ä‘Æ¡n náº±m sau ngÃ y káº¿t thÃºc há»£p Ä‘á»“ng': 'Kỳ hóa đơn nằm sau ngày kết thúc hợp đồng',
    'Tráº¡ng thÃ¡i hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡: ': 'Trạng thái hóa đơn không hợp lệ: ',
    'ID khong hop le': 'ID không hợp lệ',
    'Loáº¡i má»¥c hÃ³a Ä‘Æ¡n lÃ báº¯t buá»™c': 'Loại mục hóa đơn là bắt buộc',
    'Loáº¡i má»¥c hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡: ': 'Loại mục hóa đơn không hợp lệ: ',
    'Sá»‘ lÆ°á»£ng hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡': 'Số lượng hóa đơn không hợp lệ',
    'Ä Æ¡n giÃ¡ hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡': 'Đơn giá hóa đơn không hợp lệ',
    'ThÃ nh tiá» n hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡': 'Thành tiền hóa đơn không hợp lệ',
    'ThÃ nh tiá» n hÃ³a Ä‘Æ¡n khÃ´ng Ä‘Æ°á»£c Ã¢m': 'Thành tiền hóa đơn không được âm',
    ' khÃ´ng Ä‘Æ°á»£c Ã¢m': ' không được âm',
    'Sá»‘ dÆ° Ä‘áº§u ká»³': 'Số dư đầu kỳ',
    'Tráº¡ng thÃ¡i hÃ³a Ä‘Æ¡n khÃ´ng há»£p lá»‡': 'Trạng thái hóa đơn không hợp lệ'
}

for k, v in replacements.items():
    content = content.replace(k, v)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
