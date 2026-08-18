import os
import sys
import html

if sys.stdout.encoding.lower() != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from diag_builder import SequenceDiagramBuilder

def build_tab1_principles():
    d = SequenceDiagramBuilder("tab1_principles", "1. Nguyên Tắc Vẽ Sequence Diagram", width=1650, height=1280)
    d.add_title_header(
        "HƯỚNG DẪN & NGUYÊN TẮC VẼ SEQUENCE DIAGRAM (UML 2.5)",
        "Tổng hợp các thành phần cốt lõi, ký hiệu chuẩn UML, 6 nguyên tắc vàng và sơ đồ mẫu đối chiếu.",
        "UML SPECIFICATION CHEAT SHEET"
    )

    # 4 Overview Cards on top
    d.add_custom_box(40, 120, 360, 210, """<div style="font-family:Segoe UI,sans-serif;">
  <div style="font-size:13px;font-weight:bold;color:#0D47A1;margin-bottom:6px;border-bottom:1.5px solid #BBDEFB;padding-bottom:4px;">1. Khái Niệm & Mục Đích</div>
  <ul style="margin:0;padding-left:16px;font-size:11px;color:#37474F;line-height:1.5;">
    <li><b>Sequence Diagram (Biểu đồ tuần tự)</b> là một loại biểu đồ tương tác thuộc UML, mô tả cách các đối tượng trao đổi thông điệp theo <b>thứ tự thời gian</b>.</li>
    <li><b>Mục đích chính:</b>
      <ul>
        <li>Hiện thực hóa chi tiết từng Use Case.</li>
        <li>Xác định trách nhiệm và ranh giới giữa các tầng (Controller &rarr; Service &rarr; Repository).</li>
        <li>Làm cầu nối chuẩn xác giữa phân tích nghiệp vụ và lập trình.</li>
      </ul>
    </li>
  </ul>
</div>""", bg="#E3F2FD", border="#90CAF9")

    d.add_custom_box(420, 120, 390, 210, """<div style="font-family:Segoe UI,sans-serif;">
  <div style="font-size:13px;font-weight:bold;color:#1B5E20;margin-bottom:6px;border-bottom:1.5px solid #C8E6C9;padding-bottom:4px;">2. Các Thành Phần Cơ Bản (Core Elements)</div>
  <table style="width:100%;font-size:11px;color:#37474F;line-height:1.4;">
    <tr><td style="width:110px;font-weight:bold;color:#2E7D32;">Actor (Tác nhân):</td><td>Người dùng hoặc hệ thống ngoài tương tác với app.</td></tr>
    <tr><td style="font-weight:bold;color:#2E7D32;">Lifeline (Đường sống):</td><td>Đường đứt nét thể hiện sự tồn tại của đối tượng qua thời gian.</td></tr>
    <tr><td style="font-weight:bold;color:#2E7D32;">Activation Box:</td><td>Hình chữ nhật thể hiện đối tượng đang trực tiếp thực thi tác vụ.</td></tr>
    <tr><td style="font-weight:bold;color:#2E7D32;">Message (Thông điệp):</td><td>Lệnh gọi hàm/HTTP request giữa các đối tượng.</td></tr>
  </table>
</div>""", bg="#E8F5E9", border="#A5D6A7")

    d.add_custom_box(830, 120, 380, 210, """<div style="font-family:Segoe UI,sans-serif;">
  <div style="font-size:13px;font-weight:bold;color:#E65100;margin-bottom:6px;border-bottom:1.5px solid #FFE0B2;padding-bottom:4px;">3. Quy Chuẩn Ký Hiệu Mũi Tên</div>
  <table style="width:100%;font-size:10.5px;color:#37474F;line-height:1.4;">
    <tr><td style="font-weight:bold;color:#E65100;">Đồng bộ (Sync):</td><td>Nét liền, đầu tam giác đặc <b>(&#10148;)</b> - Gọi hàm chờ phản hồi.</td></tr>
    <tr><td style="font-weight:bold;color:#E65100;">Bất đồng bộ (Async):</td><td>Nét liền, đầu mũi tên mở <b>(&rarr;)</b> - Gửi event/msg không chờ.</td></tr>
    <tr><td style="font-weight:bold;color:#E65100;">Phản hồi (Return):</td><td>Nét đứt, đầu mũi tên mở <b>(- - &rarr;)</b> - Trả kết quả dữ liệu.</td></tr>
    <tr><td style="font-weight:bold;color:#E65100;">Tự gọi (Self call):</td><td>Mũi tên vòng cung tự gọi hàm nội bộ trong cùng class.</td></tr>
  </table>
</div>""", bg="#FFF3E0", border="#FFCC80")

    d.add_custom_box(1230, 120, 380, 210, """<div style="font-family:Segoe UI,sans-serif;">
  <div style="font-size:13px;font-weight:bold;color:#4A148C;margin-bottom:6px;border-bottom:1.5px solid #E1BEE7;padding-bottom:4px;">4. Khung Kết Hợp (Combined Fragments)</div>
  <table style="width:100%;font-size:10.5px;color:#37474F;line-height:1.35;">
    <tr><td style="width:50px;font-weight:bold;color:#7B1FA2;">alt:</td><td><b>Alternative:</b> Rẽ nhánh If - Else (chỉ 1 nhánh được thực thi).</td></tr>
    <tr><td style="font-weight:bold;color:#7B1FA2;">opt:</td><td><b>Optional:</b> Thực thi khi điều kiện thỏa mãn (tương đương If đơn).</td></tr>
    <tr><td style="font-weight:bold;color:#7B1FA2;">loop:</td><td><b>Loop:</b> Vòng lặp duyệt danh sách/mảng dữ liệu.</td></tr>
    <tr><td style="font-weight:bold;color:#7B1FA2;">par:</td><td><b>Parallel:</b> Xử lý đồng thời / song song các luồng.</td></tr>
    <tr><td style="font-weight:bold;color:#7B1FA2;">ref:</td><td><b>Reference:</b> Tham chiếu đến một Sequence Diagram con khác.</td></tr>
  </table>
</div>""", bg="#F3E5F5", border="#CE93D8")

    # Lower Section: 6 Golden Rules table + Sample Visual Diagram
    d.add_custom_box(40, 350, 600, 890, """<div style="font-family:Segoe UI,sans-serif;">
  <div style="font-size:14px;font-weight:bold;color:#1A237E;margin-bottom:10px;border-bottom:2px solid #3F51B5;padding-bottom:6px;">6 NGUYÊN TẮC VÀNG KHI VẼ SEQUENCE DIAGRAM</div>
  
  <div style="margin-bottom:12px;">
    <div style="font-size:12px;font-weight:bold;color:#0D47A1;">Nguyên tắc 1: Trục thời gian luôn chảy từ TRÊN XUỐNG DƯỚI</div>
    <div style="font-size:11px;color:#546E7A;line-height:1.4;">Mỗi sự kiện xảy ra sau phải nằm ở vị trí Y thấp hơn sự kiện trước. Tuyệt đối không vẽ mũi tên chéo ngược lên trên.</div>
  </div>

  <div style="margin-bottom:12px;">
    <div style="font-size:12px;font-weight:bold;color:#0D47A1;">Nguyên tắc 2: Sắp xếp đối tượng từ TRÁI SANG PHẢI theo kiến trúc</div>
    <div style="font-size:11px;color:#546E7A;line-height:1.4;">Thứ tự chuẩn n-tier: <b>Actor &rarr; UI/Client &rarr; Controller/API Gateway &rarr; Security/Auth &rarr; Service (Nghiệp vụ) &rarr; Repository/DAO &rarr; Database/External Services</b>.</div>
  </div>

  <div style="margin-bottom:12px;">
    <div style="font-size:12px;font-weight:bold;color:#0D47A1;">Nguyên tắc 3: Tính nhất quán về mức trừu tượng</div>
    <div style="font-size:11px;color:#546E7A;line-height:1.4;">- <i>Mức Phân tích (Analysis Level):</i> Dùng tên hàm ngôn ngữ tự nhiên (VD: "Kiểm tra hợp đồng").<br/>- <i>Mức Thiết kế (Design Level):</i> Ghi rõ phương thức lập trình cụ thể kèm tham số (VD: <code>createKhachThue(req: KhachThueRequest)</code>).</div>
  </div>

  <div style="margin-bottom:12px;">
    <div style="font-size:12px;font-weight:bold;color:#0D47A1;">Nguyên tắc 4: Luôn đóng gói kịch bản Lỗi (Exception/Alt branch)</div>
    <div style="font-size:11px;color:#546E7A;line-height:1.4;">Không chỉ vẽ luồng chạy thành công (Happy Path). Phải thể hiện các nhánh kiểm tra validation sai, quyền truy cập bị từ chối hoặc lỗi DB trong khung <b>alt</b>.</div>
  </div>

  <div style="margin-bottom:12px;">
    <div style="font-size:12px;font-weight:bold;color:#0D47A1;">Nguyên tắc 5: Đầy đủ Thanh Kích Hoạt (Activation Bar) & Return Message</div>
    <div style="font-size:11px;color:#546E7A;line-height:1.4;">Thanh kích hoạt chỉ xuất hiện khi đối tượng thực sự xử lý. Luôn có mũi tên nét đứt phản hồi kết quả để thể hiện chu trình request - response hoàn chỉnh.</div>
  </div>

  <div style="margin-bottom:12px;">
    <div style="font-size:12px;font-weight:bold;color:#0D47A1;">Nguyên tắc 6: Nguyên tắc đơn nhiệm (1 Diagram = 1 Use Case / Flow)</div>
    <div style="font-size:11px;color:#546E7A;line-height:1.4;">Tránh nhồi nhét tất cả CRUD vào một sơ đồ khổng lồ gây rối mắt. Nên chia thành từng biểu đồ chuyên biệt: Tạo mới, Tìm kiếm/Lọc, Cập nhật & Xóa.</div>
  </div>
</div>""", bg="#FFFFFF", border="#CFD8DC")

    # Sample visual diagram on the right half
    d.add_custom_box(660, 350, 950, 890, """<div style="font-family:Segoe UI,sans-serif;font-size:13px;font-weight:bold;color:#1A237E;margin-bottom:6px;border-bottom:1.5px solid #CFD8DC;padding-bottom:4px;">
  SƠ ĐỒ MINH HỌA MẪU ĐẦY ĐỦ CÁC KÝ HIỆU CHUẨN UML
</div>""", bg="#FAFAFA", border="#CFD8DC")

    # Miniature sequence inside
    ax = d.add_actor("User", 730, y=410, height=780, role="Actor")
    ux = d.add_lifeline("ClientUI", "Boundary / React", 890, y=410, height=780, theme="indigo")
    cx = d.add_lifeline("ApiController", "Controller / Spring", 1060, y=410, height=780, theme="orange")
    sx = d.add_lifeline("AppService", "Service / Logic", 1240, y=410, height=780, theme="green")
    rx = d.add_lifeline("Database", "Entity / PostgreSQL", 1440, y=410, height=780, theme="slate")

    # Activations & Messages
    d.add_activation(ux, 480, height=660, theme="blue")
    d.add_activation(cx, 510, height=600, theme="orange")
    d.add_activation(sx, 540, height=480, theme="green")
    d.add_activation(rx, 610, height=130, theme="yellow")

    d.add_sync_call(ax, ux, 480, "1. Click action / Submit form", msg_num=1)
    d.add_sync_call(ux, cx, 510, "2. HTTP POST /api/v1/resource (JSON)", msg_num=2)
    d.add_sync_call(cx, sx, 540, "3. executeBusiness(requestDto)", msg_num=3)
    
    d.add_self_call(sx, 570, "4. validateInput()", msg_num=4, width=50, height=25)
    
    d.add_sync_call(sx, rx, 620, "5. save(entity)", msg_num=5)
    d.add_return_msg(rx, sx, 700, "return savedEntity")

    d.add_opt_frame(1150, 730, 380, 75, condition="[Need notification]")
    d.add_async_call(sx, rx, 765, "6. publishEvent(NewCreatedEvent)", msg_num=6)

    d.add_alt_frame(680, 830, 910, 310, title="alt", cond1="[Xử lý thành công - HTTP 200 OK]", cond2="[Có lỗi / Exception - HTTP 400/500]", split_y=990)
    
    # Success branch
    d.add_return_msg(sx, cx, 870, "return SuccessResponseDto(data)")
    d.add_return_msg(cx, ux, 910, "HTTP 200 OK (ApiResponse.success)")
    d.add_return_msg(ux, ax, 950, "Hiển thị thông báo thành công & cập nhật UI")

    # Error branch
    d.add_activation(cx, 1010, height=70, theme="orange")
    d.add_return_msg(cx, ux, 1050, "HTTP 400/500 (ApiResponse.error(msg))", color="#C62828")
    d.add_return_msg(ux, ax, 1100, "Hiển thị Toast lỗi cho người dùng", color="#C62828")

    return d.render()

def build_tab2_create_tenant():
    d = SequenceDiagramBuilder("tab2_create_tenant", "2. UC01 - Thêm Mới Khách Thuê", width=1750, height=1350)
    d.add_title_header(
        "SEQUENCE DIAGRAM: UC01 - THÊM MỚI KHÁCH THUÊ (CREATE TENANT FLOW)",
        "Quy trình Chủ trọ thêm khách thuê mới: Tự động khởi tạo/liên kết tài khoản NguoiDung, lưu CCCD Media và cấp quyền.",
        "USE CASE: TENANT CREATION"
    )

    # Lifelines
    c_actor = d.add_actor("Chủ Trọ (Landlord)", 90, y=130, height=1150, role="Actor")
    c_fe = d.add_lifeline("KhachThuePage", "Boundary / Next.js", 250, y=130, height=1150, theme="indigo")
    c_ctrl = d.add_lifeline("KhachThueController", "Controller / REST API", 440, y=130, height=1150, theme="orange")
    c_perm = d.add_lifeline("PermissionService", "Security / Auth", 630, y=130, height=1150, theme="purple")
    c_srv = d.add_lifeline("KhachThueService", "Service / Logic", 840, y=130, height=1150, theme="green")
    c_user_repo = d.add_lifeline("NguoiDungRepo", "Repository / JPA", 1060, y=130, height=1150, theme="slate")
    c_kt_repo = d.add_lifeline("KhachThueRepo", "Repository / JPA", 1280, y=130, height=1150, theme="slate")
    c_media = d.add_lifeline("MediaService", "External / Cloudinary", 1520, y=130, height=1150, theme="pink")

    # Activations
    d.add_activation(c_fe, 200, height=1030, theme="blue")
    d.add_activation(c_ctrl, 230, height=970, theme="orange")
    d.add_activation(c_srv, 260, height=890, theme="green")

    # Step 1: User interaction
    d.add_sync_call(c_actor, c_fe, 200, "1. Nhập thông tin khách (Họ tên, SĐT, CCCD, Ngày sinh...) & Bấm 'Lưu'", msg_num=1)
    d.add_sync_call(c_fe, c_ctrl, 230, "2. POST /api/khach-thue (Payload: KhachThueRequest JSON)", msg_num=2)
    d.add_sync_call(c_ctrl, c_srv, 260, "3. createKhachThue(req: KhachThueRequest)", msg_num=3)

    # Step 2: Auth Check
    d.add_activation(c_perm, 290, height=70, theme="purple")
    d.add_sync_call(c_srv, c_perm, 290, "4. requireCurrentUserId()", msg_num=4)
    d.add_return_msg(c_perm, c_srv, 340, "return currentUserId (UUID)")

    # Step 3: Resolve Owner
    d.add_self_call(c_srv, 370, "5. resolveOwnerForCreate(req, userId)", msg_num=5, width=45, height=26)

    # Step 4: Check/Create NguoiDung (opt frame)
    d.add_opt_frame(750, 420, 420, 220, condition="[Khách thuê chưa có tài khoản NguoiDung theo SĐT]")
    d.add_activation(c_user_repo, 450, height=60, theme="yellow")
    d.add_sync_call(c_srv, c_user_repo, 450, "6. findBySoDienThoai(req.getSoDienThoai())", msg_num=6)
    d.add_return_msg(c_user_repo, c_srv, 490, "return Optional.empty()")
    
    d.add_self_call(c_srv, 520, "7. passwordEncoder.encode('123456')", msg_num=7, width=40, height=24)
    
    d.add_activation(c_user_repo, 560, height=60, theme="yellow")
    d.add_sync_call(c_srv, c_user_repo, 560, "8. save(newNguoiDung: ACTIVE, Pass='123456')", msg_num=8)
    d.add_return_msg(c_user_repo, c_srv, 600, "return savedUser")

    # Step 5: Save Tenant
    d.add_self_call(c_srv, 660, "9. KhachThue.builder().chuTro(owner).nguoiDung(user)...build()", msg_num=9, width=45, height=26)
    d.add_activation(c_kt_repo, 710, height=70, theme="yellow")
    d.add_sync_call(c_srv, c_kt_repo, 710, "10. save(khachThueEntity)", msg_num=10)
    d.add_return_msg(c_kt_repo, c_srv, 760, "return savedKhachThue (UUID id)")

    # Step 6: Save CCCD Media (opt frame)
    d.add_opt_frame(750, 800, 880, 110, condition="[Có tải lên ảnh CCCD (mặt trước / mặt sau)]")
    d.add_activation(c_media, 830, height=65, theme="yellow")
    d.add_sync_call(c_srv, c_media, 830, "11. replaceUrl(TENANT, id, cccdFrontUrl, CCCD_FRONT / BACK)", msg_num=11)
    d.add_return_msg(c_media, c_srv, 875, "return MediaResponse")

    # Step 7: Map response
    d.add_self_call(c_srv, 930, "12. KhachThueResponse.fromEntity(saved) + mapMedia()", msg_num=12, width=45, height=26)

    # Step 8: Alt Branch (Success vs Error)
    d.add_alt_frame(50, 970, 1630, 230, title="alt", cond1="[Thêm thành công - Không có ngoại lệ]", cond2="[Lỗi Validation / Trùng lặp / Exception]", split_y=1090)

    # Success
    d.add_return_msg(c_srv, c_ctrl, 1000, "return KhachThueResponse (DTO)")
    d.add_return_msg(c_ctrl, c_fe, 1030, "HTTP 200: ApiResponse.success(data, 'Thêm khách thuê thành công')")
    d.add_return_msg(c_fe, c_actor, 1060, "Đóng modal, hiển thị Toast thông báo thành công & tải lại bảng")

    # Error
    d.add_return_msg(c_ctrl, c_fe, 1120, "HTTP 400/500: ApiResponse.error(e.getMessage())", color="#C62828")
    d.add_return_msg(c_fe, c_actor, 1160, "Hiển thị thông báo lỗi trên form (VD: 'Số điện thoại đã tồn tại')", color="#C62828")

    # Notes
    d.add_note_box(1320, 360, 260, 90, "Tự động sinh tài khoản NguoiDung với email mặc định tenant_{sdt}@easyhouse.local và mật khẩu mặc định 123456 nếu khách chưa có tài khoản.")

    return d.render()

def build_tab3_get_tenants():
    d = SequenceDiagramBuilder("tab3_get_tenants", "3. UC02 - Xem & Lọc Khách Thuê", width=1750, height=1300)
    d.add_title_header(
        "SEQUENCE DIAGRAM: UC02 - XEM & LỌC DANH SÁCH KHÁCH THUÊ (GET & FILTER TENANTS)",
        "Truy vấn danh sách khách thuê có phân trang, kiểm tra quyền theo nhà trọ, ghép hợp đồng đang thuê và ảnh CCCD.",
        "USE CASE: TENANT QUERY & PAGINATION"
    )

    # Lifelines
    c_actor = d.add_actor("Chủ Trọ (Landlord)", 90, y=130, height=1100, role="Actor")
    c_fe = d.add_lifeline("KhachThuePage", "Boundary / Next.js", 260, y=130, height=1100, theme="indigo")
    c_ctrl = d.add_lifeline("KhachThueController", "Controller / REST API", 460, y=130, height=1100, theme="orange")
    c_perm = d.add_lifeline("PermissionService", "Security / Auth", 670, y=130, height=1100, theme="purple")
    c_srv = d.add_lifeline("KhachThueService", "Service / Logic", 890, y=130, height=1100, theme="green")
    c_kt_repo = d.add_lifeline("KhachThueRepo", "Repository / JPA", 1120, y=130, height=1100, theme="slate")
    c_hd_repo = d.add_lifeline("HopDongRepo", "Repository / JPA", 1330, y=130, height=1100, theme="slate")
    c_media = d.add_lifeline("MediaService", "Service / Media", 1540, y=130, height=1100, theme="pink")

    # Activations
    d.add_activation(c_fe, 200, height=980, theme="blue")
    d.add_activation(c_ctrl, 230, height=920, theme="orange")
    d.add_activation(c_srv, 260, height=850, theme="green")

    # Step 1: User Request
    d.add_sync_call(c_actor, c_fe, 200, "1. Chọn tab trạng thái ('dangThue' / 'all') hoặc gõ từ khóa tìm kiếm", msg_num=1)
    d.add_sync_call(c_fe, c_ctrl, 230, "2. GET /api/khach-thue?trangThai=...&search=...&page=1&limit=10", msg_num=2)
    d.add_sync_call(c_ctrl, c_srv, 260, "3. getAllKhachThue(trangThai, search, page, limit)", msg_num=3)

    # Step 2: Permissions
    d.add_activation(c_perm, 290, height=100, theme="purple")
    d.add_sync_call(c_srv, c_perm, 290, "4. requireCurrentUserId()", msg_num=4)
    d.add_return_msg(c_perm, c_srv, 325, "return userId")
    
    d.add_sync_call(c_srv, c_perm, 345, "5. getAllAccessibleNhaTroIds(userId)", msg_num=5)
    d.add_return_msg(c_perm, c_srv, 380, "return accessibleNhaTroIds: List<UUID>")

    # Step 3: Query Page from KhachThueRepo
    d.add_activation(c_kt_repo, 410, height=80, theme="yellow")
    d.add_sync_call(c_srv, c_kt_repo, 410, "6. findAllAccessible(isAdmin, userId, nhaTroIds, filterStatus, search, pageable)", msg_num=6)
    d.add_return_msg(c_kt_repo, c_srv, 475, "return Page<KhachThue> (danh sách khách theo trang)")

    # Step 4: Query Active Contracts
    d.add_activation(c_hd_repo, 510, height=80, theme="yellow")
    d.add_sync_call(c_srv, c_hd_repo, 510, "7. findAllActive() (Lấy danh sách hợp đồng hiệu lực để map phòng)", msg_num=7)
    d.add_return_msg(c_hd_repo, c_srv, 575, "return activeContracts: List<HopDong>")

    # Step 5: Loop mapping
    d.add_loop_frame(780, 610, 880, 240, condition="[Với mỗi KhachThue trong Page.getContent()]")
    d.add_self_call(c_srv, 640, "8. Map entity &rarr; KhachThueResponse.fromEntity(kt)", msg_num=8, width=45, height=24)
    
    # Check tenant contract
    d.add_self_call(c_srv, 690, "9. Tìm HopDong khớp kt.getId() &rarr; mapContractInfo(res, hd)", msg_num=9, width=45, height=24)
    
    # Media lookup
    d.add_activation(c_media, 740, height=60, theme="yellow")
    d.add_sync_call(c_srv, c_media, 740, "10. firstUrl(TENANT, ktId, CCCD_FRONT / BACK)", msg_num=10)
    d.add_return_msg(c_media, c_srv, 785, "return MatTruoc / MatSau URLs")

    # Step 6: Return Paginated Response
    d.add_self_call(c_srv, 875, "11. PaginatedResponse.of(pageResult, mappedList)", msg_num=11, width=45, height=24)
    d.add_return_msg(c_srv, c_ctrl, 930, "return PaginatedResponse<KhachThueResponse>")
    d.add_return_msg(c_ctrl, c_fe, 970, "HTTP 200: ApiResponse.success(paginatedData)")
    d.add_return_msg(c_fe, c_actor, 1020, "Render bảng danh sách khách thuê (Tên, SĐT, Phòng đang ở, Trạng thái, Phân trang)")

    # Notes
    d.add_note_box(1300, 240, 280, 95, "Dữ liệu được lọc chặt chẽ theo phân quyền: Chủ trọ chỉ thấy khách thuê thuộc các Nhà trọ mà mình sở hữu hoặc được phân quyền quản lý.")

    return d.render()

def build_tab4_update_delete():
    d = SequenceDiagramBuilder("tab4_update_delete", "4. UC03 - Cập Nhật & Xóa Khách Thuê", width=1750, height=1380)
    d.add_title_header(
        "SEQUENCE DIAGRAM: UC03 - CẬP NHẬT & XÓA KHÁCH THUÊ (UPDATE & SOFT DELETE FLOW)",
        "Quy trình Chủ trọ chỉnh sửa thông tin khách thuê và quy trình xóa mềm (Soft Delete + vô hiệu hóa tài khoản liên kết).",
        "USE CASE: TENANT UPDATE & SOFT DELETE"
    )

    # Lifelines
    c_actor = d.add_actor("Chủ Trọ (Landlord)", 90, y=130, height=1200, role="Actor")
    c_fe = d.add_lifeline("KhachThuePage", "Boundary / Next.js", 260, y=130, height=1200, theme="indigo")
    c_ctrl = d.add_lifeline("KhachThueController", "Controller / REST API", 460, y=130, height=1200, theme="orange")
    c_perm = d.add_lifeline("PermissionService", "Security / Auth", 670, y=130, height=1200, theme="purple")
    c_srv = d.add_lifeline("KhachThueService", "Service / Logic", 890, y=130, height=1200, theme="green")
    c_kt_repo = d.add_lifeline("KhachThueRepo", "Repository / JPA", 1120, y=130, height=1200, theme="slate")
    c_user_repo = d.add_lifeline("NguoiDungRepo", "Repository / JPA", 1330, y=130, height=1200, theme="slate")
    c_media = d.add_lifeline("MediaService", "External / Media", 1540, y=130, height=1200, theme="pink")

    # ================== PHẦN 1: CẬP NHẬT ==================
    d.add_custom_box(40, 200, 1640, 490, """<div style="font-family:Segoe UI,sans-serif;font-size:12px;font-weight:bold;color:#0D47A1;">
  PHẦN A: CẬP NHẬT THÔNG TIN KHÁCH THUÊ (UPDATE TENANT)
</div>""", bg="#F0F7FF", border="#B3E5FC")

    d.add_activation(c_fe, 240, height=420, theme="blue")
    d.add_activation(c_ctrl, 260, height=380, theme="orange")
    d.add_activation(c_srv, 280, height=330, theme="green")

    d.add_sync_call(c_actor, c_fe, 240, "1. Sửa thông tin (Họ tên, SĐT, CCCD, Địa chỉ...) & Bấm 'Cập nhật'", msg_num=1)
    d.add_sync_call(c_fe, c_ctrl, 260, "2. PUT /api/khach-thue/{id} (Payload: KhachThueRequest)", msg_num=2)
    d.add_sync_call(c_ctrl, c_srv, 280, "3. updateKhachThue(id, req)", msg_num=3)

    d.add_activation(c_perm, 300, height=50, theme="purple")
    d.add_sync_call(c_srv, c_perm, 300, "4. assertCanWrite(kt, activeContract, userId)", msg_num=4)
    d.add_return_msg(c_perm, c_srv, 335, "return void (Hợp lệ)")

    d.add_self_call(c_srv, 355, "5. Cập nhật các trường thông tin thay đổi vào entity KhachThue", msg_num=5, width=45, height=24)
    
    d.add_activation(c_kt_repo, 395, height=60, theme="yellow")
    d.add_sync_call(c_srv, c_kt_repo, 395, "6. save(updatedKhachThue)", msg_num=6)
    d.add_return_msg(c_kt_repo, c_srv, 440, "return saved")

    d.add_opt_frame(780, 465, 870, 80, condition="[Có cập nhật ảnh CCCD mới]")
    d.add_activation(c_media, 490, height=45, theme="yellow")
    d.add_sync_call(c_srv, c_media, 490, "7. saveCccdMedia(id, req.getAnhCCCD())", msg_num=7)

    d.add_return_msg(c_srv, c_ctrl, 570, "return KhachThueResponse (DTO)")
    d.add_return_msg(c_ctrl, c_fe, 600, "HTTP 200: ApiResponse.success(response, 'Cập nhật khách thuê thành công')")
    d.add_return_msg(c_fe, c_actor, 630, "Thông báo cập nhật thành công & cập nhật lại dữ liệu giao diện")

    # ================== PHẦN 2: XÓA MỀM ==================
    d.add_custom_box(40, 720, 1640, 560, """<div style="font-family:Segoe UI,sans-serif;font-size:12px;font-weight:bold;color:#B71C1C;">
  PHẦN B: XÓA MỀM KHÁCH THUÊ & VÔ HIỆU HÓA TÀI KHOẢN (SOFT DELETE TENANT)
</div>""", bg="#FFF5F5", border="#FFCDD2")

    d.add_activation(c_fe, 760, height=480, theme="blue")
    d.add_activation(c_ctrl, 780, height=440, theme="orange")
    d.add_activation(c_srv, 800, height=390, theme="green")

    d.add_sync_call(c_actor, c_fe, 760, "8. Chọn 'Xóa khách thuê' & Xác nhận trên Dialog cảnh báo", msg_num=8)
    d.add_sync_call(c_fe, c_ctrl, 780, "9. DELETE /api/khach-thue/{id}", msg_num=9)
    d.add_sync_call(c_ctrl, c_srv, 800, "10. deleteKhachThue(id: UUID)", msg_num=10)

    d.add_activation(c_perm, 825, height=50, theme="purple")
    d.add_sync_call(c_srv, c_perm, 825, "11. assertCanWrite(kt, activeContract, currentUserId)", msg_num=11)
    d.add_return_msg(c_perm, c_srv, 860, "return void (Được phép xóa)")

    d.add_self_call(c_srv, 880, "12. kt.setXoaLuc(ZonedDateTime.now()) (Soft delete)", msg_num=12, width=45, height=24)
    d.add_activation(c_kt_repo, 920, height=55, theme="yellow")
    d.add_sync_call(c_srv, c_kt_repo, 920, "13. save(khachThue)", msg_num=13)
    d.add_return_msg(c_kt_repo, c_srv, 960, "return saved")

    # Deactivate linked account
    d.add_opt_frame(780, 985, 660, 105, condition="[Khách có tài khoản NguoiDung liên kết]")
    d.add_self_call(c_srv, 1005, "14. user.setTrangThai(INACTIVE) + user.setXoaLuc(now)", msg_num=14, width=40, height=22)
    d.add_activation(c_user_repo, 1040, height=45, theme="yellow")
    d.add_sync_call(c_srv, c_user_repo, 1040, "15. save(deactivatedUser)", msg_num=15)

    d.add_return_msg(c_srv, c_ctrl, 1120, "return void")
    d.add_return_msg(c_ctrl, c_fe, 1155, "HTTP 200: ApiResponse.success(null, 'Xóa khách thuê thành công')")
    d.add_return_msg(c_fe, c_actor, 1195, "Xóa dòng khỏi danh sách & hiển thị Toast thông báo xóa thành công")

    # Notes
    d.add_note_box(1300, 840, 270, 90, "Quy tắc an toàn dữ liệu: Không xóa cứng bản ghi trong DB mà cập nhật `xoa_luc` và vô hiệu hóa tài khoản NguoiDung để ngăn đăng nhập.")

    return d.render()

def build_tab5_tenant_portal():
    d = SequenceDiagramBuilder("tab5_tenant_portal", "5. UC04 - Cổng Khách Thuê", width=1750, height=1380)
    d.add_title_header(
        "SEQUENCE DIAGRAM: UC04 - CỔNG KHÁCH THUÊ: ĐĂNG NHẬP & BÁO CÁO SỰ CỐ (TENANT PORTAL)",
        "Quy trình Khách thuê tự đăng nhập vào cổng thông tin, xem hóa đơn/hợp đồng và gửi báo cáo sự cố hư hỏng phòng.",
        "USE CASE: TENANT SELF-SERVICE PORTAL"
    )

    # Lifelines
    c_tenant = d.add_actor("Khách Thuê (Tenant)", 90, y=130, height=1200, role="Actor")
    c_fe = d.add_lifeline("TenantPortal", "Boundary / Next.js", 270, y=130, height=1200, theme="teal")
    c_auth = d.add_lifeline("AuthController", "Security / NextAuth", 480, y=130, height=1200, theme="purple")
    c_suco_ctrl = d.add_lifeline("SuCoController", "Controller / REST API", 700, y=130, height=1200, theme="orange")
    c_suco_srv = d.add_lifeline("SuCoService", "Service / Incident", 920, y=130, height=1200, theme="green")
    c_noti = d.add_lifeline("ThongBaoService", "Service / Notification", 1140, y=130, height=1200, theme="blue")
    c_db = d.add_lifeline("PostgreSQL DB", "Database / JPA", 1360, y=130, height=1200, theme="slate")
    c_landlord = d.add_actor("Chủ Trọ (Landlord)", 1570, y=130, height=1200, role="Receiver")

    # ================== PHẦN 1: ĐĂNG NHẬP ==================
    d.add_custom_box(40, 200, 1640, 450, """<div style="font-family:Segoe UI,sans-serif;font-size:12px;font-weight:bold;color:#004D40;">
  PHẦN A: KHÁCH THUÊ ĐĂNG NHẬP VÀO HỆ THỐNG (/khach-thue/dang-nhap)
</div>""", bg="#E0F2F1", border="#80CBC4")

    d.add_activation(c_fe, 240, height=380, theme="green")
    d.add_activation(c_auth, 260, height=340, theme="purple")

    d.add_sync_call(c_tenant, c_fe, 240, "1. Nhập SĐT & Mật khẩu (mặc định '123456') & Bấm 'Đăng nhập'", msg_num=1)
    d.add_sync_call(c_fe, c_auth, 260, "2. POST /api/auth/callback/credentials (Phone, Password)", msg_num=2)

    d.add_activation(c_db, 290, height=60, theme="yellow")
    d.add_sync_call(c_auth, c_db, 290, "3. findBySoDienThoai(phone) & Kiểm tra PasswordEncoder.matches()", msg_num=3)
    d.add_return_msg(c_db, c_auth, 335, "return NguoiDung (Role: KHACH_THUE, TrangThai: ACTIVE)")

    d.add_alt_frame(60, 365, 520, 230, title="alt", cond1="[Xác thực thành công]", cond2="[Sai mật khẩu / Bị khóa]", split_y=475)
    
    # Auth Success
    d.add_return_msg(c_auth, c_fe, 400, "HTTP 200: Session Token + Role KHACH_THUE")
    d.add_return_msg(c_fe, c_tenant, 435, "Chuyển hướng vào Cổng khách thuê (/khach-thue/dashboard)")

    # Auth Fail
    d.add_return_msg(c_auth, c_fe, 510, "HTTP 401: Unauthorized (Thông tin không chính xác)", color="#C62828")
    d.add_return_msg(c_fe, c_tenant, 555, "Hiển thị thông báo: 'Số điện thoại hoặc mật khẩu không đúng'", color="#C62828")

    # ================== PHẦN 2: BÁO CÁO SỰ CỐ ==================
    d.add_custom_box(40, 680, 1640, 610, """<div style="font-family:Segoe UI,sans-serif;font-size:12px;font-weight:bold;color:#E65100;">
  PHẦN B: KHÁCH THUÊ GỬI BÁO CÁO SỰ CỐ TẠI PHÒNG TRỌ
</div>""", bg="#FFF8E1", border="#FFE082")

    d.add_activation(c_fe, 720, height=530, theme="green")
    d.add_activation(c_suco_ctrl, 745, height=480, theme="orange")
    d.add_activation(c_suco_srv, 770, height=420, theme="green")

    d.add_sync_call(c_tenant, c_fe, 720, "4. Điền form Báo cáo sự cố (Tiêu đề, Mô tả sự cố, Ảnh minh họa)", msg_num=4)
    d.add_sync_call(c_fe, c_suco_ctrl, 745, "5. POST /api/su-co (Payload: SuCoRequest)", msg_num=5)
    d.add_sync_call(c_suco_ctrl, c_suco_srv, 770, "6. createSuCo(request, currentTenantId)", msg_num=6)

    d.add_self_call(c_suco_srv, 800, "7. Khởi tạo SuCo entity (trangThai = 'CHO_XU_LY', mucDoUuTien...)", msg_num=7, width=45, height=24)
    
    d.add_activation(c_db, 840, height=60, theme="yellow")
    d.add_sync_call(c_suco_srv, c_db, 840, "8. suCoRepository.save(newSuCo)", msg_num=8)
    d.add_return_msg(c_db, c_suco_srv, 885, "return savedSuCo")

    # Push Notification to Landlord
    d.add_activation(c_noti, 915, height=75, theme="blue")
    d.add_async_call(c_suco_srv, c_noti, 915, "9. guiThongBaoChoChuTro(suCoId, chuTroId, 'Khách báo sự cố mới')", msg_num=9)
    d.add_async_call(c_noti, c_landlord, 955, "10. Push Notification / Web Alert &rarr; Thông báo có sự cố cần xử lý", msg_num=10)

    # Response to Tenant
    d.add_return_msg(c_suco_srv, c_suco_ctrl, 1020, "return SuCoResponse (DTO)")
    d.add_return_msg(c_suco_ctrl, c_fe, 1065, "HTTP 200: ApiResponse.success(response, 'Gửi báo cáo sự cố thành công')")
    d.add_return_msg(c_fe, c_tenant, 1115, "Hiển thị thông báo thành công & cập nhật trạng thái 'Chờ xử lý' trong danh sách sự cố")

    # Notes
    d.add_note_box(1280, 230, 280, 85, "Khách thuê có thể đăng nhập bằng chính số điện thoại mà Chủ trọ đã đăng ký trong hợp đồng thuê phòng.")

    return d.render()

def generate_all():
    print("Generating Tab 1: Nguyên Tắc Vẽ Sequence Diagram...")
    t1 = build_tab1_principles()
    
    print("Generating Tab 2: UC01 - Thêm Mới Khách Thuê...")
    t2 = build_tab2_create_tenant()
    
    print("Generating Tab 3: UC02 - Xem & Lọc Khách Thuê...")
    t3 = build_tab3_get_tenants()
    
    print("Generating Tab 4: UC03 - Cập Nhật & Xóa Khách Thuê...")
    t4 = build_tab4_update_delete()
    
    print("Generating Tab 5: UC04 - Cổng Khách Thuê...")
    t5 = build_tab5_tenant_portal()

    full_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2026-08-18T14:00:00.000Z" agent="EasyHouse Diagram Generator" version="24.0.0" type="device">
{t1}
{t2}
{t3}
{t4}
{t5}
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
    generate_all()
