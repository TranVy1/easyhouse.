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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN HÓA ĐƠN (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_hoa_don_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("hoa_don_chuan_mau", "Sequence diagram hoá đơn", width=1100, height=1050)
    
    # 4 Columns: Chủ trọ, Frontend, Backend, Database
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: LẬP HÓA ĐƠN HÀNG THÁNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_chutro, x_fe, 115, "Nhập chỉ số điện/nước & chốt tiền tháng")
    d.add_request_msg(x_fe, x_be, 135, "Tạo hóa đơn (Tiền phòng, Điện, Nước, Dịch vụ)")
    d.add_request_msg(x_be, x_db, 155, "Lưu hóa đơn và chi tiết hóa đơn")
    d.add_response_msg(x_db, x_be, 185, "Hóa đơn đã tạo thành công")
    d.add_response_msg(x_be, x_fe, 205, "Trả thông tin hóa đơn")

    # -------------------------------------------------------------
    # BLOCK 2: XEM & TÌM KIẾM DANH SÁCH HÓA ĐƠN
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_chutro, x_fe, 270, "Lọc hóa đơn theo tháng và trạng thái")
    d.add_request_msg(x_fe, x_be, 290, "Truy vấn danh sách hóa đơn")
    d.add_request_msg(x_be, x_db, 310, "Lấy dữ liệu hóa đơn theo tòa nhà")
    d.add_response_msg(x_db, x_be, 340, "Danh sách hóa đơn và công nợ")
    d.add_response_msg(x_be, x_fe, 360, "Trả kết quả danh sách hóa đơn")

    # -------------------------------------------------------------
    # BLOCK 3: PHÁT HÀNH & GỬI THÔNG BÁO NHẮC NỢ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_chutro, x_fe, 425, "Phát hành hóa đơn & gửi thông báo cho khách")
    d.add_request_msg(x_fe, x_be, 445, "Phát hành hóa đơn")
    d.add_request_msg(x_be, x_db, 465, "Cập nhật trạng thái (CHỜ THANH TOÁN)")
    d.add_response_msg(x_db, x_be, 495, "Phát hành thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về kết quả phát hành & gửi thông báo")

    # -------------------------------------------------------------
    # BLOCK 4: XÁC NHẬN THANH TOÁN & CẬP NHẬT CÔNG NỢ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_chutro, x_fe, 580, "Xác nhận thu tiền mặt / chuyển khoản")
    d.add_request_msg(x_fe, x_be, 600, "Thực hiện thanh toán hóa đơn")
    d.add_request_msg(x_be, x_db, 620, "Lưu giao dịch thanh toán (thanh_toan)")
    d.add_response_msg(x_db, x_be, 650, "Ghi nhận thanh toán thành công")
    d.add_request_msg(x_be, x_db, 680, "Cập nhật trạng thái hóa đơn (ĐÃ THANH TOÁN)")
    d.add_response_msg(x_db, x_be, 710, "Cập nhật công nợ thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về kết quả thanh toán")
    d.add_response_msg(x_fe, x_chutro, 755, "Hiển thị thông tin hóa đơn chi tiết đã thanh toán")

    # Caption at bottom
    d.add_caption("Hình 4.2.5: Sequence diagram hoá đơn.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: LẬP HÓA ĐƠN CHI TIẾT
# =========================================================================
def build_hoa_don_them_chi_tiet():
    d = BlueTemplateSequenceBuilder("hoa_don_them_chi_tiet", "Sequence Lập hóa đơn chi tiết", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập chỉ số điện/nước mới & các chi phí phát sinh")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu tạo hóa đơn (POST /api/hoa-don)")
    d.add_request_msg(x_be, x_db, 180, "Lấy chỉ số cũ & bảng đơn giá dịch vụ (CauHinhGia)")
    d.add_response_msg(x_db, x_be, 225, "Trả về chỉ số cũ & đơn giá điện, nước")
    d.add_request_msg(x_be, x_db, 280, "Lưu bản ghi hóa đơn (hoa_don: CHUA_THANH_TOAN)")
    d.add_response_msg(x_db, x_be, 325, "Lưu hóa đơn thành công (UUID id)")
    d.add_request_msg(x_be, x_db, 380, "Lưu các dòng chi tiết hóa đơn (chi_tiet_hoa_don)")
    d.add_response_msg(x_db, x_be, 420, "Lưu chi tiết hóa đơn thành công")
    d.add_response_msg(x_be, x_fe, 465, "Trả về thông tin hóa đơn hoàn chỉnh (HoaDonResponse)")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị thông báo: Tạo hóa đơn thành công")

    d.add_caption("Hình 4.2.5.1: Sequence diagram lập hóa đơn hàng tháng.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: THANH TOÁN HÓA ĐƠN CHI TIẾT
# =========================================================================
def build_hoa_don_thanh_toan_chi_tiet():
    d = BlueTemplateSequenceBuilder("hoa_don_thanh_toan_chi_tiet", "Sequence Thanh toán hóa đơn", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập số tiền thanh toán, phương thức (Tiền mặt/Chuyển khoản) & đính kèm ảnh")
    d.add_request_msg(x_fe, x_be, 150, "Gửi thanh toán hóa đơn (POST /api/hoa-don/{id}/thanh-toan)")
    d.add_request_msg(x_be, x_db, 180, "Lưu giao dịch thanh toán vào bảng thanh_toan")
    d.add_response_msg(x_db, x_be, 225, "Lưu giao dịch thành công")
    d.add_request_msg(x_be, x_db, 280, "Cộng dồn số tiền đã trả (da_tra = da_tra + soTien)")
    d.add_response_msg(x_db, x_be, 325, "Cập nhật số tiền đã trả thành công")
    d.add_request_msg(x_be, x_db, 380, "Cập nhật trạng thái hóa đơn (DA_THANH_TOAN)")
    d.add_response_msg(x_db, x_be, 420, "Cập nhật trạng thái thành công")
    d.add_response_msg(x_be, x_fe, 465, "Trả về DTO hóa đơn sau thanh toán")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị biên lai thu tiền & cập nhật công nợ phòng")

    d.add_caption("Hình 4.2.5.2: Sequence diagram thanh toán hóa đơn.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 4: KHÁCH THUÊ XEM & THANH TOÁN TRỰC TUYẾN
# =========================================================================
def build_hoa_don_khach_thue_portal():
    d = BlueTemplateSequenceBuilder("hoa_don_khach_portal", "Sequence Khách xem & thanh toán", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=350)
    d.add_activation_box(x_be, 150, height=295)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 290, height=55)

    d.add_request_msg(x_khach, x_fe, 120, "Truy cập Cổng khách thuê & xem hóa đơn tiền phòng tháng này")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu chi tiết hóa đơn (GET /api/hoa-don/{id})")
    d.add_request_msg(x_be, x_db, 180, "Truy vấn chi tiết tiền phòng, điện, nước & số tiền cần đóng")
    d.add_response_msg(x_db, x_be, 225, "Trả về dữ liệu hóa đơn")
    d.add_request_msg(x_khach, x_fe, 260, "Quét mã VietQR chuyển khoản hoặc thanh toán VNPay")
    d.add_request_msg(x_fe, x_be, 290, "Xác nhận giao dịch thanh toán trực tuyến")
    d.add_request_msg(x_be, x_db, 320, "Ghi nhận thanh toán & chuyển hóa đơn sang ĐÃ THANH TOÁN")
    d.add_response_msg(x_db, x_be, 360, "Lưu trạng thái thành công")
    d.add_response_msg(x_be, x_fe, 400, "Trả về kết quả thanh toán thành công")
    d.add_response_msg(x_fe, x_khach, 440, "Hiển thị thông báo thanh toán thành công & hóa đơn điện tử")

    d.add_caption("Hình 4.2.5.3: Sequence diagram khách thuê xem & thanh toán hóa đơn.", x=540, y=690)
    return d.render()

def generate_exact_blue_hoa_don_diagrams():
    print("Generating Blue Template Sequence Diagrams for HOA DON with 'Chủ trọ' & 'Khách thuê'...")
    t1 = build_hoa_don_exact_sample_diagram()
    t2 = build_hoa_don_them_chi_tiet()
    t3 = build_hoa_don_thanh_toan_chi_tiet()
    t4 = build_hoa_don_khach_thue_portal()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T17:30:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_HoaDon.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_HoaDon.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_hoa_don_diagrams()
