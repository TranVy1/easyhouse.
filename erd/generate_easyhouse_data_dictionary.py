import re
import os
import sys
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml
from docx.oxml.ns import nsdecls

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

# Import parsed tables
from parse_easyhouse_schema import tables

# Vietnamese description dictionary for columns and tables
table_vn_names = {
    'nguoi_dung': 'Người dùng (Tài khoản hệ thống)',
    'vai_tro': 'Vai trò & Quyền hạn',
    'nguoi_dung_vai_tro': 'Phân quyền người dùng',
    'chu_tro': 'Chủ nhà trọ',
    'nguoi_dung_nha_tro': 'Phân quyền quản lý nhà trọ',
    'refresh_token': 'Token làm mới phiên đăng nhập',
    'email_verification_token': 'Token xác thực email',
    'login_history': 'Lịch sử đăng nhập',
    'chan_nguoi_dung': 'Danh sách chặn người dùng',
    'dang_ky_push': 'Đăng ký nhận thông báo đẩy (Push)',
    'audit_log': 'Nhật ký kiểm toán hệ thống (Audit Log)',
    'nha_tro': 'Nhà trọ / Tòa nhà',
    'tang': 'Tầng trong nhà trọ',
    'phong': 'Phòng trọ',
    'tien_ich': 'Danh mục tiện ích',
    'phong_tien_ich': 'Tiện ích thuộc phòng',
    'khach_thue': 'Khách thuê phòng',
    'hop_dong': 'Hợp đồng thuê phòng',
    'thanh_vien_hop_dong': 'Thành viên cùng ở trong hợp đồng',
    'phu_luc_hop_dong': 'Phụ lục hợp đồng',
    'contract_signature': 'Chữ ký điện tử hợp đồng',
    'dat_coc_phong': 'Phiếu giữ phòng & Đặt cọc',
    'yeu_cau_o_ghep': 'Yêu cầu tìm bạn ở ghép',
    'lich_hen': 'Lịch hẹn xem phòng',
    'dich_vu': 'Danh mục dịch vụ',
    'dich_vu_hop_dong': 'Dịch vụ đăng ký theo hợp đồng',
    'cau_hinh_gia': 'Cấu hình đơn giá dịch vụ & điện nước',
    'cau_hinh_phi_xe': 'Cấu hình phí gửi xe',
    'chi_so_dien_nuoc': 'Chỉ số điện nước định kỳ',
    'meter_anomaly_alert': 'Cảnh báo chỉ số điện nước bất thường',
    'hoa_don': 'Hóa đơn tiền phòng & dịch vụ',
    'chi_tiet_hoa_don': 'Chi tiết các khoản phí trong hóa đơn',
    'lich_su_hoa_don': 'Lịch sử trạng thái hóa đơn',
    'thanh_toan': 'Giao dịch thanh toán hóa đơn',
    'lich_thanh_toan': 'Lịch thanh toán định kỳ',
    'bank_transaction': 'Giao dịch đối soát ngân hàng (VietQR)',
    'invoice_generation_batch': 'Đợt tạo hóa đơn tự động',
    'invoice_generation_log': 'Nhật ký tạo hóa đơn tự động',
    'debt_reminder_log': 'Nhật ký nhắc nợ tự động',
    'giao_dich_tien_coc': 'Sổ quỹ giao dịch tiền cọc',
    'quyet_toan_tra_phong': 'Quyết toán thanh lý trả phòng',
    'chi_tiet_ban_giao_tai_san': 'Biên bản kiểm kê bàn giao tài sản',
    'kho_tai_san': 'Kho tài sản & Thiết bị tổng',
    'tai_san_phong': 'Tài sản & Thiết bị bố trí tại phòng',
    'lich_su_kho_tai_san': 'Lịch sử xuất nhập kho tài sản',
    'su_co': 'Báo cáo sự cố & Hư hỏng',
    'phuong_tien': 'Phương tiện gửi tại nhà trọ',
    'lich_su_phuong_tien': 'Lịch sử phương tiện gửi xe',
    'thong_bao': 'Thông báo hệ thống / Tòa nhà',
    'thong_bao_nguoi_nhan': 'Danh sách người nhận thông báo',
    'notification_delivery': 'Trạng thái phát thông báo',
    'cuoc_tro_chuyen': 'Cuộc trò chuyện (Chat room)',
    'thanh_vien_cuoc_tro_chuyen': 'Thành viên tham gia trò chuyện',
    'tin_nhan': 'Tin nhắn trao đổi',
    'bao_cao_tin_nhan': 'Báo cáo vi phạm tin nhắn',
    'file_media': 'Tệp đính kèm & Hình ảnh media'
}

column_descriptions = {
    'id': 'Khóa chính định danh duy nhất của bản ghi.',
    'nguoi_dung_id': 'Mã người dùng (tài khoản hệ thống) liên kết.',
    'chu_tro_id': 'Mã chủ trọ sở hữu hoặc quản lý.',
    'khach_thue_id': 'Mã khách thuê phòng liên kết.',
    'nha_tro_id': 'Mã nhà trọ / tòa nhà liên kết.',
    'tang_id': 'Mã tầng trong tòa nhà.',
    'phong_id': 'Mã phòng trọ liên kết.',
    'hop_dong_id': 'Mã hợp đồng thuê liên kết.',
    'hoa_don_id': 'Mã hóa đơn liên kết.',
    'thanh_toan_id': 'Mã giao dịch thanh toán liên kết.',
    'quyet_toan_tra_phong_id': 'Mã quyết toán trả phòng liên kết.',
    'dich_vu_id': 'Mã dịch vụ liên kết.',
    'kho_tai_san_id': 'Mã tài sản trong kho tổng.',
    'tai_san_phong_id': 'Mã tài sản tại phòng liên kết.',
    'su_co_id': 'Mã sự cố liên kết.',
    'cuoc_tro_chuyen_id': 'Mã cuộc trò chuyện liên kết.',
    'thong_bao_id': 'Mã thông báo liên kết.',
    'vai_tro_id': 'Mã vai trò quyền hạn.',
    'email': 'Địa chỉ email liên hệ và đăng nhập.',
    'so_dien_thoai': 'Số điện thoại liên hệ.',
    'mat_khau_hash': 'Mật khẩu đã được băm mã hóa bảo mật (BCrypt).',
    'ho_ten': 'Họ và tên đầy đủ.',
    'ho_ten_dem': 'Họ và tên đệm.',
    'ten': 'Tên chính.',
    'cccd': 'Số Căn cước công dân / Hộ chiếu.',
    'ngay_sinh': 'Ngày tháng năm sinh.',
    'gioi_tinh': 'Giới tính (NAM, NU, KHAC).',
    'que_quan': 'Quê quán / Địa chỉ thường trú.',
    'anh_dai_dien': 'Đường dẫn ảnh đại diện (avatar).',
    'trang_thai': 'Trạng thái hoạt động của bản ghi.',
    'tao_luc': 'Thời điểm tạo bản ghi.',
    'cap_nhat_luc': 'Thời điểm cập nhật bản ghi gần nhất.',
    'xoa_luc': 'Thời điểm xóa mềm (soft delete) nếu có.',
    'ghi_chu': 'Ghi chú thêm thông tin.',
    'ma_phong': 'Mã định danh phòng trọ (VD: P101, P202).',
    'ten_phong': 'Tên hiển thị phòng trọ.',
    'gia_thue': 'Đơn giá thuê phòng mỗi tháng (VNĐ).',
    'tien_coc': 'Số tiền đặt cọc thuê phòng (VNĐ).',
    'dien_tich': 'Diện tích phòng (m²).',
    'so_nguoi_toi_da': 'Số lượng người ở tối đa cho phép.',
    'ma_hop_dong': 'Mã số hợp đồng thuê phòng.',
    'ngay_bat_dau': 'Ngày bắt đầu có hiệu lực.',
    'ngay_ket_thuc': 'Ngày kết thúc theo hợp đồng.',
    'ngay_ket_thuc_thuc_te': 'Ngày kết thúc và trả phòng thực tế.',
    'chi_so_dien_ban_dau': 'Chỉ số điện tại thời điểm bàn giao bắt đầu.',
    'chi_so_nuoc_ban_dau': 'Chỉ số nước tại thời điểm bàn giao bắt đầu.',
    'chi_so_dien_cuoi_ky': 'Chỉ số điện chốt cuối kỳ.',
    'chi_so_nuoc_cuoi_ky': 'Chỉ số nước chốt cuối kỳ.',
    'so_dien_tieu_thu': 'Số lượng điện tiêu thụ trong kỳ (kWh).',
    'so_nuoc_tieu_thu': 'Số lượng nước tiêu thụ trong kỳ (m³).',
    'don_gia_dien': 'Đơn giá điện áp dụng (VNĐ/kWh).',
    'don_gia_nuoc': 'Đơn giá nước áp dụng (VNĐ/m³).',
    'tong_tien': 'Tổng số tiền cần thanh toán (VNĐ).',
    'da_tra': 'Số tiền thực tế đã thanh toán (VNĐ).',
    'con_lai': 'Số tiền còn nợ lại chưa trả (VNĐ).',
    'ma_hoa_don': 'Mã số hóa đơn thanh toán.',
    'ky_thang': 'Kỳ hóa đơn theo tháng.',
    'ky_nam': 'Kỳ hóa đơn theo năm.',
    'han_dong_tien': 'Hạn chót thanh toán tiền phòng & dịch vụ.',
    'ma_giao_dich': 'Mã tham chiếu giao dịch ngân hàng / cổng thanh toán.',
    'noi_dung': 'Nội dung chi tiết thông báo / tin nhắn / sự cố.',
    'tieu_de': 'Tiêu đề thông báo / sự cố.'
}

# Domain Groups
groups = [
    {
        'title': 'NHÓM 1: NGƯỜI DÙNG, XÁC THỰC & CHỦ TRỌ',
        'tables': ['nguoi_dung', 'vai_tro', 'nguoi_dung_vai_tro', 'chu_tro', 'nguoi_dung_nha_tro', 'refresh_token', 'email_verification_token', 'login_history', 'chan_nguoi_dung', 'dang_ky_push', 'audit_log']
    },
    {
        'title': 'NHÓM 2: TÒA NHÀ, TẦNG & PHÒNG TRỌ',
        'tables': ['nha_tro', 'tang', 'phong', 'tien_ich', 'phong_tien_ich']
    },
    {
        'title': 'NHÓM 3: KHÁCH THUÊ & HỢP ĐỒNG THUÊ',
        'tables': ['khach_thue', 'hop_dong', 'thanh_vien_hop_dong', 'phu_luc_hop_dong', 'contract_signature', 'dat_coc_phong', 'yeu_cau_o_ghep', 'lich_hen']
    },
    {
        'title': 'NHÓM 4: DỊCH VỤ & CHỈ SỐ ĐIỆN NƯỚC',
        'tables': ['dich_vu', 'dich_vu_hop_dong', 'cau_hinh_gia', 'cau_hinh_phi_xe', 'chi_so_dien_nuoc', 'meter_anomaly_alert']
    },
    {
        'title': 'NHÓM 5: HÓA ĐƠN, THANH TOÁN & QUYẾT TOÁN TRẢ PHÒNG',
        'tables': ['hoa_don', 'chi_tiet_hoa_don', 'lich_su_hoa_don', 'thanh_toan', 'lich_thanh_toan', 'bank_transaction', 'invoice_generation_batch', 'invoice_generation_log', 'debt_reminder_log', 'giao_dich_tien_coc', 'quyet_toan_tra_phong', 'chi_tiet_ban_giao_tai_san']
    },
    {
        'title': 'NHÓM 6: TÀI SẢN, SỰ CỐ & PHƯƠNG TIỆN',
        'tables': ['kho_tai_san', 'tai_san_phong', 'lich_su_kho_tai_san', 'su_co', 'phuong_tien', 'lich_su_phuong_tien']
    },
    {
        'title': 'NHÓM 7: THÔNG BÁO, TIN NHẮN & MEDIA',
        'tables': ['thong_bao', 'thong_bao_nguoi_nhan', 'notification_delivery', 'cuoc_tro_chuyen', 'thanh_vien_cuoc_tro_chuyen', 'tin_nhan', 'bao_cao_tin_nhan', 'file_media']
    }
]

def format_type(t):
    t_clean = t.upper()
    if 'CHARACTER VARYING' in t_clean:
        return t_clean.replace('CHARACTER VARYING', 'VARCHAR')
    if 'TIMESTAMP' in t_clean:
        return 'TIMESTAMPTZ' if 'TIME ZONE' in t_clean or 'TZ' in t_clean else 'TIMESTAMP'
    if 'NUMERIC' in t_clean:
        return t_clean.replace('NUMERIC', 'DECIMAL')
    return t_clean

def get_desc(tname, cname):
    if cname in column_descriptions:
        return column_descriptions[cname]
    if cname.endswith('_id'):
        ref = cname[:-3]
        return f"Mã liên kết tới bảng {ref}."
    if cname.startswith('is_') or cname.startswith('da_') or cname.startswith('co_'):
        return f"Cờ đánh dấu trạng thái ({cname})."
    if 'gia_' in cname or 'tien_' in cname or 'phi_' in cname:
        return f"Số tiền / Đơn giá ({cname}) tính theo VNĐ."
    if 'ngay_' in cname or 'thoi_gian_' in cname:
        return f"Ngày / Thời gian ghi nhận ({cname})."
    if 'so_luong' in cname:
        return f"Số lượng ({cname})."
    return f"Thông tin trường {cname} của bảng {tname}."

def get_constraint(c):
    parts = []
    if c['is_pk']:
        parts.append('PK')
    if c['is_fk']:
        parts.append('FK')
    if c['is_unique'] and not c['is_pk']:
        parts.append('Unique')
    if c['is_not_null'] and not c['is_pk']:
        parts.append('Not null')
    if not parts:
        return '-'
    return ', '.join(parts)

# Generate Markdown
md_out = []
md_out.append('# TỪ ĐIỂN DỮ LIỆU CƠ SỞ DỮ LIỆU HỆ THỐNG EASYHOUSE (DATA DICTIONARY)\n')
md_out.append('> Tài liệu đặc tả chi tiết 56 bảng cơ sở dữ liệu dự án EasyHouse theo chuẩn 5 cột (STT, Tên trường, Kiểu dữ liệu, Mô tả, Ràng buộc).\n\n')

table_count = 1
for g in groups:
    md_out.append(f"## {g['title']}\n")
    for tname in g['tables']:
        if tname not in tables:
            continue
        cols = tables[tname]
        vn_title = table_vn_names.get(tname, tname)
        md_out.append(f"### {table_count}. Bảng: `{tname}` ({vn_title})")
        md_out.append("| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |")
        md_out.append("| :--- | :--- | :--- | :--- | :--- |")
        for idx, c in enumerate(cols, 1):
            c_type = format_type(c['type'])
            c_desc = get_desc(tname, c['name'])
            c_cons = get_constraint(c)
            md_out.append(f"| {idx} | `{c['name']}` | {c_type} | {c_desc} | {c_cons} |")
        md_out.append("\n---\n")
        table_count += 1

MD_FILE_PATH = os.path.join(os.path.dirname(__file__), '..', 'data_dictionary_easyhouse.md')
with open(MD_FILE_PATH, 'w', encoding='utf-8') as f:
    f.write('\n'.join(md_out))

print(f"Generated EasyHouse Data Dictionary Markdown: {MD_FILE_PATH}")

# Also generate Word Docx
doc = Document()
for section in doc.sections:
    section.top_margin = Inches(0.7)
    section.bottom_margin = Inches(0.7)
    section.left_margin = Inches(0.7)
    section.right_margin = Inches(0.7)

style = doc.styles['Normal']
font = style.font
font.name = 'Times New Roman'
font.size = Pt(11)
font.color.rgb = RGBColor(33, 37, 41)

def set_cell_background(cell, fill_hex):
    tcPr = cell._element.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
    tcPr.append(shd)

def set_cell_margins(cell, top=100, bottom=100, left=130, right=130):
    tcPr = cell._element.get_or_add_tcPr()
    tcMar = parse_xml(f'''
        <w:tcMar {nsdecls("w")}>
            <w:top w:w="{top}" w:type="dxa"/>
            <w:bottom w:w="{bottom}" w:type="dxa"/>
            <w:left w:w="{left}" w:type="dxa"/>
            <w:right w:w="{right}" w:type="dxa"/>
        </w:tcMar>
    ''')
    tcPr.append(tcMar)

def set_table_borders(table):
    tblPr = table._element.xpath('w:tblPr')
    if tblPr:
        borders = parse_xml(f'''
            <w:tblBorders {nsdecls("w")}>
                <w:top w:val="single" w:sz="6" w:space="0" w:color="CCCCCC"/>
                <w:bottom w:val="single" w:sz="6" w:space="0" w:color="CCCCCC"/>
                <w:insideH w:val="single" w:sz="4" w:space="0" w:color="E5E7EB"/>
                <w:insideV w:val="none"/>
                <w:left w:val="none"/>
                <w:right w:val="none"/>
            </w:tblBorders>
        ''')
        tblPr[0].append(borders)

# Doc Title
title_p = doc.add_paragraph()
title_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
run = title_p.add_run("TỪ ĐIỂN DỮ LIỆU HỆ THỐNG QUẢN LÝ NHÀ TRỌ EASYHOUSE")
run.bold = True
run.font.size = Pt(16)
run.font.color.rgb = RGBColor(15, 23, 42)

sub_p = doc.add_paragraph()
sub_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
run_sub = sub_p.add_run("Mô tả cấu trúc 56 bảng cơ sở dữ liệu (PostgreSQL - EasyHouse System)")
run_sub.italic = True
run_sub.font.size = Pt(11)
run_sub.font.color.rgb = RGBColor(100, 116, 139)
doc.add_paragraph()

tbl_idx = 1
for g in groups:
    h1_p = doc.add_paragraph()
    run_h1 = h1_p.add_run(g['title'])
    run_h1.bold = True
    run_h1.font.size = Pt(13)
    run_h1.font.color.rgb = RGBColor(2, 132, 199)
    h1_p.paragraph_format.space_before = Pt(14)
    h1_p.paragraph_format.space_after = Pt(6)
    
    for tname in g['tables']:
        if tname not in tables:
            continue
        cols = tables[tname]
        vn_title = table_vn_names.get(tname, tname)
        
        h2_p = doc.add_paragraph()
        run_h2 = h2_p.add_run(f"{tbl_idx}. Bảng: {tname} ({vn_title})")
        run_h2.bold = True
        run_h2.font.size = Pt(11.5)
        run_h2.font.color.rgb = RGBColor(15, 23, 42)
        h2_p.paragraph_format.space_before = Pt(10)
        h2_p.paragraph_format.space_after = Pt(4)
        
        # Create Table
        table = doc.add_table(rows=len(cols) + 1, cols=5)
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        set_table_borders(table)
        
        col_widths = [Inches(0.5), Inches(1.8), Inches(1.3), Inches(2.8), Inches(0.9)]
        headers = ['STT', 'Tên trường', 'Kiểu dữ liệu', 'Mô tả', 'Ràng buộc']
        
        # Header Row
        for c_i, h_text in enumerate(headers):
            cell = table.cell(0, c_i)
            cell.text = h_text
            set_cell_background(cell, "F1F5F9")
            set_cell_margins(cell, top=120, bottom=120, left=120, right=120)
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER if c_i in [0, 4] else WD_ALIGN_PARAGRAPH.LEFT
            for r in p.runs:
                r.bold = True
                r.font.size = Pt(10)
                r.font.color.rgb = RGBColor(30, 41, 59)
                
        # Data Rows
        for r_i, c in enumerate(cols):
            c_type = format_type(c['type'])
            c_desc = get_desc(tname, c['name'])
            c_cons = get_constraint(c)
            
            row_vals = [str(r_i + 1), c['name'], c_type, c_desc, c_cons]
            for c_i, val in enumerate(row_vals):
                cell = table.cell(r_i + 1, c_i)
                cell.text = val
                set_cell_margins(cell, top=80, bottom=80, left=120, right=120)
                p = cell.paragraphs[0]
                p.alignment = WD_ALIGN_PARAGRAPH.CENTER if c_i in [0, 4] else WD_ALIGN_PARAGRAPH.LEFT
                for r in p.runs:
                    r.font.size = Pt(9.5)
                    if c_i == 1:
                        r.bold = True
                        r.font.color.rgb = RGBColor(15, 23, 42)
                    elif c_i == 4 and 'PK' in val:
                        r.bold = True
                        r.font.color.rgb = RGBColor(220, 38, 38)
                    elif c_i == 4 and 'FK' in val:
                        r.bold = True
                        r.font.color.rgb = RGBColor(37, 99, 235)
                    elif c_i == 4 and 'Not null' in val:
                        r.font.color.rgb = RGBColor(16, 185, 129)
                    else:
                        r.font.color.rgb = RGBColor(71, 85, 105)
                        
        for row in table.rows:
            for idx, width in enumerate(col_widths):
                row.cells[idx].width = width
                
        doc.add_paragraph()
        tbl_idx += 1

OUTPUT_DOCX = r"C:\Users\Admin\Downloads\Tu_Dien_Du_Lieu_EasyHouse.docx"
doc.save(OUTPUT_DOCX)
print(f"Generated EasyHouse Docx successfully: {OUTPUT_DOCX}")
