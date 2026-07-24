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
    <div className="min-h-screen bg-[#F8F3EC] font-sans pb-20 selection:bg-[#4FA7A0]/20 selection:text-[#243B5A] scroll-smooth">
      {/* Soothing Pastels & Soft Violet Gradient Header */}
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
                <BookOpen size={24} />
              </div>
              <div>
                <h1 className="text-3xl md:text-4xl font-extrabold tracking-tight text-[#243B5A] leading-tight">
                  Quy Chế Hoạt Động
                </h1>
                <p className="text-sm text-[#6B7A8C] font-medium mt-1">Cập nhật mới nhất: Ngày 31 tháng 05 năm 2026</p>
              </div>
            </div>
            
            <div className="hidden md:flex items-center gap-2.5 px-4 py-2.5 bg-[#4FA7A0]/10 border border-[#4FA7A0]/20 rounded-2xl text-[#243B5A] text-xs font-semibold">
              <HelpCircle size={14} className="text-[#4FA7A0]" />
              <span>Hỗ trợ quy chế: support@easyhouse.local</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Two-Column Layout */}
      <div className="max-w-6xl mx-auto px-4 md:px-8 xl:px-12 mt-10">
        <div className="flex flex-col lg:flex-row gap-10">
          
          {/* Left Sidebar Navigation */}
          <aside className="hidden lg:block w-[280px] shrink-0 sticky top-8 self-start bg-[#FFFDF8] border border-[#E8DED2] rounded-3xl p-5 shadow-sm space-y-4">
            <p className="text-xs font-bold text-[#6B7A8C] uppercase tracking-wider px-2">Mục lục quy chế</p>
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
                <p className="text-xs font-semibold text-[#6B7A8C]">Tìm hiểu quy chế nền tảng</p>
                <a href="mailto:support@easyhouse.local" className="inline-block mt-2 text-xs font-bold text-[#243B5A] hover:underline">Ban Kiểm Duyệt Quy Chế</a>
              </div>
            </div>
          </aside>

          {/* Right Main Content Card */}
          <div className="flex-1 bg-[#FFFDF8] rounded-3xl p-6 md:p-10 shadow-sm border border-[#E8DED2] space-y-12">
            
            {/* Section 1 */}
            <section id="nguyen-tac" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  1
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Nguyên tắc hoạt động chung</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Hệ thống số hóa bất động sản cho thuê <strong>EasyHouse</strong> hoạt động dựa trên các nguyên tắc cơ bản: <strong>minh bạch thông tin, giao dịch công bằng và hỗ trợ tối đa cư dân</strong>. Nền tảng là cầu nối tin cậy giúp kết nối trực tiếp, gạt bỏ trung gian để chủ trọ vận hành trơn tru tòa nhà và người thuê nhanh chóng tìm được chỗ ở như ý.
                </p>
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Tất cả các thành viên tham gia hệ thống (gồm quản trị viên, chủ nhà trọ và khách thuê phòng) đều có nghĩa vụ hành xử lịch sự, tôn trọng các điều khoản dân sự và quy định pháp luật hiện hành.
                </p>
              </div>
            </section>

            {/* Section 2 */}
            <section id="dang-tin" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  2
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Quy trình đăng tin và Kiểm duyệt phòng trọ</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Để đảm bảo chất lượng hiển thị tối ưu và loại bỏ hoàn toàn các tin đăng ảo, chúng tôi áp dụng quy trình kiểm duyệt 2 lớp nghiêm ngặt:
                </p>
                <div className="grid grid-cols-1 gap-3.5 text-sm text-[#6B7A8C]">
                  <div className="flex gap-3 items-start bg-[#F8F3EC]/70 p-3.5 rounded-2xl border border-[#E8DED2]">
                    <CheckCircle2 size={16} className="text-[#4FA7A0] shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-[#243B5A]">Quy trình khởi tạo thông tin phòng</p>
                      <p className="text-xs text-[#6B7A8C] mt-0.5">Chủ nhà điền đúng số phòng, diện tích thật, đơn giá thuê, đính kèm tối thiểu 4 ảnh thực tế các góc phòng (phòng ngủ, bếp, toilet, ban công).</p>
                    </div>
                  </div>
                  <div className="flex gap-3 items-start bg-[#F8F3EC]/70 p-3.5 rounded-2xl border border-[#E8DED2]">
                    <CheckCircle2 size={16} className="text-[#4FA7A0] shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-[#243B5A]">Kiểm duyệt chất lượng tin tức</p>
                      <p className="text-xs text-[#6B7A8C] mt-0.5">Hệ thống quét ảnh trùng lặp kết hợp quản trị viên kiểm tra thủ công. Tin đăng không đạt chất lượng sẽ bị từ chối phê duyệt hiển thị.</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 3 */}
            <section id="hop-dong" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  3
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Ký kết hợp đồng và Cơ chế thanh toán</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  EasyHouse cung cấp giải pháp lập **Hợp đồng điện tử trực tuyến** làm cơ sở thỏa thuận pháp lý cao nhất giữa bên thuê và cho thuê. Tất cả các chỉ số điện, nước, internet phát sinh hàng tháng đều phải được cập nhật dựa trên cơ sở ghi nhận chỉ số thực tế đầu kỳ và cuối kỳ.
                </p>
                <p className="text-sm text-[#6B7A8C] leading-relaxed font-semibold text-[#243B5A]">
                  Các giao dịch nộp tiền nhà hàng tháng được xử lý quét mã QR VietQR trực tuyến. Trạng thái thanh toán của Khách thuê sẽ được hệ thống cập nhật tức thì (Đã trả, Trả một phần, Chưa trả) ngay sau khi tài khoản ngân hàng liên kết báo có số dư, loại bỏ rủi ro tranh chấp tài chính.
                </p>
              </div>
            </section>

            {/* Section 4 */}
            <section id="khieu-nai" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  4
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Giải quyết khiếu nại và Tranh chấp dân sự</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-4">
                <div className="p-5 bg-[#4FA7A0]/10 border border-[#4FA7A0]/20 rounded-3xl flex gap-3 text-[#243B5A] text-sm leading-relaxed">
                  <Award size={22} className="shrink-0 text-[#243B5A] mt-0.5" />
                  <div>
                    <p className="font-extrabold text-[#243B5A] text-base">Cơ chế trọng tài trung gian:</p>
                    <p className="mt-1 text-[#243B5A]">
                      Khi có sự cố hỏng hóc vật chất nghiêm trọng không được giải quyết thỏa đáng, hoặc thông tin bài đăng bị phản ánh lừa đảo đặt cọc ảo, cư dân có quyền gửi yêu cầu Báo cáo Sự cố. Ban quản trị EasyHouse đóng vai trò trung gian xác minh thực tế, yêu cầu các bên đối thoại trực tiếp trên tinh thần hợp đồng và áp dụng các chế tài phạt thích đáng đối với bên vi phạm.
                    </p>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 5 */}
            <section id="ban-quan-ly" className="space-y-4 scroll-mt-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-[#4FA7A0]/10 text-[#243B5A] font-extrabold flex items-center justify-center text-sm shrink-0">
                  5
                </div>
                <h2 className="text-xl font-bold text-[#243B5A]">Quyền và Nghĩa vụ của Ban Quản Lý nền tảng</h2>
              </div>
              <div className="pl-0 md:pl-11 space-y-3">
                <p className="text-sm text-[#6B7A8C] leading-relaxed">
                  Ban quản lý có quyền gỡ bỏ không báo trước các tin đăng có hình ảnh phản cảm, vi phạm pháp luật thuần phong mỹ tục hoặc nội dung không trung thực. Chúng tôi chịu trách nhiệm nâng cấp bảo mật hệ thống máy chủ, sao lưu lịch sử hợp đồng và bảo vệ thông tin cá nhân của người dùng.
                </p>
                <p className="text-sm text-[#6B7A8C] leading-relaxed text-[#6B7A8C]">
                  Chúng tôi không chịu trách nhiệm đối với các thỏa thuận bằng tiền mặt nằm ngoài phạm vi kiểm soát và hệ thống báo cáo hóa đơn chính thống của ứng dụng EasyHouse.
                </p>
              </div>
            </section>

            {/* Footer sub-bar inside container */}
            <div className="border-t border-[#E8DED2] pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-[#6B7A8C]">
              <p>© 2026 EasyHouse. Mọi quyền được bảo lưu.</p>
              <div className="flex gap-6 font-semibold">
                <Link href="/dieu-khoan-dich-vu" className="text-[#6B7A8C] hover:text-[#243B5A] transition-colors">Điều khoản dịch vụ</Link>
                <Link href="/chinh-sach-bao-mat" className="text-[#6B7A8C] hover:text-[#4FA7A0] transition-colors">Chính sách bảo mật</Link>
              </div>
            </div>

          </div>

        </div>
      </div>
    </div>
  );
}
