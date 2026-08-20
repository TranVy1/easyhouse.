import re
import os
import sys
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.oxml import parse_xml, OxmlElement
from docx.oxml.ns import nsdecls

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

DOCX_IN = r"E:\duAnCaNhan\qlyphongtro\SD-26_DATNSP26.docx"
doc = Document(DOCX_IN)

# Helper to add TOC entry with right-aligned dot leader tab stop
def create_toc_entry_p(parent_element, text_left, page_num_str):
    p = OxmlElement('w:p')
    pPr = parse_xml(r'''
        <w:pPr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
            <w:tabs>
                <w:tab w:val="right" w:leader="dot" w:pos="9360"/>
            </w:tabs>
            <w:spacing w:after="60" w:line="240" w:lineRule="auto"/>
        </w:pPr>
    ''')
    p.append(pPr)
    
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
    
    r_tab = OxmlElement('w:r')
    tab_elem = OxmlElement('w:tab')
    r_tab.append(tab_elem)
    p.append(r_tab)
    
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

figure_toc_data = [
    ("Hình 1.4.1: Khảo sát tại TingTong", "29"),
    ("Hình 1.4.2: Khảo sát offline tòa nhà cho thuê tại Cầu Giấy", "31"),
    ("Hình 2.1.1: Use case tổng", "40"),
    ("Hình 2.2.1: Sơ đồ quan hệ thực thể", "43"),
    ("Hình 3.1.1: Danh sách bảng", "44"),
    ("Hình 3.2.1: Sơ đồ giao diện người dùng", "47"),
    ("Hình 4.1.1: Sơ đồ tổ chức", "58"),
    ("Hình 4.2.1: Sequence diagram tòa nhà", "60"),
    ("Hình 4.2.2: Sequence diagram phòng", "61"),
    ("Hình 4.2.3: Sequence diagram hợp đồng", "62"),
    ("Hình 4.2.4: Sequence diagram cấu hình giá", "63"),
    ("Hình 4.2.5: Sequence diagram hoá đơn", "64"),
    ("Hình 4.2.6: Sequence diagram thanh toán", "65"),
    ("Hình 4.2.7: Sequence diagram tin nhắn", "66"),
    ("Hình 4.2.8: Sequence diagram sự cố", "67"),
    ("Hình 4.2.9: Sequence diagram khách thuê", "68"),
    ("Hình 4.2.10: Sequence diagram hợp đồng khách thuê", "69"),
    ("Hình 4.2.11: Sequence diagram hoá đơn khách thuê", "70"),
    ("Hình 6.1.1: Màn hình trang chủ", "72"),
    ("Hình 6.1.2: Màn hình toà nhà", "74"),
    ("Hình 6.1.3: Màn hình danh sách hợp đồng", "77"),
    ("Hình 6.1.4: Màn hình chi tiết hợp đồng", "77"),
    ("Hình 6.1.5: Màn hình hoá đơn", "80"),
    ("Hình 6.1.6: Màn hình thanh toán", "82"),
    ("Hình 6.1.7: Màn hình chat hỗ trợ", "86"),
    ("Hình 6.1.8: Màn hình chat AI", "89"),
    ("Hình 6.2.1: Giao diện trang chủ khách thuê", "92"),
    ("Hình 6.2.2: Giao diện hợp đồng khách thuê", "87"),
    ("Hình 6.2.3: Giao diện hoá đơn khách thuê", "88"),
    ("Hình 6.2.4: Giao diện chat hỗ trợ khách thuê", "89"),
    ("Hình A.1.1: Use Case quản lý tài khoản", "111"),
    ("Hình A.1.2: Activity Diagram quản lý tài khoản", "112"),
    ("Hình A.2.1: Use Case quản lý tòa nhà và phòng", "113"),
    ("Hình A.2.2: Activity Diagram quản lý tòa nhà và phòng", "115"),
    ("Hình A.3.1: Use Case quản lý khách thuê", "116"),
    ("Hình A.3.2: Activity Diagram quản lý khách thuê", "117"),
    ("Hình A.4.1: Use Case quản lý đặt cọc phòng", "118"),
    ("Hình A.4.2: Activity Diagram đặt cọc và chuyển thành hợp đồng", "119"),
    ("Hình A.5.1: Use Case quản lý hợp đồng thuê", "120"),
    ("Hình A.5.2: Activity Diagram quản lý vòng đời hợp đồng", "121"),
    ("Hình A.6.1: Use Case quản lý dịch vụ và cấu hình giá", "122"),
    ("Hình A.6.2: Activity Diagram cấu hình và áp dụng giá", "123"),
    ("Hình A.7.1: Use Case quản lý phương tiện và biểu phí xe", "124"),
    ("Hình A.7.2: Activity Diagram đăng ký phương tiện và tính phí", "125"),
    ("Hình A.8.1: Use Case quản lý chỉ số điện nước", "126"),
    ("Hình A.8.2: Activity Diagram ghi chỉ số điện nước", "127"),
    ("Hình A.9.1: Use Case quản lý hóa đơn", "128"),
    ("Hình A.9.2: Activity Diagram lập và phát hành hóa đơn", "129"),
    ("Hình A.10.1: Use Case thanh toán và đối soát giao dịch", "130"),
    ("Hình A.10.2: Activity Diagram thanh toán hóa đơn", "131"),
    ("Hình A.11.1: Use Case quản lý công nợ", "132"),
    ("Hình A.11.2: Activity Diagram nhắc nợ hóa đơn", "133"),
    ("Hình A.12.1: Use Case quản lý sự cố", "134"),
    ("Hình A.12.2: Activity Diagram tiếp nhận và xử lý sự cố", "135"),
    ("Hình A.13.1: Use Case quản lý tin nhắn và thông báo", "136"),
    ("Hình A.13.2: Activity Diagram nhắn tin và kiểm duyệt", "137"),
    ("Hình A.14.1: Use Case quản lý kho tài sản và tài sản phòng", "138"),
    ("Hình A.14.2: Activity Diagram cấp phát và thu hồi tài sản", "139"),
    ("Hình A.15.1: Use Case thống kê và báo cáo", "140"),
    ("Hình A.15.2: Activity Diagram lập báo cáo", "141"),
    ("Hình B.1: Sơ đồ quan hệ thực thể (ERD)", "142")
]

# Find MỤC LỤC ẢNH
target_img_p = None
for p in doc.paragraphs:
    if p.text.strip() == "MỤC LỤC ẢNH":
        target_img_p = p
        break

if target_img_p:
    parent = target_img_p._element.getparent()
    insert_pos = parent.index(target_img_p._element) + 1
    
    pPr = parse_xml(r'''
        <w:pPr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
            <w:jc w:val="center"/>
            <w:spacing w:before="240" w:after="180"/>
        </w:pPr>
    ''')
    target_img_p._element.append(pPr)
    for r in target_img_p.runs:
        r.bold = True
        r.font.name = 'Times New Roman'
        r.font.size = Pt(14)
        r.font.color.rgb = RGBColor(15, 23, 42)
        
    for item_text, page_str in figure_toc_data:
        entry_elem = create_toc_entry_p(parent, item_text, page_str)
        parent.insert(insert_pos, entry_elem)
        insert_pos += 1
        
    print(f"Inserted {len(figure_toc_data)} figure TOC items with dot leaders into document.")

DOCX_OUT = r"E:\duAnCaNhan\qlyphongtro\SD-26_DATNSP26.docx"
DOCX_OUT_DOWNLOADS = r"C:\Users\Admin\Downloads\SD-26_DATNSP26.docx"

doc.save(DOCX_OUT)
doc.save(DOCX_OUT_DOWNLOADS)
print("Saved both updated docx files successfully!")
