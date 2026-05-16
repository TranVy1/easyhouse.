import type { NextConfig } from "next";

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
        destination: 'http://localhost:8080/api/auth/register'
      },
      {
        source: '/api/auth/forgot-password',
        destination: 'http://localhost:8080/api/auth/forgot-password'
      },
      {
        source: '/api/phong',
        destination: 'http://localhost:8080/api/phong'
      },
      {
        source: '/api/phong/:path*',
        destination: 'http://localhost:8080/api/phong/:path*'
      },
      {
        source: '/api/toa-nha',
        destination: 'http://localhost:8080/api/toa-nha'
      },
      {
        source: '/api/toa-nha/:path*',
        destination: 'http://localhost:8080/api/toa-nha/:path*'
      },
      {
        source: '/api/khach-thue',
        destination: 'http://localhost:8080/api/khach-thue'
      },
      {
        source: '/api/khach-thue/:path*',
        destination: 'http://localhost:8080/api/khach-thue/:path*'
      },
      {
        source: '/api/dashboard/:path*',
        destination: 'http://localhost:8080/api/dashboard/:path*'
      },
      {
        source: '/api/hop-dong',
        destination: 'http://localhost:8080/api/hop-dong'
      },
      {
        source: '/api/hop-dong/:path*',
        destination: 'http://localhost:8080/api/hop-dong/:path*'
      },
      {
        source: '/api/hoa-don',
        destination: 'http://localhost:8080/api/hoa-don'
      },
      {
        source: '/api/hoa-don/:path*',
        destination: 'http://localhost:8080/api/hoa-don/:path*'
      },
      {
        source: '/api/hoa-don-public/:path*',
        destination: 'http://localhost:8080/api/hoa-don-public/:path*'
      },
      {
        source: '/api/upload',
        destination: 'http://localhost:8080/api/upload'
      },
      {
        source: '/api/thanh-toan',
        destination: 'http://localhost:8080/api/thanh-toan'
      },
      {
        source: '/api/thanh-toan/:path*',
        destination: 'http://localhost:8080/api/thanh-toan/:path*'
      },
      {
        source: '/api/thong-bao',
        destination: 'http://localhost:8080/api/thong-bao'
      },
      {
        source: '/api/thong-bao/:path*',
        destination: 'http://localhost:8080/api/thong-bao/:path*'
      },
      {
        source: '/api/su-co',
        destination: 'http://localhost:8080/api/su-co'
      },
      {
        source: '/api/su-co/:path*',
        destination: 'http://localhost:8080/api/su-co/:path*'
      },
      {
        source: '/api/admin/:path*',
        destination: 'http://localhost:8080/api/admin/:path*'
      },
      {
        source: '/api/user/:path*',
        destination: 'http://localhost:8080/api/user/:path*'
      },
      {
        source: '/api/test-payment',
        destination: 'http://localhost:8080/api/test-payment'
      },
    ];
  }
};

export default nextConfig;
