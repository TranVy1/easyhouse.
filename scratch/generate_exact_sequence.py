import os
import sys
import html
import xml.etree.ElementTree as ET

if sys.stdout.encoding.lower() != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

class ExactSequenceBuilder:
    def __init__(self, diag_id, name, width=1400, height=900):
        self.diag_id = diag_id
        self.name = name
        self.width = width
        self.height = height
        self.cells = []
        self.cell_counter = 1

    def _next_id(self, prefix="cell"):
        self.cell_counter += 1
        return f"{prefix}_{self.cell_counter}"

    def add_actor(self, label, x, y=40, line_height=650):
        cid = self._next_id("actor")
        # Actor shape
        self.cells.append(f"""<mxCell id="{cid}_icon" value="" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=#ffffff;strokeColor=#000000;strokeWidth=1.5;" vertex="1" parent="1">
  <mxGeometry x="{x - 15}" y="{y}" width="30" height="50" as="geometry" />
</mxCell>""")
        # Actor Label
        self.cells.append(f"""<mxCell id="{cid}_lbl" value="&lt;b&gt;{html.escape(label)}&lt;/b&gt;" style="text;html=1;align=center;verticalAlign=top;fontSize=12;fontFamily=Helvetica;fontColor=#000000;" vertex="1" parent="1">
  <mxGeometry x="{x - 60}" y="{y + 52}" width="120" height="24" as="geometry" />
</mxCell>""")
        # Lifeline dashed
        start_y = y + 76
        end_y = y + line_height
        self.cells.append(f"""<mxCell id="{cid}_line" value="" style="endArrow=none;dashed=1;html=1;rounded=0;strokeColor=#000000;strokeWidth=1;dashPattern=6 4;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{x}" y="{start_y}" as="sourcePoint" />
    <mxPoint x="{x}" y="{end_y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")
        return x

    def add_lifeline(self, name, x, y=40, width=150, height=36, line_height=650):
        cid = self._next_id("ll")
        # Header Box
        self.cells.append(f"""<mxCell id="{cid}_box" value="&lt;b&gt;{html.escape(name)}&lt;/b&gt;" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor=#ffffff;strokeColor=#000000;strokeWidth=1.5;fontSize=12;fontFamily=Helvetica;fontColor=#000000;align=center;verticalAlign=middle;" vertex="1" parent="1">
  <mxGeometry x="{x - width // 2}" y="{y}" width="{width}" height="{height}" as="geometry" />
</mxCell>""")
        # Lifeline dashed
        start_y = y + height
        end_y = y + line_height
        self.cells.append(f"""<mxCell id="{cid}_line" value="" style="endArrow=none;dashed=1;html=1;rounded=0;strokeColor=#000000;strokeWidth=1;dashPattern=6 4;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{x}" y="{start_y}" as="sourcePoint" />
    <mxPoint x="{x}" y="{end_y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")
        return x

    def add_sync_msg(self, from_x, to_x, y, text):
        cid = self._next_id("sync")
        self.cells.append(f"""<mxCell id="{cid}" value="{html.escape(text)}" style="endArrow=block;html=1;rounded=0;strokeColor=#000000;strokeWidth=1;endFill=1;align=center;verticalAlign=bottom;labelBackgroundColor=#ffffff;fontFamily=Helvetica;fontSize=11;fontColor=#000000;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{from_x}" y="{y}" as="sourcePoint" />
    <mxPoint x="{to_x}" y="{y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")

    def add_return_msg(self, from_x, to_x, y, text):
        cid = self._next_id("ret")
        self.cells.append(f"""<mxCell id="{cid}" value="{html.escape(text)}" style="endArrow=open;dashed=1;html=1;rounded=0;strokeColor=#000000;strokeWidth=1;endFill=0;align=center;verticalAlign=bottom;labelBackgroundColor=#ffffff;fontFamily=Helvetica;fontSize=11;fontColor=#000000;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{from_x}" y="{y}" as="sourcePoint" />
    <mxPoint x="{to_x}" y="{y}" as="targetPoint" />
  </mxGeometry>
</mxCell>""")

    def add_self_msg(self, x, y, text, width=40, height=25):
        cid = self._next_id("self")
        self.cells.append(f"""<mxCell id="{cid}" value="{html.escape(text)}" style="endArrow=block;html=1;rounded=0;strokeColor=#000000;strokeWidth=1;endFill=1;align=left;verticalAlign=middle;labelBackgroundColor=#ffffff;fontFamily=Helvetica;fontSize=11;fontColor=#000000;edgeStyle=orthogonalEdgeStyle;curved=0;spacingLeft=5;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{x}" y="{y}" as="sourcePoint" />
    <mxPoint x="{x}" y="{y + height}" as="targetPoint" />
    <Array as="points">
      <mxPoint x="{x + width}" y="{y}" />
      <mxPoint x="{x + width}" y="{y + height}" />
    </Array>
  </mxGeometry>
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

# ==========================================
# 1. TAB: Sequence Thêm khách thuê
# ==========================================
def build_seq_them_khach_thue():
    d = ExactSequenceBuilder("seq_them_khach_thue", "Sequence Thêm khách thuê", width=1400, height=850)
    
    # Header positions exactly spaced as in screenshot
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=680)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=680)
    x_ctrl = d.add_lifeline("KhachThueController", 540, y=40, width=160, height=38, line_height=680)
    x_srv = d.add_lifeline("KhachThueService", 770, y=40, width=150, height=38, line_height=680)
    x_db = d.add_lifeline("PostgreSQL DB", 990, y=40, width=140, height=38, line_height=680)
    x_media = d.add_lifeline("MediaService", 1200, y=40, width=140, height=38, line_height=680)

    # 12 steps flow
    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn thêm mới & nhập thông tin khách thuê")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. POST /api/khach-thue (KhachThueRequest)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. createKhachThue(request)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findBySoDienThoai(sdt) & checkNguoiDung()")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về NguoiDung (hoặc tạo mới với Pass=\"123456\")")
    d.add_sync_msg(x_srv, x_db, 370, "6. save(khachThue) & linkNguoiDung()")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về KhachThue (Lưu thành công)")
    d.add_sync_msg(x_srv, x_media, 470, "8. saveCccdMedia(anhCCCD)")
    d.add_return_msg(x_media, x_srv, 520, "9. Trả về URL ảnh CCCD Cloudinary")
    d.add_return_msg(x_srv, x_ctrl, 570, "10. Trả về KhachThueResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 620, "11. ApiResponse (HTTP 200 Created)")
    d.add_return_msg(x_fe, x_chutro, 670, "12. Hiển thị: Thêm khách thuê thành công")

    return d.render()

# ==========================================
# 2. TAB: Sequence Xem danh sách khách thuê
# ==========================================
def build_seq_xem_danh_sach():
    d = ExactSequenceBuilder("seq_xem_khach_thue", "Sequence Xem & Lọc khách thuê", width=1400, height=800)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=630)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=630)
    x_ctrl = d.add_lifeline("KhachThueController", 540, y=40, width=160, height=38, line_height=630)
    x_srv = d.add_lifeline("KhachThueService", 770, y=40, width=150, height=38, line_height=630)
    x_perm = d.add_lifeline("PermissionService", 980, y=40, width=140, height=38, line_height=630)
    x_db = d.add_lifeline("PostgreSQL DB", 1190, y=40, width=140, height=38, line_height=630)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn lọc theo trạng thái (dangThue/all) & tìm kiếm")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. GET /api/khach-thue?trangThai=...&search=...&page=1&limit=10")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. getAllKhachThue(trangThai, search, page, limit)")
    d.add_sync_msg(x_srv, x_perm, 270, "4. requireCurrentUserId() & getAllAccessibleNhaTroIds(userId)")
    d.add_return_msg(x_perm, x_srv, 320, "5. Trả về danh sách nhaTroIds được cấp quyền")
    d.add_sync_msg(x_srv, x_db, 370, "6. findAllAccessible(filter, search, pageable) & findAllActiveContracts()")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về Page<KhachThue> & danh sách HopDong hiệu lực")
    d.add_self_msg(x_srv, 460, "8. Map thông tin phòng đang ở, tòa nhà & ảnh CCCD", width=45, height=25)
    d.add_return_msg(x_srv, x_ctrl, 520, "9. Trả về PaginatedResponse<KhachThueResponse>")
    d.add_return_msg(x_ctrl, x_fe, 570, "10. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 620, "11. Hiển thị danh sách khách thuê (Table + Phân trang)")

    return d.render()

# ==========================================
# 3. TAB: Sequence Cập nhật khách thuê
# ==========================================
def build_seq_cap_nhat_khach_thue():
    d = ExactSequenceBuilder("seq_cap_nhat_khach_thue", "Sequence Cập nhật khách thuê", width=1400, height=850)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=680)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=680)
    x_ctrl = d.add_lifeline("KhachThueController", 540, y=40, width=160, height=38, line_height=680)
    x_srv = d.add_lifeline("KhachThueService", 770, y=40, width=150, height=38, line_height=680)
    x_db = d.add_lifeline("PostgreSQL DB", 990, y=40, width=140, height=38, line_height=680)
    x_media = d.add_lifeline("MediaService", 1200, y=40, width=140, height=38, line_height=680)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Sửa thông tin khách thuê (Họ tên, SĐT, CCCD...) & Bấm Lưu")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. PUT /api/khach-thue/{id} (KhachThueRequest)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. updateKhachThue(id, request)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & assertCanWrite(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về KhachThue entity hợp lệ")
    d.add_sync_msg(x_srv, x_db, 370, "6. update(khachThue) & syncNguoiDung()")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về KhachThue (Cập nhật thành công)")
    d.add_sync_msg(x_srv, x_media, 470, "8. saveCccdMedia(anhCCCD mới)")
    d.add_return_msg(x_media, x_srv, 520, "9. Trả về URL ảnh CCCD mới")
    d.add_return_msg(x_srv, x_ctrl, 570, "10. Trả về KhachThueResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 620, "11. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 670, "12. Hiển thị: Cập nhật khách thuê thành công")

    return d.render()

# ==========================================
# 4. TAB: Sequence Xóa khách thuê
# ==========================================
def build_seq_xoa_khach_thue():
    d = ExactSequenceBuilder("seq_xoa_khach_thue", "Sequence Xóa khách thuê", width=1300, height=750)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=580)
    x_fe = d.add_lifeline("Frontend (Next.js)", 320, y=40, width=150, height=38, line_height=580)
    x_ctrl = d.add_lifeline("KhachThueController", 560, y=40, width=160, height=38, line_height=580)
    x_srv = d.add_lifeline("KhachThueService", 800, y=40, width=150, height=38, line_height=580)
    x_db = d.add_lifeline("PostgreSQL DB", 1040, y=40, width=150, height=38, line_height=580)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn Xóa khách thuê & Xác nhận trên Dialog")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. DELETE /api/khach-thue/{id}")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. deleteKhachThue(id)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & assertCanWrite(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về KhachThue entity")
    d.add_sync_msg(x_srv, x_db, 370, "6. setXoaLuc(now) & setTrangThaiNguoiDung(INACTIVE)")
    d.add_return_msg(x_db, x_srv, 420, "7. Xác nhận đã soft-delete & khóa tài khoản NguoiDung")
    d.add_return_msg(x_srv, x_ctrl, 470, "8. Trả về kết quả xóa thành công")
    d.add_return_msg(x_ctrl, x_fe, 520, "9. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 570, "10. Hiển thị: Xóa khách thuê thành công & Tải lại bảng")

    return d.render()

# ==========================================
# 5. TAB: Sequence Đăng nhập khách thuê (Portal)
# ==========================================
def build_seq_dang_nhap_khach_thue():
    d = ExactSequenceBuilder("seq_dang_nhap_portal", "Sequence Đăng nhập khách thuê", width=1300, height=720)
    
    x_tenant = d.add_actor("Khách thuê", 100, y=40, line_height=540)
    x_fe = d.add_lifeline("Frontend (Next.js)", 320, y=40, width=150, height=38, line_height=540)
    x_auth = d.add_lifeline("AuthController (NextAuth)", 570, y=40, width=170, height=38, line_height=540)
    x_srv = d.add_lifeline("KhachThueService", 820, y=40, width=150, height=38, line_height=540)
    x_db = d.add_lifeline("PostgreSQL DB", 1060, y=40, width=150, height=38, line_height=540)

    d.add_sync_msg(x_tenant, x_fe, 120, "1. Nhập SĐT & Mật khẩu (Pass mặc định '123456')")
    d.add_sync_msg(x_fe, x_auth, 170, "2. POST /api/auth/callback/credentials (Phone, Password)")
    d.add_sync_msg(x_auth, x_srv, 220, "3. authenticateTenant(phone, rawPassword)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findBySoDienThoai(phone) & checkActive()")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về NguoiDung (Băm BCrypt & Role KHACH_THUE)")
    d.add_self_msg(x_srv, 355, "6. passwordEncoder.matches(raw, hash)", width=45, height=25)
    d.add_return_msg(x_srv, x_auth, 410, "7. Trả về User hợp lệ & thông tin khách thuê")
    d.add_return_msg(x_auth, x_fe, 460, "8. Trả về Session Token (JWT)")
    d.add_return_msg(x_fe, x_tenant, 510, "9. Chuyển hướng vào Cổng khách thuê (/khach-thue/dashboard)")

    return d.render()

# ==========================================
# 6. TAB: Sequence Khách thuê báo sự cố
# ==========================================
def build_seq_bao_su_co():
    d = ExactSequenceBuilder("seq_bao_su_co", "Sequence Báo cáo sự cố", width=1450, height=780)
    
    x_tenant = d.add_actor("Khách thuê", 90, y=40, line_height=600)
    x_fe = d.add_lifeline("Frontend (Next.js)", 280, y=40, width=150, height=38, line_height=600)
    x_ctrl = d.add_lifeline("SuCoController", 480, y=40, width=150, height=38, line_height=600)
    x_srv = d.add_lifeline("SuCoService", 680, y=40, width=140, height=38, line_height=600)
    x_db = d.add_lifeline("PostgreSQL DB", 880, y=40, width=140, height=38, line_height=600)
    x_noti = d.add_lifeline("ThongBaoService", 1080, y=40, width=140, height=38, line_height=600)
    x_chutro = d.add_actor("Chủ trọ", 1280, y=40, line_height=600)

    d.add_sync_msg(x_tenant, x_fe, 120, "1. Điền form báo sự cố phòng trọ (Tiêu đề, Mô tả, Ảnh)")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. POST /api/su-co (SuCoRequest)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. createSuCo(request, currentTenantId)")
    d.add_sync_msg(x_srv, x_db, 270, "4. save(suCo: CHO_XU_LY, tenantId, phongId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về SuCo entity đã lưu")
    d.add_sync_msg(x_srv, x_noti, 370, "6. sendNotification(chuTroId, 'Khách thuê báo sự cố mới')")
    d.add_sync_msg(x_noti, x_chutro, 420, "7. Gửi Push Notification / Alert đến Chủ trọ")
    d.add_return_msg(x_noti, x_srv, 470, "8. Xác nhận đã gửi thông báo")
    d.add_return_msg(x_srv, x_ctrl, 510, "9. Trả về SuCoResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 550, "10. ApiResponse (HTTP 201 Created)")
    d.add_return_msg(x_fe, x_tenant, 590, "11. Hiển thị: Gửi báo cáo sự cố thành công")

    return d.render()

def generate_exact_diagrams():
    print("Generating Sequence Diagrams in EXACT requested style...")
    t1 = build_seq_them_khach_thue()
    t2 = build_seq_xem_danh_sach()
    t3 = build_seq_cap_nhat_khach_thue()
    t4 = build_seq_xoa_khach_thue()
    t5 = build_seq_dang_nhap_khach_thue()
    t6 = build_seq_bao_su_co()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T14:30:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
{t5}
{t6}
</mxfile>"""

    # Destination paths
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
    generate_exact_diagrams()
