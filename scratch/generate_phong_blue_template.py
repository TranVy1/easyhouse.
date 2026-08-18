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

    def add_header_footer_column(self, label, x, top_y=40, bottom_y=860, box_w=140, box_h=46):
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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN PHÒNG (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_phong_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("phong_chuan_mau", "Sequence diagram phòng", width=1100, height=1050)
    
    # 4 Columns: Chủ trọ, Frontend, Backend, Database
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: THÊM MỚI PHÒNG TRỌ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_chutro, x_fe, 115, "Bắt đầu tạo phòng mới")
    d.add_request_msg(x_fe, x_be, 135, "Tạo phòng trọ (Tên, Giá, Tiện nghi)")
    d.add_request_msg(x_be, x_db, 155, "Lưu thông tin phòng và tiện nghi")
    d.add_response_msg(x_db, x_be, 185, "Phòng đã tạo thành công")
    d.add_response_msg(x_be, x_fe, 205, "Trả thông tin phòng")

    # -------------------------------------------------------------
    # BLOCK 2: XEM & LỌC DANH SÁCH PHÒNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_chutro, x_fe, 270, "Lọc danh sách phòng theo trạng thái")
    d.add_request_msg(x_fe, x_be, 290, "Truy vấn danh sách phòng")
    d.add_request_msg(x_be, x_db, 310, "Lấy phòng theo tòa nhà & trạng thái")
    d.add_response_msg(x_db, x_be, 340, "Danh sách phòng và thông tin thuê")
    d.add_response_msg(x_be, x_fe, 360, "Trả kết quả danh sách phòng")

    # -------------------------------------------------------------
    # BLOCK 3: CẬP NHẬT THÔNG TIN & GIÁ PHÒNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_chutro, x_fe, 425, "Chỉnh sửa thông tin và giá phòng")
    d.add_request_msg(x_fe, x_be, 445, "Cập nhật phòng trọ")
    d.add_request_msg(x_be, x_db, 465, "Lưu thông tin phòng cập nhật")
    d.add_response_msg(x_db, x_be, 495, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về thông tin phòng đã cập nhật")

    # -------------------------------------------------------------
    # BLOCK 4: KIỂM TRA RÀNG BUỘC & XÓA PHÒNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_chutro, x_fe, 580, "Yêu cầu xóa phòng trọ")
    d.add_request_msg(x_fe, x_be, 600, "Thực hiện xóa phòng")
    d.add_request_msg(x_be, x_db, 620, "Kiểm tra hợp đồng đang thuê (count ACTIVE)")
    d.add_response_msg(x_db, x_be, 650, "Phòng trống (không có hợp đồng active)")
    d.add_request_msg(x_be, x_db, 680, "Thực hiện soft-delete phòng")
    d.add_response_msg(x_db, x_be, 710, "Xóa thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về kết quả xóa phòng")
    d.add_response_msg(x_fe, x_chutro, 755, "Hiển thị danh sách phòng đã cập nhật")

    # Caption at bottom
    d.add_caption("Hình 4.2.2: Sequence diagram quản lý phòng.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: THÊM MỚI PHÒNG CHI TIẾT
# =========================================================================
def build_phong_them_chi_tiet():
    d = BlueTemplateSequenceBuilder("phong_them_chi_tiet", "Sequence Thêm mới phòng", width=1100, height=750)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=600, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=360)
    d.add_activation_box(x_be, 150, height=310)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập thông tin phòng (Tên, Tầng, Giá thuê, Tiện nghi, Ảnh)")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu tạo phòng (POST /api/phong)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra trùng tên phòng trong tòa nhà (existsByTen)")
    d.add_response_msg(x_db, x_be, 225, "Tên phòng hợp lệ (chưa tồn tại)")
    d.add_request_msg(x_be, x_db, 280, "Lưu thông tin phòng trọ (phong: AVAILABLE)")
    d.add_response_msg(x_db, x_be, 325, "Lưu phòng thành công (UUID id)")
    d.add_request_msg(x_be, x_db, 380, "Lưu danh sách tiện nghi và liên kết ảnh phòng")
    d.add_response_msg(x_db, x_be, 420, "Xác nhận lưu tiện nghi và ảnh")
    d.add_response_msg(x_be, x_fe, 455, "Trả về thông tin phòng hoàn chỉnh (PhongResponse)")
    d.add_response_msg(x_fe, x_chutro, 490, "Hiển thị thông báo: Thêm phòng thành công")

    d.add_caption("Hình 4.2.3: Sequence diagram thêm mới phòng trọ.", x=540, y=670)
    return d.render()

# =========================================================================
# TAB 3: CHI TIẾT & TÀI SẢN PHÒNG
# =========================================================================
def build_phong_chi_tiet_tai_san():
    d = BlueTemplateSequenceBuilder("phong_chi_tiet_tai_san", "Sequence Chi tiết & Tài sản", width=1100, height=750)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=600, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=330)
    d.add_activation_box(x_be, 150, height=275)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 370, height=45)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhấp chọn xem chi tiết phòng trọ")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu chi tiết phòng (GET /api/phong/{id})")
    d.add_request_msg(x_be, x_db, 180, "Truy vấn thông tin cơ bản & tiện nghi phòng")
    d.add_response_msg(x_db, x_be, 225, "Trả về thông tin phòng")
    d.add_request_msg(x_be, x_db, 280, "Lấy hợp đồng đang hoạt động & thông tin khách thuê")
    d.add_response_msg(x_db, x_be, 325, "Trả về hợp đồng đang thuê (nếu có)")
    d.add_request_msg(x_be, x_db, 370, "Truy vấn danh mục tài sản thiết bị trong phòng")
    d.add_response_msg(x_db, x_be, 405, "Trả về danh sách tài sản (Điều hòa, Giường, Tủ)")
    d.add_response_msg(x_be, x_fe, 435, "Trả về DTO chi tiết phòng và danh mục tài sản")
    d.add_response_msg(x_fe, x_chutro, 470, "Hiển thị giao diện chi tiết phòng và bảng tài sản")

    d.add_caption("Hình 4.2.4: Sequence diagram chi tiết và tài sản phòng.", x=540, y=670)
    return d.render()

# =========================================================================
# TAB 4: KHÁCH TÌM PHÒNG CÔNG KHAI
# =========================================================================
def build_phong_tim_kiem_cong_khai():
    d = BlueTemplateSequenceBuilder("phong_tim_kiem_cong_khai", "Sequence Tìm phòng công khai", width=1100, height=750)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=600, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=310)
    d.add_activation_box(x_be, 150, height=255)
    d.add_activation_box(x_db, 180, height=55)

    d.add_request_msg(x_khach, x_fe, 120, "Truy cập /xem-phong & chọn bộ lọc (Khu vực, Mức giá, Vị trí GPS)")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu tìm phòng gần đây (GET /api/public/phong/nearby)")
    d.add_request_msg(x_be, x_db, 180, "Truy vấn các phòng trạng thái AVAILABLE và tọa độ tòa nhà")
    d.add_response_msg(x_db, x_be, 225, "Trả về danh sách phòng trống khả dụng")
    d.add_response_msg(x_be, x_be, 275, "Tính khoảng cách Haversine & lọc phòng trong bán kính")
    d.add_response_msg(x_be, x_fe, 335, "Trả về danh sách phòng kèm khoảng cách và ảnh đại diện")
    d.add_response_msg(x_fe, x_khach, 375, "Render danh sách card phòng trực quan kèm nút Đặt lịch xem phòng")

    d.add_caption("Hình 4.2.5: Sequence diagram khách tìm phòng công khai.", x=540, y=670)
    return d.render()

def generate_exact_blue_phong_diagrams():
    print("Generating Blue Template Sequence Diagrams for PHONG with 'Chủ trọ' & 'Khách thuê'...")
    t1 = build_phong_exact_sample_diagram()
    t2 = build_phong_them_chi_tiet()
    t3 = build_phong_chi_tiet_tai_san()
    t4 = build_phong_tim_kiem_cong_khai()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T16:45:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_Phong.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_Phong.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_phong_diagrams()
