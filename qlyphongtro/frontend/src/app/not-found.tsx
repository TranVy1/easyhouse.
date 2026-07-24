import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Home, LogIn, AlertCircle } from "lucide-react";

export default function NotFound() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-[#F8F3EC] via-[#FFFDF8] to-[#E6F3F1] flex items-center justify-center px-4">
      <div className="text-center max-w-md mx-auto">
        {/* 404 Icon */}
        <div className="mb-8">
          <div className="flex justify-center mb-4">
            <AlertCircle className="h-16 w-16 text-[#4FA7A0]" />
          </div>
          <h1 className="text-6xl font-bold text-[#243B5A] mb-2">404</h1>
          <h2 className="text-2xl font-semibold text-[#243B5A] mb-4">
            Trang không tìm thấy
          </h2>
        </div>

        {/* Description */}
        <div className="bg-[#FFFDF8] rounded-lg border border-[#E8DED2] shadow-lg shadow-[#243B5A]/10 p-6 mb-8">
          <p className="text-[#6B7A8C] mb-6">
            Xin lỗi, trang bạn đang tìm kiếm không tồn tại hoặc đã được di chuyển.
          </p>
          
          {/* Action Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link href="/">
              <Button size="lg" className="w-full sm:w-auto px-6 py-3">
                <Home className="h-4 w-4 mr-2" />
                Về trang chủ
              </Button>
            </Link>
            
            <Link href="/dang-nhap">
              <Button size="lg" variant="outline" className="w-full sm:w-auto px-6 py-3">
                <LogIn className="h-4 w-4 mr-2" />
                Đăng nhập
              </Button>
            </Link>
          </div>
        </div>

        {/* Additional Info */}
        <div className="text-sm text-[#6B7A8C] space-y-2">
          <p>Nếu bạn cho rằng đây là lỗi, vui lòng liên hệ quản trị viên.</p>
          <p>Mã lỗi: 404 - Không tìm thấy trang</p>
        </div>
      </div>
    </div>
  );
}
