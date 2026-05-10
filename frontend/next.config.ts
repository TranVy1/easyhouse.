import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  experimental: {
    optimizePackageImports: ['lucide-react'],
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
        source: '/api/upload',
        destination: 'http://localhost:8080/api/upload'
      },
    ];
  }
};

export default nextConfig;