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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN SỰ CỐ (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_su_co_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("su_co_chuan_mau", "Sequence diagram sự cố", width=1100, height=1050)
    
    # 4 Columns: Khách thuê/Chủ trọ, Frontend, Backend, Database
    x_actor = d.add_header_footer_column("Khách thuê / Chủ trọ", 150, top_y=40, bottom_y=880, box_w=150, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: BÁO CÁO SỰ CỐ MỚI
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_actor, x_fe, 115, "Nhập mô tả sự cố, mức độ ưu tiên & đính kèm ảnh")
    d.add_request_msg(x_fe, x_be, 135, "Tạo yêu cầu sự cố (POST /api/su-co)")
    d.add_request_msg(x_be, x_db, 155, "Lưu bản ghi sự cố (su_co: CHỜ XỬ LÝ)")
    d.add_response_msg(x_db, x_be, 185, "Sự cố đã tạo thành công")
    d.add_response_msg(x_be, x_fe, 205, "Trả thông tin sự cố & gửi thông báo")

    # -------------------------------------------------------------
    # BLOCK 2: XEM & LỌC DANH SÁCH SỰ CỐ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_actor, x_fe, 270, "Lọc sự cố theo tòa nhà, phòng & trạng thái")
    d.add_request_msg(x_fe, x_be, 290, "Truy vấn danh sách sự cố")
    d.add_request_msg(x_be, x_db, 310, "Lấy dữ liệu sự cố và tiến độ xử lý")
    d.add_response_msg(x_db, x_be, 340, "Danh sách sự cố và mức độ khẩn cấp")
    d.add_response_msg(x_be, x_fe, 360, "Trả kết quả danh sách sự cố")

    # -------------------------------------------------------------
    # BLOCK 3: TIẾP NHẬN & PHÂN CÔNG XỬ LÝ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_actor, x_fe, 425, "Tiếp nhận & hẹn lịch sửa chữa")
    d.add_request_msg(x_fe, x_be, 445, "Cập nhật tiến độ sự cố")
    d.add_request_msg(x_be, x_db, 465, "Cập nhật trạng thái (ĐANG XỬ LÝ) & ngày hẹn")
    d.add_response_msg(x_db, x_be, 495, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về kết quả cập nhật tiến độ")

    # -------------------------------------------------------------
    # BLOCK 4: NGHIỆM THU HOÀN THÀNH & ĐÁNH GIÁ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_actor, x_fe, 580, "Xác nhận nghiệm thu & chi phí sửa chữa")
    d.add_request_msg(x_fe, x_be, 600, "Hoàn tất xử lý sự cố")
    d.add_request_msg(x_be, x_db, 620, "Cập nhật trạng thái sự cố (HOÀN THÀNH)")
    d.add_response_msg(x_db, x_be, 650, "Cập nhật trạng thái thành công")
    d.add_request_msg(x_be, x_db, 680, "Lưu chi phí bảo trì và đánh giá chất lượng")
    d.add_response_msg(x_db, x_be, 710, "Lưu đánh giá thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về kết quả hoàn tất sự cố")
    d.add_response_msg(x_fe, x_actor, 755, "Hiển thị thông tin sự cố chi tiết đã hoàn thành")

    # Caption at bottom
    d.add_caption("Hình 4.2.8: Sequence diagram sự cố.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: BÁO CÁO SỰ CỐ CHI TIẾT
# =========================================================================
def build_su_co_bao_cao_chi_tiet():
    d = BlueTemplateSequenceBuilder("sc_bao_cao_chi_tiet", "Sequence Báo cáo sự cố chi tiết", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_khach, x_fe, 120, "Nhập tiêu đề, phòng, mô tả hỏng hóc, mức độ ưu tiên & tải ảnh")
    d.add_request_msg(x_fe, x_be, 150, "Gửi báo cáo sự cố (POST /api/su-co)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra hợp đồng thuê hợp lệ của khách tại phòng")
    d.add_response_msg(x_db, x_be, 225, "Xác thực phòng và khách thuê thành công")
    d.add_request_msg(x_be, x_db, 280, "Lưu bản ghi sự cố mới (su_co: CHO_XU_LY, anh_dinh_kem)")
    d.add_response_msg(x_db, x_be, 325, "Lưu sự cố thành công (UUID id)")
    d.add_request_msg(x_be, x_db, 380, "Tạo thông báo gửi đến Chủ trọ quản lý tòa nhà")
    d.add_response_msg(x_db, x_be, 420, "Gửi thông báo thành công")
    d.add_response_msg(x_be, x_fe, 465, "Trả về DTO sự cố (SuCoResponse)")
    d.add_response_msg(x_fe, x_khach, 500, "Hiển thị thông báo: Báo cáo sự cố thành công")

    d.add_caption("Hình 4.2.8.1: Sequence diagram khách thuê báo cáo sự cố.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: TIẾP NHẬN & PHÂN CÔNG XỬ LÝ CHI TIẾT
# =========================================================================
def build_su_co_tiep_nhan_chi_tiet():
    d = BlueTemplateSequenceBuilder("sc_tiep_nhan_chi_tiet", "Sequence Tiếp nhận & Phân công", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Chọn tiếp nhận sự cố, hẹn ngày xử lý & phân công thợ")
    d.add_request_msg(x_fe, x_be, 150, "Cập nhật trạng thái sự cố (PUT /api/su-co/{id})")
    d.add_request_msg(x_be, x_db, 180, "Lấy thông tin sự cố hiện tại")
    d.add_response_msg(x_db, x_be, 225, "Trả về bản ghi sự cố")
    d.add_request_msg(x_be, x_db, 280, "Cập nhật trạng thái DANG_XU_LY, ngày hẹn & thợ phụ trách")
    d.add_response_msg(x_db, x_be, 325, "Cập nhật sự cố thành công")
    d.add_request_msg(x_be, x_db, 380, "Gửi thông báo cập nhật tiến độ đến Khách thuê")
    d.add_response_msg(x_db, x_be, 420, "Gửi thông báo thành công")
    d.add_response_msg(x_be, x_fe, 465, "Trả về kết quả cập nhật tiến độ")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị thông báo tiếp nhận & phân công hoàn tất")

    d.add_caption("Hình 4.2.8.2: Sequence diagram chủ trọ tiếp nhận và phân công xử lý.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 4: NGHIỆM THU & QUYẾT TOÁN CHI PHÍ SỬA CHỮA
# =========================================================================
def build_su_co_nghiem_thu_chi_phi():
    d = BlueTemplateSequenceBuilder("sc_nghiem_thu_chi_phi", "Sequence Nghiệm thu & Chi phí", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=360)
    d.add_activation_box(x_be, 150, height=310)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập chi phí sửa chữa thực tế, đính kèm ảnh hoàn thành & xác nhận")
    d.add_request_msg(x_fe, x_be, 150, "Gửi xác nhận hoàn tất (PUT /api/su-co/{id})")
    d.add_request_msg(x_be, x_db, 180, "Cập nhật trạng thái sự cố sang HOAN_THANH & lưu chi phí")
    d.add_response_msg(x_db, x_be, 225, "Lưu hoàn thành thành công")
    d.add_request_msg(x_be, x_db, 280, "Ghi nhận chi phí sửa chữa vào sổ quỹ/nhật ký chi phí tòa nhà")
    d.add_response_msg(x_db, x_be, 325, "Lưu chi phí thành công")
    d.add_request_msg(x_be, x_db, 380, "Gửi thông báo hoàn tất sự cố cho khách thuê để đánh giá")
    d.add_response_msg(x_db, x_be, 420, "Gửi thông báo thành công")
    d.add_response_msg(x_be, x_fe, 455, "Trả về DTO sự cố hoàn tất")
    d.add_response_msg(x_fe, x_chutro, 490, "Hiển thị thông báo: Sự cố đã xử lý và nghiệm thu xong")

    d.add_caption("Hình 4.2.8.3: Sequence diagram nghiệm thu và quyết toán chi phí sự cố.", x=540, y=690)
    return d.render()

def generate_exact_blue_su_co_diagrams():
    print("Generating Blue Template Sequence Diagrams for SU CO with 'Khách thuê / Chủ trọ'...")
    t1 = build_su_co_exact_sample_diagram()
    t2 = build_su_co_bao_cao_chi_tiet()
    t3 = build_su_co_tiep_nhan_chi_tiet()
    t4 = build_su_co_nghiem_thu_chi_phi()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T18:00:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_SuCo.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_SuCo.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_su_co_diagrams()
