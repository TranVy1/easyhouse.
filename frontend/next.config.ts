import type { NextConfig } from "next";

const backendUrl = process.env.BACKEND_URL || "http://localhost:8080";

const nextConfig: NextConfig = {
  /* config options here */
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
  images: {
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
  // Thêm 2 dòng này để tắt ESLint và TypeScript errors khi build
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
    async rewrites() {
    return [
      {
        source: '/api/auth/register',
        destination: `${backendUrl}/api/auth/register`
      },
      {
        source: '/api/auth/forgot-password',
        destination: `${backendUrl}/api/auth/forgot-password`
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
        source: '/api/toa-nha',
        destination: `${backendUrl}/api/toa-nha`
      },
      {
        source: '/api/toa-nha/:path*',
        destination: `${backendUrl}/api/toa-nha/:path*`
      },
      {
        source: '/api/khach-thue',
        destination: `${backendUrl}/api/khach-thue`
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
      {
        source: '/api/su-co',
        destination: `${backendUrl}/api/su-co`
      },
      {
        source: '/api/su-co/:path*',
        destination: `${backendUrl}/api/su-co/:path*`
      },
      {
        source: '/api/admin/:path*',
        destination: `${backendUrl}/api/admin/:path*`
      },
      {
        source: '/api/user/:path*',
        destination: `${backendUrl}/api/user/:path*`
      },
    ];
  }
};

export default nextConfig;
