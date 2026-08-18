import os
import sys
import html
import xml.etree.ElementTree as ET

if sys.stdout.encoding.lower() != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

class BlueTemplateSequenceBuilder:
    def __init__(self, diag_id, name, width=1150, height=1050):
        self.diag_id = diag_id
        self.name = name
        self.width = width
        self.height = height
        self.cells = []
        self.cell_counter = 1

    def _next_id(self, prefix="cell"):
        self.cell_counter += 1
        return f"{prefix}_{self.cell_counter}"

    def add_header_footer_column(self, label, x, top_y=40, bottom_y=880, box_w=140, box_h=46):
        cid = self._next_id("col")
        # Top Box (Light blue background, blue border, bold text)
        self.cells.append(f"""<mxCell id="{cid}_top" value="&lt;b&gt;{html.escape(label)}&lt;/b&gt;" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor=#C5DEFC;strokeColor=#93C5FD;strokeWidth=1;fontSize=12;fontFamily=Helvetica;fontColor=#000000;align=center;verticalAlign=middle;rounded=0;" vertex="1" parent="1">
  <mxGeometry x="{x - box_w // 2}" y="{top_y}" width="{box_w}" height="{box_h}" as="geometry" />
</mxCell>""")

        # Bottom Box (Matching top box)
        self.cells.append(f"""<mxCell id="{cid}_bot" value="&lt;b&gt;{html.escape(label)}&lt;/b&gt;" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor=#C5DEFC;strokeColor=#93C5FD;strokeWidth=1;fontSize=12;fontFamily=Helvetica;fontColor=#000000;align=center;verticalAlign=middle;rounded=0;" vertex="1" parent="1">
  <mxGeometry x="{x - box_w // 2}" y="{bottom_y}" width="{box_w}" height="{box_h}" as="geometry" />
</mxCell>""")

        # Vertical dashed lifeline
        start_y = top_y + box_h
        end_y = bottom_y
        self.cells.append(f"""<mxCell id="{cid}_line" value="" style="endArrow=none;dashed=1;html=1;rounded=0;strokeColor=#94A3B8;strokeWidth=1;dashPattern=4 4;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{x}" y="{start_y}" as="sourcePoint" />
    <mxPoint x="{x}" y="{end_y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")
        return x

    def add_activation_box(self, x, y, height=60, width=12):
        cid = self._next_id("act")
        self.cells.append(f"""<mxCell id="{cid}" value="" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#000000;strokeWidth=1;rounded=0;" vertex="1" parent="1">
  <mxGeometry x="{x - width // 2}" y="{y}" width="{width}" height="{height}" as="geometry" />
</mxCell>""")
        return cid

    def add_request_msg(self, from_x, to_x, y, text):
        cid = self._next_id("req")
        self.cells.append(f"""<mxCell id="{cid}" value="{html.escape(text)}" style="endArrow=block;html=1;rounded=0;strokeColor=#000000;strokeWidth=1;endFill=1;align=center;verticalAlign=bottom;labelBackgroundColor=#ffffff;fontFamily=Helvetica;fontSize=11;fontColor=#000000;spacingBottom=3;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{from_x}" y="{y}" as="sourcePoint" />
    <mxPoint x="{to_x}" y="{y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")

    def add_response_msg(self, from_x, to_x, y, text):
        cid = self._next_id("resp")
        self.cells.append(f"""<mxCell id="{cid}" value="{html.escape(text)}" style="endArrow=open;dashed=1;html=1;rounded=0;strokeColor=#000000;strokeWidth=1;endFill=0;align=center;verticalAlign=bottom;labelBackgroundColor=#ffffff;fontFamily=Helvetica;fontSize=11;fontColor=#000000;dashPattern=3 3;spacingBottom=3;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{from_x}" y="{y}" as="sourcePoint" />
    <mxPoint x="{to_x}" y="{y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")

    def add_caption(self, text, x=540, y=950):
        cid = self._next_id("cap")
        self.cells.append(f"""<mxCell id="{cid}" value="&lt;b style=&quot;font-size:14px;font-style:italic;&quot;&gt;{html.escape(text)}&lt;/b&gt;" style="text;html=1;align=center;verticalAlign=middle;fontSize=14;fontFamily=Times New Roman;fontColor=#000000;" vertex="1" parent="1">
  <mxGeometry x="{x - 300}" y="{y}" width="600" height="30" as="geometry" />
</mxCell>""")

    def render(self):
        cells_xml = "\n        ".join(self.cells)
        return f"""  <diagram id="{self.diag_id}" name="{html.escape(self.name)}">
    <mxGraphModel dx="1422" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="{self.width}" pageHeight="{self.height}" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        {cells_xml}
      </root>
    </mxGraphModel>
  </diagram>"""

# =========================================================================
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN HỢP ĐỒNG KHÁCH THUÊ (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_hop_dong_khach_thue_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("hdkt_chuan_mau", "Sequence diagram hợp đồng khách thuê", width=1100, height=1050)
    
    # 4 Columns: Khách thuê, Frontend, Backend, Database
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: XEM & TẢI HỢP ĐỒNG PDF
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_khach, x_fe, 115, "Xem hợp đồng phòng đang thuê")
    d.add_request_msg(x_fe, x_be, 135, "Tải tài liệu hợp đồng (GET /api/hop-dong/{id}/document)")
    d.add_request_msg(x_be, x_db, 155, "Truy vấn điều khoản, thông tin phòng & chủ trọ")
    d.add_response_msg(x_db, x_be, 185, "Trả về dữ liệu hợp đồng hợp lệ")
    d.add_response_msg(x_be, x_fe, 205, "Trả về nội dung hợp đồng & file PDF")

    # -------------------------------------------------------------
    # BLOCK 2: KÝ ĐIỆN TỬ HỢP ĐỒNG THUÊ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_khach, x_fe, 270, "Xác nhận ký điện tử (vẽ chữ ký số / OTP)")
    d.add_request_msg(x_fe, x_be, 290, "Gửi chữ ký điện tử (POST /api/hop-dong/{id}/sign)")
    d.add_request_msg(x_be, x_db, 310, "Lưu chữ ký số & cập nhật trạng thái hợp đồng (ĐÃ KÝ)")
    d.add_response_msg(x_db, x_be, 340, "Lưu chữ ký thành công")
    d.add_response_msg(x_be, x_fe, 360, "Trả về kết quả hợp đồng đã ký kết")

    # -------------------------------------------------------------
    # BLOCK 3: GỬI YÊU CẦU GIA HẠN HỢP ĐỒNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_khach, x_fe, 425, "Chọn thời gian gia hạn & gửi yêu cầu")
    d.add_request_msg(x_fe, x_be, 445, "Tạo yêu cầu gia hạn hợp đồng (POST /api/yeu-cau-hop-dong)")
    d.add_request_msg(x_be, x_db, 465, "Lưu yêu cầu gia hạn vào hàng đợi (CHỜ DUYỆT)")
    d.add_response_msg(x_db, x_be, 495, "Lưu yêu cầu thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về kết quả gửi yêu cầu & thông báo cho chủ trọ")

    # -------------------------------------------------------------
    # BLOCK 4: GỬI YÊU CẦU TRẢ PHÒNG & QUYẾT TOÁN
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_khach, x_fe, 580, "Chọn ngày dự kiến trả phòng & gửi yêu cầu")
    d.add_request_msg(x_fe, x_be, 600, "Tạo yêu cầu trả phòng (POST /api/yeu-cau-hop-dong)")
    d.add_request_msg(x_be, x_db, 620, "Lưu yêu cầu trả phòng (loai: TRA_PHONG)")
    d.add_response_msg(x_db, x_be, 650, "Lưu yêu cầu thành công")
    d.add_request_msg(x_be, x_db, 680, "Tạo thông báo gửi tới Chủ trọ xếp lịch kiểm kê")
    d.add_response_msg(x_db, x_be, 710, "Gửi thông báo thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về trạng thái yêu cầu trả phòng đang chờ xử lý")
    d.add_response_msg(x_fe, x_khach, 755, "Hiển thị thông báo: Yêu cầu trả phòng đã được tiếp nhận")

    # Caption at bottom
    d.add_caption("Hình 4.2.10: Sequence diagram hợp đồng khách thuê.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: XEM & TẢI HỢP ĐỒNG PDF CHI TIẾT
# =========================================================================
def build_hdkt_xem_tai_pdf_chi_tiet():
    d = BlueTemplateSequenceBuilder("hdkt_xem_tai_pdf", "Sequence Xem & Tải HĐ PDF", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Nhấp xem hợp đồng phòng hiện tại trên Portal")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu tài liệu hợp đồng (GET /api/hop-dong/{id}/document)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra quyền truy cập của khách thuê (kiemTraQuyenDoc)")
    d.add_response_msg(x_db, x_be, 225, "Xác nhận khách thuê sở hữu hợp đồng")
    d.add_request_msg(x_be, x_db, 280, "Lấy điều khoản thuê, thông tin giá, tiền cọc & chữ ký số")
    d.add_response_msg(x_db, x_be, 325, "Trả về toàn bộ dữ liệu hợp đồng")
    d.add_request_msg(x_be, x_be, 375, "Kết xuất nội dung HTML & tạo file PDF hợp đồng")
    d.add_response_msg(x_be, x_fe, 435, "Trả về tài liệu PDF (Content-Type: application/pdf)")
    d.add_response_msg(x_fe, x_khach, 480, "Hiển thị bản xem trước hợp đồng & nút tải file PDF về máy")

    d.add_caption("Hình 4.2.10.1: Sequence diagram khách thuê xem và tải hợp đồng PDF.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: KÝ ĐIỆN TỬ HỢP ĐỒNG CHI TIẾT
# =========================================================================
def build_hdkt_ky_dien_tu_chi_tiet():
    d = BlueTemplateSequenceBuilder("hdkt_ky_dien_tu", "Sequence Ký điện tử HĐ", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Vẽ chữ ký trực tiếp trên màn hình cảm ứng & xác nhận")
    d.add_request_msg(x_fe, x_be, 150, "Gửi chữ ký điện tử (POST /api/hop-dong/{id}/sign)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra trạng thái hợp đồng đang chờ ký (trangThai: CHO_KY)")
    d.add_response_msg(x_db, x_be, 225, "Hợp đồng sẵn sàng ký")
    d.add_request_msg(x_be, x_db, 280, "Lưu dữ liệu chữ ký số vào bảng contract_signature")
    d.add_response_msg(x_db, x_be, 325, "Lưu chữ ký thành công")
    d.add_request_msg(x_be, x_db, 380, "Cập nhật trạng thái hợp đồng sang ACTIVE (ĐANG HIỆU LỰC)")
    d.add_response_msg(x_db, x_be, 420, "Cập nhật trạng thái thành công")
    d.add_response_msg(x_be, x_fe, 465, "Trả về kết quả ký hợp đồng thành công")
    d.add_response_msg(x_fe, x_khach, 500, "Hiển thị thông báo: Hợp đồng đã ký kết thành công")

    d.add_caption("Hình 4.2.10.2: Sequence diagram khách thuê ký điện tử hợp đồng.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 4: GỬI YÊU CẦU GIA HẠN & TRẢ PHÒNG CHI TIẾT
# =========================================================================
def build_hdkt_yeu_cau_gia_han_tra_phong():
    d = BlueTemplateSequenceBuilder("hdkt_yeu_cau", "Sequence Yêu cầu gia hạn/trả phòng", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=360)
    d.add_activation_box(x_be, 150, height=310)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Nhập thông tin yêu cầu (Gia hạn thêm 6 tháng / Trả phòng ngày dd/mm)")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu (POST /api/hop-dong/{id}/yeu-cau)")
    d.add_request_msg(x_be, x_db, 180, "Lưu bản ghi yêu cầu vào bảng yeu_cau_hop_dong (CHO_DUYET)")
    d.add_response_msg(x_db, x_be, 225, "Lưu yêu cầu thành công")
    d.add_request_msg(x_be, x_db, 280, "Tạo thông báo đẩy gửi tới Chủ trọ quản lý")
    d.add_response_msg(x_db, x_be, 325, "Gửi thông báo thành công")
    d.add_request_msg(x_be, x_db, 380, "Cập nhật trạng thái theo dõi trên Dashboard khách")
    d.add_response_msg(x_db, x_be, 420, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 455, "Trả về DTO yêu cầu hợp đồng (YeuCauHopDongResponse)")
    d.add_response_msg(x_fe, x_khach, 490, "Hiển thị trạng thái: Yêu cầu đang chờ chủ trọ phê duyệt")

    d.add_caption("Hình 4.2.10.3: Sequence diagram khách thuê gửi yêu cầu gia hạn và trả phòng.", x=540, y=690)
    return d.render()

def generate_exact_blue_hop_dong_khach_thue_diagrams():
    print("Generating Blue Template Sequence Diagrams for HOP DONG KHACH THUE...")
    t1 = build_hop_dong_khach_thue_exact_sample_diagram()
    t2 = build_hdkt_xem_tai_pdf_chi_tiet()
    t3 = build_hdkt_ky_dien_tu_chi_tiet()
    t4 = build_hdkt_yeu_cau_gia_han_tra_phong()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T18:20:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_HopDongKhachThue.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_HopDongKhachThue.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_hop_dong_khach_thue_diagrams()
