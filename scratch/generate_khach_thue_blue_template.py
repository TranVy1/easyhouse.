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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN KHÁCH THUÊ (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_khach_thue_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("khach_thue_chuan_mau", "Sequence diagram khách thuê", width=1100, height=1050)
    
    # 4 Columns: Chủ trọ, Frontend, Backend, Database
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: THÊM MỚI KHÁCH THUÊ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_chutro, x_fe, 115, "Nhập thông tin khách thuê (Họ tên, SĐT, CCCD)")
    d.add_request_msg(x_fe, x_be, 135, "Tạo hồ sơ khách thuê mới")
    d.add_request_msg(x_be, x_db, 155, "Lưu thông tin khách thuê và ảnh CCCD")
    d.add_response_msg(x_db, x_be, 185, "Khách thuê đã tạo thành công")
    d.add_response_msg(x_be, x_fe, 205, "Trả thông tin khách thuê")

    # -------------------------------------------------------------
    # BLOCK 2: XEM & TÌM KIẾM KHÁCH THUÊ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_chutro, x_fe, 270, "Tìm kiếm & lọc danh sách khách thuê")
    d.add_request_msg(x_fe, x_be, 290, "Truy vấn danh sách khách thuê")
    d.add_request_msg(x_be, x_db, 310, "Lấy dữ liệu khách thuê theo trạng thái")
    d.add_response_msg(x_db, x_be, 340, "Danh sách khách thuê và phòng ở")
    d.add_response_msg(x_be, x_fe, 360, "Trả kết quả danh sách khách thuê")

    # -------------------------------------------------------------
    # BLOCK 3: CẬP NHẬT THÔNG TIN KHÁCH THUÊ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_chutro, x_fe, 425, "Chỉnh sửa thông tin liên hệ & xe máy")
    d.add_request_msg(x_fe, x_be, 445, "Cập nhật hồ sơ khách thuê")
    d.add_request_msg(x_be, x_db, 465, "Lưu thông tin khách thuê cập nhật")
    d.add_response_msg(x_db, x_be, 495, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về thông tin khách thuê đã cập nhật")

    # -------------------------------------------------------------
    # BLOCK 4: KIỂM TRA HỢP ĐỒNG & XÓA KHÁCH THUÊ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_chutro, x_fe, 580, "Yêu cầu xóa hồ sơ khách thuê")
    d.add_request_msg(x_fe, x_be, 600, "Thực hiện xóa khách thuê")
    d.add_request_msg(x_be, x_db, 620, "Kiểm tra hợp đồng thuê đang active (count ACTIVE)")
    d.add_response_msg(x_db, x_be, 650, "Khách không còn hợp đồng active")
    d.add_request_msg(x_be, x_db, 680, "Thực hiện soft-delete hồ sơ khách thuê")
    d.add_response_msg(x_db, x_be, 710, "Xóa khách thuê thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về kết quả xóa")
    d.add_response_msg(x_fe, x_chutro, 755, "Hiển thị danh sách khách thuê đã cập nhật")

    # Caption at bottom
    d.add_caption("Hình 4.2.9: Sequence diagram khách thuê.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: THÊM MỚI KHÁCH THUÊ CHI TIẾT
# =========================================================================
def build_khach_thue_them_chi_tiet():
    d = BlueTemplateSequenceBuilder("kt_them_chi_tiet", "Sequence Thêm mới khách thuê", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập thông tin cá nhân (Họ tên, SĐT, Email, CCCD, Quê quán & Ảnh CCCD)")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu tạo khách thuê (POST /api/khach-thue)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra trùng lặp số điện thoại & số CCCD (existsByCccd)")
    d.add_response_msg(x_db, x_be, 225, "Thông tin hợp lệ (chưa tồn tại)")
    d.add_request_msg(x_be, x_db, 280, "Tạo tài khoản người dùng & lưu bản ghi khach_thue")
    d.add_response_msg(x_db, x_be, 325, "Lưu khách thuê thành công (UUID id)")
    d.add_request_msg(x_be, x_db, 380, "Lưu liên kết ảnh CCCD 2 mặt & thông tin tạm trú")
    d.add_response_msg(x_db, x_be, 420, "Xác nhận lưu hồ sơ khách thuê")
    d.add_response_msg(x_be, x_fe, 465, "Trả về DTO khách thuê hoàn chỉnh (KhachThueResponse)")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị thông báo: Thêm khách thuê thành công")

    d.add_caption("Hình 4.2.9.1: Sequence diagram thêm mới khách thuê.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: CẬP NHẬT THÔNG TIN KHÁCH THUÊ
# =========================================================================
def build_khach_thue_cap_nhat_chi_tiet():
    d = BlueTemplateSequenceBuilder("kt_cap_nhat_chi_tiet", "Sequence Cập nhật thông tin", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=360)
    d.add_activation_box(x_be, 150, height=310)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Chỉnh sửa SĐT, địa chỉ thường trú, biển số xe & cập nhật CCCD")
    d.add_request_msg(x_fe, x_be, 150, "Gửi thông tin cập nhật (PUT /api/khach-thue/{id})")
    d.add_request_msg(x_be, x_db, 180, "Lấy thông tin khách thuê hiện tại")
    d.add_response_msg(x_db, x_be, 225, "Trả về hồ sơ khách thuê")
    d.add_request_msg(x_be, x_db, 280, "Cập nhật dữ liệu vào bảng khach_thue & nguoi_dung")
    d.add_response_msg(x_db, x_be, 325, "Cập nhật thành công")
    d.add_request_msg(x_be, x_db, 380, "Ghi nhận lịch sử thay đổi thông tin khách thuê")
    d.add_response_msg(x_db, x_be, 420, "Lưu lịch sử thành công")
    d.add_response_msg(x_be, x_fe, 455, "Trả về DTO khách thuê đã cập nhật")
    d.add_response_msg(x_fe, x_chutro, 490, "Hiển thị thông báo: Cập nhật thông tin khách thuê thành công")

    d.add_caption("Hình 4.2.9.2: Sequence diagram cập nhật thông tin khách thuê.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 4: KHÁCH THUÊ ĐĂNG NHẬP & XEM THÔNG TIN
# =========================================================================
def build_khach_thue_portal_view():
    d = BlueTemplateSequenceBuilder("kt_portal_view", "Sequence Khách đăng nhập & Xem TT", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=360)
    d.add_activation_box(x_be, 150, height=310)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Đăng nhập Cổng khách thuê bằng SĐT & Mật khẩu")
    d.add_request_msg(x_fe, x_be, 150, "Xác thực tài khoản (POST /api/auth/login)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra mật khẩu & vai trò KHACH_THUE")
    d.add_response_msg(x_db, x_be, 225, "Xác thực thành công, sinh Session Token")
    d.add_request_msg(x_khach, x_fe, 260, "Truy cập xem thông tin phòng & hợp đồng hiện tại")
    d.add_request_msg(x_fe, x_be, 290, "Lấy thông tin hợp đồng đang thuê (GET /api/khach-thue/me)")
    d.add_request_msg(x_be, x_db, 320, "Truy vấn hợp đồng, hóa đơn & thiết bị phòng")
    d.add_response_msg(x_db, x_be, 360, "Trả về dữ liệu phòng và hợp đồng")
    d.add_response_msg(x_be, x_fe, 400, "Trả về thông tin chi tiết dành cho khách thuê")
    d.add_response_msg(x_fe, x_khach, 440, "Render Dashboard khách thuê: Tiền phòng, Điện nước & Hóa đơn")

    d.add_caption("Hình 4.2.9.3: Sequence diagram khách thuê đăng nhập và xem thông tin.", x=540, y=690)
    return d.render()

def generate_exact_blue_khach_thue_diagrams():
    print("Generating Blue Template Sequence Diagrams for KHACH THUE with 'Chủ trọ' & 'Khách thuê'...")
    t1 = build_khach_thue_exact_sample_diagram()
    t2 = build_khach_thue_them_chi_tiet()
    t3 = build_khach_thue_cap_nhat_chi_tiet()
    t4 = build_khach_thue_portal_view()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T18:10:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_KhachThue.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_KhachThue.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_khach_thue_diagrams()
