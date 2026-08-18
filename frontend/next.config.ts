import type { NextConfig } from "next";

const backendUrl = process.env.BACKEND_URL || "http://localhost:8080";

const nextConfig: NextConfig = {
  typescript: {
    ignoreBuildErrors: true,
  },
  /* config options here */
  allowedDevOrigins: ['easyhouse.site', 'www.easyhouse.site', 'localhost'],
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
  images: {
    // Cloudinary serves the optimized image directly. Next's production
    // image proxy rejects valid Cloudinary URLs in this deployment.
    unoptimized: true,
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'res.cloudinary.com',
      },
      {
        protocol: 'http',
        hostname: 'res.cloudinary.com',
      },
      {
        protocol: 'https',
        hostname: 'img.vietqr.io',
      },
    ],
  },
  // Bỏ qua eslint và typescript check khi build đã bị tắt
  async rewrites() {
    return [
      {
        source: '/api/public/:path*',
        destination: `${backendUrl}/api/public/:path*`
      },
      {
        source: '/api/phong',
        destination: `${backendUrl}/api/phong`
      },
      {
        source: '/api/phong/:path*',
        destination: `${backendUrl}/api/phong/:path*`
      },
      {
        source: '/api/tai-san-phong',
        destination: `${backendUrl}/api/tai-san-phong`
      },
      {
        source: '/api/tai-san-phong/:path*',
        destination: `${backendUrl}/api/tai-san-phong/:path*`
      },
      {
        source: '/api/kho-tai-san',
        destination: `${backendUrl}/api/kho-tai-san`
      },
      {
        source: '/api/kho-tai-san/:path*',
        destination: `${backendUrl}/api/kho-tai-san/:path*`
      },
      {
        source: '/api/phuong-tien',
        destination: `${backendUrl}/api/phuong-tien`
      },
      {
        source: '/api/phuong-tien/:path*',
        destination: `${backendUrl}/api/phuong-tien/:path*`
      },
      {
        source: '/api/toa-nha',
        destination: `${backendUrl}/api/toa-nha`
      },
      {
        source: '/api/toa-nha/:path*',
        destination: `${backendUrl}/api/toa-nha/:path*`
      },
      {
        source: '/api/import/:path*',
        destination: `${backendUrl}/api/import/:path*`
      },
      {
        source: '/api/khach-thue',
        destination: `${backendUrl}/api/khach-thue`
      },
      {
        source: '/api/backend-auth/:path*',
        destination: `${backendUrl}/api/auth/:path*`
      },
      {
        source: '/api/khach-thue/:path*',
        destination: `${backendUrl}/api/khach-thue/:path*`
      },
      {
        source: '/api/dashboard/:path*',
        destination: `${backendUrl}/api/dashboard/:path*`
      },
      {
        source: '/api/hop-dong',
        destination: `${backendUrl}/api/hop-dong`
      },
      {
        source: '/api/hop-dong/:path*',
        destination: `${backendUrl}/api/hop-dong/:path*`
      },
      {
        // Hang doi duyet yeu cau huy / gia han hop dong.
        source: '/api/yeu-cau-hop-dong',
        destination: `${backendUrl}/api/yeu-cau-hop-dong`
      },
      {
        source: '/api/yeu-cau-hop-dong/:path*',
        destination: `${backendUrl}/api/yeu-cau-hop-dong/:path*`
      },
      {
        source: '/api/dich-vu',
        destination: `${backendUrl}/api/dich-vu`
      },
      {
        source: '/api/dich-vu/:path*',
        destination: `${backendUrl}/api/dich-vu/:path*`
      },
      {
        source: '/api/hoa-don',
        destination: `${backendUrl}/api/hoa-don`
      },
      {
        source: '/api/hoa-don/:path*',
        destination: `${backendUrl}/api/hoa-don/:path*`
      },
      {
        source: '/api/hoa-don-public/:path*',
        destination: `${backendUrl}/api/hoa-don-public/:path*`
      },
      {
        source: '/api/cong-no',
        destination: `${backendUrl}/api/cong-no`
      },
      {
        source: '/api/cong-no/:path*',
        destination: `${backendUrl}/api/cong-no/:path*`
      },
      {
        source: '/api/debt-reminders/:path*',
        destination: `${backendUrl}/api/debt-reminders/:path*`
      },
      {
        source: '/api/dat-coc',
        destination: `${backendUrl}/api/dat-coc`
      },
      {
        source: '/api/dat-coc/:path*',
        destination: `${backendUrl}/api/dat-coc/:path*`
      },
      {
        source: '/api/upload',
        destination: `${backendUrl}/api/upload`
      },
      {
        source: '/api/thanh-toan',
        destination: `${backendUrl}/api/thanh-toan`
      },
      {
        source: '/api/thanh-toan/:path*',
        destination: `${backendUrl}/api/thanh-toan/:path*`
      },
      {
        source: '/api/thong-bao',
        destination: `${backendUrl}/api/thong-bao`
      },
      {
        source: '/api/thong-bao/:path*',
        destination: `${backendUrl}/api/thong-bao/:path*`
      },
      // Module tin nhắn. Đặt ở /api/tin-nhan chứ KHÔNG phải /api/chat: đã có
      // route handler /api/chat cho chatbot Gemini, mà rewrites() trả về mảng
      // phẳng nên chạy SAU filesystem route — trùng tên sẽ khiến định tuyến khó đoán.
      //
      // Chỉ REST đi qua đây. WebSocket nối THẲNG tới backend qua NEXT_PUBLIC_WS_URL
      // vì rewrite của Next không nâng cấp được kết nối WebSocket.
      // Thông báo đẩy (P5). Tách khỏi /api/tin-nhan vì là hạ tầng chung —
      // sau này hoá đơn, sự cố, lịch hẹn cũng dùng chung đường này.
      {
        source: '/api/thong-bao-day/:path*',
        destination: `${backendUrl}/api/thong-bao-day/:path*`
      },
      {
        source: '/api/tin-nhan',
        destination: `${backendUrl}/api/tin-nhan`
      },
      {
        source: '/api/tin-nhan/:path*',
        destination: `${backendUrl}/api/tin-nhan/:path*`
      },
      {
        source: '/api/su-co',
        destination: `${backendUrl}/api/su-co`
      },
      {
        source: '/api/su-co/:path*',
        destination: `${backendUrl}/api/su-co/:path*`
      },
      {
        source: '/api/cau-hinh-gia',
        destination: `${backendUrl}/api/cau-hinh-gia`
      },
      {
        source: '/api/cau-hinh-gia/:path*',
        destination: `${backendUrl}/api/cau-hinh-gia/:path*`
      },
      {
        source: '/api/cau-hinh-phi-xe',
        destination: `${backendUrl}/api/cau-hinh-phi-xe`
      },
      {
        source: '/api/cau-hinh-phi-xe/:path*',
        destination: `${backendUrl}/api/cau-hinh-phi-xe/:path*`
      },
      {
        source: '/api/chi-so-dien-nuoc',
        destination: `${backendUrl}/api/chi-so-dien-nuoc`
      },
      {
        source: '/api/chi-so-dien-nuoc/:path*',
        destination: `${backendUrl}/api/chi-so-dien-nuoc/:path*`
      },
      {
        source: '/api/tenant',
        destination: `${backendUrl}/api/tenant`
      },
      {
        source: '/api/tenant/:path*',
        destination: `${backendUrl}/api/tenant/:path*`
      },
      {
        source: '/api/admin/:path*',
        destination: `${backendUrl}/api/admin/:path*`
      },
      {
        source: '/api/user/:path*',
        destination: `${backendUrl}/api/user/:path*`
      },
      {
        source: '/api/tien-ich',
        destination: `${backendUrl}/api/tien-ich`
      },
      {
        source: '/api/tien-ich/:path*',
        destination: `${backendUrl}/api/tien-ich/:path*`
      },
      {
        source: '/api/lich-hen',
        destination: `${backendUrl}/api/lich-hen`
      },
      {
        source: '/api/lich-hen/:path*',
        destination: `${backendUrl}/api/lich-hen/:path*`
      },
      {
        source: '/api/media',
        destination: `${backendUrl}/api/media`
      },
      {
        source: '/api/media/:path*',
        destination: `${backendUrl}/api/media/:path*`
      },
      {
        source: '/api/meter-alerts',
        destination: `${backendUrl}/api/meter-alerts`
      },
      {
        source: '/api/meter-alerts/:path*',
        destination: `${backendUrl}/api/meter-alerts/:path*`
      },
      {
        source: '/api/bao-cao/:path*',
        destination: `${backendUrl}/api/bao-cao/:path*`
      },
      {
        source: '/api/audit-log/:path*',
        destination: `${backendUrl}/api/audit-log/:path*`
      },
      {
        source: '/api/audit-log',
        destination: `${backendUrl}/api/audit-log`
      },
      {
        source: '/api/bank-transaction/:path*',
        destination: `${backendUrl}/api/bank-transaction/:path*`
      },
      {
        source: '/api/bank-transaction',
        destination: `${backendUrl}/api/bank-transaction`
      },
      {
        source: '/api/vnpay/:path*',
        destination: `${backendUrl}/api/vnpay/:path*`
      },
      {
        source: '/api/vnpay',
        destination: `${backendUrl}/api/vnpay`
      },
    ];
  }
};

export default nextConfig;
