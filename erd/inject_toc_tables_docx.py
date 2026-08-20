import re
import os
import sys
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import parse_xml, OxmlElement
from docx.oxml.ns import nsdecls, qn

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

DOCX_IN = r"E:\duAnCaNhan\qlyphongtro\SD-26_DATNSP26.docx"
doc = Document(DOCX_IN)

# Clean up typos in body table captions
cleanup_map = {
    'Bảng B.6: Bảng refresh token .': 'Bảng B.6: Bảng refresh token.',
    'Bảng B.7: Bảng email verification token .': 'Bảng B.7: Bảng email verification token.',
    'Bảng B.8: Bảng login history .': 'Bảng B.8: Bảng login history.',
    'Bảng B.11: Nhà trọ': 'Bảng B.11: Bảng nhà trọ.',
    'Bảng B.17: Bảng contract_signature.': 'Bảng B.17: Bảng contract signature.',
    'Bảng B.18: Đặt cọc phòng': 'Bảng B.18: Bảng đặt cọc phòng.',
    'Bảng B.19: Yêu cầu ở ghép.': 'Bảng B.19: Bảng yêu cầu ở ghép.',
    'Bảng B.20: Lịch hẹn.': 'Bảng B.20: Bảng lịch hẹn.',
    'Bảng B.21: Bảng phòng': 'Bảng B.21: Bảng phòng.',
    'Bảng B.36: Bảng tạo hóa đơn tự động': 'Bảng B.36: Bảng tạo hóa đơn tự động.',
    'Bảng B.37: Bảng nhật ký tạo hóa đơn tự động)': 'Bảng B.37: Bảng nhật ký tạo hóa đơn tự động.',
    'Bảng B.50: Bảng trạng thái phát thông báo).': 'Bảng B.50: Bảng trạng thái phát thông báo.',
    'Bảng B.52: Bảng thành viên tham gia trò chuyện': 'Bảng B.52: Bảng thành viên tham gia trò chuyện.'
}

for p in doc.paragraphs:
    txt = p.text.strip()
    if txt in cleanup_map:
        new_txt = cleanup_map[txt]
        p.text = new_txt
        for r in p.runs:
            r.bold = True
            r.font.name = 'Times New Roman'
            r.font.size = Pt(11)

print("Cleaned up body table captions.")

# Helper to add TOC entry with right-aligned dot leader tab stop
def create_toc_entry_p(parent_element, text_left, page_num_str):
    p = OxmlElement('w:p')
    
    # Paragraph properties with Right Tab Stop at 6.5 inches (9360 dxa) with dot leader
    pPr = parse_xml(r'''
        <w:pPr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
            <w:tabs>
                <w:tab w:val="right" w:leader="dot" w:pos="9360"/>
            </w:tabs>
            <w:spacing w:after="60" w:line="240" w:lineRule="auto"/>
        </w:pPr>
    ''')
    p.append(pPr)
    
    # Left text run
    r1 = OxmlElement('w:r')
    rPr1 = parse_xml(r'''
        <w:rPr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
            <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
            <w:sz w:val="21"/>
            <w:color w:val="1E293B"/>
        </w:rPr>
    ''')
    r1.append(rPr1)
    t1 = OxmlElement('w:t')
    t1.text = text_left
    r1.append(t1)
    p.append(r1)
    
    # Tab run
    r_tab = OxmlElement('w:r')
    tab_elem = OxmlElement('w:tab')
    r_tab.append(tab_elem)
    p.append(r_tab)
    
    # Right page number run
    r2 = OxmlElement('w:r')
    rPr2 = parse_xml(r'''
        <w:rPr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
            <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
            <w:sz w:val="21"/>
            <w:color w:val="334155"/>
        </w:rPr>
    ''')
    r2.append(rPr2)
    t2 = OxmlElement('w:t')
    t2.text = str(page_num_str)
    r2.append(t2)
    p.append(r2)
    
    return p

# List of Tables for MỤC LỤC BẢNG with estimated page ranges
table_toc_data = [
    # Chương 1 - 5
    ("Bảng 1.3: Phiên bản tài liệu.", "15"),
    ("Bảng 1.4: Nguồn lực.", "16"),
    ("Bảng 1.3.1: Kế hoạch.", "17"),
    ("Bảng 1.4.4: Bảng khảo sát kết quả.", "33"),
    ("Bảng 2.1.2: Danh sách các Use case.", "41"),
    ("Bảng 2.2.1: Danh sách các thực thể.", "43"),
    ("Bảng 3.1.2: Danh sách các bảng.", "45"),
    ("Bảng 3.2.2: Danh sách các bảng giao diện người dùng.", "48"),
    ("Bảng 4.1.2: Danh sách thư viện sử dụng.", "59"),
    ("Bảng 5.2.1: Kết quả kiểm thử.", "108"),
    
    # Phụ lục A
    ("Bảng A: Ký hiệu sơ đồ Use Case.", "110"),
    ("Bảng A.1: Use Case quản lý tài khoản.", "111"),
    ("Bảng A.2: Use Case quản lý tòa nhà và phòng.", "113"),
    ("Bảng A.3: Use Case quản lý khách thuê.", "116"),
    ("Bảng A.4: Use Case quản lý đặt cọc phòng.", "118"),
    ("Bảng A.5: Use Case quản lý hợp đồng.", "120"),
    ("Bảng A.6: Use Case quản lý dịch vụ và cấu hình giá.", "122"),
    ("Bảng A.7: Use Case quản lý chỉ số điện nước.", "126"),
    ("Bảng A.8: Use Case quản lý hóa đơn.", "128"),
    ("Bảng A.9: Use Case thanh toán và đối soát giao dịch.", "130"),
    ("Bảng A.10: Use Case quản lý sự cố.", "134"),
    ("Bảng A.11: Use Case quản lý tin nhắn.", "136"),
    ("Bảng A.12: Use Case quản lý kho tài sản và tài sản phòng.", "138"),
    ("Bảng A.13: Use Case thống kê và báo cáo.", "140"),
    
    # Phụ lục B
    ("Bảng B.1: Bảng người dùng.", "143"),
    ("Bảng B.2: Bảng vai trò.", "144"),
    ("Bảng B.3: Bảng người dùng vai trò.", "144"),
    ("Bảng B.4: Bảng chủ trọ.", "145"),
    ("Bảng B.5: Bảng người dùng nhà trọ.", "145"),
    ("Bảng B.6: Bảng refresh token.", "146"),
    ("Bảng B.7: Bảng email verification token.", "146"),
    ("Bảng B.8: Bảng login history.", "147"),
    ("Bảng B.9: Bảng chặn người dùng.", "147"),
    ("Bảng B.10: Bảng đăng ký push.", "148"),
    ("Bảng B.11: Bảng nhà trọ.", "148"),
    ("Bảng B.12: Bảng audit log.", "149"),
    ("Bảng B.13: Bảng khách thuê.", "149"),
    ("Bảng B.14: Bảng hợp đồng.", "150"),
    ("Bảng B.15: Bảng thành viên hợp đồng.", "151"),
    ("Bảng B.16: Bảng phụ lục hợp đồng.", "151"),
    ("Bảng B.17: Bảng contract signature.", "152"),
    ("Bảng B.18: Bảng đặt cọc phòng.", "152"),
    ("Bảng B.19: Bảng yêu cầu ở ghép.", "153"),
    ("Bảng B.20: Bảng lịch hẹn.", "153"),
    ("Bảng B.21: Bảng phòng.", "154"),
    ("Bảng B.22: Bảng tiện ích.", "154"),
    ("Bảng B.23: Bảng phòng tiện ích.", "155"),
    ("Bảng B.24: Bảng dịch vụ.", "155"),
    ("Bảng B.25: Bảng dịch vụ hợp đồng.", "156"),
    ("Bảng B.26: Bảng cấu hình giá.", "156"),
    ("Bảng B.27: Bảng cấu hình phí xe.", "157"),
    ("Bảng B.28: Bảng chỉ số điện nước.", "157"),
    ("Bảng B.29: Bảng meter anomaly alert.", "158"),
    ("Bảng B.30: Bảng hóa đơn.", "158"),
    ("Bảng B.31: Bảng chi tiết hóa đơn.", "159"),
    ("Bảng B.32: Bảng lịch sử hóa đơn.", "159"),
    ("Bảng B.33: Bảng thanh toán.", "160"),
    ("Bảng B.34: Bảng lịch thanh toán.", "160"),
    ("Bảng B.35: Bảng giao dịch đối soát ngân hàng.", "161"),
    ("Bảng B.36: Bảng tạo hóa đơn tự động.", "161"),
    ("Bảng B.37: Bảng nhật ký tạo hóa đơn tự động.", "162"),
    ("Bảng B.38: Bảng nhật ký nhắc nợ tự động.", "162"),
    ("Bảng B.39: Bảng sổ quỹ giao dịch tiền cọc.", "163"),
    ("Bảng B.40: Bảng quyết toán thanh lý trả phòng.", "163"),
    ("Bảng B.41: Bảng biên bản kiểm kê bàn giao tài sản.", "164"),
    ("Bảng B.42: Bảng kho tài sản.", "164"),
    ("Bảng B.43: Bảng tài sản phòng.", "165"),
    ("Bảng B.44: Bảng lịch sử xuất nhập kho tài sản.", "165"),
    ("Bảng B.45: Bảng sự cố.", "166"),
    ("Bảng B.46: Bảng phương tiện.", "166"),
    ("Bảng B.47: Bảng lịch sử phương tiện gửi xe.", "167"),
    ("Bảng B.48: Bảng thông báo.", "167"),
    ("Bảng B.49: Bảng danh sách người nhận thông báo.", "168"),
    ("Bảng B.50: Bảng trạng thái phát thông báo.", "168"),
    ("Bảng B.51: Bảng trò chuyện.", "169"),
    ("Bảng B.52: Bảng thành viên tham gia trò chuyện.", "169"),
    ("Bảng B.53: Bảng tin nhắn trao đổi.", "170"),
    ("Bảng B.54: Bảng báo cáo vi phạm tin nhắn.", "170"),
    ("Bảng B.55: Bảng tệp đính kèm & hình ảnh media.", "171")
]

# Find MỤC LỤC BẢNG paragraph and insert elements
target_p = None
for p in doc.paragraphs:
    if p.text.strip() == "MỤC LỤC BẢNG":
        target_p = p
        break

if target_p:
    parent = target_p._element.getparent()
    insert_pos = parent.index(target_p._element) + 1
    
    # Format MỤC LỤC BẢNG Header
    target_p.style = doc.styles['Normal']
    pPr = parse_xml(r'''
        <w:pPr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
            <w:jc w:val="center"/>
            <w:spacing w:before="240" w:after="180"/>
        </w:pPr>
    ''')
    target_p._element.append(pPr)
    for r in target_p.runs:
        r.bold = True
        r.font.name = 'Times New Roman'
        r.font.size = Pt(14)
        r.font.color.rgb = RGBColor(15, 23, 42)
        
    for item_text, page_str in table_toc_data:
        entry_elem = create_toc_entry_p(parent, item_text, page_str)
        parent.insert(insert_pos, entry_elem)
        insert_pos += 1
        
    print(f"Inserted {len(table_toc_data)} table TOC items with dot leaders into document.")

DOCX_OUT = r"E:\duAnCaNhan\qlyphongtro\SD-26_DATNSP26.docx"
DOCX_OUT_DOWNLOADS = r"C:\Users\Admin\Downloads\SD-26_DATNSP26.docx"

doc.save(DOCX_OUT)
doc.save(DOCX_OUT_DOWNLOADS)
print(f"Saved updated docx to {DOCX_OUT} and {DOCX_OUT_DOWNLOADS}")
