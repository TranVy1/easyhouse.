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
# TAB 1: SƠ ĐỒ CHUẨN MẪU TOÀN DIỆN TIN NHẮN (4 KHỐI NGHIỆP VỤ LIỀN MẠCH)
# =========================================================================
def build_tin_nhan_exact_sample_diagram():
    d = BlueTemplateSequenceBuilder("tin_nhan_chuan_mau", "Sequence diagram tin nhắn", width=1100, height=1050)
    
    # 4 Columns: Khách thuê/Chủ trọ, Frontend, Backend, Database
    x_actor = d.add_header_footer_column("Khách thuê / Chủ trọ", 150, top_y=40, bottom_y=880, box_w=150, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=880, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=880, box_w=140, box_h=46)

    # -------------------------------------------------------------
    # BLOCK 1: MỞ CUỘC HỘI THOẠI & TẢI LỊCH SỬ TIN NHẮN
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 115, height=95)
    d.add_activation_box(x_be, 135, height=80)
    d.add_activation_box(x_db, 155, height=45)

    d.add_request_msg(x_actor, x_fe, 115, "Chọn cuộc hội thoại cần nhắn tin")
    d.add_request_msg(x_fe, x_be, 135, "Truy vấn lịch sử tin nhắn (GET /api/tin-nhan/hoi-thoai/{id})")
    d.add_request_msg(x_be, x_db, 155, "Lấy danh sách tin nhắn & tệp đính kèm")
    d.add_response_msg(x_db, x_be, 185, "Trả về lịch sử tin nhắn")
    d.add_response_msg(x_be, x_fe, 205, "Trả dữ liệu tin nhắn & hiển thị khung chat")

    # -------------------------------------------------------------
    # BLOCK 2: SOẠN & GỬI TIN NHẮN MỚI
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 270, height=95)
    d.add_activation_box(x_be, 290, height=80)
    d.add_activation_box(x_db, 310, height=45)

    d.add_request_msg(x_actor, x_fe, 270, "Nhập nội dung tin nhắn / Đính kèm hình ảnh")
    d.add_request_msg(x_fe, x_be, 290, "Gửi tin nhắn (POST /api/tin-nhan hoặc WebSocket)")
    d.add_request_msg(x_be, x_db, 310, "Lưu tin nhắn (tin_nhan) & tệp đính kèm vào DB")
    d.add_response_msg(x_db, x_be, 340, "Lưu tin nhắn thành công (sequence id)")
    d.add_response_msg(x_be, x_fe, 360, "Trả về tin nhắn đã gửi thành công")

    # -------------------------------------------------------------
    # BLOCK 3: PHÂN PHỐI TIN NHẮN THỜI GIAN THỰC (WEBSOCKET)
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 425, height=95)
    d.add_activation_box(x_be, 445, height=80)
    d.add_activation_box(x_db, 465, height=45)

    d.add_request_msg(x_actor, x_fe, 425, "Hệ thống phát tín hiệu tin nhắn mới")
    d.add_request_msg(x_fe, x_be, 445, "Phát tán tin nhắn qua WebSocket (/topic/chat)")
    d.add_request_msg(x_be, x_db, 465, "Kiểm tra trạng thái online/offline của người nhận")
    d.add_response_msg(x_db, x_be, 495, "Xác nhận trạng thái kết nối")
    d.add_response_msg(x_be, x_fe, 515, "Đẩy tin nhắn tức thời tới màn hình người nhận")

    # -------------------------------------------------------------
    # BLOCK 4: ĐÁNH DẤU ĐÃ ĐỌC & CẬP NHẬT THÔNG BÁO
    # -------------------------------------------------------------
    d.add_activation_box(x_fe, 580, height=185)
    d.add_activation_box(x_be, 600, height=150)
    d.add_activation_box(x_db, 620, height=40)
    d.add_activation_box(x_db, 680, height=40)

    d.add_request_msg(x_actor, x_fe, 580, "Người nhận xem tin nhắn trong cuộc trò chuyện")
    d.add_request_msg(x_fe, x_be, 600, "Gửi sự kiện đã đọc (POST /api/tin-nhan/da-doc)")
    d.add_request_msg(x_be, x_db, 620, "Cập nhật mốc đọc tin nhắn (den_seq & DA_DOC)")
    d.add_response_msg(x_db, x_be, 650, "Cập nhật trạng thái đã đọc thành công")
    d.add_request_msg(x_be, x_db, 680, "Cập nhật số tin nhắn chưa đọc & xóa thông báo")
    d.add_response_msg(x_db, x_be, 710, "Lưu trạng thái thông báo thành công")
    d.add_response_msg(x_be, x_fe, 730, "Gửi tín hiệu đã xem tới người gửi")
    d.add_response_msg(x_fe, x_actor, 755, "Hiển thị trạng thái 'Đã xem' trên khung chat")

    # Caption at bottom
    d.add_caption("Hình 4.2.7: Sequence diagram tin nhắn.", x=540, y=950)

    return d.render()

# =========================================================================
# TAB 2: GỬI TIN NHẮN & TỆP ĐÍNH KÈM CHI TIẾT
# =========================================================================
def build_tin_nhan_gui_chi_tiet():
    d = BlueTemplateSequenceBuilder("tn_gui_chi_tiet", "Sequence Gửi tin nhắn & Tệp", width=1100, height=780)
    x_actor = d.add_header_footer_column("Người gửi", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_actor, x_fe, 120, "Soạn tin nhắn văn bản hoặc đính kèm ảnh phòng/hóa đơn")
    d.add_request_msg(x_fe, x_be, 150, "Gửi tin nhắn (POST /api/tin-nhan/hoi-thoai/{id}/gui)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra quyền thành viên trong cuộc hội thoại (checkMembership)")
    d.add_response_msg(x_db, x_be, 225, "Xác nhận thành viên hợp lệ")
    d.add_request_msg(x_be, x_db, 280, "Lưu bản ghi tin nhắn và tệp đính kèm vào DB")
    d.add_response_msg(x_db, x_be, 325, "Lưu thành công, sinh mã định danh tin nhắn")
    d.add_request_msg(x_be, x_db, 380, "Cập nhật thời gian tin nhắn cuối cùng (tin_nhan_cuoi_luc)")
    d.add_response_msg(x_db, x_be, 420, "Cập nhật hội thoại thành công")
    d.add_response_msg(x_be, x_fe, 465, "Phát tán tin nhắn tức thì qua WebSocket tới người nhận")
    d.add_response_msg(x_fe, x_actor, 500, "Hiển thị tin nhắn đã gửi kèm dấu tích gửi thành công")

    d.add_caption("Hình 4.2.7.1: Sequence diagram gửi tin nhắn và tệp đính kèm.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 3: TRẠNG THÁI ĐANG GÕ & ĐÃ ĐỌC
# =========================================================================
def build_tin_nhan_dang_go_da_doc():
    d = BlueTemplateSequenceBuilder("tn_dang_go_da_doc", "Sequence Đang gõ & Đã đọc", width=1100, height=780)
    x_actor = d.add_header_footer_column("Người dùng", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=380)
    d.add_activation_box(x_be, 150, height=330)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_actor, x_fe, 120, "Người dùng gõ bàn phím trong khung soạn tin")
    d.add_request_msg(x_fe, x_be, 150, "Gửi tín hiệu đang gõ qua WebSocket (/app/chat.typing)")
    d.add_request_msg(x_be, x_fe, 195, "Chuyển tiếp tín hiệu typing tới đối phương trong phòng chat")
    d.add_request_msg(x_actor, x_fe, 240, "Người nhận mở màn hình xem nội dung tin nhắn mới")
    d.add_request_msg(x_fe, x_be, 275, "Gửi yêu cầu đánh dấu đã đọc (POST /api/tin-nhan/{id}/da-doc)")
    d.add_request_msg(x_be, x_db, 310, "Cập nhật vị trí tin nhắn đã đọc (den_seq) vào bảng thanh_vien_hoi_thoai")
    d.add_response_msg(x_db, x_be, 350, "Cập nhật thành công")
    d.add_response_msg(x_be, x_fe, 390, "Gửi sự kiện read-receipt qua WebSocket tới người gửi")
    d.add_response_msg(x_fe, x_actor, 430, "Cập nhật trạng thái 'Đã xem' trên khung chat của người gửi")

    d.add_caption("Hình 4.2.7.2: Sequence diagram trạng thái đang gõ và đánh dấu đã đọc.", x=540, y=690)
    return d.render()

# =========================================================================
# TAB 4: THU HỒI & GHIM TIN NHẮN
# =========================================================================
def build_tin_nhan_thu_hoi_ghim():
    d = BlueTemplateSequenceBuilder("tn_thu_hoi_ghim", "Sequence Thu hồi & Ghim", width=1100, height=780)
    x_actor = d.add_header_footer_column("Người dùng", 150, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_fe = d.add_header_footer_column("Frontend", 410, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_be = d.add_header_footer_column("Backend", 670, top_y=40, bottom_y=620, box_w=140, box_h=46)
    x_db = d.add_header_footer_column("Database", 930, top_y=40, bottom_y=620, box_w=140, box_h=46)

    d.add_activation_box(x_fe, 120, height=360)
    d.add_activation_box(x_be, 150, height=310)
    d.add_activation_box(x_db, 180, height=55)
    d.add_activation_box(x_db, 280, height=55)
    d.add_activation_box(x_db, 380, height=50)

    d.add_request_msg(x_actor, x_fe, 120, "Nhấp chọn 'Thu hồi tin nhắn' trên tin nhắn đã gửi")
    d.add_request_msg(x_fe, x_be, 150, "Gửi yêu cầu thu hồi (POST /api/tin-nhan/{id}/thu-hoi)")
    d.add_request_msg(x_be, x_db, 180, "Kiểm tra quyền sở hữu tin nhắn & cập nhật da_thu_hoi = true")
    d.add_response_msg(x_db, x_be, 225, "Cập nhật thu hồi thành công")
    d.add_request_msg(x_actor, x_fe, 260, "Nhấp chọn 'Ghim tin nhắn' để lưu ý quan trọng")
    d.add_request_msg(x_fe, x_be, 290, "Gửi yêu cầu ghim tin nhắn (POST /api/tin-nhan/{id}/ghim)")
    d.add_request_msg(x_be, x_db, 320, "Cập nhật trang_thai_ghim = true trong DB")
    d.add_response_msg(x_db, x_be, 360, "Lưu trạng thái ghim thành công")
    d.add_response_msg(x_be, x_fe, 400, "Phát sự kiện cập nhật tin nhắn qua WebSocket")
    d.add_response_msg(x_fe, x_actor, 440, "Hiển thị thông báo: 'Tin nhắn đã thu hồi' và thanh ghim đầu trang")

    d.add_caption("Hình 4.2.7.3: Sequence diagram thu hồi và ghim tin nhắn.", x=540, y=690)
    return d.render()

def generate_exact_blue_tin_nhan_diagrams():
    print("Generating Blue Template Sequence Diagrams for TIN NHAN with 'Khách thuê / Chủ trọ'...")
    t1 = build_tin_nhan_exact_sample_diagram()
    t2 = build_tin_nhan_gui_chi_tiet()
    t3 = build_tin_nhan_dang_go_da_doc()
    t4 = build_tin_nhan_thu_hoi_ghim()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T17:55:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
</mxfile>"""

    download_dir = "C:\\Users\\Admin\\Downloads"
    download_path = os.path.join(download_dir, "EasyHouse_Sequence_Diagram_TinNhan.drawio")
    
    repo_doc_dir = "e:\\duAnCaNhan\\qlyphongtro\\docs"
    os.makedirs(repo_doc_dir, exist_ok=True)
    repo_path = os.path.join(repo_doc_dir, "EasyHouse_Sequence_Diagram_TinNhan.drawio")

    with open(download_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved successfully to Downloads: {download_path}")

    with open(repo_path, "w", encoding="utf-8") as f:
        f.write(full_xml)
    print(f"Saved duplicate to docs/: {repo_path}")

if __name__ == "__main__":
    generate_exact_blue_tin_nhan_diagrams()
