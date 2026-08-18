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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN HỢP ĐỒNG (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_hop_dong_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("hop_dong_chuan_mau", "Sequence diagram hợp đồng", width=1100, height=1050)
    
    # 4 Columns: Chủ trọ, Frontend, Backend, Database
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: LẬP HỢP ĐỒNG MỚI
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_chutro, x_fe, 115, "Chọn phòng & nhập thông tin hợp đồng")
    d.add_request_msg(x_fe, x_be, 135, "Tạo hợp đồng thuê (Khách, Giá, Tiền cọc)")
    d.add_request_msg(x_be, x_db, 155, "Lưu hợp đồng & cập nhật phòng (ĐANG THUÊ)")
    d.add_response_msg(x_db, x_be, 185, "Hợp đồng đã tạo thành công")
    d.add_response_msg(x_be, x_fe, 205, "Trả thông tin hợp đồng")

    # -------------------------------------------------------------
    # BLOCK 2: XEM & TÌM KIẾM HỢP ĐỒNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_chutro, x_fe, 270, "Tìm kiếm & lọc hợp đồng theo trạng thái")
    d.add_request_msg(x_fe, x_be, 290, "Truy vấn danh sách hợp đồng")
    d.add_request_msg(x_be, x_db, 310, "Lấy hợp đồng theo tòa nhà & khách thuê")
    d.add_response_msg(x_db, x_be, 340, "Danh sách hợp đồng và trạng thái")
    d.add_response_msg(x_be, x_fe, 360, "Trả kết quả danh sách hợp đồng")

    # -------------------------------------------------------------
    # BLOCK 3: CẬP NHẬT & GIA HẠN HỢP ĐỒNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_chutro, x_fe, 425, "Gia hạn / Chỉnh sửa thời hạn hợp đồng")
    d.add_request_msg(x_fe, x_be, 445, "Cập nhật thông tin hợp đồng")
    d.add_request_msg(x_be, x_db, 465, "Lưu thời hạn mới & điều chỉnh giá thuê")
    d.add_response_msg(x_db, x_be, 495, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về thông tin hợp đồng đã gia hạn")

    # -------------------------------------------------------------
    # BLOCK 4: THANH LÝ HỢP ĐỒNG & TRẢ PHÒNG
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_chutro, x_fe, 580, "Thực hiện thanh lý hợp đồng & trả phòng")
    d.add_request_msg(x_fe, x_be, 600, "Xác nhận quyết toán trả phòng")
    d.add_request_msg(x_be, x_db, 620, "Cập nhật hợp đồng (KẾT THÚC) & hoàn cọc")
    d.add_response_msg(x_db, x_be, 650, "Xác nhận kết thúc hợp đồng")
    d.add_request_msg(x_be, x_db, 680, "Giải phóng phòng (chuyển về trạng thái TRỐNG)")
    d.add_response_msg(x_db, x_be, 710, "Cập nhật phòng thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về kết quả thanh lý hợp đồng")
    d.add_response_msg(x_fe, x_chutro, 755, "Hiển thị: Thanh lý hợp đồng & Trả phòng thành công")

    # Caption at bottom
    d.add_caption("Hình 4.2.3: Sequence diagram hợp đồng.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: LẬP HỢP ĐỒNG MỚI CHI TIẾT
# =========================================================================
def build_hop_dong_them_chi_tiet():
    d = BlueTemplateSequenceBuilder("hop_dong_them_chi_tiet", "Sequence Lập hợp đồng mới", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập thông tin hợp đồng (Phòng, Khách thuê, Ngày thuê, Tiền cọc)")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu tạo hợp đồng (POST /api/hop-dong)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra phòng khả dụng (trạng thái AVAILABLE)")
    d.add_response_msg(x_db, x_be, 225, "Phòng trống hợp lệ")
    d.add_request_msg(x_be, x_db, 280, "Lưu bản ghi hợp đồng mới (trạng thái ACTIVE)")
    d.add_response_msg(x_db, x_be, 325, "Lưu hợp đồng thành công (UUID id)")
    d.add_request_msg(x_be, x_db, 380, "Cập nhật phòng sang RENTED & liên kết khách thuê")
    d.add_response_msg(x_db, x_be, 420, "Cập nhật phòng thành công")
    d.add_response_msg(x_be, x_fe, 465, "Trả về thông tin hợp đồng hoàn chỉnh (HopDongResponse)")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị thông báo: Tạo hợp đồng thành công")

    d.add_caption("Hình 4.2.3.1: Sequence diagram lập hợp đồng thuê phòng.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: QUYẾT TOÁN TRẢ PHÒNG & THANH LÝ CHI TIẾT
# =========================================================================
def build_hop_dong_tra_phong_chi_tiet():
    d = BlueTemplateSequenceBuilder("hop_dong_tra_phong_chi_tiet", "Sequence Quyết toán trả phòng", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập chỉ số điện/nước cuối kỳ, kiểm kê tài sản & khấu trừ cọc")
    d.add_request_msg(x_fe, x_be, 150, "Gửi quyết toán trả phòng (POST /api/hop-dong/{id}/tra-phong)")
    d.add_request_msg(x_be, x_db, 180, "Lưu bảng kê quyết toán (tiền phòng, điện nước, bồi hoàn tài sản)")
    d.add_response_msg(x_db, x_be, 225, "Lưu quyết toán thành công")
    d.add_request_msg(x_be, x_db, 280, "Cập nhật hợp đồng (TERMINATED) & chốt hoàn tiền cọc")
    d.add_response_msg(x_db, x_be, 325, "Xác nhận kết thúc hợp đồng")
    d.add_request_msg(x_be, x_db, 380, "Chuyển trạng thái phòng về AVAILABLE (TRỐNG)")
    d.add_response_msg(x_db, x_be, 420, "Phòng đã sẵn sàng cho thuê lại")
    d.add_response_msg(x_be, x_fe, 465, "Trả về kết quả quyết toán & thanh lý hợp đồng")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị biên bản bàn giao & quyết toán hoàn tất")

    d.add_caption("Hình 4.2.3.2: Sequence diagram quyết toán trả phòng & thanh lý.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 4: KHÁCH THUÊ XEM & KÝ HỢP ĐỒNG ĐIỆN TỬ
# =========================================================================
def build_hop_dong_ky_dien_tu():
    d = BlueTemplateSequenceBuilder("hop_dong_ky_dien_tu", "Sequence Khách ký hợp đồng", width=1100, height=780)
    x_khach = d.add_header_footer_column("Khách thuê", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=350)
    d.add_activation_box(x_be, 150, height=295)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 290, height=55)

    d.add_request_msg(x_khach, x_fe, 120, "Truy cập Cổng khách thuê & xem hợp đồng phòng đang thuê")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu tải nội dung hợp đồng (GET /api/hop-dong/{id}/document)")
    d.add_request_msg(x_be, x_db, 180, "Lấy điều khoản, thông tin phòng, giá thuê & chữ ký")
    d.add_response_msg(x_db, x_be, 225, "Trả về dữ liệu hợp đồng")
    d.add_request_msg(x_khach, x_fe, 260, "Xác nhận ký điện tử hợp đồng (vẽ chữ ký số / OTP)")
    d.add_request_msg(x_fe, x_be, 290, "Gửi chữ ký điện tử (POST /api/hop-dong/{id}/sign)")
    d.add_request_msg(x_be, x_db, 320, "Lưu chữ ký số (contract_signature) & cập nhật hợp đồng")
    d.add_response_msg(x_db, x_be, 360, "Lưu chữ ký thành công")
    d.add_response_msg(x_be, x_fe, 400, "Trả về trạng thái hợp đồng đã ký kết")
    d.add_response_msg(x_fe, x_khach, 440, "Hiển thị hợp đồng hoàn tất ký & cho phép tải file PDF")

    d.add_caption("Hình 4.2.3.3: Sequence diagram khách thuê ký hợp đồng điện tử.", x=540, y=690)
    return d.render()

def generate_exact_blue_hop_dong_diagrams():
    print("Generating Blue Template Sequence Diagrams for HOP DONG with 'Chủ trọ' & 'Khách thuê'...")
    t1 = build_hop_dong_exact_sample_diagram()
    t2 = build_hop_dong_them_chi_tiet()
    t3 = build_hop_dong_tra_phong_chi_tiet()
    t4 = build_hop_dong_ky_dien_tu()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T17:00:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_HopDong.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_HopDong.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_hop_dong_diagrams()
