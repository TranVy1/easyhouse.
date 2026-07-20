import sys

file_path = r'f:\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\services\HoaDonService.java'
with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

def fix_line(line_no, new_str):
    idx = line_no - 1
    # Find the string inside quotes and replace it
    start = lines[idx].find('"')
    if start != -1:
        end = lines[idx].find('"', start + 1)
        if end != -1:
            # wait, some strings have concatenation like `"abc " + ...`
            # better to replace the whole line from `throw new RuntimeException("...` to the end of the statement.
            pass

lines[77-1] = '            throw new RuntimeException("Tháng hóa đơn không hợp lệ");\n'
lines[80-1] = '            throw new RuntimeException("Năm hóa đơn không hợp lệ");\n'
lines[106-1] = '            throw new RuntimeException("Hóa đơn đã bị xóa");\n'
lines[117-1] = '            throw new RuntimeException("Hóa đơn đã bị xóa");\n'
lines[129-1] = '            throw new RuntimeException("Số tiền đã thanh toán chỉ được cập nhật thông qua module thanh toán.");\n'
lines[169-1] = '            throw new RuntimeException("Hóa đơn đã bị xóa");\n'
lines[173-1] = '            throw new RuntimeException("Không thể sửa hóa đơn đã có giao dịch thanh toán");\n'
lines[195-1] = '            throw new RuntimeException("Số tiền đã thanh toán chỉ được cập nhật qua module thanh toán");\n'
lines[228-1] = '            throw new RuntimeException("Không thể xóa hóa đơn đã có giao dịch thanh toán");\n'
lines[299-1] = '            throw new RuntimeException("Hóa đơn bắt buộc chọn hợp đồng hợp lệ");\n'
lines[302-1] = '            throw new RuntimeException("Hợp đồng nháp hoặc đã hủy không được lập hóa đơn");\n'
lines[308-1] = '            throw new RuntimeException("Hợp đồng thiếu phòng hoặc khách thuê, không thể lập hóa đơn");\n'
lines[340-1] = '            throw new RuntimeException("Bạn không có quyền xem hóa đơn này");\n'
lines[346-1] = '            throw new RuntimeException("Bạn không có quyền sửa hóa đơn này");\n'
lines[370-1] = '            throw new RuntimeException("Bạn không có quyền xem hợp đồng này");\n'
lines[376-1] = '            throw new RuntimeException("Bạn không có quyền lập hóa đơn cho hợp đồng này");\n'
lines[436-1] = '                throw new RuntimeException("Hóa đơn phải có ít nhất một dòng chi tiết");\n'
lines[464-1] = '            throw new RuntimeException("Hóa đơn phải có ít nhất một dòng chi tiết");\n'
lines[497-1] = '            throw new RuntimeException("Cần nhập đủ chỉ số cũ và mới cho " + moTa.toLowerCase(Locale.ROOT));\n'
lines[501-1] = '            throw new RuntimeException("Chỉ số điện nước không hợp lệ");\n'
lines[504-1] = '            throw new RuntimeException("Số tiêu thụ thực tế không hợp lệ");\n'
lines[512-1] = '            throw new RuntimeException("Chưa có đơn giá hợp lệ cho " + moTa.toLowerCase(Locale.ROOT));\n'
lines[592-1] = '            throw new RuntimeException("Chỉ số " + loai.name() + " của phòng trong kỳ này đã được ghi cho hợp đồng khác");\n'
lines[704-1] = '            throw new RuntimeException("Hợp đồng đã có hóa đơn trong kỳ " + kyThang + "/" + kyNam);\n'
lines[726-1] = '            throw new RuntimeException("Hóa đơn phải đúng " + label + " của hợp đồng");\n'
lines[732-1] = '            throw new RuntimeException("Kỳ hóa đơn không hợp lệ");\n'
lines[738-1] = '            throw new RuntimeException("Vui lòng nhập đủ ngày hóa đơn");\n'
lines[741-1] = '            throw new RuntimeException("Đến ngày phải sau hoặc bằng từ ngày");\n'
lines[744-1] = '            throw new RuntimeException("Hạn trả không được trước từ ngày");\n'
lines[747-1] = '            throw new RuntimeException("Kỳ hóa đơn nằm trước ngày bắt đầu hợp đồng");\n'
lines[750-1] = '            throw new RuntimeException("Kỳ hóa đơn nằm sau ngày kết thúc hợp đồng");\n'
lines[781-1] = '                    throw new RuntimeException("Trạng thái hóa đơn không hợp lệ: " + value);\n'
lines[794-1] = '            throw new RuntimeException("ID không hợp lệ");\n'
lines[814-1] = '            throw new RuntimeException("Loại mục hóa đơn là bắt buộc");\n'
lines[819-1] = '            throw new RuntimeException("Loại mục hóa đơn không hợp lệ: " + value);\n'
lines[825-1] = '            throw new RuntimeException("Số lượng hóa đơn không hợp lệ");\n'
lines[828-1] = '            throw new RuntimeException("Đơn giá hóa đơn không hợp lệ");\n'
lines[831-1] = '            throw new RuntimeException("Thành tiền hóa đơn không hợp lệ");\n'
lines[837-1] = '            throw new RuntimeException("Thành tiền hóa đơn không được âm");\n'
lines[844-1] = '            throw new RuntimeException(label + " không được âm");\n'


with open(file_path, 'w', encoding='utf-8') as f:
    f.writelines(lines)
print('Done!')
