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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN HÓA ĐƠN KHÁCH THUÊ (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_hoa_don_khach_thue_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("hdkt_inv_chuan_mau", "Sequence diagram hoá đơn khách thuê", width=1100, height=1050)
    
    # 4 Columns: Khách thuê, Frontend, Backend, Database
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: TRA CỨU DANH SÁCH HÓA ĐƠN THÁNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_khach, x_fe, 115, "Truy cập Cổng khách thuê & xem danh sách hóa đơn")
    d.add_request_msg(x_fe, x_be, 135, "Truy vấn hóa đơn theo hợp đồng (GET /api/hoa-don)")
    d.add_request_msg(x_be, x_db, 155, "Lấy danh sách hóa đơn theo hợp đồng phòng đang thuê")
    d.add_response_msg(x_db, x_be, 185, "Trả về danh sách hóa đơn và công nợ")
    d.add_response_msg(x_be, x_fe, 205, "Trả dữ liệu danh sách hóa đơn cần đóng")

    # -------------------------------------------------------------
    # BLOCK 2: XEM BẢNG KÊ CHI TIẾT ĐIỆN NƯỚC
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_khach, x_fe, 270, "Xem chi tiết hóa đơn tháng hiện tại")
    d.add_request_msg(x_fe, x_be, 290, "Yêu cầu chi tiết hóa đơn (GET /api/hoa-don/{id})")
    d.add_request_msg(x_be, x_db, 310, "Lấy chỉ số điện, nước, đơn giá & các khoản phí dịch vụ")
    d.add_response_msg(x_db, x_be, 340, "Trả về dữ liệu chi tiết hóa đơn")
    d.add_response_msg(x_be, x_fe, 360, "Hiển thị bảng kê chi tiết: Điện, Nước, Tiền phòng, Wifi")

    # -------------------------------------------------------------
    # BLOCK 3: THANH TOÁN TRỰC TUYẾN (VIETQR / VNPAY)
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_khach, x_fe, 425, "Quét mã VietQR chuyển khoản / Chọn thanh toán VNPay")
    d.add_request_msg(x_fe, x_be, 445, "Gửi xác nhận thanh toán (POST /api/hoa-don/{id}/thanh-toan)")
    d.add_request_msg(x_be, x_db, 465, "Lưu giao dịch thanh_toan & cập nhật hoa_don (ĐÃ THANH TOÁN)")
    d.add_response_msg(x_db, x_be, 495, "Cập nhật giao dịch và công nợ thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về kết quả thanh toán thành công")

    # -------------------------------------------------------------
    # BLOCK 4: NHẬN BIÊN LAI ĐIỆN TỬ & CẬP NHẬT TRẠNG THÁI
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_khach, x_fe, 580, "Xem biên lai thu tiền điện tử")
    d.add_request_msg(x_fe, x_be, 600, "Truy vấn biên lai thu tiền (GET /api/thanh-toan/hoa-don/{id})")
    d.add_request_msg(x_be, x_db, 620, "Lấy thông tin giao dịch & mã biên lai điện tử")
    d.add_response_msg(x_db, x_be, 650, "Trả về chi tiết biên lai thu tiền")
    d.add_request_msg(x_be, x_db, 680, "Ghi nhận trạng thái hoàn tất nghĩa vụ tài chính")
    d.add_response_msg(x_db, x_be, 710, "Lưu trạng thái thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về dữ liệu biên lai điện tử")
    d.add_response_msg(x_fe, x_khach, 755, "Hiển thị biên lai đã thanh toán & cập nhật trạng thái hóa đơn")

    # Caption at bottom
    d.add_caption("Hình 4.2.10: Sequence diagram hoá đơn khách thuê.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: XEM BẢNG KÊ ĐIỆN NƯỚC CHI TIẾT
# =========================================================================
def build_hdkt_inv_xem_chi_tiet():
    d = BlueTemplateSequenceBuilder("hdkt_inv_xem", "Sequence Xem bảng kê chi tiết", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Nhấp chọn hóa đơn tiền phòng tháng mới trên Dashboard")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu chi tiết hóa đơn (GET /api/hoa-don/{id})")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra quyền xem hóa đơn của khách thuê (checkCanRead)")
    d.add_response_msg(x_db, x_be, 225, "Xác nhận hợp lệ")
    d.add_request_msg(x_be, x_db, 280, "Truy vấn chi tiết chỉ số điện cũ/mới, nước cũ/mới & đơn giá")
    d.add_response_msg(x_db, x_be, 325, "Trả về dữ liệu chi tiết hóa đơn (chi_tiet_hoa_don)")
    d.add_request_msg(x_be, x_db, 380, "Lấy thông tin tài khoản ngân hàng & QR nhận tiền của chủ trọ")
    d.add_response_msg(x_db, x_be, 420, "Trả về thông tin thanh toán")
    d.add_response_msg(x_be, x_fe, 465, "Trả về HoaDonResponse (Tổng tiền, Tiêu thụ, Đơn giá)")
    d.add_response_msg(x_fe, x_khach, 500, "Hiển thị bảng kê chi tiết hóa đơn & nút Thanh toán ngay")

    d.add_caption("Hình 4.2.10.1: Sequence diagram khách thuê xem chi tiết hóa đơn.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: THANH TOÁN VIETQR & ĐÍNH KÈM BIÊN LAI
# =========================================================================
def build_hdkt_inv_thanh_toan_vietqr():
    d = BlueTemplateSequenceBuilder("hdkt_inv_vietqr", "Sequence Thanh toán VietQR", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Quét mã VietQR trên ứng dụng ngân hàng & chuyển khoản thành công")
    d.add_request_msg(x_fe, x_be, 150, "Gửi xác nhận thanh toán kèm ảnh chụp biên lai ngân hàng")
    d.add_request_msg(x_be, x_db, 180, "Lưu giao dịch thanh toán vào bảng thanh_toan")
    d.add_response_msg(x_db, x_be, 225, "Lưu giao dịch thành công (UUID id)")
    d.add_request_msg(x_be, x_db, 280, "Cộng dồn số tiền đã trả (da_tra) & chuyển hóa đơn sang DA_THANH_TOAN")
    d.add_response_msg(x_db, x_be, 325, "Cập nhật trạng thái hóa đơn thành công")
    d.add_request_msg(x_be, x_db, 380, "Tạo thông báo đã nhận tiền gửi tới Chủ trọ quản lý")
    d.add_response_msg(x_db, x_be, 420, "Gửi thông báo thành công")
    d.add_response_msg(x_be, x_fe, 465, "Trả về DTO hóa đơn sau thanh toán")
    d.add_response_msg(x_fe, x_khach, 500, "Hiển thị thông báo: Thanh toán hóa đơn thành công!")

    d.add_caption("Hình 4.2.10.2: Sequence diagram khách thuê thanh toán chuyển khoản VietQR.", x=540, y=690)
    return d.render()

def generate_exact_blue_hoa_don_khach_thue_diagrams():
    print("Generating Blue Template Sequence Diagrams for HOA DON KHACH THUE...")
    t1 = build_hoa_don_khach_thue_exact_sample_diagram()
    t2 = build_hdkt_inv_xem_chi_tiet()
    t3 = build_hdkt_inv_thanh_toan_vietqr()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T18:35:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_HoaDonKhachThue.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_HoaDonKhachThue.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_hoa_don_khach_thue_diagrams()
