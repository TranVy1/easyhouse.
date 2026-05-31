"use client";

import Link from "next/link";
import { ArrowLeft, Shield, CheckCircle2, Lock, Eye, Users, FileSignature, HelpCircle } from "lucide-react";

export default function ChinhSachBaoMatPage() {
  const sections = [
    { id: "thu-thap", title: "1. Thông tin cá nhân thu thập", icon: <Eye size={16} /> },
    { id: "muc-dich", title: "2. Mục đích sử dụng thông tin", icon: <FileSignature size={16} /> },
    { id: "chia-se", title: "3. Chia sẻ thông tin bên thứ ba", icon: <Users size={16} /> },
    { id: "ky-thuat", title: "4. Bảo mật kỹ thuật an toàn", icon: <Lock size={16} /> },
    { id: "kiem-soat", title: "5. Quyền kiểm soát dữ liệu cá nhân", icon: <Shield size={16} /> },
  ];

  return (
    <div className="min-h-screen bg-[#F8FAFC] font-sans pb-20 selection:bg-emerald-100 selection:text-emerald-900 scroll-smooth">
      {/* Soothing Pastels & Soft Emerald Gradient Header */}
      <div className="bg-gradient-to-b from-emerald-50/60 via-teal-50/30 to-[#F8FAFC] border-b border-slate-100 pt-16 pb-12 px-4 md:px-8 xl:px-12 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-96 h-96 bg-emerald-300/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute top-12 left-1/3 w-72 h-72 bg-teal-300/10 rounded-full blur-3xl pointer-events-none" />
        
        <div className="max-w-6xl mx-auto relative z-10">
          <Link 
            href="/" 
            className="inline-flex items-center gap-2 text-slate-600 hover:text-emerald-600 hover:border-emerald-200 bg-white hover:bg-emerald-50/50 px-4 py-2 rounded-xl text-sm font-semibold transition-all mb-6 border border-slate-200/60 shadow-sm"
          >
            <ArrowLeft size={16} /> Quay lại Trang chủ
          </Link>
          
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-2xl bg-emerald-600 text-white flex items-center justify-center shadow-lg shadow-emerald-100 border border-emerald-500/20 shrink-0">
                <Shield size={24} />
              </div>
              <div>
                <h1 className="text-3xl md:text-4xl font-extrabold tracking-tight text-slate-900 leading-tight">
                  Chính Sách Bảo Mật
                </h1>
                <p className="text-sm text-slate-500 font-medium mt-1">Cập nhật mới nhất: Ngày 31 tháng 05 năm 2026</p>
              </div>
            </div>
            
            <div className="hidden md:flex items-center gap-2.5 px-4 py-2.5 bg-emerald-50/60 border border-emerald-100/80 rounded-2xl text-emerald-700 text-xs font-semibold">
              <HelpCircle size={14} className="text-emerald-500" />
              <span>Hỗ trợ bảo mật: support@easyhouse.local</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Two-Column Layout */}
      <div className="max-w-6xl mx-auto px-4 md:px-8 xl:px-12 mt-10">
        <div className="flex flex-col lg:flex-row gap-10">
          
          {/* Left Sidebar Navigation */}
          <aside className="hidden lg:block w-[280px] shrink-0 sticky top-8 self-start bg-white border border-slate-100/80 rounded-3xl p-5 shadow-sm space-y-4">
            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider px-2">Mục lục chính sách</p>
            <nav className="flex flex-col gap-1">
              {sections.map((sec) => (
                <a
                  key={sec.id}
                  href={`#${sec.id}`}
                  className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:text-emerald-600 hover:bg-emerald-50/40 transition-all cursor-pointer group"
                >
                  <span className="text-slate-400 group-hover:text-emerald-500 transition-colors shrink-0">
                    {sec.icon}
                  </span>
                  <span className="truncate">{sec.title.split(". ")[1]}</span>
                </a>
              ))}
            </nav>
            <div className="border-t border-slate-100 pt-4 px-2">
              <div className="bg-slate-50 rounded-xl p-3 text-center border border-slate-100">
                <p className="text-xs font-semibold text-slate-500">An toàn dữ liệu của bạn</p>
                <a href="mailto:support@easyhouse.local" className="inline-block mt-2 text-xs font-bold text-emerald-600 hover:underline">Bộ phận Bảo mật Dữ liệu</a>
              </div>
            </div>
          </aside>

          {/* Right Main Content Card */}
          <div className="flex-1 bg-white rounded-3xl p-6 md:p-10 shadow-sm border border-slate-100/80 space-y-12">
            
            {/* Section 1 */}
            <section id="thu-thap" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  1
                </div>
                <h2 className="text-xl font-bold text-slate-900">Thông tin cá nhân thu thập</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Nhằm cung cấp các dịch vụ tìm kiếm và quản lý bất động sản cho thuê chuyên nghiệp, <strong>EasyHouse</strong> thu thập một số thông tin cá nhân cơ bản từ người dùng khi khởi tạo tài khoản hoặc điền hồ sơ thành viên bao gồm: họ tên, địa chỉ email, số điện thoại, ảnh hồ sơ (avatar).
                </p>
                <p className="text-sm text-slate-600 leading-relaxed">
                  Đối với quy trình tạo lập hợp đồng thuê nhà trực tuyến, hệ thống sẽ yêu cầu người dùng cung cấp thông tin Căn cước công dân (CCCD) và ảnh chụp đính kèm. Dữ liệu này chỉ được lưu trữ nhằm làm căn cứ xác thực pháp lý đối với hợp đồng giữa Chủ nhà và Khách thuê, tuyệt đối không được sử dụng cho bất kỳ mục đích nào khác.
                </p>
              </div>
            </section>

            {/* Section 2 */}
            <section id="muc-dich" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  2
                </div>
                <h2 className="text-xl font-bold text-slate-900">Mục đích sử dụng thông tin</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Mọi thông tin cá nhân thu thập trên EasyHouse được sử dụng cho các mục đích thiết thực nhằm bảo vệ và nâng cao trải nghiệm người dùng:
                </p>
                <div className="grid grid-cols-1 gap-3.5 text-sm text-slate-600">
                  <div className="flex gap-3 items-start bg-slate-50/50 p-3.5 rounded-2xl border border-slate-100">
                    <CheckCircle2 size={16} className="text-emerald-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-800">Duy trì tài khoản và dịch vụ cư dân trực tuyến</p>
                      <p className="text-xs text-slate-500 mt-0.5">Quản lý cơ sở vật chất tòa nhà, chốt số điện nước, gửi thông báo hóa đơn nợ tự động và xử lý báo cáo sự cố hư hại.</p>
                    </div>
                  </div>
                  <div className="flex gap-3 items-start bg-slate-50/50 p-3.5 rounded-2xl border border-slate-100">
                    <CheckCircle2 size={16} className="text-emerald-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-800">Kết nối liên lạc an toàn</p>
                      <p className="text-xs text-slate-500 mt-0.5">Cho phép trao đổi trực tiếp giữa bên cho thuê và bên thuê phòng, gửi thông báo gạch nợ hóa đơn tự động tức thì.</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 3 */}
            <section id="chia-se" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  3
                </div>
                <h2 className="text-xl font-bold text-slate-900">Chia sẻ thông tin và Bên thứ ba</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Chúng tôi <strong>không bao giờ mua bán, cho thuê hoặc chia sẻ</strong> bất kỳ thông tin định danh cá nhân nào của người dùng cho bên thứ ba vì các mục đích thương mại hay quảng cáo không được sự đồng ý trước của bạn.
                </p>
                <p className="text-sm text-slate-600 leading-relaxed">
                  Thông tin chỉ được chia sẻ trong trường hợp cần thực hiện các giao dịch thanh toán QR Ngân hàng (đối soát tự động của ngân hàng liên kết) hoặc khi nhận được văn bản yêu cầu chính thức từ cơ quan hành pháp có thẩm quyền theo quy định của pháp luật Việt Nam.
                </p>
              </div>
            </section>

            {/* Section 4 */}
            <section id="ky-thuat" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  4
                </div>
                <h2 className="text-xl font-bold text-slate-900">Bảo mật kỹ thuật an toàn</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <div className="p-5 bg-emerald-50 border border-emerald-100 rounded-3xl flex gap-3 text-emerald-800 text-sm leading-relaxed">
                  <Lock size={22} className="shrink-0 text-emerald-600 mt-0.5" />
                  <div>
                    <p className="font-extrabold text-emerald-950 text-base">Cam kết bảo vệ dữ liệu SSL/TLS:</p>
                    <p className="mt-1 text-slate-700">
                      Mọi luồng truyền tải thông tin nhạy cảm trên hệ thống (bao gồm thông tin cá nhân, hợp đồng và hóa đơn điện nước) đều được mã hóa bằng giao thức SSL/TLS chuẩn hóa. Toàn bộ thông tin ảnh CCCD của người dùng đều được mã hóa lưu trữ giới hạn quyền hạn nghiêm ngặt, đề phòng tối đa nguy cơ truy cập trái phép.
                    </p>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 5 */}
            <section id="kiem-soat" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  5
                </div>
                <h2 className="text-xl font-bold text-slate-900">Quyền kiểm soát dữ liệu cá nhân</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Người dùng có toàn quyền truy cập để cập nhật hoặc sửa đổi thông tin hồ sơ cá nhân của mình bất kỳ lúc nào trong mục Hồ sơ. 
                </p>
                <p className="text-sm text-slate-600 leading-relaxed">
                  Nếu bạn có mong muốn hủy tài khoản hoặc yêu cầu hệ thống EasyHouse xóa bỏ vĩnh viễn toàn bộ dữ liệu lịch sử liên quan, vui lòng gửi yêu cầu hỗ trợ trực tiếp về email <strong>support@easyhouse.local</strong> để ban quản trị tiến hành phê duyệt và loại bỏ dữ liệu an toàn trong vòng 24h làm việc.
                </p>
              </div>
            </section>

            {/* Footer sub-bar inside container */}
            <div className="border-t border-slate-100 pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-slate-400">
              <p>© 2026 EasyHouse. Mọi quyền được bảo lưu.</p>
              <div className="flex gap-6 font-semibold">
                <Link href="/dieu-khoan-dich-vu" className="text-slate-500 hover:text-blue-600 transition-colors">Điều khoản dịch vụ</Link>
                <Link href="/quy-che-hoat-dong" className="text-slate-500 hover:text-violet-600 transition-colors">Quy chế hoạt động</Link>
              </div>
            </div>

          </div>

        </div>
      </div>
    </div>
  );
}
