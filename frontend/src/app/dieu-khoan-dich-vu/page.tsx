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
    <div className="min-h-screen bg-[#F8FAFC] font-sans pb-20 selection:bg-blue-100 selection:text-blue-900 scroll-smooth">
      {/* Soothing Pastels & Soft Gradient Header */}
      <div className="bg-gradient-to-b from-blue-50/60 via-indigo-50/30 to-[#F8FAFC] border-b border-slate-100 pt-16 pb-12 px-4 md:px-8 xl:px-12 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-96 h-96 bg-blue-300/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute top-12 left-1/3 w-72 h-72 bg-indigo-300/10 rounded-full blur-3xl pointer-events-none" />
        
        <div className="max-w-6xl mx-auto relative z-10">
          <Link 
            href="/" 
            className="inline-flex items-center gap-2 text-slate-600 hover:text-blue-600 hover:border-blue-200 bg-white hover:bg-blue-50/50 px-4 py-2 rounded-xl text-sm font-semibold transition-all mb-6 border border-slate-200/60 shadow-sm"
          >
            <ArrowLeft size={16} /> Quay lại Trang chủ
          </Link>
          
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-2xl bg-blue-600 text-white flex items-center justify-center shadow-lg shadow-blue-100 border border-blue-500/20 shrink-0">
                <FileText size={24} />
              </div>
              <div>
                <h1 className="text-3xl md:text-4xl font-extrabold tracking-tight text-slate-900 leading-tight">
                  Điều Khoản Dịch Vụ
                </h1>
                <p className="text-sm text-slate-500 font-medium mt-1">Cập nhật mới nhất: Ngày 31 tháng 05 năm 2026</p>
              </div>
            </div>
            
            <div className="hidden md:flex items-center gap-2.5 px-4 py-2.5 bg-blue-50/60 border border-blue-100/80 rounded-2xl text-blue-700 text-xs font-semibold">
              <HelpCircle size={14} className="text-blue-500" />
              <span>Hỗ trợ pháp lý: support@easyhouse.local</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Two-Column Layout (Extremely Harmonious & Professional) */}
      <div className="max-w-6xl mx-auto px-4 md:px-8 xl:px-12 mt-10">
        <div className="flex flex-col lg:flex-row gap-10">
          
          {/* Left Sidebar Navigation (Desktop only - floating table of contents) */}
          <aside className="hidden lg:block w-[280px] shrink-0 sticky top-8 self-start bg-white border border-slate-100/80 rounded-3xl p-5 shadow-sm space-y-4">
            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider px-2">Mục lục điều khoản</p>
            <nav className="flex flex-col gap-1">
              {sections.map((sec) => (
                <a
                  key={sec.id}
                  href={`#${sec.id}`}
                  className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:text-blue-600 hover:bg-blue-50/40 transition-all cursor-pointer group"
                >
                  <span className="text-slate-400 group-hover:text-blue-500 transition-colors shrink-0">
                    {sec.icon}
                  </span>
                  <span className="truncate">{sec.title.split(". ")[1]}</span>
                </a>
              ))}
            </nav>
            <div className="border-t border-slate-100 pt-4 px-2">
              <div className="bg-slate-50 rounded-xl p-3 text-center border border-slate-100">
                <p className="text-xs font-semibold text-slate-500">Bạn cần tư vấn thêm?</p>
                <a href="mailto:support@easyhouse.local" className="inline-block mt-2 text-xs font-bold text-blue-600 hover:underline">Liên hệ bộ phận pháp lý</a>
              </div>
            </div>
          </aside>

          {/* Right Main Content Card */}
          <div className="flex-1 bg-white rounded-3xl p-6 md:p-10 shadow-sm border border-slate-100/80 space-y-12">
            
            {/* Section 1 */}
            <section id="chap-thuan" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  1
                </div>
                <h2 className="text-xl font-bold text-slate-900">Chấp thuận điều khoản</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Chào mừng bạn đến với hệ sinh thái <strong>EasyHouse</strong>. Bằng việc đăng ký tài khoản, truy cập thông tin nhà trọ hoặc sử dụng bất kỳ phần mềm quản lý, tiện ích dịch vụ cư dân trực tuyến nào của chúng tôi, bạn chính thức xác nhận đã đọc, hiểu và tự nguyện cam kết tuân thủ đầy đủ các nội dung được thỏa thuận trong văn bản Điều khoản Dịch vụ này.
                </p>
                <p className="text-sm text-slate-600 leading-relaxed">
                  Nếu bạn đại diện cho một tổ chức cho thuê hoặc tập thể cư dân, việc sử dụng tài khoản đồng nghĩa với cam kết tổ chức đó cũng chấp thuận các quy chế ràng buộc liên đới này.
                </p>
              </div>
            </section>

            {/* Section 2 */}
            <section id="chu-tro" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  2
                </div>
                <h2 className="text-xl font-bold text-slate-900">Quyền và Trách nhiệm của Chủ trọ (Landlord)</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Chủ trọ khi đăng ký tòa nhà và tạo các phòng cho thuê trên EasyHouse cam kết thực hiện đúng các quy định minh bạch thông tin sau:
                </p>
                <div className="grid grid-cols-1 gap-3.5 text-sm text-slate-600">
                  <div className="flex gap-3 items-start bg-slate-50/50 p-3.5 rounded-2xl border border-slate-100">
                    <CheckCircle2 size={16} className="text-blue-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-800">Xác thực thông tin phòng trọ</p>
                      <p className="text-xs text-slate-500 mt-0.5">Mô tả đúng địa chỉ thực tế, đơn giá phòng, phí dịch vụ cố định (điện, nước, internet) và tình trạng nội thất có sẵn.</p>
                    </div>
                  </div>
                  <div className="flex gap-3 items-start bg-slate-50/50 p-3.5 rounded-2xl border border-slate-100">
                    <CheckCircle2 size={16} className="text-blue-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-800">Tôn trọng Hợp đồng trực tuyến</p>
                      <p className="text-xs text-slate-500 mt-0.5">Khởi tạo và thực hiện đúng thời hạn thuê, đặt cọc và chu kỳ đóng tiền đã thỏa thuận trong hợp đồng số.</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 3 */}
            <section id="khach-thue" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  3
                </div>
                <h2 className="text-xl font-bold text-slate-900">Quyền và Trách nhiệm của Khách thuê (Tenant)</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Khách thuê khi gia nhập hệ thống EasyHouse có trách nhiệm hợp tác minh bạch thông tin cư trú và tuân thủ các nghĩa vụ tài chính:
                </p>
                <div className="grid grid-cols-1 gap-3.5 text-sm text-slate-600">
                  <div className="flex gap-3 items-start bg-slate-50/50 p-3.5 rounded-2xl border border-slate-100">
                    <CheckCircle2 size={16} className="text-blue-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-800">Cung cấp thông tin xác thực định danh</p>
                      <p className="text-xs text-slate-500 mt-0.5">Cung cấp hình ảnh định danh (CCCD) trung thực để lập hồ sơ cư trú và làm căn cứ pháp lý của hợp đồng thuê.</p>
                    </div>
                  </div>
                  <div className="flex gap-3 items-start bg-slate-50/50 p-3.5 rounded-2xl border border-slate-100">
                    <CheckCircle2 size={16} className="text-blue-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-800">Nghĩa vụ đóng phí và bảo quản tài sản</p>
                      <p className="text-xs text-slate-500 mt-0.5">Thanh toán đầy đủ các hóa đơn dịch vụ đúng ngày thông báo và bồi thường hỏng hóc cơ sở vật chất do lỗi chủ quan.</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 4 */}
            <section id="thanh-toan" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  4
                </div>
                <h2 className="text-xl font-bold text-slate-900">Quy định về Hóa đơn và Thanh toán điện tử</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Hệ thống EasyHouse hỗ trợ chức năng tự động tạo hóa đơn chi tiết hàng tháng căn cứ trên chỉ số tiêu thụ điện nước thực tế do chủ trọ cập nhật và đơn giá hợp đồng.
                </p>
                <p className="text-sm text-slate-600 leading-relaxed font-semibold text-blue-600">
                  Khách thuê cam kết thực hiện chuyển khoản thanh toán qua QR Ngân hàng (định dạng VietQR) đúng cú pháp do hệ thống hiển thị để đảm bảo trạng thái hóa đơn được tự động gạch nợ thành công tức thì.
                </p>
              </div>
            </section>

            {/* Section 5 */}
            <section id="vi-pham" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  5
                </div>
                <h2 className="text-xl font-bold text-slate-900">Xử lý vi phạm và Khóa tài khoản</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <div className="p-5 bg-amber-50 border border-amber-100 rounded-3xl flex gap-3 text-amber-800 text-sm leading-relaxed">
                  <ShieldAlert size={22} className="shrink-0 text-amber-600 mt-0.5" />
                  <div>
                    <p className="font-extrabold text-amber-950 text-base">Lưu ý quan trọng bảo vệ người dùng:</p>
                    <p className="mt-1 text-slate-700">
                      Chúng tôi bảo lưu toàn quyền đình chỉ, khóa tài khoản hoặc hủy bỏ quyền truy cập hệ thống của bất kỳ cá nhân hay tổ chức nào bị phát hiện có hành vi đăng tin ảo/phòng không tồn tại, lừa đảo đặt cọc, giả mạo biên lai chuyển khoản hoặc liên tục chậm trễ nghĩa vụ thanh toán mà không có lý do chính đáng được chủ nhà chấp thuận.
                    </p>
                  </div>
                </div>
              </div>
            </section>

            {/* Footer sub-bar inside container */}
            <div className="border-t border-slate-100 pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-slate-400">
              <p>© 2026 EasyHouse. Mọi quyền được bảo lưu.</p>
              <div className="flex gap-6 font-semibold">
                <Link href="/chinh-sach-bao-mat" className="text-slate-500 hover:text-emerald-600 transition-colors">Chính sách bảo mật</Link>
                <Link href="/quy-che-hoat-dong" className="text-slate-500 hover:text-violet-600 transition-colors">Quy chế hoạt động</Link>
              </div>
            </div>

          </div>

        </div>
      </div>
    </div>
  );
}
