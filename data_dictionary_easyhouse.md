# TỪ ĐIỂN DỮ LIỆU CƠ SỞ DỮ LIỆU HỆ THỐNG EASYHOUSE (DATA DICTIONARY)

> Tài liệu đặc tả chi tiết 56 bảng cơ sở dữ liệu dự án EasyHouse theo chuẩn 5 cột (STT, Tên trường, Kiểu dữ liệu, Mô tả, Ràng buộc).


## NHÓM 1: NGƯỜI DÙNG, XÁC THỰC & CHỦ TRỌ

### 1. Bảng: `nguoi_dung` (Người dùng (Tài khoản hệ thống))
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `email` | CHARACTER | Địa chỉ email liên hệ và đăng nhập. | Unique, Not null |
| 3 | `ho_ten` | CHARACTER | Họ và tên đầy đủ. | Not null |
| 4 | `so_dien_thoai` | CHARACTER | Số điện thoại liên hệ. | Unique |
| 5 | `anh_dai_dien` | TEXT | Đường dẫn ảnh đại diện (avatar). | - |
| 6 | `ngay_sinh` | DATE | Ngày tháng năm sinh. | - |
| 7 | `gioi_tinh` | CHARACTER | Giới tính (NAM, NU, KHAC). | - |
| 8 | `dia_chi` | TEXT | Thông tin trường dia_chi của bảng nguoi_dung. | - |
| 9 | `que_quan` | CHARACTER | Quê quán / Địa chỉ thường trú. | - |
| 10 | `so_cccd` | CHARACTER | Thông tin trường so_cccd của bảng nguoi_dung. | Unique |
| 11 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 12 | `so_lan_dang_nhap_sai` | INTEGER | Thông tin trường so_lan_dang_nhap_sai của bảng nguoi_dung. | Not null |
| 13 | `khoa_den_luc` | TIMESTAMP | Thông tin trường khoa_den_luc của bảng nguoi_dung. | - |
| 14 | `lan_dang_nhap_cuoi` | TIMESTAMP | Thông tin trường lan_dang_nhap_cuoi của bảng nguoi_dung. | - |
| 15 | `cau_hinh_2fa` | JSONB | Thông tin trường cau_hinh_2fa của bảng nguoi_dung. | - |
| 16 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 17 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 18 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |
| 19 | `mat_khau` | CHARACTER | Thông tin trường mat_khau của bảng nguoi_dung. | - |
| 20 | `trang_thai_kyc` | CHARACTER | Thông tin trường trang_thai_kyc của bảng nguoi_dung. | - |
| 21 | `anh_cccd_truoc` | CHARACTER | Thông tin trường anh_cccd_truoc của bảng nguoi_dung. | - |
| 22 | `anh_cccd_sau` | CHARACTER | Thông tin trường anh_cccd_sau của bảng nguoi_dung. | - |
| 23 | `anh_gpkd` | CHARACTER | Thông tin trường anh_gpkd của bảng nguoi_dung. | - |

---

### 2. Bảng: `vai_tro` (Vai trò & Quyền hạn)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `ten` | PUBLIC | Tên chính. | Unique, Not null |
| 3 | `mo_ta` | TEXT | Thông tin trường mo_ta của bảng vai_tro. | - |
| 4 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 3. Bảng: `nguoi_dung_vai_tro` (Phân quyền người dùng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | PK, FK |
| 2 | `vai_tro_id` | UUID | Mã vai trò quyền hạn. | PK, FK |
| 3 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 4. Bảng: `chu_tro` (Chủ nhà trọ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK, Unique |
| 3 | `ten_cong_ty` | CHARACTER | Thông tin trường ten_cong_ty của bảng chu_tro. | - |
| 4 | `so_cccd` | CHARACTER | Thông tin trường so_cccd của bảng chu_tro. | Unique, Not null |
| 5 | `ma_so_thue` | CHARACTER | Thông tin trường ma_so_thue của bảng chu_tro. | - |
| 6 | `so_tai_khoan` | CHARACTER | Thông tin trường so_tai_khoan của bảng chu_tro. | - |
| 7 | `da_xac_minh` | BOOLEAN | Cờ đánh dấu trạng thái (da_xac_minh). | - |
| 8 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | - |
| 9 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | - |
| 10 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |

---

### 5. Bảng: `nguoi_dung_nha_tro` (Phân quyền quản lý nhà trọ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK, Unique, Not null |
| 3 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK, Unique, Not null |
| 4 | `vai_tro` | PUBLIC | Thông tin trường vai_tro của bảng nguoi_dung_nha_tro. | Unique, Not null |
| 5 | `co_quyen_xem` | BOOLEAN | Cờ đánh dấu trạng thái (co_quyen_xem). | Not null |
| 6 | `co_quyen_sua` | BOOLEAN | Cờ đánh dấu trạng thái (co_quyen_sua). | Not null |
| 7 | `co_quyen_thu_tien` | BOOLEAN | Cờ đánh dấu trạng thái (co_quyen_thu_tien). | Not null |
| 8 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 6. Bảng: `refresh_token` (Token làm mới phiên đăng nhập)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK, Not null |
| 3 | `token` | CHARACTER | Thông tin trường token của bảng refresh_token. | Unique, Not null |
| 4 | `ngay_het_han` | TIMESTAMP | Ngày / Thời gian ghi nhận (ngay_het_han). | Not null |
| 5 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 7. Bảng: `email_verification_token` (Token xác thực email)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK, Not null |
| 3 | `token` | CHARACTER | Thông tin trường token của bảng email_verification_token. | Unique, Not null |
| 4 | `ngay_het_han` | TIMESTAMP | Ngày / Thời gian ghi nhận (ngay_het_han). | Not null |
| 5 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 8. Bảng: `login_history` (Lịch sử đăng nhập)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK |
| 3 | `email` | CHARACTER | Địa chỉ email liên hệ và đăng nhập. | - |
| 4 | `thanh_cong` | BOOLEAN | Thông tin trường thanh_cong của bảng login_history. | Not null |
| 5 | `ip_address` | INET | Thông tin trường ip_address của bảng login_history. | - |
| 6 | `user_agent` | TEXT | Thông tin trường user_agent của bảng login_history. | - |
| 7 | `ly_do_that_bai` | TEXT | Thông tin trường ly_do_that_bai của bảng login_history. | - |
| 8 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 9. Bảng: `chan_nguoi_dung` (Danh sách chặn người dùng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_chan_id` | UUID | Mã liên kết tới bảng nguoi_chan. | FK, Unique, Not null |
| 3 | `nguoi_bi_chan_id` | UUID | Mã liên kết tới bảng nguoi_bi_chan. | FK, Unique, Not null |
| 4 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 10. Bảng: `dang_ky_push` (Đăng ký nhận thông báo đẩy (Push))
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK, Not null |
| 3 | `nen_tang` | PUBLIC | Thông tin trường nen_tang của bảng dang_ky_push. | Not null |
| 4 | `endpoint` | TEXT | Thông tin trường endpoint của bảng dang_ky_push. | Unique, Not null |
| 5 | `khoa_p256dh` | TEXT | Thông tin trường khoa_p256dh của bảng dang_ky_push. | - |
| 6 | `khoa_auth` | TEXT | Thông tin trường khoa_auth của bảng dang_ky_push. | - |
| 7 | `mo_ta_thiet_bi` | TEXT | Thông tin trường mo_ta_thiet_bi của bảng dang_ky_push. | - |
| 8 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 9 | `dung_luc` | TIMESTAMP | Thông tin trường dung_luc của bảng dang_ky_push. | - |

---

### 11. Bảng: `audit_log` (Nhật ký kiểm toán hệ thống (Audit Log))
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK |
| 3 | `hanh_dong` | CHARACTER | Thông tin trường hanh_dong của bảng audit_log. | Not null |
| 4 | `bang_tac_dong` | CHARACTER | Thông tin trường bang_tac_dong của bảng audit_log. | - |
| 5 | `ban_ghi_id` | UUID | Mã liên kết tới bảng ban_ghi. | - |
| 6 | `du_lieu_cu` | JSONB | Thông tin trường du_lieu_cu của bảng audit_log. | - |
| 7 | `du_lieu_moi` | JSONB | Thông tin trường du_lieu_moi của bảng audit_log. | - |
| 8 | `ip_address` | INET | Thông tin trường ip_address của bảng audit_log. | - |
| 9 | `user_agent` | CHARACTER | Thông tin trường user_agent của bảng audit_log. | - |
| 10 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

## NHÓM 2: TÒA NHÀ, TẦNG & PHÒNG TRỌ

### 12. Bảng: `nha_tro` (Nhà trọ / Tòa nhà)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `chu_tro_id` | UUID | Mã chủ trọ sở hữu hoặc quản lý. | FK, Not null |
| 3 | `ten` | CHARACTER | Tên chính. | Not null |
| 4 | `dia_chi` | TEXT | Thông tin trường dia_chi của bảng nha_tro. | Not null |
| 5 | `so_nha` | CHARACTER | Thông tin trường so_nha của bảng nha_tro. | - |
| 6 | `duong` | CHARACTER | Thông tin trường duong của bảng nha_tro. | - |
| 7 | `phuong` | CHARACTER | Thông tin trường phuong của bảng nha_tro. | - |
| 8 | `quan` | CHARACTER | Thông tin trường quan của bảng nha_tro. | - |
| 9 | `thanh_pho` | CHARACTER | Thông tin trường thanh_pho của bảng nha_tro. | - |
| 10 | `mo_ta` | TEXT | Thông tin trường mo_ta của bảng nha_tro. | - |
| 11 | `tien_nghi_chung` | TEXT | Số tiền / Đơn giá (tien_nghi_chung) tính theo VNĐ. | - |
| 12 | `noi_quy` | TEXT | Thông tin trường noi_quy của bảng nha_tro. | - |
| 13 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 14 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 15 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 16 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |
| 17 | `vi_do` | DECIMAL(10,7) | Thông tin trường vi_do của bảng nha_tro. | - |
| 18 | `kinh_do` | DECIMAL(10,7) | Thông tin trường kinh_do của bảng nha_tro. | - |
| 19 | `google_place_id` | CHARACTER | Mã liên kết tới bảng google_place. | - |
| 20 | `dia_chi_da_chuan_hoa` | TEXT | Thông tin trường dia_chi_da_chuan_hoa của bảng nha_tro. | - |

---

### 13. Bảng: `tang` (Tầng trong nhà trọ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK, Unique, Not null |
| 3 | `so_tang` | INTEGER | Thông tin trường so_tang của bảng tang. | Unique, Not null |
| 4 | `ten_tang` | CHARACTER | Thông tin trường ten_tang của bảng tang. | - |
| 5 | `thu_tu_hien_thi` | INTEGER | Thông tin trường thu_tu_hien_thi của bảng tang. | - |
| 6 | `so_phong_du_kien` | INTEGER | Thông tin trường so_phong_du_kien của bảng tang. | - |
| 7 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 8 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 9 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 10 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |

---

### 14. Bảng: `phong` (Phòng trọ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK, Unique, Not null |
| 3 | `ten` | CHARACTER | Tên chính. | Unique, Not null |
| 4 | `khu_vuc` | CHARACTER | Thông tin trường khu_vuc của bảng phong. | - |
| 5 | `tang` | INTEGER | Thông tin trường tang của bảng phong. | - |
| 6 | `dien_tich` | DECIMAL(10,2) | Diện tích phòng (m²). | Not null |
| 7 | `so_nguoi_toi_da` | INTEGER | Số lượng người ở tối đa cho phép. | Not null |
| 8 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 9 | `gia_hien_tai` | DECIMAL(15,2) | Số tiền / Đơn giá (gia_hien_tai) tính theo VNĐ. | Not null |
| 10 | `tien_coc_mac_dinh` | DECIMAL(15,2) | Số tiền / Đơn giá (tien_coc_mac_dinh) tính theo VNĐ. | Not null |
| 11 | `mo_ta` | TEXT | Thông tin trường mo_ta của bảng phong. | - |
| 12 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 13 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 14 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |
| 15 | `tang_id` | UUID | Mã tầng trong tòa nhà. | FK |

---

### 15. Bảng: `tien_ich` (Danh mục tiện ích)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `ten` | CHARACTER | Tên chính. | Unique, Not null |
| 3 | `bieu_tuong` | CHARACTER | Thông tin trường bieu_tuong của bảng tien_ich. | - |
| 4 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 16. Bảng: `phong_tien_ich` (Tiện ích thuộc phòng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `phong_id` | UUID | Mã phòng trọ liên kết. | PK, FK |
| 2 | `tien_ich_id` | UUID | Mã liên kết tới bảng tien_ich. | PK, FK |
| 3 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

## NHÓM 3: KHÁCH THUÊ & HỢP ĐỒNG THUÊ

### 17. Bảng: `khach_thue` (Khách thuê phòng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK, Unique |
| 3 | `chu_tro_id` | UUID | Mã chủ trọ sở hữu hoặc quản lý. | FK, Unique, Not null |
| 4 | `ho_ten` | CHARACTER | Họ và tên đầy đủ. | Not null |
| 5 | `so_dien_thoai` | CHARACTER | Số điện thoại liên hệ. | - |
| 6 | `email` | CHARACTER | Địa chỉ email liên hệ và đăng nhập. | - |
| 7 | `so_cccd` | CHARACTER | Thông tin trường so_cccd của bảng khach_thue. | Unique |
| 8 | `ngay_sinh` | DATE | Ngày tháng năm sinh. | - |
| 9 | `gioi_tinh` | CHARACTER | Giới tính (NAM, NU, KHAC). | - |
| 10 | `dia_chi` | TEXT | Thông tin trường dia_chi của bảng khach_thue. | - |
| 11 | `que_quan` | CHARACTER | Quê quán / Địa chỉ thường trú. | - |
| 12 | `nghe_nghiep` | CHARACTER | Thông tin trường nghe_nghiep của bảng khach_thue. | - |
| 13 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 14 | `dang_hoat_dong` | BOOLEAN | Thông tin trường dang_hoat_dong của bảng khach_thue. | Not null |
| 15 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 16 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 17 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |

---

### 18. Bảng: `hop_dong` (Hợp đồng thuê phòng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Not null |
| 3 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK, Not null |
| 4 | `ma_hop_dong` | CHARACTER | Mã số hợp đồng thuê phòng. | Unique, Not null |
| 5 | `ngay_bat_dau` | DATE | Ngày bắt đầu có hiệu lực. | Not null |
| 6 | `ngay_ket_thuc` | DATE | Ngày kết thúc theo hợp đồng. | Not null |
| 7 | `ngay_ket_thuc_thuc_te` | DATE | Ngày kết thúc và trả phòng thực tế. | - |
| 8 | `gia_thue_hop_dong` | DECIMAL(15,2) | Số tiền / Đơn giá (gia_thue_hop_dong) tính theo VNĐ. | Not null |
| 9 | `tien_coc` | DECIMAL(15,2) | Số tiền đặt cọc thuê phòng (VNĐ). | Not null |
| 10 | `trang_thai_coc` | PUBLIC | Thông tin trường trang_thai_coc của bảng hop_dong. | Not null |
| 11 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 12 | `chu_ky_thanh_toan` | CHARACTER | Thông tin trường chu_ky_thanh_toan của bảng hop_dong. | Not null |
| 13 | `ngay_thanh_toan_hang_thang` | INTEGER | Ngày / Thời gian ghi nhận (ngay_thanh_toan_hang_thang). | Not null |
| 14 | `tu_dong_gia_han` | BOOLEAN | Số tiền / Đơn giá (tu_dong_gia_han) tính theo VNĐ. | Not null |
| 15 | `chi_so_dien_ban_dau` | INTEGER | Chỉ số điện tại thời điểm bàn giao bắt đầu. | - |
| 16 | `chi_so_nuoc_ban_dau` | INTEGER | Chỉ số nước tại thời điểm bàn giao bắt đầu. | - |
| 17 | `noi_dung_hop_dong` | TEXT | Thông tin trường noi_dung_hop_dong của bảng hop_dong. | - |
| 18 | `file_pdf` | TEXT | Thông tin trường file_pdf của bảng hop_dong. | - |
| 19 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 20 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 21 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 22 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |
| 23 | `template_version` | CHARACTER | Thông tin trường template_version của bảng hop_dong. | - |
| 24 | `previewed_at` | TIMESTAMP | Thông tin trường previewed_at của bảng hop_dong. | - |
| 25 | `confirmed_at` | TIMESTAMP | Thông tin trường confirmed_at của bảng hop_dong. | - |
| 26 | `locked_at` | TIMESTAMP | Thông tin trường locked_at của bảng hop_dong. | - |
| 27 | `signed_pdf_url` | TEXT | Thông tin trường signed_pdf_url của bảng hop_dong. | - |
| 28 | `tenant_signed_at` | TIMESTAMP | Thông tin trường tenant_signed_at của bảng hop_dong. | - |
| 29 | `landlord_signed_at` | TIMESTAMP | Thông tin trường landlord_signed_at của bảng hop_dong. | - |
| 30 | `signature_status` | CHARACTER | Thông tin trường signature_status của bảng hop_dong. | Not null |

---

### 19. Bảng: `thanh_vien_hop_dong` (Thành viên cùng ở trong hợp đồng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK, Not null |
| 3 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK |
| 4 | `ho_ten` | CHARACTER | Họ và tên đầy đủ. | Not null |
| 5 | `so_cccd` | CHARACTER | Thông tin trường so_cccd của bảng thanh_vien_hop_dong. | - |
| 6 | `so_dien_thoai` | CHARACTER | Số điện thoại liên hệ. | - |
| 7 | `ngay_vao` | DATE | Ngày / Thời gian ghi nhận (ngay_vao). | Not null |
| 8 | `ngay_roi` | DATE | Ngày / Thời gian ghi nhận (ngay_roi). | - |
| 9 | `dang_o` | BOOLEAN | Thông tin trường dang_o của bảng thanh_vien_hop_dong. | Not null |
| 10 | `la_nguoi_dai_dien` | BOOLEAN | Thông tin trường la_nguoi_dai_dien của bảng thanh_vien_hop_dong. | Not null |
| 11 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 12 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 13 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

### 20. Bảng: `phu_luc_hop_dong` (Phụ lục hợp đồng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK, Not null |
| 3 | `loai` | CHARACTER | Thông tin trường loai của bảng phu_luc_hop_dong. | Not null |
| 4 | `noi_dung` | TEXT | Nội dung chi tiết thông báo / tin nhắn / sự cố. | Not null |
| 5 | `ngay_hieu_luc` | DATE | Ngày / Thời gian ghi nhận (ngay_hieu_luc). | Not null |
| 6 | `gia_thue_moi` | DECIMAL(15,2) | Số tiền / Đơn giá (gia_thue_moi) tính theo VNĐ. | - |
| 7 | `ngay_ket_thuc_moi` | DATE | Ngày / Thời gian ghi nhận (ngay_ket_thuc_moi). | - |
| 8 | `file_pdf` | TEXT | Thông tin trường file_pdf của bảng phu_luc_hop_dong. | - |
| 9 | `nguoi_tao_id` | UUID | Mã liên kết tới bảng nguoi_tao. | FK |
| 10 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 21. Bảng: `contract_signature` (Chữ ký điện tử hợp đồng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `ip_address` | CHARACTER | Thông tin trường ip_address của bảng contract_signature. | - |
| 3 | `signature_image_url` | TEXT | Thông tin trường signature_image_url của bảng contract_signature. | - |
| 4 | `signed_at` | TIMESTAMP | Thông tin trường signed_at của bảng contract_signature. | Not null |
| 5 | `signer_id` | UUID | Mã liên kết tới bảng signer. | - |
| 6 | `signer_role` | CHARACTER | Thông tin trường signer_role của bảng contract_signature. | Not null |
| 7 | `user_agent` | CHARACTER | Thông tin trường user_agent của bảng contract_signature. | - |
| 8 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | Not null |

---

### 22. Bảng: `dat_coc_phong` (Phiếu giữ phòng & Đặt cọc)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Not null |
| 3 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK, Not null |
| 4 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK |
| 5 | `so_tien_coc` | DECIMAL(38,2) | Số tiền / Đơn giá (so_tien_coc) tính theo VNĐ. | Not null |
| 6 | `ngay_dat_coc` | TIMESTAMP | Ngày / Thời gian ghi nhận (ngay_dat_coc). | Not null |
| 7 | `ngay_du_kien_vao` | DATE | Ngày / Thời gian ghi nhận (ngay_du_kien_vao). | - |
| 8 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 9 | `ghi_chu` | CHARACTER | Ghi chú thêm thông tin. | - |
| 10 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 11 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 12 | `cancelled_at` | TIMESTAMP | Thông tin trường cancelled_at của bảng dat_coc_phong. | - |
| 13 | `confirmed_at` | TIMESTAMP | Thông tin trường confirmed_at của bảng dat_coc_phong. | - |
| 14 | `ly_do_huy` | CHARACTER | Thông tin trường ly_do_huy của bảng dat_coc_phong. | - |
| 15 | `nguoi_xac_nhan_id` | UUID | Mã liên kết tới bảng nguoi_xac_nhan. | FK |

---

### 23. Bảng: `yeu_cau_o_ghep` (Yêu cầu tìm bạn ở ghép)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK, Not null |
| 3 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK, Not null |
| 4 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 5 | `loi_nhan` | CHARACTER | Thông tin trường loi_nhan của bảng yeu_cau_o_ghep. | - |
| 6 | `ghi_chu_tu_choi` | CHARACTER | Thông tin trường ghi_chu_tu_choi của bảng yeu_cau_o_ghep. | - |
| 7 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 8 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | - |

---

### 24. Bảng: `lich_hen` (Lịch hẹn xem phòng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Not null |
| 3 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK |
| 4 | `ho_ten` | CHARACTER | Họ và tên đầy đủ. | - |
| 5 | `so_dien_thoai` | CHARACTER | Số điện thoại liên hệ. | - |
| 6 | `email` | CHARACTER | Địa chỉ email liên hệ và đăng nhập. | - |
| 7 | `ngay_hen` | TIMESTAMP | Ngày / Thời gian ghi nhận (ngay_hen). | Not null |
| 8 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 9 | `google_calendar_event_id` | TEXT | Mã liên kết tới bảng google_calendar_event. | - |
| 10 | `da_gui_nhac_nho` | BOOLEAN | Cờ đánh dấu trạng thái (da_gui_nhac_nho). | Not null |
| 11 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 12 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 13 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 14 | `ghi_chu_admin` | TEXT | Thông tin trường ghi_chu_admin của bảng lich_hen. | - |
| 15 | `so_cccd` | CHARACTER | Thông tin trường so_cccd của bảng lich_hen. | - |

---

## NHÓM 4: DỊCH VỤ & CHỈ SỐ ĐIỆN NƯỚC

### 25. Bảng: `dich_vu` (Danh mục dịch vụ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `chu_tro_id` | UUID | Mã chủ trọ sở hữu hoặc quản lý. | FK, Unique |
| 3 | `ten_dich_vu` | CHARACTER | Thông tin trường ten_dich_vu của bảng dich_vu. | Unique, Not null |
| 4 | `loai_tinh_phi` | CHARACTER | Thông tin trường loai_tinh_phi của bảng dich_vu. | Not null |
| 5 | `don_vi` | CHARACTER | Thông tin trường don_vi của bảng dich_vu. | - |
| 6 | `don_gia_mac_dinh` | DECIMAL(38,2) | Số tiền / Đơn giá (don_gia_mac_dinh) tính theo VNĐ. | Not null |
| 7 | `bat_buoc` | BOOLEAN | Thông tin trường bat_buoc của bảng dich_vu. | Not null |
| 8 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 9 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

### 26. Bảng: `dich_vu_hop_dong` (Dịch vụ đăng ký theo hợp đồng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK, Unique, Not null |
| 3 | `dich_vu_id` | UUID | Mã dịch vụ liên kết. | FK, Unique, Not null |
| 4 | `loai_tinh_phi` | CHARACTER | Thông tin trường loai_tinh_phi của bảng dich_vu_hop_dong. | Not null |
| 5 | `don_gia_ap_dung` | DECIMAL(38,2) | Số tiền / Đơn giá (don_gia_ap_dung) tính theo VNĐ. | Not null |
| 6 | `so_luong` | DECIMAL(38,2) | Số lượng (so_luong). | Not null |
| 7 | `bat_dau_tu` | DATE | Thông tin trường bat_dau_tu của bảng dich_vu_hop_dong. | Unique, Not null |
| 8 | `ket_thuc_luc` | DATE | Thông tin trường ket_thuc_luc của bảng dich_vu_hop_dong. | - |
| 9 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 27. Bảng: `cau_hinh_gia` (Cấu hình đơn giá dịch vụ & điện nước)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK, Not null |
| 3 | `dich_vu_id` | UUID | Mã dịch vụ liên kết. | FK |
| 4 | `loai` | CHARACTER | Thông tin trường loai của bảng cau_hinh_gia. | Not null |
| 5 | `ten_hien_thi` | CHARACTER | Thông tin trường ten_hien_thi của bảng cau_hinh_gia. | Not null |
| 6 | `loai_tinh_phi` | CHARACTER | Thông tin trường loai_tinh_phi của bảng cau_hinh_gia. | Not null |
| 7 | `don_gia` | DECIMAL(38,2) | Thông tin trường don_gia của bảng cau_hinh_gia. | Not null |
| 8 | `hieu_luc_tu` | DATE | Thông tin trường hieu_luc_tu của bảng cau_hinh_gia. | Not null |
| 9 | `hieu_luc_den` | DATE | Thông tin trường hieu_luc_den của bảng cau_hinh_gia. | - |
| 10 | `dang_ap_dung` | BOOLEAN | Thông tin trường dang_ap_dung của bảng cau_hinh_gia. | Not null |
| 11 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 12 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

### 28. Bảng: `cau_hinh_phi_xe` (Cấu hình phí gửi xe)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK, Not null |
| 3 | `loai_xe` | CHARACTER | Thông tin trường loai_xe của bảng cau_hinh_phi_xe. | Not null |
| 4 | `don_gia` | DECIMAL(18,2) | Thông tin trường don_gia của bảng cau_hinh_phi_xe. | Not null |
| 5 | `hieu_luc_tu` | DATE | Thông tin trường hieu_luc_tu của bảng cau_hinh_phi_xe. | Not null |
| 6 | `hieu_luc_den` | DATE | Thông tin trường hieu_luc_den của bảng cau_hinh_phi_xe. | - |
| 7 | `dang_ap_dung` | BOOLEAN | Thông tin trường dang_ap_dung của bảng cau_hinh_phi_xe. | Not null |
| 8 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 9 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 10 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

### 29. Bảng: `chi_so_dien_nuoc` (Chỉ số điện nước định kỳ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Unique, Not null |
| 3 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK |
| 4 | `loai` | CHARACTER | Thông tin trường loai của bảng chi_so_dien_nuoc. | Unique, Not null |
| 5 | `ky_nam` | INTEGER | Kỳ hóa đơn theo năm. | Unique, Not null |
| 6 | `ky_thang` | INTEGER | Kỳ hóa đơn theo tháng. | Unique, Not null |
| 7 | `ngay_ghi` | DATE | Ngày / Thời gian ghi nhận (ngay_ghi). | Not null |
| 8 | `chi_so_cu` | INTEGER | Thông tin trường chi_so_cu của bảng chi_so_dien_nuoc. | Not null |
| 9 | `chi_so_moi` | INTEGER | Thông tin trường chi_so_moi của bảng chi_so_dien_nuoc. | Not null |
| 10 | `tieu_thu` | INTEGER | Thông tin trường tieu_thu của bảng chi_so_dien_nuoc. | - |
| 11 | `anh_dong_ho` | CHARACTER | Thông tin trường anh_dong_ho của bảng chi_so_dien_nuoc. | - |
| 12 | `nguoi_ghi_id` | UUID | Mã liên kết tới bảng nguoi_ghi. | FK |
| 13 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 14 | `ghi_chu` | CHARACTER | Ghi chú thêm thông tin. | - |
| 15 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 16 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

### 30. Bảng: `meter_anomaly_alert` (Cảnh báo chỉ số điện nước bất thường)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `chi_so_id` | UUID | Mã liên kết tới bảng chi_so. | FK, Not null |
| 3 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Not null |
| 4 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK |
| 5 | `loai` | CHARACTER | Thông tin trường loai của bảng meter_anomaly_alert. | Not null |
| 6 | `ky_thang` | INTEGER | Kỳ hóa đơn theo tháng. | Not null |
| 7 | `ky_nam` | INTEGER | Kỳ hóa đơn theo năm. | Not null |
| 8 | `tieu_thu_hien_tai` | INTEGER | Thông tin trường tieu_thu_hien_tai của bảng meter_anomaly_alert. | Not null |
| 9 | `tieu_thu_trung_binh` | DECIMAL(10,2) | Thông tin trường tieu_thu_trung_binh của bảng meter_anomaly_alert. | - |
| 10 | `ty_le_tang` | DECIMAL(10,2) | Thông tin trường ty_le_tang của bảng meter_anomaly_alert. | - |
| 11 | `muc_do` | CHARACTER | Thông tin trường muc_do của bảng meter_anomaly_alert. | Not null |
| 12 | `ly_do` | TEXT | Thông tin trường ly_do của bảng meter_anomaly_alert. | Not null |
| 13 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 14 | `resolved_at` | TIMESTAMP | Thông tin trường resolved_at của bảng meter_anomaly_alert. | - |
| 15 | `resolved_by` | UUID | Thông tin trường resolved_by của bảng meter_anomaly_alert. | FK |
| 16 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

## NHÓM 5: HÓA ĐƠN, THANH TOÁN & QUYẾT TOÁN TRẢ PHÒNG

### 31. Bảng: `hoa_don` (Hóa đơn tiền phòng & dịch vụ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK, Unique, Not null |
| 3 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Not null |
| 4 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK, Not null |
| 5 | `ma_hoa_don` | CHARACTER | Mã số hóa đơn thanh toán. | Unique, Not null |
| 6 | `ky_nam` | INTEGER | Kỳ hóa đơn theo năm. | Unique, Not null |
| 7 | `ky_thang` | INTEGER | Kỳ hóa đơn theo tháng. | Unique, Not null |
| 8 | `tu_ngay` | DATE | Thông tin trường tu_ngay của bảng hoa_don. | Not null |
| 9 | `den_ngay` | DATE | Thông tin trường den_ngay của bảng hoa_don. | Not null |
| 10 | `so_du_dau_ky` | DECIMAL(15,2) | Thông tin trường so_du_dau_ky của bảng hoa_don. | Not null |
| 11 | `tong_tien_phat_sinh` | DECIMAL(15,2) | Số tiền / Đơn giá (tong_tien_phat_sinh) tính theo VNĐ. | Not null |
| 12 | `tong_tien` | DECIMAL(15,2) | Tổng số tiền cần thanh toán (VNĐ). | Not null |
| 13 | `da_tra` | DECIMAL(15,2) | Số tiền thực tế đã thanh toán (VNĐ). | Not null |
| 14 | `so_du_cuoi_ky` | DECIMAL(15,2) | Thông tin trường so_du_cuoi_ky của bảng hoa_don. | - |
| 15 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 16 | `han_tra` | DATE | Thông tin trường han_tra của bảng hoa_don. | Not null |
| 17 | `ngay_lap_hoa_don` | TIMESTAMP | Ngày / Thời gian ghi nhận (ngay_lap_hoa_don). | Not null |
| 18 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 19 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 20 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 21 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |
| 22 | `auto_generated` | BOOLEAN | Thông tin trường auto_generated của bảng hoa_don. | - |
| 23 | `generation_batch_id` | UUID | Mã liên kết tới bảng generation_batch. | - |
| 24 | `source_schedule_id` | UUID | Mã liên kết tới bảng source_schedule. | - |
| 25 | `hoa_don_goc_id` | UUID | Mã liên kết tới bảng hoa_don_goc. | FK |
| 26 | `loai_hoa_don` | CHARACTER | Thông tin trường loai_hoa_don của bảng hoa_don. | Unique, Not null |

---

### 32. Bảng: `chi_tiet_hoa_don` (Chi tiết các khoản phí trong hóa đơn)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hoa_don_id` | UUID | Mã hóa đơn liên kết. | FK, Not null |
| 3 | `dich_vu_id` | UUID | Mã dịch vụ liên kết. | FK |
| 4 | `chi_so_dien_nuoc_id` | UUID | Mã liên kết tới bảng chi_so_dien_nuoc. | FK |
| 5 | `su_co_id` | UUID | Mã sự cố liên kết. | FK |
| 6 | `loai` | PUBLIC | Thông tin trường loai của bảng chi_tiet_hoa_don. | Not null |
| 7 | `mo_ta` | CHARACTER | Thông tin trường mo_ta của bảng chi_tiet_hoa_don. | Not null |
| 8 | `so_luong` | DECIMAL(38,2) | Số lượng (so_luong). | Not null |
| 9 | `don_gia` | DECIMAL(38,2) | Thông tin trường don_gia của bảng chi_tiet_hoa_don. | Not null |
| 10 | `thanh_tien` | DECIMAL(38,2) | Thông tin trường thanh_tien của bảng chi_tiet_hoa_don. | Not null |
| 11 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 12 | `source_type` | CHARACTER | Thông tin trường source_type của bảng chi_tiet_hoa_don. | Not null |
| 13 | `source_id` | UUID | Mã liên kết tới bảng source. | - |
| 14 | `pricing_rule_version` | CHARACTER | Thông tin trường pricing_rule_version của bảng chi_tiet_hoa_don. | Not null |
| 15 | `period_start` | DATE | Thông tin trường period_start của bảng chi_tiet_hoa_don. | Not null |
| 16 | `period_end` | DATE | Thông tin trường period_end của bảng chi_tiet_hoa_don. | Not null |
| 17 | `calculation_hash` | CHARACTER | Thông tin trường calculation_hash của bảng chi_tiet_hoa_don. | Not null |

---

### 33. Bảng: `lich_su_hoa_don` (Lịch sử trạng thái hóa đơn)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hoa_don_id` | UUID | Mã hóa đơn liên kết. | FK, Not null |
| 3 | `trang_thai_truoc` | PUBLIC | Thông tin trường trang_thai_truoc của bảng lich_su_hoa_don. | - |
| 4 | `trang_thai_moi` | PUBLIC | Thông tin trường trang_thai_moi của bảng lich_su_hoa_don. | Not null |
| 5 | `nguoi_thay_doi_id` | UUID | Mã liên kết tới bảng nguoi_thay_doi. | FK |
| 6 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 7 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 34. Bảng: `thanh_toan` (Giao dịch thanh toán hóa đơn)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hoa_don_id` | UUID | Mã hóa đơn liên kết. | FK, Not null |
| 3 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK |
| 4 | `so_tien` | DECIMAL(15,2) | Thông tin trường so_tien của bảng thanh_toan. | Not null |
| 5 | `ngay_thanh_toan` | TIMESTAMP | Ngày / Thời gian ghi nhận (ngay_thanh_toan). | Not null |
| 6 | `phuong_thuc_thanh_toan` | PUBLIC | Thông tin trường phuong_thuc_thanh_toan của bảng thanh_toan. | Not null |
| 7 | `ma_tham_chieu` | CHARACTER | Thông tin trường ma_tham_chieu của bảng thanh_toan. | - |
| 8 | `external_transaction_id` | CHARACTER | Mã liên kết tới bảng external_transaction. | Unique |
| 9 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 10 | `nguoi_thanh_toan_id` | UUID | Mã liên kết tới bảng nguoi_thanh_toan. | FK |
| 11 | `nguoi_ghi_nhan_id` | UUID | Mã liên kết tới bảng nguoi_ghi_nhan. | FK |
| 12 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 13 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 35. Bảng: `lich_thanh_toan` (Lịch thanh toán định kỳ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK, Unique, Not null |
| 3 | `ky_nam` | INTEGER | Kỳ hóa đơn theo năm. | Unique, Not null |
| 4 | `ky_thang` | INTEGER | Kỳ hóa đơn theo tháng. | Unique, Not null |
| 5 | `tu_ngay` | DATE | Thông tin trường tu_ngay của bảng lich_thanh_toan. | Not null |
| 6 | `den_ngay` | DATE | Thông tin trường den_ngay của bảng lich_thanh_toan. | Not null |
| 7 | `han_thanh_toan` | DATE | Thông tin trường han_thanh_toan của bảng lich_thanh_toan. | Not null |
| 8 | `so_tien_du_kien` | DECIMAL(15,2) | Số tiền / Đơn giá (so_tien_du_kien) tính theo VNĐ. | Not null |
| 9 | `hoa_don_id` | UUID | Mã hóa đơn liên kết. | FK |
| 10 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 11 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 12 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 13 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 14 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |

---

### 36. Bảng: `bank_transaction` (Giao dịch đối soát ngân hàng (VietQR))
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK |
| 3 | `hoa_don_id` | UUID | Mã hóa đơn liên kết. | FK |
| 4 | `so_tien` | DECIMAL(38,2) | Thông tin trường so_tien của bảng bank_transaction. | Not null |
| 5 | `noi_dung_chuyen_khoan` | CHARACTER | Thông tin trường noi_dung_chuyen_khoan của bảng bank_transaction. | - |
| 6 | `ma_giao_dich` | CHARACTER | Mã tham chiếu giao dịch ngân hàng / cổng thanh toán. | Unique |
| 7 | `ngan_hang` | CHARACTER | Thông tin trường ngan_hang của bảng bank_transaction. | - |
| 8 | `thoi_gian_giao_dich` | TIMESTAMP | Ngày / Thời gian ghi nhận (thoi_gian_giao_dich). | Not null |
| 9 | `payload` | JSONB | Thông tin trường payload của bảng bank_transaction. | - |
| 10 | `da_doi_soat` | BOOLEAN | Cờ đánh dấu trạng thái (da_doi_soat). | Not null |
| 11 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 37. Bảng: `invoice_generation_batch` (Đợt tạo hóa đơn tự động)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK |
| 3 | `ky_thang` | INTEGER | Kỳ hóa đơn theo tháng. | Not null |
| 4 | `ky_nam` | INTEGER | Kỳ hóa đơn theo năm. | Not null |
| 5 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 6 | `tong_hop_dong` | INTEGER | Thông tin trường tong_hop_dong của bảng invoice_generation_batch. | Not null |
| 7 | `tao_thanh_cong` | INTEGER | Thông tin trường tao_thanh_cong của bảng invoice_generation_batch. | Not null |
| 8 | `bo_qua` | INTEGER | Thông tin trường bo_qua của bảng invoice_generation_batch. | Not null |
| 9 | `loi` | INTEGER | Thông tin trường loi của bảng invoice_generation_batch. | Not null |
| 10 | `nguoi_tao_id` | UUID | Mã liên kết tới bảng nguoi_tao. | FK |
| 11 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 38. Bảng: `invoice_generation_log` (Nhật ký tạo hóa đơn tự động)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `batch_id` | UUID | Mã liên kết tới bảng batch. | FK, Not null |
| 3 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK |
| 4 | `hoa_don_id` | UUID | Mã hóa đơn liên kết. | FK |
| 5 | `status` | CHARACTER | Thông tin trường status của bảng invoice_generation_log. | Not null |
| 6 | `reason` | TEXT | Thông tin trường reason của bảng invoice_generation_log. | - |
| 7 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 39. Bảng: `debt_reminder_log` (Nhật ký nhắc nợ tự động)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `channel` | CHARACTER | Thông tin trường channel của bảng debt_reminder_log. | Not null |
| 3 | `error_message` | CHARACTER | Thông tin trường error_message của bảng debt_reminder_log. | - |
| 4 | `recipient_contact` | CHARACTER | Thông tin trường recipient_contact của bảng debt_reminder_log. | - |
| 5 | `reminder_type` | CHARACTER | Thông tin trường reminder_type của bảng debt_reminder_log. | Not null |
| 6 | `sent_at` | TIMESTAMP | Thông tin trường sent_at của bảng debt_reminder_log. | Not null |
| 7 | `status` | CHARACTER | Thông tin trường status của bảng debt_reminder_log. | Not null |
| 8 | `hoa_don_id` | UUID | Mã hóa đơn liên kết. | Not null |
| 9 | `recipient_id` | UUID | Mã liên kết tới bảng recipient. | - |

---

### 40. Bảng: `giao_dich_tien_coc` (Sổ quỹ giao dịch tiền cọc)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK, Not null |
| 3 | `thanh_toan_id` | UUID | Mã giao dịch thanh toán liên kết. | FK, Unique |
| 4 | `quyet_toan_tra_phong_id` | UUID | Mã quyết toán trả phòng liên kết. | FK |
| 5 | `loai` | CHARACTER | Thông tin trường loai của bảng giao_dich_tien_coc. | Not null |
| 6 | `so_tien` | DECIMAL(18,2) | Thông tin trường so_tien của bảng giao_dich_tien_coc. | Not null |
| 7 | `thoi_diem` | TIMESTAMP | Thông tin trường thoi_diem của bảng giao_dich_tien_coc. | Not null |
| 8 | `dien_giai` | TEXT | Thông tin trường dien_giai của bảng giao_dich_tien_coc. | Not null |
| 9 | `ma_tham_chieu` | CHARACTER | Thông tin trường ma_tham_chieu của bảng giao_dich_tien_coc. | - |
| 10 | `chung_tu_url` | TEXT | Thông tin trường chung_tu_url của bảng giao_dich_tien_coc. | - |
| 11 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 41. Bảng: `quyet_toan_tra_phong` (Quyết toán thanh lý trả phòng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `hop_dong_id` | UUID | Mã hợp đồng thuê liên kết. | FK, Unique, Not null |
| 3 | `hoa_don_id` | UUID | Mã hóa đơn liên kết. | FK, Unique, Not null |
| 4 | `ngay_tra_phong` | DATE | Ngày / Thời gian ghi nhận (ngay_tra_phong). | Not null |
| 5 | `tien_coc_ban_dau` | DECIMAL(18,2) | Số tiền / Đơn giá (tien_coc_ban_dau) tính theo VNĐ. | Not null |
| 6 | `tien_coc_da_can_tru` | DECIMAL(18,2) | Số tiền / Đơn giá (tien_coc_da_can_tru) tính theo VNĐ. | Not null |
| 7 | `tien_coc_can_hoan` | DECIMAL(18,2) | Số tiền / Đơn giá (tien_coc_can_hoan) tính theo VNĐ. | Not null |
| 8 | `tien_phai_thu_them` | DECIMAL(18,2) | Số tiền / Đơn giá (tien_phai_thu_them) tính theo VNĐ. | Not null |
| 9 | `khoan_khau_tru` | JSONB | Thông tin trường khoan_khau_tru của bảng quyet_toan_tra_phong. | Not null |
| 10 | `trang_thai` | CHARACTER | Trạng thái hoạt động của bản ghi. | Not null |
| 11 | `ban_giao_da_xac_nhan` | BOOLEAN | Thông tin trường ban_giao_da_xac_nhan của bảng quyet_toan_tra_phong. | Not null |
| 12 | `ve_sinh_kiem_tra_xong` | BOOLEAN | Thông tin trường ve_sinh_kiem_tra_xong của bảng quyet_toan_tra_phong. | Not null |
| 13 | `hoan_coc_luc` | TIMESTAMP | Thông tin trường hoan_coc_luc của bảng quyet_toan_tra_phong. | - |
| 14 | `ban_giao_luc` | TIMESTAMP | Thông tin trường ban_giao_luc của bảng quyet_toan_tra_phong. | - |
| 15 | `kiem_tra_luc` | TIMESTAMP | Thông tin trường kiem_tra_luc của bảng quyet_toan_tra_phong. | - |
| 16 | `hoan_tat_luc` | TIMESTAMP | Thông tin trường hoan_tat_luc của bảng quyet_toan_tra_phong. | - |
| 17 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 18 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 19 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

### 42. Bảng: `chi_tiet_ban_giao_tai_san` (Biên bản kiểm kê bàn giao tài sản)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `quyet_toan_tra_phong_id` | UUID | Mã quyết toán trả phòng liên kết. | FK, Not null |
| 3 | `tai_san_phong_id` | UUID | Mã tài sản tại phòng liên kết. | FK |
| 4 | `ten_tai_san` | CHARACTER | Thông tin trường ten_tai_san của bảng chi_tiet_ban_giao_tai_san. | Not null |
| 5 | `so_luong_ban_dau` | INTEGER | Số lượng (so_luong_ban_dau). | Not null |
| 6 | `tinh_trang_ban_dau` | CHARACTER | Thông tin trường tinh_trang_ban_dau của bảng chi_tiet_ban_giao_tai_san. | Not null |
| 7 | `anh_tai_san_ban_dau` | TEXT | Thông tin trường anh_tai_san_ban_dau của bảng chi_tiet_ban_giao_tai_san. | - |
| 8 | `so_luong_thuc_te` | INTEGER | Số lượng (so_luong_thuc_te). | - |
| 9 | `tinh_trang_thuc_te` | CHARACTER | Thông tin trường tinh_trang_thuc_te của bảng chi_tiet_ban_giao_tai_san. | - |
| 10 | `chung_tu_url` | TEXT | Thông tin trường chung_tu_url của bảng chi_tiet_ban_giao_tai_san. | - |
| 11 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 12 | `da_xac_nhan` | BOOLEAN | Cờ đánh dấu trạng thái (da_xac_nhan). | Not null |
| 13 | `xac_nhan_luc` | TIMESTAMP | Thông tin trường xac_nhan_luc của bảng chi_tiet_ban_giao_tai_san. | - |
| 14 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 15 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

## NHÓM 6: TÀI SẢN, SỰ CỐ & PHƯƠNG TIỆN

### 43. Bảng: `kho_tai_san` (Kho tài sản & Thiết bị tổng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK, Not null |
| 3 | `ten_tai_san` | CHARACTER | Thông tin trường ten_tai_san của bảng kho_tai_san. | Not null |
| 4 | `hinh_anh` | TEXT | Thông tin trường hinh_anh của bảng kho_tai_san. | - |
| 5 | `tong_so_luong` | INTEGER | Số lượng (tong_so_luong). | Not null |
| 6 | `so_luong_kha_dung` | INTEGER | Số lượng (so_luong_kha_dung). | Not null |
| 7 | `so_luong_da_cap_phat` | INTEGER | Số lượng (so_luong_da_cap_phat). | Not null |
| 8 | `so_luong_hu_hong` | INTEGER | Số lượng (so_luong_hu_hong). | Not null |
| 9 | `tinh_trang` | CHARACTER | Thông tin trường tinh_trang của bảng kho_tai_san. | Not null |
| 10 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 11 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | - |
| 12 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | - |
| 13 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |

---

### 44. Bảng: `tai_san_phong` (Tài sản & Thiết bị bố trí tại phòng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Not null |
| 3 | `ten_tai_san` | CHARACTER | Thông tin trường ten_tai_san của bảng tai_san_phong. | Not null |
| 4 | `so_luong` | INTEGER | Số lượng (so_luong). | Not null |
| 5 | `gia_tri` | DECIMAL(19,2) | Số tiền / Đơn giá (gia_tri) tính theo VNĐ. | Not null |
| 6 | `tinh_trang` | CHARACTER | Thông tin trường tinh_trang của bảng tai_san_phong. | Not null |
| 7 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 8 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | - |
| 9 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | - |
| 10 | `anh_tai_san` | TEXT | Thông tin trường anh_tai_san của bảng tai_san_phong. | - |
| 11 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |
| 12 | `kho_tai_san_id` | UUID | Mã tài sản trong kho tổng. | FK |

---

### 45. Bảng: `lich_su_kho_tai_san` (Lịch sử xuất nhập kho tài sản)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `kho_tai_san_id` | UUID | Mã tài sản trong kho tổng. | FK, Not null |
| 3 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK |
| 4 | `loai_giao_dich` | CHARACTER | Thông tin trường loai_giao_dich của bảng lich_su_kho_tai_san. | Not null |
| 5 | `so_luong` | INTEGER | Số lượng (so_luong). | Not null |
| 6 | `ghi_chu` | TEXT | Ghi chú thêm thông tin. | - |
| 7 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | - |

---

### 46. Bảng: `su_co` (Báo cáo sự cố & Hư hỏng)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Not null |
| 3 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK |
| 4 | `nguoi_bao_id` | UUID | Mã liên kết tới bảng nguoi_bao. | FK |
| 5 | `tieu_de` | CHARACTER | Tiêu đề thông báo / sự cố. | Not null |
| 6 | `mo_ta` | TEXT | Thông tin trường mo_ta của bảng su_co. | Not null |
| 7 | `loai_su_co` | PUBLIC | Thông tin trường loai_su_co của bảng su_co. | Not null |
| 8 | `uu_tien` | PUBLIC | Thông tin trường uu_tien của bảng su_co. | Not null |
| 9 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 10 | `nguoi_phu_trach_id` | UUID | Mã liên kết tới bảng nguoi_phu_trach. | FK |
| 11 | `chi_phi_sua_chua` | DECIMAL(15,2) | Số tiền / Đơn giá (chi_phi_sua_chua) tính theo VNĐ. | Not null |
| 12 | `tinh_vao_hoa_don` | BOOLEAN | Thông tin trường tinh_vao_hoa_don của bảng su_co. | Not null |
| 13 | `ghi_chu_chu_nha` | TEXT | Thông tin trường ghi_chu_chu_nha của bảng su_co. | - |
| 14 | `giai_quyet_luc` | TIMESTAMP | Thông tin trường giai_quyet_luc của bảng su_co. | - |
| 15 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 16 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

### 47. Bảng: `phuong_tien` (Phương tiện gửi tại nhà trọ)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `ma_pt` | CHARACTER | Thông tin trường ma_pt của bảng phuong_tien. | Unique, Not null |
| 3 | `loai_xe` | CHARACTER | Thông tin trường loai_xe của bảng phuong_tien. | Not null |
| 4 | `bien_so` | CHARACTER | Thông tin trường bien_so của bảng phuong_tien. | Not null |
| 5 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK |
| 6 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK |
| 7 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK |
| 8 | `chu_tro_id` | UUID | Mã chủ trọ sở hữu hoặc quản lý. | FK |
| 9 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | - |
| 10 | `created_at` | TIMESTAMP | Thông tin trường created_at của bảng phuong_tien. | - |
| 11 | `updated_at` | TIMESTAMP | Thông tin trường updated_at của bảng phuong_tien. | - |
| 12 | `anh_xe` | CHARACTER | Thông tin trường anh_xe của bảng phuong_tien. | - |
| 13 | `loai_phuong_tien` | CHARACTER | Thông tin trường loai_phuong_tien của bảng phuong_tien. | - |
| 14 | `ten_dong_xe` | CHARACTER | Thông tin trường ten_dong_xe của bảng phuong_tien. | - |
| 15 | `mau_xe` | CHARACTER | Thông tin trường mau_xe của bảng phuong_tien. | - |
| 16 | `ten_chu_xe` | CHARACTER | Thông tin trường ten_chu_xe của bảng phuong_tien. | - |
| 17 | `so_ve_xe` | CHARACTER | Thông tin trường so_ve_xe của bảng phuong_tien. | - |
| 18 | `hieu_luc_tu` | DATE | Thông tin trường hieu_luc_tu của bảng phuong_tien. | Not null |
| 19 | `hieu_luc_den` | DATE | Thông tin trường hieu_luc_den của bảng phuong_tien. | - |

---

### 48. Bảng: `lich_su_phuong_tien` (Lịch sử phương tiện gửi xe)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `phuong_tien_id` | UUID | Mã liên kết tới bảng phuong_tien. | FK, Not null |
| 3 | `khach_thue_id` | UUID | Mã khách thuê phòng liên kết. | FK, Not null |
| 4 | `phong_id` | UUID | Mã phòng trọ liên kết. | FK, Not null |
| 5 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK, Not null |
| 6 | `hieu_luc_tu` | DATE | Thông tin trường hieu_luc_tu của bảng lich_su_phuong_tien. | Not null |
| 7 | `hieu_luc_den` | DATE | Thông tin trường hieu_luc_den của bảng lich_su_phuong_tien. | - |
| 8 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

## NHÓM 7: THÔNG BÁO, TIN NHẮN & MEDIA

### 49. Bảng: `thong_bao` (Thông báo hệ thống / Tòa nhà)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `nguoi_gui_id` | UUID | Mã liên kết tới bảng nguoi_gui. | FK |
| 3 | `loai` | PUBLIC | Thông tin trường loai của bảng thong_bao. | Not null |
| 4 | `tieu_de` | CHARACTER | Tiêu đề thông báo / sự cố. | Not null |
| 5 | `noi_dung` | TEXT | Nội dung chi tiết thông báo / tin nhắn / sự cố. | Not null |
| 6 | `doi_tuong` | PUBLIC | Thông tin trường doi_tuong của bảng thong_bao. | - |
| 7 | `doi_tuong_id` | UUID | Mã liên kết tới bảng doi_tuong. | - |
| 8 | `kenh` | PUBLIC | Thông tin trường kenh của bảng thong_bao. | Not null |
| 9 | `gui_tat_ca` | BOOLEAN | Thông tin trường gui_tat_ca của bảng thong_bao. | Not null |
| 10 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 11 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 12 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |

---

### 50. Bảng: `thong_bao_nguoi_nhan` (Danh sách người nhận thông báo)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `thong_bao_id` | UUID | Mã thông báo liên kết. | FK, Unique, Not null |
| 3 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK, Unique, Not null |
| 4 | `da_doc` | BOOLEAN | Cờ đánh dấu trạng thái (da_doc). | Not null |
| 5 | `doc_luc` | TIMESTAMP | Thông tin trường doc_luc của bảng thong_bao_nguoi_nhan. | - |
| 6 | `gui_luc` | TIMESTAMP | Thông tin trường gui_luc của bảng thong_bao_nguoi_nhan. | - |
| 7 | `loi_gui` | TEXT | Thông tin trường loi_gui của bảng thong_bao_nguoi_nhan. | - |

---

### 51. Bảng: `notification_delivery` (Trạng thái phát thông báo)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `aggregate_type` | CHARACTER | Thông tin trường aggregate_type của bảng notification_delivery. | Unique, Not null |
| 3 | `aggregate_id` | UUID | Mã liên kết tới bảng aggregate. | Unique, Not null |
| 4 | `rule_code` | CHARACTER | Thông tin trường rule_code của bảng notification_delivery. | Unique, Not null |
| 5 | `scheduled_for` | DATE | Thông tin trường scheduled_for của bảng notification_delivery. | Unique, Not null |
| 6 | `channel` | CHARACTER | Thông tin trường channel của bảng notification_delivery. | Unique, Not null |
| 7 | `recipient_id` | UUID | Mã liên kết tới bảng recipient. | Unique, Not null |
| 8 | `status` | CHARACTER | Thông tin trường status của bảng notification_delivery. | Not null |
| 9 | `error_message` | TEXT | Thông tin trường error_message của bảng notification_delivery. | - |
| 10 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 11 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |

---

### 52. Bảng: `cuoc_tro_chuyen` (Cuộc trò chuyện (Chat room))
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `loai` | PUBLIC | Thông tin trường loai của bảng cuoc_tro_chuyen. | Not null |
| 3 | `ten` | TEXT | Tên chính. | - |
| 4 | `anh` | TEXT | Thông tin trường anh của bảng cuoc_tro_chuyen. | - |
| 5 | `nha_tro_id` | UUID | Mã nhà trọ / tòa nhà liên kết. | FK |
| 6 | `tang_id` | UUID | Mã tầng trong tòa nhà. | FK |
| 7 | `nguoi_tao_id` | UUID | Mã liên kết tới bảng nguoi_tao. | FK |
| 8 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 9 | `khoa_duy_nhat` | TEXT | Thông tin trường khoa_duy_nhat của bảng cuoc_tro_chuyen. | Unique, Not null |
| 10 | `tin_nhan_cuoi_luc` | TIMESTAMP | Thông tin trường tin_nhan_cuoi_luc của bảng cuoc_tro_chuyen. | - |
| 11 | `xem_truoc` | TEXT | Thông tin trường xem_truoc của bảng cuoc_tro_chuyen. | - |
| 12 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 13 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 14 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |

---

### 53. Bảng: `thanh_vien_cuoc_tro_chuyen` (Thành viên tham gia trò chuyện)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `cuoc_tro_chuyen_id` | UUID | Mã cuộc trò chuyện liên kết. | FK, Unique, Not null |
| 3 | `nguoi_dung_id` | UUID | Mã người dùng (tài khoản hệ thống) liên kết. | FK, Unique, Not null |
| 4 | `vai_tro` | PUBLIC | Thông tin trường vai_tro của bảng thanh_vien_cuoc_tro_chuyen. | Not null |
| 5 | `tham_gia_luc` | TIMESTAMP | Số tiền / Đơn giá (tham_gia_luc) tính theo VNĐ. | Not null |
| 6 | `roi_luc` | TIMESTAMP | Thông tin trường roi_luc của bảng thanh_vien_cuoc_tro_chuyen. | - |
| 7 | `doc_den_seq` | BIGINT | Thông tin trường doc_den_seq của bảng thanh_vien_cuoc_tro_chuyen. | Not null |
| 8 | `doc_den_luc` | TIMESTAMP | Thông tin trường doc_den_luc của bảng thanh_vien_cuoc_tro_chuyen. | - |
| 9 | `tat_thong_bao` | BOOLEAN | Thông tin trường tat_thong_bao của bảng thanh_vien_cuoc_tro_chuyen. | Not null |
| 10 | `ghim` | BOOLEAN | Thông tin trường ghim của bảng thanh_vien_cuoc_tro_chuyen. | Not null |
| 11 | `luu_tru` | BOOLEAN | Thông tin trường luu_tru của bảng thanh_vien_cuoc_tro_chuyen. | Not null |
| 12 | `an_den_seq` | BIGINT | Thông tin trường an_den_seq của bảng thanh_vien_cuoc_tro_chuyen. | Not null |
| 13 | `biet_danh` | TEXT | Thông tin trường biet_danh của bảng thanh_vien_cuoc_tro_chuyen. | - |
| 14 | `tat_thong_bao_den` | TIMESTAMP | Thông tin trường tat_thong_bao_den của bảng thanh_vien_cuoc_tro_chuyen. | - |

---

### 54. Bảng: `tin_nhan` (Tin nhắn trao đổi)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `so_thu_tu` | BIGINT | Thông tin trường so_thu_tu của bảng tin_nhan. | Unique, Not null |
| 3 | `cuoc_tro_chuyen_id` | UUID | Mã cuộc trò chuyện liên kết. | FK, Not null |
| 4 | `nguoi_gui_id` | UUID | Mã liên kết tới bảng nguoi_gui. | FK |
| 5 | `loai` | PUBLIC | Thông tin trường loai của bảng tin_nhan. | Not null |
| 6 | `noi_dung` | TEXT | Nội dung chi tiết thông báo / tin nhắn / sự cố. | - |
| 7 | `file_media_id` | UUID | Mã liên kết tới bảng file_media. | FK |
| 8 | `tra_loi_cho_id` | UUID | Mã liên kết tới bảng tra_loi_cho. | FK |
| 9 | `ma_client` | TEXT | Thông tin trường ma_client của bảng tin_nhan. | - |
| 10 | `da_thu_hoi` | BOOLEAN | Cờ đánh dấu trạng thái (da_thu_hoi). | Not null |
| 11 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |
| 12 | `cap_nhat_luc` | TIMESTAMP | Thời điểm cập nhật bản ghi gần nhất. | Not null |
| 13 | `xoa_luc` | TIMESTAMP | Thời điểm xóa mềm (soft delete) nếu có. | - |
| 14 | `ghim_luc` | TIMESTAMP | Thông tin trường ghim_luc của bảng tin_nhan. | - |
| 15 | `nguoi_ghim_id` | UUID | Mã liên kết tới bảng nguoi_ghim. | FK |
| 16 | `chuyen_tiep_tu_id` | UUID | Mã liên kết tới bảng chuyen_tiep_tu. | FK |

---

### 55. Bảng: `bao_cao_tin_nhan` (Báo cáo vi phạm tin nhắn)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `tin_nhan_id` | UUID | Mã liên kết tới bảng tin_nhan. | FK, Unique, Not null |
| 3 | `cuoc_tro_chuyen_id` | UUID | Mã cuộc trò chuyện liên kết. | FK, Not null |
| 4 | `nguoi_bao_cao_id` | UUID | Mã liên kết tới bảng nguoi_bao_cao. | FK, Unique, Not null |
| 5 | `ly_do` | TEXT | Thông tin trường ly_do của bảng bao_cao_tin_nhan. | Not null |
| 6 | `trang_thai` | PUBLIC | Trạng thái hoạt động của bản ghi. | Not null |
| 7 | `nguoi_xu_ly_id` | UUID | Mã liên kết tới bảng nguoi_xu_ly. | FK |
| 8 | `ghi_chu_xu_ly` | TEXT | Thông tin trường ghi_chu_xu_ly của bảng bao_cao_tin_nhan. | - |
| 9 | `xu_ly_luc` | TIMESTAMP | Thông tin trường xu_ly_luc của bảng bao_cao_tin_nhan. | - |
| 10 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---

### 56. Bảng: `file_media` (Tệp đính kèm & Hình ảnh media)
| STT | Tên trường | Kiểu dữ liệu | Mô tả | Ràng buộc |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `id` | UUID | Khóa chính định danh duy nhất của bản ghi. | PK |
| 2 | `doi_tuong` | CHARACTER | Thông tin trường doi_tuong của bảng file_media. | Not null |
| 3 | `doi_tuong_id` | UUID | Mã liên kết tới bảng doi_tuong. | Not null |
| 4 | `url` | TEXT | Thông tin trường url của bảng file_media. | Not null |
| 5 | `public_id` | CHARACTER | Mã liên kết tới bảng public. | - |
| 6 | `loai_file` | CHARACTER | Thông tin trường loai_file của bảng file_media. | - |
| 7 | `kich_thuoc_bytes` | BIGINT | Thông tin trường kich_thuoc_bytes của bảng file_media. | - |
| 8 | `metadata` | JSONB | Thông tin trường metadata của bảng file_media. | - |
| 9 | `nguoi_tai_len_id` | UUID | Mã liên kết tới bảng nguoi_tai_len. | FK |
| 10 | `tao_luc` | TIMESTAMP | Thời điểm tạo bản ghi. | Not null |

---
