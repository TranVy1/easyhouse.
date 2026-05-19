import CredentialsProvider from 'next-auth/providers/credentials';
import { NextAuthOptions } from 'next-auth';

export const authOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      name: 'credentials',
      credentials: {
        email: { label: 'Email', type: 'email' },
        matKhau: { label: 'Mật khẩu', type: 'password' }
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.matKhau) {
          return null;
        }

        try {
          const backendUrl = process.env.BACKEND_URL || 'http://localhost:8080';
          // Gọi API Login của Spring Boot Backend
          const res = await fetch(`${backendUrl}/api/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              email: credentials.email.toLowerCase(),
              matKhau: credentials.matKhau
            })
          });

          // Giả sử API trả về { success: true, data: { id, hoTen, email, vaiTro, token, ... } }
          // Nếu Backend chưa có API này, NextAuth sẽ báo lỗi đăng nhập.
          if (res.ok) {
            const result = await res.json();
            if (result.success && result.data) {
              const user = result.data;
              return {
                id: user.id || user._id || '1',
                email: user.email,
                name: user.ten || user.hoTen || user.name || 'User',
                role: user.vaiTro || user.role || 'ADMIN',
                phone: user.soDienThoai || user.phone || '',
                avatar: user.anhDaiDien || user.avatar || '',
                accessToken: user.token
              };
            }
          }
          
          return null;
        } catch (error) {
          console.error('Auth error:', error);
          return null;
        }
      }
    })
  ],
  session: {
    strategy: 'jwt',
    maxAge: 30 * 24 * 60 * 60, // 30 ngày
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role;
        token.phone = user.phone;
        token.avatar = user.avatar;
        token.accessToken = user.accessToken;
      }
      return token;
    },
    async session({ session, token }) {
      if (token) {
        session.user.id = token.sub!;
        session.user.role = token.role as string;
        session.user.phone = token.phone as string;
        session.user.avatar = token.avatar as string;
        session.accessToken = token.accessToken;
      }
      return session;
    }
  },
  pages: {
    signIn: '/dang-nhap',
    error: '/dang-nhap',
  },
  secret: process.env.NEXTAUTH_SECRET || 'secret-key-qlyphongtro',
};

// Không export handler ở đây nữa, sẽ tạo route riêng trong app/api/auth/[...nextauth]/route.ts
