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

    def add_lifeline(self, name, x, y=40, width=150, height=38, line_height=650):
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

    def add_self_msg(self, x, y, text, width=45, height=25):
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
# 1. TAB: Sequence Thêm mới tòa nhà
# ==========================================
def build_seq_them_toa_nha():
    d = ExactSequenceBuilder("seq_them_toa_nha", "Sequence Thêm mới tòa nhà", width=1450, height=880)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=710)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=710)
    x_ctrl = d.add_lifeline("NhaTroController", 540, y=40, width=150, height=38, line_height=710)
    x_srv = d.add_lifeline("NhaTroService", 760, y=40, width=150, height=38, line_height=710)
    x_db = d.add_lifeline("PostgreSQL DB", 980, y=40, width=140, height=38, line_height=710)
    x_dichvu = d.add_lifeline("DichVuRepo / Giá", 1190, y=40, width=140, height=38, line_height=710)

    # 12 steps flow
    d.add_sync_msg(x_chutro, x_fe, 120, "1. Nhập thông tin tòa nhà (Tên, Địa chỉ, Số tầng, Giá dịch vụ)")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. POST /api/toa-nha (NhaTroRequest JSON)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. createNhaTro(request)")
    d.add_sync_msg(x_srv, x_db, 270, "4. saveAndFlush(nhaTroEntity: chuTro = currentUser)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về NhaTro (Lưu thành công, UUID id)")
    d.add_self_msg(x_srv, 360, "6. generateRoomsFromCreateRequest(saved, request)", width=45, height=25)
    d.add_sync_msg(x_srv, x_db, 415, "7. saveAll(tầng & danh sách phòng khởi tạo ban đầu)")
    d.add_return_msg(x_db, x_srv, 465, "8. Xác nhận tạo thành công các tầng và phòng")
    d.add_sync_msg(x_srv, x_dichvu, 515, "9. saveDichVuToaNha(điện, nước, internet, rác...)")
    d.add_return_msg(x_dichvu, x_srv, 565, "10. Xác nhận lưu cấu hình đơn giá dịch vụ")
    d.add_return_msg(x_srv, x_ctrl, 615, "11. Trả về NhaTroResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 665, "12. ApiResponse (HTTP 200: Thêm tòa nhà thành công)")
    d.add_return_msg(x_fe, x_chutro, 715, "13. Hiển thị thông báo thành công & chuyển về trang chi tiết tòa nhà")

    return d.render()

# ==========================================
# 2. TAB: Sequence Xem danh sách tòa nhà
# ==========================================
def build_seq_xem_danh_sach_toa_nha():
    d = ExactSequenceBuilder("seq_xem_toa_nha", "Sequence Xem danh sách tòa nhà", width=1400, height=800)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=630)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=630)
    x_ctrl = d.add_lifeline("NhaTroController", 540, y=40, width=150, height=38, line_height=630)
    x_srv = d.add_lifeline("NhaTroService", 760, y=40, width=150, height=38, line_height=630)
    x_perm = d.add_lifeline("PermissionService", 980, y=40, width=140, height=38, line_height=630)
    x_db = d.add_lifeline("PostgreSQL DB", 1190, y=40, width=140, height=38, line_height=630)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Mở trang Tòa nhà / Nhập từ khóa tìm kiếm & chọn trang")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. GET /api/toa-nha?search=...&page=1&limit=10")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. getAllNhaTro(search, page, limit)")
    d.add_sync_msg(x_srv, x_perm, 270, "4. requireCurrentUserId() & getAllAccessibleNhaTroIds(userId)")
    d.add_return_msg(x_perm, x_srv, 320, "5. Trả về danh sách nhaTroIds thuộc quyền quản lý")
    d.add_sync_msg(x_srv, x_db, 370, "6. findAllAccessible(isAdmin, nhaTroIds, search, pageable)")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về Page<NhaTro> kèm số lượng phòng & tầng")
    d.add_self_msg(x_srv, 460, "8. Map tỷ lệ lấp đầy, số phòng trống / đang thuê", width=45, height=25)
    d.add_return_msg(x_srv, x_ctrl, 520, "9. Trả về PaginatedResponse<NhaTroResponse>")
    d.add_return_msg(x_ctrl, x_fe, 570, "10. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 620, "11. Hiển thị danh sách card/bảng tòa nhà (Tên, Địa chỉ, Số phòng, Doanh thu)")

    return d.render()

# ==========================================
# 3. TAB: Sequence Sơ đồ & Thống kê tòa nhà
# ==========================================
def build_seq_so_do_thong_ke():
    d = ExactSequenceBuilder("seq_so_do_thong_ke", "Sequence Sơ đồ & Thống kê", width=1400, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=660)
    x_ctrl = d.add_lifeline("NhaTroController", 540, y=40, width=150, height=38, line_height=660)
    x_srv = d.add_lifeline("NhaTroService", 760, y=40, width=150, height=38, line_height=660)
    x_tang_repo = d.add_lifeline("TangRepository", 980, y=40, width=140, height=38, line_height=660)
    x_phong_repo = d.add_lifeline("PhongRepository", 1190, y=40, width=140, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn xem Sơ đồ phòng & Thống kê của tòa nhà")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. GET /api/toa-nha/{id}/so-do & GET /api/toa-nha/{id}/thong-ke")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. getSoDoToaNha(id) & getThongKeToaNha(id)")
    d.add_sync_msg(x_srv, x_tang_repo, 270, "4. findByNhaTroIdOrderBySoTangAsc(id)")
    d.add_return_msg(x_tang_repo, x_srv, 320, "5. Trả về danh sách tầng (Tang list)")
    d.add_sync_msg(x_srv, x_phong_repo, 370, "6. findByNhaTroId(id) (Lấy toàn bộ phòng & trạng thái)")
    d.add_return_msg(x_phong_repo, x_srv, 420, "7. Trả về danh sách Phong (TRONG, DANG_THUE, DANG_SUA...)")
    d.add_self_msg(x_srv, 460, "8. Gom nhóm phòng theo từng tầng & tính tỷ lệ lấp đầy", width=45, height=25)
    d.add_return_msg(x_srv, x_ctrl, 520, "9. Trả về SoDoToaNhaResponse & ThongKeToaNhaResponse")
    d.add_return_msg(x_ctrl, x_fe, 570, "10. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 620, "11. Render ma trận Sơ đồ phòng theo tầng & biểu đồ thống kê")

    return d.render()

# ==========================================
# 4. TAB: Sequence Tạo phòng hàng loạt
# ==========================================
def build_seq_generate_rooms():
    d = ExactSequenceBuilder("seq_generate_rooms", "Sequence Tạo phòng hàng loạt", width=1400, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=660)
    x_ctrl = d.add_lifeline("NhaTroController", 540, y=40, width=150, height=38, line_height=660)
    x_srv = d.add_lifeline("NhaTroService", 760, y=40, width=150, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 990, y=40, width=140, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn 'Tạo phòng nhanh' (Số tầng, Số phòng/tầng, Giá thuê, Tiền cọc)")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. POST /api/toa-nha/{id}/generate-rooms (GenerateRoomsRequest)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. generateRooms(id, request)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & assertCanWrite(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về NhaTro entity hợp lệ")
    d.add_self_msg(x_srv, 360, "6. Sinh danh sách Tang & Phong theo tiền tố đánh số (P101, P102...)", width=45, height=25)
    d.add_sync_msg(x_srv, x_db, 415, "7. tangRepository.saveAll() & phongRepository.saveAll()")
    d.add_return_msg(x_db, x_srv, 465, "8. Xác nhận đã lưu toàn bộ danh sách phòng mới")
    d.add_return_msg(x_srv, x_ctrl, 515, "9. Trả về GenerateRoomsResponse (Số phòng đã tạo thành công)")
    d.add_return_msg(x_ctrl, x_fe, 565, "10. ApiResponse (HTTP 200: Tạo phòng hàng loạt thành công)")
    d.add_return_msg(x_fe, x_chutro, 615, "11. Hiển thị thông báo thành công & cập nhật lại sơ đồ phòng")

    return d.render()

# ==========================================
# 5. TAB: Sequence Cập nhật tòa nhà
# ==========================================
def build_seq_cap_nhat_toa_nha():
    d = ExactSequenceBuilder("seq_cap_nhat_toa_nha", "Sequence Cập nhật tòa nhà", width=1400, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=660)
    x_ctrl = d.add_lifeline("NhaTroController", 540, y=40, width=150, height=38, line_height=660)
    x_srv = d.add_lifeline("NhaTroService", 760, y=40, width=150, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 990, y=40, width=140, height=38, line_height=660)
    x_dichvu = d.add_lifeline("DichVuRepo", 1200, y=40, width=140, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Sửa thông tin tòa nhà (Tên, Địa chỉ, Tiện ích, Giá dịch vụ) & Bấm Lưu")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. PUT /api/toa-nha/{id} (NhaTroRequest)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. updateNhaTro(id, request)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & assertCanWrite(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về NhaTro entity hợp lệ")
    d.add_sync_msg(x_srv, x_db, 370, "6. mapRequestToEntity() & save(updatedNhaTro)")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về NhaTro (Cập nhật thành công)")
    d.add_sync_msg(x_srv, x_dichvu, 470, "8. saveDichVuToaNha(request.getDichVuList())")
    d.add_return_msg(x_dichvu, x_srv, 520, "9. Xác nhận cập nhật bảng giá dịch vụ mới")
    d.add_return_msg(x_srv, x_ctrl, 570, "10. Trả về NhaTroResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 620, "11. ApiResponse (HTTP 200: Cập nhật tòa nhà thành công)")
    d.add_return_msg(x_fe, x_chutro, 670, "12. Hiển thị thông báo thành công & cập nhật lại giao diện")

    return d.render()

# ==========================================
# 6. TAB: Sequence Xóa tòa nhà
# ==========================================
def build_seq_xoa_toa_nha():
    d = ExactSequenceBuilder("seq_xoa_toa_nha", "Sequence Xóa tòa nhà", width=1400, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=660)
    x_ctrl = d.add_lifeline("NhaTroController", 540, y=40, width=150, height=38, line_height=660)
    x_srv = d.add_lifeline("NhaTroService", 760, y=40, width=150, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 990, y=40, width=140, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn 'Xóa tòa nhà' & Xác nhận trên Hộp thoại cảnh báo")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. DELETE /api/toa-nha/{id}")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. deleteNhaTro(id)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & assertCanWrite(currentUserId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về NhaTro entity")
    d.add_sync_msg(x_srv, x_db, 370, "6. countByNhaTroIdAndTrangThai(RENTED) (Kiểm tra phòng có người thuê)")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về 0 (Không còn phòng nào đang thuê)")
    d.add_sync_msg(x_srv, x_db, 470, "8. setXoaLuc(now) & UPDATE phong, tang SET xoa_luc = now")
    d.add_return_msg(x_db, x_srv, 520, "9. Xác nhận đã soft-delete tòa nhà cùng các tầng và phòng trực thuộc")
    d.add_return_msg(x_srv, x_ctrl, 570, "10. Trả về void (Thành công)")
    d.add_return_msg(x_ctrl, x_fe, 620, "11. ApiResponse (HTTP 200: Xóa tòa nhà thành công)")
    d.add_return_msg(x_fe, x_chutro, 670, "12. Hiển thị thông báo thành công & điều hướng về danh sách tòa nhà")

    return d.render()

def generate_all_toa_nha():
    print("Generating Sequence Diagrams for TOA NHA in exact minimalist form...")
    t1 = build_seq_them_toa_nha()
    t2 = build_seq_xem_danh_sach_toa_nha()
    t3 = build_seq_so_do_thong_ke()
    t4 = build_seq_generate_rooms()
    t5 = build_seq_cap_nhat_toa_nha()
    t6 = build_seq_xoa_toa_nha()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T15:00:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
{t5}
{t6}
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
    generate_all_toa_nha()
