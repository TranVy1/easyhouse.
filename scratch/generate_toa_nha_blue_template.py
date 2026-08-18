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

    def add_header_footer_column(self, label, x, top_y=50, bottom_y=860, box_w=140, box_h=46):
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

    def add_caption(self, text, x=540, y=935):
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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN (CHỦ TRỌ)
# =========================================================================
def build_toa_nha_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("toa_nha_chuan_mau", "Sequence diagram toà nhà", width=1100, height=1000)
    
    # 4 Columns: Chủ trọ, Frontend, Backend, Database
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=860, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=860, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=860, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=860, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: THÊM MỚI TÒA NHÀ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 120, height=95)
    d.add_activation_box(x_be, 145, height=80)
    d.add_activation_box(x_db, 170, height=45)

    d.add_request_msg(x_chutro, x_fe, 120, "Bắt đầu tạo tòa nhà")
    d.add_request_msg(x_fe, x_be, 145, "Tạo tòa nhà mới")
    d.add_request_msg(x_be, x_db, 170, "Lưu thông tin tòa nhà")
    d.add_response_msg(x_db, x_be, 205, "Tòa nhà đã tạo")
    d.add_response_msg(x_be, x_fe, 225, "Trả thông tin tòa nhà")

    # -------------------------------------------------------------
    # BLOCK 2: TẠO PHÒNG HÀNG LOẠT
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 290, height=95)
    d.add_activation_box(x_be, 315, height=80)
    d.add_activation_box(x_db, 340, height=45)

    d.add_request_msg(x_chutro, x_fe, 290, "Cấu hình tạo phòng hàng loạt")
    d.add_request_msg(x_fe, x_be, 315, "Sinh phòng tự động")
    d.add_request_msg(x_be, x_db, 340, "Lưu danh sách tầng và phòng")
    d.add_response_msg(x_db, x_be, 375, "Danh sách phòng đã tạo")
    d.add_response_msg(x_be, x_fe, 395, "Trả kết quả tạo phòng")

    # -------------------------------------------------------------
    # BLOCK 3: XEM SƠ ĐỒ & THỐNG KÊ PHÒNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 460, height=95)
    d.add_activation_box(x_be, 485, height=80)
    d.add_activation_box(x_db, 510, height=45)

    d.add_request_msg(x_chutro, x_fe, 460, "Xem sơ đồ và thống kê")
    d.add_request_msg(x_fe, x_be, 485, "Truy vấn sơ đồ tòa nhà")
    d.add_request_msg(x_be, x_db, 510, "Lấy dữ liệu phòng theo tầng")
    d.add_response_msg(x_db, x_be, 545, "Danh sách phòng và trạng thái")
    d.add_response_msg(x_be, x_fe, 565, "Trả về sơ đồ và tỷ lệ lấp đầy")

    # -------------------------------------------------------------
    # BLOCK 4: CẬP NHẬT TÒA NHÀ & DỊCH VỤ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 630, height=140)
    d.add_activation_box(x_be, 655, height=105)
    d.add_activation_box(x_db, 680, height=45)

    d.add_request_msg(x_chutro, x_fe, 630, "Chỉnh sửa thông tin và dịch vụ")
    d.add_request_msg(x_fe, x_be, 655, "Cập nhật tòa nhà")
    d.add_request_msg(x_be, x_db, 680, "Lưu chi tiết và giá dịch vụ")
    d.add_response_msg(x_db, x_be, 715, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 735, "Trả về kết quả cập nhật")
    d.add_response_msg(x_fe, x_chutro, 760, "Hiển thị thông tin tòa nhà chi tiết")

    # Caption at bottom
    d.add_caption("Hình 4.2.1: Sequence diagram toà nhà.", x=540, y=930)

    return d.render()

# =========================================================================
# TAB 2: THÊM TÒA NHÀ CHI TIẾT
# =========================================================================
def build_toa_nha_them_chi_tiet():
    d = BlueTemplateSequenceBuilder("toa_nha_them_chi_tiet", "Sequence Thêm mới tòa nhà", width=1100, height=750)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=600, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=360)
    d.add_activation_box(x_be, 150, height=310)
    d.add_activation_box(x_db, 180, height=60)
    d.add_activation_box(x_db, 290, height=60)
    d.add_activation_box(x_db, 390, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập thông tin tòa nhà (Tên, Địa chỉ, Số tầng, Dịch vụ)")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu tạo tòa nhà (POST /api/toa-nha)")
    d.add_request_msg(x_be, x_db, 180, "Lưu bản ghi tòa nhà (nha_tro)")
    d.add_response_msg(x_db, x_be, 230, "Lưu tòa nhà thành công")
    d.add_request_msg(x_be, x_db, 290, "Tạo các tầng (tang) và phòng (phong) mặc định")
    d.add_response_msg(x_db, x_be, 340, "Xác nhận tạo danh sách phòng ban đầu")
    d.add_request_msg(x_be, x_db, 390, "Lưu cấu hình đơn giá dịch vụ (Điện, Nước, Rác...)")
    d.add_response_msg(x_db, x_be, 430, "Xác nhận lưu bảng giá dịch vụ")
    d.add_response_msg(x_be, x_fe, 465, "Trả về thông tin tòa nhà hoàn chỉnh (DTO)")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị thông báo: Thêm tòa nhà thành công")

    d.add_caption("Hình 4.2.2: Sequence diagram thêm mới tòa nhà.", x=540, y=670)
    return d.render()

# =========================================================================
# TAB 3: XEM SƠ ĐỒ & THỐNG KÊ CHI TIẾT
# =========================================================================
def build_toa_nha_so_do_chi_tiet():
    d = BlueTemplateSequenceBuilder("toa_nha_so_do_chi_tiet", "Sequence Sơ đồ & Thống kê", width=1100, height=750)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=600, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=330)
    d.add_activation_box(x_be, 150, height=270)
    d.add_activation_box(x_db, 180, height=60)
    d.add_activation_box(x_db, 290, height=60)

    d.add_request_msg(x_chutro, x_fe, 120, "Chọn xem sơ đồ tòa nhà & thống kê")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu lấy sơ đồ phòng và thống kê (GET /api/toa-nha/{id}/so-do)")
    d.add_request_msg(x_be, x_db, 180, "Truy vấn danh sách tầng theo tòa nhà")
    d.add_response_msg(x_db, x_be, 230, "Trả về danh sách các tầng")
    d.add_request_msg(x_be, x_db, 290, "Truy vấn toàn bộ phòng & trạng thái (TRỐNG, ĐANG THUÊ, ĐẶT CỌC)")
    d.add_response_msg(x_db, x_be, 340, "Trả về danh sách phòng theo tầng")
    d.add_response_msg(x_be, x_fe, 390, "Trả về ma trận sơ đồ phòng & tỷ lệ lấp đầy tòa nhà")
    d.add_response_msg(x_fe, x_chutro, 435, "Render giao diện sơ đồ phòng trực quan và biểu đồ thống kê")

    d.add_caption("Hình 4.2.3: Sequence diagram sơ đồ phòng & thống kê tòa nhà.", x=540, y=670)
    return d.render()

# =========================================================================
# TAB 4: CẬP NHẬT & XÓA TÒA NHÀ
# =========================================================================
def build_toa_nha_cap_nhat_xoa():
    d = BlueTemplateSequenceBuilder("toa_nha_cap_nhat_xoa", "Sequence Cập nhật & Xóa tòa nhà", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=640, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=640, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=640, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=640, box_w=140, box_h=46)

    # Cập nhật
    d.add_activation_box(x_fe, 120, height=190)
    d.add_activation_box(x_be, 145, height=145)
    d.add_activation_box(x_db, 170, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Sửa thông tin tòa nhà (Địa chỉ, Bảng giá dịch vụ)")
    d.add_request_msg(x_fe, x_be, 145, "Gửi thông tin cập nhật (PUT /api/toa-nha/{id})")
    d.add_request_msg(x_be, x_db, 170, "Cập nhật dữ liệu tòa nhà & giá dịch vụ")
    d.add_response_msg(x_db, x_be, 210, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 240, "Trả về kết quả cập nhật")
    d.add_response_msg(x_fe, x_chutro, 275, "Hiển thị thông báo cập nhật thành công")

    # Xóa tòa nhà
    d.add_activation_box(x_fe, 360, height=220)
    d.add_activation_box(x_be, 385, height=175)
    d.add_activation_box(x_db, 410, height=45)
    d.add_activation_box(x_db, 490, height=45)

    d.add_request_msg(x_chutro, x_fe, 360, "Chọn xóa tòa nhà & xác nhận")
    d.add_request_msg(x_fe, x_be, 385, "Yêu cầu xóa tòa nhà (DELETE /api/toa-nha/{id})")
    d.add_request_msg(x_be, x_db, 410, "Kiểm tra phòng có người thuê (count RENTED)")
    d.add_response_msg(x_db, x_be, 445, "Không có phòng nào đang thuê")
    d.add_request_msg(x_be, x_db, 490, "Thực hiện soft-delete tòa nhà cùng tầng và phòng")
    d.add_response_msg(x_db, x_be, 525, "Xác nhận xóa thành công")
    d.add_response_msg(x_be, x_fe, 545, "Trả về kết quả xóa")
    d.add_response_msg(x_fe, x_chutro, 570, "Hiển thị: Xóa tòa nhà thành công")

    d.add_caption("Hình 4.2.4: Sequence diagram cập nhật và xóa tòa nhà.", x=540, y=710)
    return d.render()

def generate_exact_blue_diagrams():
    print("Generating Blue Template Sequence Diagrams for Toa Nha with 'Chủ trọ'...")
    t1 = build_toa_nha_exact_sample_diagram()
    t2 = build_toa_nha_them_chi_tiet()
    t3 = build_toa_nha_so_do_chi_tiet()
    t4 = build_toa_nha_cap_nhat_xoa()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T16:40:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_ToaNha.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_ToaNha.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_diagrams()
