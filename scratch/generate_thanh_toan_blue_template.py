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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN THANH TOÁN (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_thanh_toan_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("thanh_toan_chuan_mau", "Sequence diagram thanh toán", width=1100, height=1050)
    
    # 4 Columns: Khách thuê/Chủ trọ, Frontend, Backend, Database
    x_actor = d.add_header_footer_column("Khách thuê / Chủ trọ", 150, top_y=40, bottom_y=880, box_w=150, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: KHỞI TẠO YÊU CẦU THANH TOÁN
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_actor, x_fe, 115, "Chọn hóa đơn & phương thức thanh toán")
    d.add_request_msg(x_fe, x_be, 135, "Khởi tạo thanh toán (Mã HĐ, Số tiền, VietQR/VNPay)")
    d.add_request_msg(x_be, x_db, 155, "Truy vấn thông tin hóa đơn & số tiền còn nợ")
    d.add_response_msg(x_db, x_be, 185, "Trả về thông tin hóa đơn hợp lệ")
    d.add_response_msg(x_be, x_fe, 205, "Trả về mã giao dịch & mã VietQR / Link VNPay")

    # -------------------------------------------------------------
    # BLOCK 2: THỰC HIỆN GIAO DỊCH THANH TOÁN
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_actor, x_fe, 270, "Quét mã chuyển khoản / Xác nhận trả tiền")
    d.add_request_msg(x_fe, x_be, 290, "Gửi thông tin giao dịch thanh toán")
    d.add_request_msg(x_be, x_db, 310, "Kiểm tra mã giao dịch & trạng thái thanh toán")
    d.add_response_msg(x_db, x_be, 340, "Xác nhận giao dịch hợp lệ")
    d.add_response_msg(x_be, x_fe, 360, "Trả kết quả xác thực thanh toán")

    # -------------------------------------------------------------
    # BLOCK 3: LƯU THANH TOÁN & CẬP NHẬT CÔNG NỢ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_actor, x_fe, 425, "Xác nhận hoàn tất thanh toán")
    d.add_request_msg(x_fe, x_be, 445, "Thực hiện ghi nhận thanh toán")
    d.add_request_msg(x_be, x_db, 465, "Lưu bản ghi thanh_toan & cập nhật hoa_don (ĐÃ THANH TOÁN)")
    d.add_response_msg(x_db, x_be, 495, "Lưu thanh toán & cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về kết quả thanh toán & biên lai điện tử")

    # -------------------------------------------------------------
    # BLOCK 4: TRA CỨU LỊCH SỬ & XUẤT BIÊN LAI
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_actor, x_fe, 580, "Xem lịch sử thanh toán & biên lai thu tiền")
    d.add_request_msg(x_fe, x_be, 600, "Truy vấn lịch sử thanh toán theo hóa đơn")
    d.add_request_msg(x_be, x_db, 620, "Lấy danh sách giao dịch thanh toán từ DB")
    d.add_response_msg(x_db, x_be, 650, "Trả về danh sách thanh toán và ngày giờ")
    d.add_request_msg(x_be, x_db, 680, "Cập nhật nhật ký thu tiền và công nợ phòng")
    d.add_response_msg(x_db, x_be, 710, "Ghi nhận thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về chi tiết lịch sử thanh toán")
    d.add_response_msg(x_fe, x_actor, 755, "Hiển thị thông tin hóa đơn chi tiết & biên lai đã thanh toán")

    # Caption at bottom
    d.add_caption("Hình 4.2.6: Sequence diagram thanh toán.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: THANH TOÁN CHUYỂN KHOẢN VIETQR
# =========================================================================
def build_thanh_toan_vietqr_chi_tiet():
    d = BlueTemplateSequenceBuilder("tt_vietqr_chi_tiet", "Sequence Thanh toán VietQR", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Chọn thanh toán qua chuyển khoản ngân hàng VietQR")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu tạo mã VietQR động (GET /api/vietqr/generate)")
    d.add_request_msg(x_be, x_db, 180, "Lấy thông tin tài khoản chủ trọ, số tiền & nội dung chuyển khoản")
    d.add_response_msg(x_db, x_be, 225, "Trả về thông tin thanh toán")
    d.add_request_msg(x_khach, x_fe, 260, "Quét mã QR trên app Mobile Banking & chuyển khoản thành công")
    d.add_request_msg(x_fe, x_be, 290, "Gửi xác nhận đã chuyển khoản (kèm ảnh biên lai)")
    d.add_request_msg(x_be, x_db, 320, "Lưu giao dịch thanh_toan & cập nhật trạng thái hoa_don")
    d.add_response_msg(x_db, x_be, 360, "Lưu thanh toán thành công")
    d.add_response_msg(x_be, x_fe, 400, "Trả về kết quả thanh toán thành công")
    d.add_response_msg(x_fe, x_khach, 440, "Hiển thị thông báo thanh toán hoàn tất & biên lai điện tử")

    d.add_caption("Hình 4.2.6.1: Sequence diagram thanh toán chuyển khoản VietQR.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: THANH TOÁN QUA CỔNG VNPAY
# =========================================================================
def build_thanh_toan_vnpay_chi_tiet():
    d = BlueTemplateSequenceBuilder("tt_vnpay_chi_tiet", "Sequence Thanh toán VNPay", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Chọn phương thức thanh toán cổng trực tuyến VNPay")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu tạo URL thanh toán (POST /api/vnpay/create-payment)")
    d.add_request_msg(x_be, x_db, 180, "Tạo mã giao dịch (vnp_TxnRef) & lưu thông tin đơn hàng")
    d.add_response_msg(x_db, x_be, 225, "Lưu đơn hàng thành công")
    d.add_response_msg(x_be, x_fe, 260, "Trả về URL thanh toán VNPay có chữ ký số (vnp_SecureHash)")
    d.add_request_msg(x_khach, x_fe, 295, "Thực hiện thanh toán thành công trên Cổng VNPay")
    d.add_request_msg(x_fe, x_be, 330, "VNPay Callback / IPN xác nhận thanh toán (vnp_ResponseCode = 00)")
    d.add_request_msg(x_be, x_db, 365, "Cập nhật giao dịch thanh_toan & chuyển hoa_don sang ĐÃ THANH TOÁN")
    d.add_response_msg(x_db, x_be, 405, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 440, "Trả về kết quả giao dịch VNPay thành công")
    d.add_response_msg(x_fe, x_khach, 480, "Hiển thị thông báo giao dịch thành công & hóa đơn điện tử")

    d.add_caption("Hình 4.2.6.2: Sequence diagram thanh toán qua cổng VNPay.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 4: CHỦ TRỌ XÁC NHẬN THU TIỀN MẶT
# =========================================================================
def build_thanh_toan_tien_mat_chi_tiet():
    d = BlueTemplateSequenceBuilder("tt_tien_mat_chi_tiet", "Sequence Xác nhận tiền mặt", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=360)
    d.add_activation_box(x_be, 150, height=310)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập số tiền mặt đã thu từ khách & ghi chú biên nhận")
    d.add_request_msg(x_fe, x_be, 150, "Gửi xác nhận thu tiền mặt (POST /api/thanh-toan)")
    d.add_request_msg(x_be, x_db, 180, "Lưu bản ghi thanh toán tiền mặt (phuongThuc = TIEN_MAT)")
    d.add_response_msg(x_db, x_be, 225, "Lưu thanh toán thành công")
    d.add_request_msg(x_be, x_db, 280, "Cộng dồn số tiền đã trả vào hóa đơn (da_tra += soTien)")
    d.add_response_msg(x_db, x_be, 325, "Cập nhật số tiền đã trả")
    d.add_request_msg(x_be, x_db, 380, "Cập nhật trạng thái hóa đơn (DA_THANH_TOAN / THANH_TOAN_MOT_PHAN)")
    d.add_response_msg(x_db, x_be, 420, "Cập nhật trạng thái thành công")
    d.add_response_msg(x_be, x_fe, 455, "Trả về DTO thanh toán và phiếu thu tiền")
    d.add_response_msg(x_fe, x_chutro, 490, "Hiển thị phiếu thu tiền mặt & cập nhật công nợ phòng")

    d.add_caption("Hình 4.2.6.3: Sequence diagram chủ trọ xác nhận thu tiền mặt.", x=540, y=690)
    return d.render()

def generate_exact_blue_thanh_toan_diagrams():
    print("Generating Blue Template Sequence Diagrams for THANH TOAN with 'Chủ trọ' & 'Khách thuê'...")
    t1 = build_thanh_toan_exact_sample_diagram()
    t2 = build_thanh_toan_vietqr_chi_tiet()
    t3 = build_thanh_toan_vnpay_chi_tiet()
    t4 = build_thanh_toan_tien_mat_chi_tiet()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T17:45:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_ThanhToan.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_ThanhToan.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_thanh_toan_diagrams()
