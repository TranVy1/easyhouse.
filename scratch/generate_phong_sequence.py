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
# 1. TAB: Sequence Thêm mới phòng
# ==========================================
def build_seq_them_phong():
    d = ExactSequenceBuilder("seq_them_phong", "Sequence Thêm mới phòng", width=1450, height=880)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=710)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=710)
    x_ctrl = d.add_lifeline("PhongController", 530, y=40, width=150, height=38, line_height=710)
    x_srv = d.add_lifeline("PhongService", 750, y=40, width=140, height=38, line_height=710)
    x_db = d.add_lifeline("PostgreSQL DB", 970, y=40, width=140, height=38, line_height=710)
    x_media = d.add_lifeline("MediaService / Tiện nghi", 1200, y=40, width=160, height=38, line_height=710)

    # 13 steps flow
    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn tòa nhà & nhập thông tin phòng (Tên, Tầng, Giá, Cọc, Tiện nghi, Ảnh)")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. POST /api/phong (PhongRequest JSON)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. createPhong(request)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(nhaTroId) & existsByNhaTroIdAndTen(ten)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về NhaTro hợp lệ & Tên phòng chưa tồn tại")
    d.add_self_msg(x_srv, 360, "6. resolveTang(nhaTroId, tangId, soTang)", width=45, height=25)
    d.add_sync_msg(x_srv, x_db, 415, "7. saveAndFlush(phongEntity: AVAILABLE)")
    d.add_return_msg(x_db, x_srv, 465, "8. Trả về Phong (Lưu thành công, UUID id)")
    d.add_sync_msg(x_srv, x_media, 515, "9. replaceUrls(ROOM_IMAGE) & replacePhongTienIch(tienNghiList)")
    d.add_return_msg(x_media, x_srv, 565, "10. Xác nhận lưu ảnh phòng Cloudinary & danh sách tiện nghi")
    d.add_return_msg(x_srv, x_ctrl, 615, "11. Trả về PhongResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 665, "12. ApiResponse (HTTP 200: Thêm phòng thành công)")
    d.add_return_msg(x_fe, x_chutro, 715, "13. Hiển thị thông báo thành công & cập nhật lại danh sách phòng")

    return d.render()

# ==========================================
# 2. TAB: Sequence Xem & Lọc danh sách phòng
# ==========================================
def build_seq_xem_danh_sach_phong():
    d = ExactSequenceBuilder("seq_xem_phong", "Sequence Xem & Lọc phòng", width=1400, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=660)
    x_ctrl = d.add_lifeline("PhongController", 530, y=40, width=150, height=38, line_height=660)
    x_srv = d.add_lifeline("PhongService", 750, y=40, width=140, height=38, line_height=660)
    x_perm = d.add_lifeline("PermissionService", 970, y=40, width=140, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 1190, y=40, width=140, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn lọc theo tòa nhà, trạng thái (TRỐNG/ĐANG THUÊ) & tìm kiếm")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. GET /api/phong?toaNha=...&trangThai=...&search=...&page=1&limit=10")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. getAllPhong(toaNha, trangThai, search, page, limit, simple)")
    d.add_sync_msg(x_srv, x_perm, 270, "4. requireCurrentUserId() & getAllAccessibleNhaTroIds(userId)")
    d.add_return_msg(x_perm, x_srv, 320, "5. Trả về danh sách nhaTroIds được phân quyền")
    d.add_sync_msg(x_srv, x_db, 370, "6. findAllAccessible(nid, trangThai, search, isAdmin, nhaTroIds, pageable)")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về Page<Phong> danh sách phòng")
    d.add_self_msg(x_srv, 460, "8. Map thông tin HopDong đang hoạt động, ảnh phòng & tiện ích", width=45, height=25)
    d.add_return_msg(x_srv, x_ctrl, 520, "9. Trả về PaginatedResponse<PhongResponse>")
    d.add_return_msg(x_ctrl, x_fe, 570, "10. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 620, "11. Hiển thị danh sách card/bảng phòng (Tên, Tòa nhà, Trạng thái, Giá, Người thuê)")

    return d.render()

# ==========================================
# 3. TAB: Sequence Chi tiết & Tài sản phòng
# ==========================================
def build_seq_chi_tiet_tai_san_phong():
    d = ExactSequenceBuilder("seq_chi_tiet_phong", "Sequence Chi tiết & Tài sản phòng", width=1450, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=660)
    x_ctrl = d.add_lifeline("PhongController", 530, y=40, width=150, height=38, line_height=660)
    x_srv = d.add_lifeline("PhongService", 750, y=40, width=140, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 970, y=40, width=140, height=38, line_height=660)
    x_taisan = d.add_lifeline("TaiSanPhongRepo", 1200, y=40, width=150, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Nhấp chọn xem chi tiết phòng trọ")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. GET /api/phong/{id}")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. getPhongById(id)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & assertCanRead(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về Phong entity")
    d.add_sync_msg(x_srv, x_db, 370, "6. findFirstByPhongIdAndTrangThai(ACTIVE) (Lấy hợp đồng & người thuê)")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về HopDong active (Họ tên khách, SĐT, Ngày bắt đầu)")
    d.add_sync_msg(x_srv, x_taisan, 470, "8. findByPhongId(phongId) (Danh mục tài sản & thiết bị trong phòng)")
    d.add_return_msg(x_taisan, x_srv, 520, "9. Trả về danh sách TaiSanPhong (Điều hòa, Tủ lạnh, Giường, Tình trạng)")
    d.add_return_msg(x_srv, x_ctrl, 570, "10. Trả về PhongResponse DTO đầy đủ")
    d.add_return_msg(x_ctrl, x_fe, 620, "11. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 670, "12. Hiển thị trang chi tiết phòng: Thông tin, Khách thuê, Tiện nghi, Tài sản")

    return d.render()

# ==========================================
# 4. TAB: Sequence Cập nhật phòng
# ==========================================
def build_seq_cap_nhat_phong():
    d = ExactSequenceBuilder("seq_cap_nhat_phong", "Sequence Cập nhật phòng", width=1450, height=850)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=680)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=680)
    x_ctrl = d.add_lifeline("PhongController", 530, y=40, width=150, height=38, line_height=680)
    x_srv = d.add_lifeline("PhongService", 750, y=40, width=140, height=38, line_height=680)
    x_db = d.add_lifeline("PostgreSQL DB", 970, y=40, width=140, height=38, line_height=680)
    x_media = d.add_lifeline("MediaService / Tiện nghi", 1200, y=40, width=160, height=38, line_height=680)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chỉnh sửa thông tin phòng (Giá thuê, Trạng thái, Diện tích, Ảnh...) & Bấm Lưu")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. PUT /api/phong/{id} (PhongRequest)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. updatePhong(id, request)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & assertCanWrite(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về Phong entity hợp lệ")
    d.add_sync_msg(x_srv, x_db, 370, "6. existsByTenAndIdNot() (Kiểm tra trùng tên khi đổi tên phòng)")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về false (Tên hợp lệ)")
    d.add_sync_msg(x_srv, x_db, 470, "8. saveAndFlush(updatedPhong)")
    d.add_return_msg(x_db, x_srv, 520, "9. Trả về Phong (Cập nhật thành công)")
    d.add_sync_msg(x_srv, x_media, 570, "10. replaceUrls(ROOM_IMAGE) & replacePhongTienIch(tienNghi)")
    d.add_return_msg(x_media, x_srv, 615, "11. Xác nhận cập nhật ảnh và tiện nghi mới")
    d.add_return_msg(x_srv, x_ctrl, 660, "12. Trả về PhongResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 705, "13. ApiResponse (HTTP 200: Cập nhật phòng thành công)")
    d.add_return_msg(x_fe, x_chutro, 750, "14. Hiển thị thông báo thành công & cập nhật lại giao diện phòng")

    return d.render()

# ==========================================
# 5. TAB: Sequence Xóa phòng
# ==========================================
def build_seq_xoa_phong():
    d = ExactSequenceBuilder("seq_xoa_phong", "Sequence Xóa phòng", width=1400, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=660)
    x_ctrl = d.add_lifeline("PhongController", 530, y=40, width=150, height=38, line_height=660)
    x_srv = d.add_lifeline("PhongService", 750, y=40, width=140, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 970, y=40, width=140, height=38, line_height=660)
    x_hd_repo = d.add_lifeline("HopDongRepo", 1190, y=40, width=140, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn 'Xóa phòng' & Xác nhận trên Dialog cảnh báo")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. DELETE /api/phong/{id}")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. deletePhong(id)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & assertCanWrite(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về Phong entity")
    d.add_sync_msg(x_srv, x_hd_repo, 370, "6. findRoomOccupyingContracts(id, [PENDING, ACTIVE])")
    d.add_return_msg(x_hd_repo, x_srv, 420, "7. Trả về danh sách rỗng (Không có hợp đồng nào đang hiệu lực)")
    d.add_sync_msg(x_srv, x_db, 470, "8. setXoaLuc(ZonedDateTime.now()) & save(phong)")
    d.add_return_msg(x_db, x_srv, 520, "9. Xác nhận đã soft-delete phòng thành công")
    d.add_return_msg(x_srv, x_ctrl, 570, "10. Trả về void (Thành công)")
    d.add_return_msg(x_ctrl, x_fe, 620, "11. ApiResponse (HTTP 200: Xóa phòng thành công)")
    d.add_return_msg(x_fe, x_chutro, 670, "12. Hiển thị thông báo thành công & xóa phòng khỏi danh sách")

    return d.render()

# ==========================================
# 6. TAB: Sequence Khách tìm phòng công khai
# ==========================================
def build_seq_khach_tim_phong():
    d = ExactSequenceBuilder("seq_khach_tim_phong", "Sequence Tìm phòng công khai", width=1400, height=830)
    
    x_khach = d.add_actor("Khách thuê / Vãng lai", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Xem phòng)", 330, y=40, width=160, height=38, line_height=660)
    x_ctrl = d.add_lifeline("PublicPhongController", 570, y=40, width=160, height=38, line_height=660)
    x_srv = d.add_lifeline("PhongService", 800, y=40, width=140, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 1030, y=40, width=140, height=38, line_height=660)

    d.add_sync_msg(x_khach, x_fe, 120, "1. Truy cập trang /xem-phong & chọn bộ lọc (Khu vực, Mức giá, Bán kính GPS)")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. GET /api/public/phong/nearby?viDo=...&kinhDo=...&radiusKm=5&minGia=...")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. getPublicNearbyPhong(viDo, kinhDo, radiusKm, ...)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findPublicNearbyCandidates(trangThai = AVAILABLE)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về danh sách phòng trống khả dụng")
    d.add_self_msg(x_srv, 360, "6. calculateDistanceKm() (Tính khoảng cách theo công thức Haversine)", width=45, height=25)
    d.add_self_msg(x_srv, 415, "7. Lọc phòng trong bán kính <= 5km & sắp xếp theo khoảng cách gần nhất", width=45, height=25)
    d.add_return_msg(x_srv, x_ctrl, 475, "8. Trả về PaginatedResponse<PublicPhongSummaryResponse>")
    d.add_return_msg(x_ctrl, x_fe, 525, "9. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_khach, 575, "10. Render danh sách phòng kèm ảnh, giá, khoảng cách và nút Đặt lịch xem phòng")

    return d.render()

def generate_all_phong():
    print("Generating Sequence Diagrams for PHONG in exact minimalist form...")
    t1 = build_seq_them_phong()
    t2 = build_seq_xem_danh_sach_phong()
    t3 = build_seq_chi_tiet_tai_san_phong()
    t4 = build_seq_cap_nhat_phong()
    t5 = build_seq_xoa_phong()
    t6 = build_seq_khach_tim_phong()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T15:30:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
{t5}
{t6}
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
    generate_all_phong()
