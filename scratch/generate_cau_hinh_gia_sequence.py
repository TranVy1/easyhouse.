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
# 1. TAB: Sequence Thêm mới cấu hình giá
# ==========================================
def build_seq_them_cau_hinh_gia():
    d = ExactSequenceBuilder("seq_them_cau_hinh_gia", "Sequence Thêm cấu hình giá", width=1450, height=880)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=710)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=710)
    x_ctrl = d.add_lifeline("CauHinhGiaController", 530, y=40, width=160, height=38, line_height=710)
    x_srv = d.add_lifeline("CauHinhGiaService", 760, y=40, width=150, height=38, line_height=710)
    x_db = d.add_lifeline("PostgreSQL DB", 990, y=40, width=140, height=38, line_height=710)
    x_audit = d.add_lifeline("AuditLogRepository", 1210, y=40, width=150, height=38, line_height=710)

    # 13 steps flow
    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn nhà trọ, loại dịch vụ (Điện/Nước/Dịch vụ), nhập Đơn giá & Ngày hiệu lực")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. POST /api/cau-hinh-gia (CauHinhGiaRequest JSON)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. create(request: CauHinhGiaRequest)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(nhaTroId) & checkWritePermission(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về NhaTro hợp lệ")
    d.add_self_msg(x_srv, 360, "6. validateMoney(donGia) & validateOverlap(entity)", width=45, height=25)
    d.add_sync_msg(x_srv, x_db, 415, "7. deactivateExistingConfigs() (Chốt ngày hết hạn cấu hình cũ = hieuLucTu - 1)")
    d.add_return_msg(x_db, x_srv, 465, "8. Xác nhận đã cập nhật trạng thái cấu hình giá cũ")
    d.add_sync_msg(x_srv, x_db, 515, "9. save(newCauHinhGia: dangApDung = true)")
    d.add_return_msg(x_db, x_srv, 565, "10. Trả về CauHinhGia entity (Lưu thành công, UUID id)")
    d.add_sync_msg(x_srv, x_audit, 615, "11. logAudit(saved, 'CREATE') (Ghi lịch sử thay đổi bảng giá)")
    d.add_return_msg(x_srv, x_ctrl, 660, "12. Trả về CauHinhGiaResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 705, "13. ApiResponse (HTTP 200: Tạo cấu hình giá thành công)")
    d.add_return_msg(x_fe, x_chutro, 750, "14. Hiển thị thông báo thành công & cập nhật lại bảng giá dịch vụ")

    return d.render()

# ==========================================
# 2. TAB: Sequence Xem & Lọc cấu hình giá
# ==========================================
def build_seq_xem_cau_hinh_gia():
    d = ExactSequenceBuilder("seq_xem_cau_hinh_gia", "Sequence Xem & Lọc cấu hình giá", width=1400, height=800)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=630)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=630)
    x_ctrl = d.add_lifeline("CauHinhGiaController", 540, y=40, width=160, height=38, line_height=630)
    x_srv = d.add_lifeline("CauHinhGiaService", 770, y=40, width=150, height=38, line_height=630)
    x_perm = d.add_lifeline("PermissionService", 980, y=40, width=140, height=38, line_height=630)
    x_db = d.add_lifeline("PostgreSQL DB", 1190, y=40, width=140, height=38, line_height=630)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn lọc theo nhà trọ, loại mục (ELECTRICITY/WATER/SERVICE) & trạng thái áp dụng")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. GET /api/cau-hinh-gia?nhaTroId=...&loai=...&dangApDung=true&page=1&limit=10")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. getAll(nhaTroId, loai, dangApDung, pageable)")
    d.add_sync_msg(x_srv, x_perm, 270, "4. requireCurrentUserId() & getAllAccessibleNhaTroIds(userId)")
    d.add_return_msg(x_perm, x_srv, 320, "5. Trả về danh sách nhaTroIds được cấp quyền quản lý")
    d.add_sync_msg(x_srv, x_db, 370, "6. findAll(Specification<CauHinhGia>, pageable)")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về Page<CauHinhGia> danh sách bảng giá")
    d.add_self_msg(x_srv, 460, "8. Map entity sang CauHinhGiaResponse.fromEntity()", width=45, height=25)
    d.add_return_msg(x_srv, x_ctrl, 520, "9. Trả về PaginatedResponse<CauHinhGiaResponse>")
    d.add_return_msg(x_ctrl, x_fe, 570, "10. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 620, "11. Hiển thị bảng cấu hình đơn giá dịch vụ (Điện, Nước, Rác, Wifi, Thang máy...)")

    return d.render()

# ==========================================
# 3. TAB: Sequence Lấy đơn giá áp dụng
# ==========================================
def build_seq_lay_gia_ap_dung():
    d = ExactSequenceBuilder("seq_lay_gia_ap_dung", "Sequence Lấy giá áp dụng", width=1400, height=780)
    
    x_actor = d.add_actor("Chủ trọ / Hệ thống", 100, y=40, line_height=610)
    x_fe = d.add_lifeline("Frontend (Lập HĐ)", 310, y=40, width=150, height=38, line_height=610)
    x_ctrl = d.add_lifeline("CauHinhGiaController", 540, y=40, width=160, height=38, line_height=610)
    x_srv = d.add_lifeline("CauHinhGiaService", 770, y=40, width=150, height=38, line_height=610)
    x_db = d.add_lifeline("PostgreSQL DB", 1000, y=40, width=150, height=38, line_height=610)

    d.add_sync_msg(x_actor, x_fe, 120, "1. Nhập chỉ số điện/nước hoặc lập hóa đơn tháng (chọn ngày tính tiền)")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. GET /api/cau-hinh-gia/ap-dung?nhaTroId=...&loai=ELECTRICITY&ngayApDung=2026-08-01")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. getApplicable(nhaTroId, loai, ngayApDung)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(nhaTroId) & checkReadPermission(userId)")
    d.add_return_msg(x_db, x_srv, 320, "5. Xác nhận quyền xem nhà trọ")
    d.add_sync_msg(x_srv, x_db, 370, "6. findApplicable(nhaTroId, loai, effectiveDate) (hieuLucTu <= ngày <= hieuLucDen)")
    d.add_return_msg(x_db, x_srv, 420, "7. Trả về CauHinhGia entity đang có hiệu lực tại thời điểm")
    d.add_return_msg(x_srv, x_ctrl, 470, "8. Trả về CauHinhGiaResponse (Đơn giá: 3.500đ/kWh, Loại tính phí: PER_UNIT)")
    d.add_return_msg(x_ctrl, x_fe, 520, "9. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_actor, 570, "10. Tự động điền đơn giá vào form tính tiền điện/nước của hóa đơn")

    return d.render()

# ==========================================
# 4. TAB: Sequence Cập nhật & Tạo phiên bản giá
# ==========================================
def build_seq_cap_nhat_gia():
    d = ExactSequenceBuilder("seq_cap_nhat_gia", "Sequence Cập nhật & Tạo phiên bản", width=1450, height=880)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=710)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=710)
    x_ctrl = d.add_lifeline("CauHinhGiaController", 530, y=40, width=160, height=38, line_height=710)
    x_srv = d.add_lifeline("CauHinhGiaService", 760, y=40, width=150, height=38, line_height=710)
    x_db = d.add_lifeline("PostgreSQL DB", 990, y=40, width=140, height=38, line_height=710)
    x_audit = d.add_lifeline("AuditLogRepository", 1210, y=40, width=150, height=38, line_height=710)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Điều chỉnh đơn giá mới (VD: Giá điện tăng lên 3.800đ) & chọn ngày bắt đầu áp dụng")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. PUT /api/cau-hinh-gia/{id} (CauHinhGiaRequest)")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. update(id, request)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & checkWritePermission(oldEntity.getNhaTro())")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về CauHinhGia phiên bản cũ")
    d.add_self_msg(x_srv, 360, "6. validateMoney(newDonGia) & validateOverlap(newEntity, oldId)", width=45, height=25)
    d.add_sync_msg(x_srv, x_db, 415, "7. deactivateExistingConfigs() (Chốt hieuLucDen của bản ghi cũ = ngayApDungMoi - 1)")
    d.add_return_msg(x_db, x_srv, 465, "8. Xác nhận đã chốt hạn hiệu lực phiên bản giá cũ")
    d.add_sync_msg(x_srv, x_db, 515, "9. save(newEntity: phiên bản giá mới, dangApDung = true)")
    d.add_return_msg(x_db, x_srv, 565, "10. Trả về CauHinhGia (Phiên bản mới lưu thành công)")
    d.add_sync_msg(x_srv, x_audit, 615, "11. logAudit(saved, 'UPDATE_VERSION')")
    d.add_return_msg(x_srv, x_ctrl, 660, "12. Trả về CauHinhGiaResponse DTO")
    d.add_return_msg(x_ctrl, x_fe, 705, "13. ApiResponse (HTTP 200: Cập nhật cấu hình giá thành công)")
    d.add_return_msg(x_fe, x_chutro, 750, "14. Hiển thị thông báo thành công & cập nhật lịch sử biến động giá")

    return d.render()

# ==========================================
# 5. TAB: Sequence Ngừng áp dụng cấu hình giá
# ==========================================
def build_seq_ngung_ap_dung():
    d = ExactSequenceBuilder("seq_ngung_ap_dung", "Sequence Ngừng áp dụng giá", width=1450, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Next.js)", 310, y=40, width=150, height=38, line_height=660)
    x_ctrl = d.add_lifeline("CauHinhGiaController", 530, y=40, width=160, height=38, line_height=660)
    x_srv = d.add_lifeline("CauHinhGiaService", 760, y=40, width=150, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 990, y=40, width=140, height=38, line_height=660)
    x_audit = d.add_lifeline("AuditLogRepository", 1210, y=40, width=150, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Chọn 'Ngừng áp dụng' dịch vụ/bảng giá & Xác nhận")
    d.add_sync_msg(x_fe, x_ctrl, 170, "2. DELETE /api/cau-hinh-gia/{id}")
    d.add_sync_msg(x_ctrl, x_srv, 220, "3. deactivate(id)")
    d.add_sync_msg(x_srv, x_db, 270, "4. findById(id) & checkWritePermission(entity.getNhaTro())")
    d.add_return_msg(x_db, x_srv, 320, "5. Trả về CauHinhGia entity")
    d.add_self_msg(x_srv, 360, "6. entity.setDangApDung(false) & entity.setHieuLucDen(LocalDate.now())", width=45, height=25)
    d.add_sync_msg(x_srv, x_db, 415, "7. save(entity)")
    d.add_return_msg(x_db, x_srv, 465, "8. Xác nhận đã cập nhật trạng thái ngừng áp dụng")
    d.add_sync_msg(x_srv, x_audit, 515, "9. logAudit(saved, 'DEACTIVATE')")
    d.add_return_msg(x_srv, x_ctrl, 565, "10. Trả về void (Thành công)")
    d.add_return_msg(x_ctrl, x_fe, 615, "11. ApiResponse (HTTP 200: Ngừng áp dụng cấu hình giá thành công)")
    d.add_return_msg(x_fe, x_chutro, 665, "12. Cập nhật badge trạng thái 'Ngừng áp dụng' trên bảng giá")

    return d.render()

# ==========================================
# 6. TAB: Sequence Tự động áp giá khi lập hóa đơn
# ==========================================
def build_seq_tich_hop_lap_hoa_don():
    d = ExactSequenceBuilder("seq_tich_hop_hoa_don", "Sequence Áp giá khi lập hóa đơn", width=1450, height=830)
    
    x_chutro = d.add_actor("Chủ trọ", 100, y=40, line_height=660)
    x_fe = d.add_lifeline("Frontend (Lập HĐ)", 310, y=40, width=150, height=38, line_height=660)
    x_hd_ctrl = d.add_lifeline("HoaDonController", 520, y=40, width=150, height=38, line_height=660)
    x_hd_srv = d.add_lifeline("HoaDonService", 720, y=40, width=140, height=38, line_height=660)
    x_chg_srv = d.add_lifeline("CauHinhGiaService", 930, y=40, width=150, height=38, line_height=660)
    x_db = d.add_lifeline("PostgreSQL DB", 1140, y=40, width=140, height=38, line_height=660)

    d.add_sync_msg(x_chutro, x_fe, 120, "1. Nhập chỉ số điện mới (50 kWh) & nước mới (3 m3) cho phòng")
    d.add_sync_msg(x_fe, x_hd_ctrl, 170, "2. POST /api/hoa-don/tinh-tien (HoaDonCalculationRequest)")
    d.add_sync_msg(x_hd_ctrl, x_hd_srv, 220, "3. calculateInvoicePreview(phongId, chiSoDien, chiSoNuoc, ngayLap)")
    d.add_sync_msg(x_hd_srv, x_chg_srv, 270, "4. getApplicable(nhaTroId, ELECTRICITY, ngayLap) & getApplicable(WATER)")
    d.add_sync_msg(x_chg_srv, x_db, 320, "5. findApplicable(nhaTroId, loai, ngayLap)")
    d.add_return_msg(x_db, x_chg_srv, 370, "6. Trả về đơn giá điện (3.500đ/kWh) & nước (25.000đ/m3)")
    d.add_return_msg(x_chg_srv, x_hd_srv, 420, "7. Trả về CauHinhGiaResponse cho từng loại mục")
    d.add_self_msg(x_hd_srv, 460, "8. Tính thành tiền = Tiêu thụ * Đơn giá + Tiền phòng + Phí dịch vụ", width=45, height=25)
    d.add_return_msg(x_hd_srv, x_hd_ctrl, 520, "9. Trả về HoaDonPreviewResponse (Tổng tiền & chi tiết từng mục)")
    d.add_return_msg(x_hd_ctrl, x_fe, 570, "10. ApiResponse (HTTP 200 OK)")
    d.add_return_msg(x_fe, x_chutro, 620, "11. Hiển thị bảng kê chi tiết hóa đơn: Đơn giá, Số lượng, Thành tiền")

    return d.render()

def generate_all_cau_hinh_gia():
    print("Generating Sequence Diagrams for CAU HINH GIA in exact minimalist form...")
    t1 = build_seq_them_cau_hinh_gia()
    t2 = build_seq_xem_cau_hinh_gia()
    t3 = build_seq_lay_gia_ap_dung()
    t4 = build_seq_cap_nhat_gia()
    t5 = build_seq_ngung_ap_dung()
    t6 = build_seq_tich_hop_lap_hoa_don()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T16:00:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
{t5}
{t6}
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
    generate_all_cau_hinh_gia()
