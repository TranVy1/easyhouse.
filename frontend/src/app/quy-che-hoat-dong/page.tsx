"use client";

import Link from "next/link";
import { ArrowLeft, BookOpen, CheckCircle2, Award, Info, FileEdit, Scale, ShieldAlert, HelpCircle } from "lucide-react";

export default function QuyCheHoatDongPage() {
  const sections = [
    { id: "nguyen-tac", title: "1. Nguyên tắc hoạt động chung", icon: <Info size={16} /> },
    { id: "dang-tin", title: "2. Quy trình đăng tin & Kiểm duyệt", icon: <FileEdit size={16} /> },
    { id: "hop-dong", title: "3. Ký kết hợp đồng & Thanh toán", icon: <BookOpen size={16} /> },
    { id: "khieu-nai", title: "4. Giải quyết khiếu nại tranh chấp", icon: <Scale size={16} /> },
    { id: "ban-quan-ly", title: "5. Quyền & Nghĩa vụ Ban Quản Lý", icon: <ShieldAlert size={16} /> },
  ];

  return (
    <div className="min-h-screen bg-[#F8FAFC] font-sans pb-20 selection:bg-violet-100 selection:text-violet-900 scroll-smooth">
      {/* Soothing Pastels & Soft Violet Gradient Header */}
      <div className="bg-gradient-to-b from-violet-50/60 via-fuchsia-50/30 to-[#F8FAFC] border-b border-slate-100 pt-16 pb-12 px-4 md:px-8 xl:px-12 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-96 h-96 bg-violet-300/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute top-12 left-1/3 w-72 h-72 bg-fuchsia-300/10 rounded-full blur-3xl pointer-events-none" />
        
        <div className="max-w-6xl mx-auto relative z-10">
          <Link 
            href="/" 
            className="inline-flex items-center gap-2 text-slate-600 hover:text-violet-600 hover:border-violet-200 bg-white hover:bg-violet-50/50 px-4 py-2 rounded-xl text-sm font-semibold transition-all mb-6 border border-slate-200/60 shadow-sm"
          >
            <ArrowLeft size={16} /> Quay lại Trang chủ
          </Link>
          
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-2xl bg-violet-600 text-white flex items-center justify-center shadow-lg shadow-violet-100 border border-violet-500/20 shrink-0">
                <BookOpen size={24} />
              </div>
              <div>
                <h1 className="text-3xl md:text-4xl font-extrabold tracking-tight text-slate-900 leading-tight">
                  Quy Chế Hoạt Động
                </h1>
                <p className="text-sm text-slate-500 font-medium mt-1">Cập nhật mới nhất: Ngày 31 tháng 05 năm 2026</p>
              </div>
            </div>
            
            <div className="hidden md:flex items-center gap-2.5 px-4 py-2.5 bg-violet-50/60 border border-violet-100/80 rounded-2xl text-violet-700 text-xs font-semibold">
              <HelpCircle size={14} className="text-violet-500" />
              <span>Hỗ trợ quy chế: support@easyhouse.local</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Two-Column Layout */}
      <div className="max-w-6xl mx-auto px-4 md:px-8 xl:px-12 mt-10">
        <div className="flex flex-col lg:flex-row gap-10">
          
          {/* Left Sidebar Navigation */}
          <aside className="hidden lg:block w-[280px] shrink-0 sticky top-8 self-start bg-white border border-slate-100/80 rounded-3xl p-5 shadow-sm space-y-4">
            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider px-2">Mục lục quy chế</p>
            <nav className="flex flex-col gap-1">
              {sections.map((sec) => (
                <a
                  key={sec.id}
                  href={`#${sec.id}`}
                  className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:text-violet-600 hover:bg-violet-50/40 transition-all cursor-pointer group"
                >
                  <span className="text-slate-400 group-hover:text-violet-500 transition-colors shrink-0">
                    {sec.icon}
                  </span>
                  <span className="truncate">{sec.title.split(". ")[1]}</span>
                </a>
              ))}
            </nav>
            <div className="border-t border-slate-100 pt-4 px-2">
              <div className="bg-slate-50 rounded-xl p-3 text-center border border-slate-100">
                <p className="text-xs font-semibold text-slate-500">Tìm hiểu quy chế nền tảng</p>
                <a href="mailto:support@easyhouse.local" className="inline-block mt-2 text-xs font-bold text-violet-600 hover:underline">Ban Kiểm Duyệt Quy Chế</a>
              </div>
            </div>
          </aside>

          {/* Right Main Content Card */}
          <div className="flex-1 bg-white rounded-3xl p-6 md:p-10 shadow-sm border border-slate-100/80 space-y-12">
            
            {/* Section 1 */}
            <section id="nguyen-tac" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-violet-50 text-violet-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  1
                </div>
                <h2 className="text-xl font-bold text-slate-900">Nguyên tắc hoạt động chung</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Hệ thống số hóa bất động sản cho thuê <strong>EasyHouse</strong> hoạt động dựa trên các nguyên tắc cơ bản: <strong>minh bạch thông tin, giao dịch công bằng và hỗ trợ tối đa cư dân</strong>. Nền tảng là cầu nối tin cậy giúp kết nối trực tiếp, gạt bỏ trung gian để chủ trọ vận hành trơn tru tòa nhà và người thuê nhanh chóng tìm được chỗ ở như ý.
                </p>
                <p className="text-sm text-slate-600 leading-relaxed">
                  Tất cả các thành viên tham gia hệ thống (gồm quản trị viên, chủ nhà trọ và khách thuê phòng) đều có nghĩa vụ hành xử lịch sự, tôn trọng các điều khoản dân sự và quy định pháp luật hiện hành.
                </p>
              </div>
            </section>

            {/* Section 2 */}
            <section id="dang-tin" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-violet-50 text-violet-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  2
                </div>
                <h2 className="text-xl font-bold text-slate-900">Quy trình đăng tin và Kiểm duyệt phòng trọ</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Để đảm bảo chất lượng hiển thị tối ưu và loại bỏ hoàn toàn các tin đăng ảo, chúng tôi áp dụng quy trình kiểm duyệt 2 lớp nghiêm ngặt:
                </p>
                <div className="grid grid-cols-1 gap-3.5 text-sm text-slate-600">
                  <div className="flex gap-3 items-start bg-slate-50/50 p-3.5 rounded-2xl border border-slate-100">
                    <CheckCircle2 size={16} className="text-violet-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-800">Quy trình khởi tạo thông tin phòng</p>
                      <p className="text-xs text-slate-500 mt-0.5">Chủ nhà điền đúng số phòng, diện tích thật, đơn giá thuê, đính kèm tối thiểu 4 ảnh thực tế các góc phòng (phòng ngủ, bếp, toilet, ban công).</p>
                    </div>
                  </div>
                  <div className="flex gap-3 items-start bg-slate-50/50 p-3.5 rounded-2xl border border-slate-100">
                    <CheckCircle2 size={16} className="text-violet-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-800">Kiểm duyệt chất lượng tin tức</p>
                      <p className="text-xs text-slate-500 mt-0.5">Hệ thống quét ảnh trùng lặp kết hợp quản trị viên kiểm tra thủ công. Tin đăng không đạt chất lượng sẽ bị từ chối phê duyệt hiển thị.</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 3 */}
            <section id="hop-dong" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-violet-50 text-violet-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  3
                </div>
                <h2 className="text-xl font-bold text-slate-900">Ký kết hợp đồng và Cơ chế thanh toán</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-slate-600 leading-relaxed">
                  EasyHouse cung cấp giải pháp lập **Hợp đồng điện tử trực tuyến** làm cơ sở thỏa thuận pháp lý cao nhất giữa bên thuê và cho thuê. Tất cả các chỉ số điện, nước, internet phát sinh hàng tháng đều phải được cập nhật dựa trên cơ sở ghi nhận chỉ số thực tế đầu kỳ và cuối kỳ.
                </p>
                <p className="text-sm text-slate-600 leading-relaxed font-semibold text-violet-600">
                  Các giao dịch nộp tiền nhà hàng tháng được xử lý quét mã QR VietQR trực tuyến. Trạng thái thanh toán của Khách thuê sẽ được hệ thống cập nhật tức thì (Đã trả, Trả một phần, Chưa trả) ngay sau khi tài khoản ngân hàng liên kết báo có số dư, loại bỏ rủi ro tranh chấp tài chính.
                </p>
              </div>
            </section>

            {/* Section 4 */}
            <section id="khieu-nai" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-violet-50 text-violet-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  4
                </div>
                <h2 className="text-xl font-bold text-slate-900">Giải quyết khiếu nại và Tranh chấp dân sự</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <div className="p-5 bg-violet-50 border border-violet-100 rounded-3xl flex gap-3 text-violet-800 text-sm leading-relaxed">
                  <Award size={22} className="shrink-0 text-violet-600 mt-0.5" />
                  <div>
                    <p className="font-extrabold text-violet-950 text-base">Cơ chế trọng tài trung gian:</p>
                    <p className="mt-1 text-slate-700">
                      Khi có sự cố hỏng hóc vật chất nghiêm trọng không được giải quyết thỏa đáng, hoặc thông tin bài đăng bị phản ánh lừa đảo đặt cọc ảo, cư dân có quyền gửi yêu cầu Báo cáo Sự cố. Ban quản trị EasyHouse đóng vai trò trung gian xác minh thực tế, yêu cầu các bên đối thoại trực tiếp trên tinh thần hợp đồng và áp dụng các chế tài phạt thích đáng đối với bên vi phạm.
                    </p>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 5 */}
            <section id="ban-quan-ly" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-violet-50 text-violet-600 font-extrabold flex items-center justify-center text-sm shrink-0">
                  5
                </div>
                <h2 className="text-xl font-bold text-slate-900">Quyền và Nghĩa vụ của Ban Quản Lý nền tảng</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-slate-600 leading-relaxed">
                  Ban quản lý có quyền gỡ bỏ không báo trước các tin đăng có hình ảnh phản cảm, vi phạm pháp luật thuần phong mỹ tục hoặc nội dung không trung thực. Chúng tôi chịu trách nhiệm nâng cấp bảo mật hệ thống máy chủ, sao lưu lịch sử hợp đồng và bảo vệ thông tin cá nhân của người dùng.
                </p>
                <p className="text-sm text-slate-600 leading-relaxed text-slate-500">
                  Chúng tôi không chịu trách nhiệm đối với các thỏa thuận bằng tiền mặt nằm ngoài phạm vi kiểm soát và hệ thống báo cáo hóa đơn chính thống của ứng dụng EasyHouse.
                </p>
              </div>
            </section>

            {/* Footer sub-bar inside container */}
            <div className="border-t border-slate-100 pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-slate-400">
              <p>© 2026 EasyHouse. Mọi quyền được bảo lưu.</p>
              <div className="flex gap-6 font-semibold">
                <Link href="/dieu-khoan-dich-vu" className="text-slate-500 hover:text-blue-600 transition-colors">Điều khoản dịch vụ</Link>
                <Link href="/chinh-sach-bao-mat" className="text-slate-500 hover:text-emerald-600 transition-colors">Chính sách bảo mật</Link>
              </div>
            </div>

          </div>

        </div>
      </div>
    </div>
  );
}
