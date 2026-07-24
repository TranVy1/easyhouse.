"use client";

import Link from "next/link";
import { ArrowLeft, FileText, CheckCircle2, ShieldAlert, BookOpen, UserCheck, ShieldCheck, HelpCircle } from "lucide-react";

export default function DieuKhoanDichVuPage() {
  const sections = [
    { id: "chap-thuan", title: "1. Chấp thuận điều khoản", icon: <BookOpen size={16} /> },
    { id: "chu-tro", title: "2. Quyền lợi & Trách nhiệm Chủ trọ", icon: <UserCheck size={16} /> },
    { id: "khach-thue", title: "3. Quyền lợi & Trách nhiệm Khách thuê", icon: <ShieldCheck size={16} /> },
    { id: "thanh-toan", title: "4. Quy định Hóa đơn & Thanh toán", icon: <FileText size={16} /> },
    { id: "vi-pham", title: "5. Xử lý vi phạm & Khóa tài khoản", icon: <ShieldAlert size={16} /> },
  ];

  return (
    <div className="min-h-screen bg-[#F8F3EC] font-sans pb-20 selection:bg-[#4FA7A0]/20 selection:text-[#243B5A] scroll-smooth">
      {/* Soothing Pastels & Soft Gradient Header */}
      <div className="bg-gradient-to-b from-[#4FA7A0]/12 via-[#FFFDF8]/60 to-[#F8F3EC] border-b border-[#E8DED2] pt-16 pb-12 px-4 md:px-8 xl:px-12 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-96 h-96 bg-[#4FA7A0]/12 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute top-12 left-1/3 w-72 h-72 bg-[#F2A45B]/12 rounded-full blur-3xl pointer-events-none" />
        
        <div className="max-w-6xl mx-auto relative z-10">
          <Link 
            href="/" 
            className="inline-flex items-center gap-2 text-[#6B7A8C] hover:text-[#243B5A] hover:border-[#4FA7A0]/30 bg-[#FFFDF8] hover:bg-[#4FA7A0]/10 px-4 py-2 rounded-xl text-sm font-semibold transition-all mb-6 border border-[#E8DED2] shadow-sm"
          >
            <ArrowLeft size={16} /> Quay lại Trang chủ
          </Link>
          
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-2xl bg-[#243B5A] text-white flex items-center justify-center shadow-lg shadow-[#243B5A]/10 border border-[#243B5A]/20 shrink-0">
                <FileText size={24} />
              </div>
              <div>
                <h1 className="text-3xl md:text-4xl font-extrabold tracking-tight text-[#243B5A] leading-tight">
                  Điều Khoản Dịch Vụ
                </h1>
                <p className="text-sm text-[#6B7A8C] font-medium mt-1">Cập nhật mới nhất: Ngày 31 tháng 05 năm 2026</p>
              </div>
            </div>
            
            <div className="hidden md:flex items-center gap-2.5 px-4 py-2.5 bg-[#4FA7A0]/10 border border-[#4FA7A0]/20 rounded-2xl text-[#243B5A] text-xs font-semibold">
              <HelpCircle size={14} className="text-[#4FA7A0]" />
              <span>Hỗ trợ pháp lý: support@easyhouse.local</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Two-Column Layout (Extremely Harmonious & Professional) */}
      <div className="max-w-6xl mx-auto px-4 md:px-8 xl:px-12 mt-10">
        <div className="flex flex-col lg:flex-row gap-10">
          
          {/* Left Sidebar Navigation (Desktop only - floating table of contents) */}
          <aside className="hidden lg:block w-[280px] shrink-0 sticky top-8 self-start bg-[#FFFDF8] border border-[#E8DED2] rounded-3xl p-5 shadow-sm space-y-4">
            <p className="text-xs font-bold text-[#6B7A8C] uppercase tracking-wider px-2">Mục lục điều khoản</p>
            <nav className="flex flex-col gap-1">
              {sections.map((sec) => (
                <a
                  key={sec.id}
                  href={`#${sec.id}`}
                  className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-[#6B7A8C] hover:text-[#243B5A] hover:bg-[#4FA7A0]/10 transition-all cursor-pointer group"
                >
                  <span className="text-[#6B7A8C] group-hover:text-[#4FA7A0] transition-colors shrink-0">
                    {sec.icon}
                  </span>
                  <span className="truncate">{sec.title.split(". ")[1]}</span>
                </a>
              ))}
            </nav>
            <div className="border-t border-[#E8DED2] pt-4 px-2">
              <div className="bg-[#F8F3EC] rounded-xl p-3 text-center border border-[#E8DED2]">
                <p className="text-xs font-semibold text-[#6B7A8C]">Bạn cần tư vấn thêm?</p>
                <a href="mailto:support@easyhouse.local" className="inline-block mt-2 text-xs font-bold text-[#243B5A] hover:underline">Liên hệ bộ phận pháp lý</a>
              </div>
            </div>
          </aside>

          {/* Right Main Content Card */}
          <div className="flex-1 bg-[#FFFDF8] rounded-3xl p-6 md:p-10 shadow-sm border border-[#E8DED2] space-y-12">
            
            {/* Section 1 */}
            <section id="chap-thuan" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  1
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Chấp thuận điều khoản</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Chào mừng bạn đến với hệ sinh thái <strong>EasyHouse</strong>. Bằng việc đăng ký tài khoản, truy cập thông tin nhà trọ hoặc sử dụng bất kỳ phần mềm quản lý, tiện ích dịch vụ cư dân trực tuyến nào của chúng tôi, bạn chính thức xác nhận đã đọc, hiểu và tự nguyện cam kết tuân thủ đầy đủ các nội dung được thỏa thuận trong văn bản Điều khoản Dịch vụ này.
                </p>
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Nếu bạn đại diện cho một tổ chức cho thuê hoặc tập thể cư dân, việc sử dụng tài khoản đồng nghĩa với cam kết tổ chức đó cũng chấp thuận các quy chế ràng buộc liên đới này.
                </p>
              </div>
            </section>

            {/* Section 2 */}
            <section id="chu-tro" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  2
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Quyền và Trách nhiệm của Chủ trọ (Landlord)</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Chủ trọ khi đăng ký tòa nhà và tạo các phòng cho thuê trên EasyHouse cam kết thực hiện đúng các quy định minh bạch thông tin sau:
                </p>
                <div className="grid grid-cols-1 gap-3.5 text-sm text-[#6B7A8C]">
                  <div className="flex gap-3 items-start bg-[#F8F3EC]/70 p-3.5 rounded-2xl border border-[#E8DED2]">
                    <CheckCircle2 size={16} className="text-[#4FA7A0] shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-[#243B5A]">Xác thực thông tin phòng trọ</p>
                      <p className="text-xs text-[#6B7A8C] mt-0.5">Mô tả đúng địa chỉ thực tế, đơn giá phòng, phí dịch vụ cố định (điện, nước, internet) và tình trạng nội thất có sẵn.</p>
                    </div>
                  </div>
                  <div className="flex gap-3 items-start bg-[#F8F3EC]/70 p-3.5 rounded-2xl border border-[#E8DED2]">
                    <CheckCircle2 size={16} className="text-[#4FA7A0] shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-[#243B5A]">Tôn trọng Hợp đồng trực tuyến</p>
                      <p className="text-xs text-[#6B7A8C] mt-0.5">Khởi tạo và thực hiện đúng thời hạn thuê, đặt cọc và chu kỳ đóng tiền đã thỏa thuận trong hợp đồng số.</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 3 */}
            <section id="khach-thue" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  3
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Quyền và Trách nhiệm của Khách thuê (Tenant)</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Khách thuê khi gia nhập hệ thống EasyHouse có trách nhiệm hợp tác minh bạch thông tin cư trú và tuân thủ các nghĩa vụ tài chính:
                </p>
                <div className="grid grid-cols-1 gap-3.5 text-sm text-[#6B7A8C]">
                  <div className="flex gap-3 items-start bg-[#F8F3EC]/70 p-3.5 rounded-2xl border border-[#E8DED2]">
                    <CheckCircle2 size={16} className="text-[#4FA7A0] shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-[#243B5A]">Cung cấp thông tin xác thực định danh</p>
                      <p className="text-xs text-[#6B7A8C] mt-0.5">Cung cấp hình ảnh định danh (CCCD) trung thực để lập hồ sơ cư trú và làm căn cứ pháp lý của hợp đồng thuê.</p>
                    </div>
                  </div>
                  <div className="flex gap-3 items-start bg-[#F8F3EC]/70 p-3.5 rounded-2xl border border-[#E8DED2]">
                    <CheckCircle2 size={16} className="text-[#4FA7A0] shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-[#243B5A]">Nghĩa vụ đóng phí và bảo quản tài sản</p>
                      <p className="text-xs text-[#6B7A8C] mt-0.5">Thanh toán đầy đủ các hóa đơn dịch vụ đúng ngày thông báo và bồi thường hỏng hóc cơ sở vật chất do lỗi chủ quan.</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 4 */}
            <section id="thanh-toan" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  4
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Quy định về Hóa đơn và Thanh toán điện tử</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Hệ thống EasyHouse hỗ trợ chức năng tự động tạo hóa đơn chi tiết hàng tháng căn cứ trên chỉ số tiêu thụ điện nước thực tế do chủ trọ cập nhật và đơn giá hợp đồng.
                </p>
                <p className="text-sm text-[#6B7A8C] leading-relaxed font-semibold text-[#243B5A]">
                  Khách thuê cam kết thực hiện chuyển khoản thanh toán qua QR Ngân hàng (định dạng VietQR) đúng cú pháp do hệ thống hiển thị để đảm bảo trạng thái hóa đơn được tự động gạch nợ thành công tức thì.
                </p>
              </div>
            </section>

            {/* Section 5 */}
            <section id="vi-pham" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  5
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Xử lý vi phạm và Khóa tài khoản</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <div className="p-5 bg-[#F2A45B]/15 border border-[#F2A45B]/30 rounded-3xl flex gap-3 text-[#9A5A1B] text-sm leading-relaxed">
                  <ShieldAlert size={22} className="shrink-0 text-[#F2A45B] mt-0.5" />
                  <div>
                    <p className="font-extrabold text-[#243B5A] text-base">Lưu ý quan trọng bảo vệ người dùng:</p>
                    <p className="mt-1 text-[#243B5A]">
                      Chúng tôi bảo lưu toàn quyền đình chỉ, khóa tài khoản hoặc hủy bỏ quyền truy cập hệ thống của bất kỳ cá nhân hay tổ chức nào bị phát hiện có hành vi đăng tin ảo/phòng không tồn tại, lừa đảo đặt cọc, giả mạo biên lai chuyển khoản hoặc liên tục chậm trễ nghĩa vụ thanh toán mà không có lý do chính đáng được chủ nhà chấp thuận.
                    </p>
                  </div>
                </div>
              </div>
            </section>

            {/* Footer sub-bar inside container */}
            <div className="border-t border-[#E8DED2] pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-[#6B7A8C]">
              <p>© 2026 EasyHouse. Mọi quyền được bảo lưu.</p>
              <div className="flex gap-6 font-semibold">
                <Link href="/chinh-sach-bao-mat" className="text-[#6B7A8C] hover:text-[#4FA7A0] transition-colors">Chính sách bảo mật</Link>
                <Link href="/quy-che-hoat-dong" className="text-[#6B7A8C] hover:text-[#243B5A] transition-colors">Quy chế hoạt động</Link>
              </div>
            </div>

          </div>

        </div>
      </div>
    </div>
  );
}
