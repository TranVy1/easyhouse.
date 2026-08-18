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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN CẤU HÌNH GIÁ (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_cau_hinh_gia_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("cau_hinh_gia_chuan_mau", "Sequence diagram cấu hình giá", width=1100, height=1050)
    
    # 4 Columns: Chủ trọ, Frontend, Backend, Database
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: THIẾT LẬP CẤU HÌNH GIÁ MỚI
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_chutro, x_fe, 115, "Bắt đầu tạo cấu hình giá (Điện, Nước, Dịch vụ)")
    d.add_request_msg(x_fe, x_be, 135, "Tạo cấu hình giá mới (Đơn giá, Ngày hiệu lực)")
    d.add_request_msg(x_be, x_db, 155, "Lưu cấu hình giá & chốt hạn bản ghi cũ")
    d.add_response_msg(x_db, x_be, 185, "Cấu hình giá đã tạo thành công")
    d.add_response_msg(x_be, x_fe, 205, "Trả thông tin cấu hình giá")

    # -------------------------------------------------------------
    # BLOCK 2: XEM & TRA CỨU BẢNG GIÁ DỊCH VỤ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_chutro, x_fe, 270, "Xem danh sách bảng giá theo tòa nhà")
    d.add_request_msg(x_fe, x_be, 290, "Truy vấn cấu hình giá đang áp dụng")
    d.add_request_msg(x_be, x_db, 310, "Lấy dữ liệu bảng giá theo loại dịch vụ")
    d.add_response_msg(x_db, x_be, 340, "Danh sách cấu hình giá hiệu lực")
    d.add_response_msg(x_be, x_fe, 360, "Trả về bảng giá dịch vụ")

    # -------------------------------------------------------------
    # BLOCK 3: CẬP NHẬT & TẠO PHIÊN BẢN GIÁ MỚI
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_chutro, x_fe, 425, "Điều chỉnh đơn giá mới & ngày áp dụng")
    d.add_request_msg(x_fe, x_be, 445, "Cập nhật cấu hình giá")
    d.add_request_msg(x_be, x_db, 465, "Lưu phiên bản giá mới & chốt hạn phiên bản cũ")
    d.add_response_msg(x_db, x_be, 495, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 515, "Trả về kết quả cập nhật phiên bản giá")

    # -------------------------------------------------------------
    # BLOCK 4: NGỪNG ÁP DỤNG CẤU HÌNH GIÁ
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_chutro, x_fe, 580, "Yêu cầu ngừng áp dụng cấu hình giá")
    d.add_request_msg(x_fe, x_be, 600, "Thực hiện ngừng áp dụng giá")
    d.add_request_msg(x_be, x_db, 620, "Cập nhật trạng thái (DANG_AP_DUNG = false)")
    d.add_response_msg(x_db, x_be, 650, "Cập nhật trạng thái thành công")
    d.add_request_msg(x_be, x_db, 680, "Chốt ngày hết hạn hiệu lực (hieuLucDen = now)")
    d.add_response_msg(x_db, x_be, 710, "Lưu trạng thái thành công")
    d.add_response_msg(x_be, x_fe, 730, "Trả về kết quả xử lý")
    d.add_response_msg(x_fe, x_chutro, 755, "Hiển thị bảng giá dịch vụ đã cập nhật")

    # Caption at bottom
    d.add_caption("Hình 4.2.4: Sequence diagram cấu hình giá.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: THÊM CẤU HÌNH GIÁ CHI TIẾT
# =========================================================================
def build_cau_hinh_gia_them_chi_tiet():
    d = BlueTemplateSequenceBuilder("chg_them_chi_tiet", "Sequence Thêm cấu hình giá", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập cấu hình giá (Nhà trọ, Loại dịch vụ, Đơn giá, Ngày hiệu lực)")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu tạo bảng giá (POST /api/cau-hinh-gia)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra trùng lặp khoảng thời gian hiệu lực (validateOverlap)")
    d.add_response_msg(x_db, x_be, 225, "Khoảng thời gian hợp lệ")
    d.add_request_msg(x_be, x_db, 280, "Tự động chốt hạn cấu hình giá cũ (hieuLucDen = hieuLucTu - 1)")
    d.add_response_msg(x_db, x_be, 325, "Đã cập nhật cấu hình cũ")
    d.add_request_msg(x_be, x_db, 380, "Lưu cấu hình giá mới & ghi nhận Audit Log (CREATE)")
    d.add_response_msg(x_db, x_be, 420, "Lưu cấu hình giá thành công (UUID id)")
    d.add_response_msg(x_be, x_fe, 465, "Trả về thông tin cấu hình giá (CauHinhGiaResponse)")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị thông báo: Tạo cấu hình giá thành công")

    d.add_caption("Hình 4.2.4.1: Sequence diagram thêm mới cấu hình giá dịch vụ.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: LẤY ĐƠN GIÁ HIỆU LỰC TÍNH HÓA ĐƠN
# =========================================================================
def build_cau_hinh_gia_lay_ap_dung():
    d = BlueTemplateSequenceBuilder("chg_lay_ap_dung", "Sequence Lấy giá áp dụng", width=1100, height=750)
    x_chutro = d.add_header_footer_column("Chủ trọ / Hệ thống", 150, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=600, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=600, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=330)
    d.add_activation_box(x_be, 150, height=275)
    d.add_activation_box(x_db, 180, height=60)
    d.add_activation_box(x_db, 290, height=60)

    d.add_request_msg(x_chutro, x_fe, 120, "Nhập chỉ số điện/nước hoặc chọn ngày lập hóa đơn")
    d.add_request_msg(x_fe, x_be, 150, "Yêu cầu lấy đơn giá áp dụng (GET /api/cau-hinh-gia/ap-dung)")
    d.add_request_msg(x_be, x_db, 180, "Truy vấn đơn giá điện (ELECTRICITY) hiệu lực tại ngày chốt")
    d.add_response_msg(x_db, x_be, 230, "Trả về đơn giá điện (3.500đ/kWh, PER_UNIT)")
    d.add_request_msg(x_be, x_db, 290, "Truy vấn đơn giá nước (WATER) & các dịch vụ cố định")
    d.add_response_msg(x_db, x_be, 340, "Trả về đơn giá nước (25.000đ/m3) & phí dịch vụ")
    d.add_response_msg(x_be, x_fe, 390, "Trả về bảng đơn giá áp dụng đầy đủ cho hóa đơn")
    d.add_response_msg(x_fe, x_chutro, 435, "Tự động điền đơn giá và tính thành tiền chi tiết trên hóa đơn")

    d.add_caption("Hình 4.2.4.2: Sequence diagram lấy đơn giá áp dụng lập hóa đơn.", x=540, y=670)
    return d.render()

# =========================================================================
# TAB 4: CẬP NHẬT & TẠO PHIÊN BẢN MỚI
# =========================================================================
def build_cau_hinh_gia_cap_nhat_phien_ban():
    d = BlueTemplateSequenceBuilder("chg_cap_nhat_phien_ban", "Sequence Cập nhật & Tạo phiên bản", width=1100, height=780)
    x_chutro = d.add_header_footer_column("Chủ trọ", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_chutro, x_fe, 120, "Điều chỉnh đơn giá dịch vụ mới & chọn ngày bắt đầu áp dụng")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu cập nhật giá (PUT /api/cau-hinh-gia/{id})")
    d.add_request_msg(x_be, x_db, 180, "Lấy thông tin cấu hình giá phiên bản cũ")
    d.add_response_msg(x_db, x_be, 225, "Trả về bản ghi cũ")
    d.add_request_msg(x_be, x_db, 280, "Chốt ngày hết hạn của bản ghi cũ = ngày hiệu lực mới - 1")
    d.add_response_msg(x_db, x_be, 325, "Xác nhận chốt hạn bản ghi cũ")
    d.add_request_msg(x_be, x_db, 380, "Lưu bản ghi phiên bản giá mới (dangApDung = true) & ghi Audit Log")
    d.add_response_msg(x_db, x_be, 420, "Lưu phiên bản giá mới thành công")
    d.add_response_msg(x_be, x_fe, 465, "Trả về thông tin phiên bản giá đã cập nhật")
    d.add_response_msg(x_fe, x_chutro, 500, "Hiển thị thông báo thành công & cập nhật lịch sử giá")

    d.add_caption("Hình 4.2.4.3: Sequence diagram cập nhật và tạo phiên bản giá mới.", x=540, y=690)
    return d.render()

def generate_exact_blue_cau_hinh_gia_diagrams():
    print("Generating Blue Template Sequence Diagrams for CAU HINH GIA with 'Chủ trọ'...")
    t1 = build_cau_hinh_gia_exact_sample_diagram()
    t2 = build_cau_hinh_gia_them_chi_tiet()
    t3 = build_cau_hinh_gia_lay_ap_dung()
    t4 = build_cau_hinh_gia_cap_nhat_phien_ban()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T17:15:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_CauHinhGia.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_CauHinhGia.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_cau_hinh_gia_diagrams()
