import CredentialsProvider from 'next-auth/providers/credentials';
import { NextAuthOptions } from 'next-auth';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8080';

export const authTenantOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      id: 'tenant-credentials',
      name: 'tenant-credentials',
      credentials: {
        soDienThoai: { label: 'Số điện thoại', type: 'text' },
        matKhau: { label: 'Mật khẩu', type: 'password' }
      },
      async authorize(credentials) {
        if (!credentials?.soDienThoai || !credentials?.matKhau) {
          return null;
        }

        try {
          const res = await fetch(`${BACKEND_URL}/api/auth/khach-thue/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              soDienThoai: credentials.soDienThoai,
              matKhau: credentials.matKhau
            })
          });

          let result;
          try {
            result = await res.json();
          } catch {
            throw new Error('Không thể kết nối đến máy chủ');
          }

          if (res.ok && result.success && result.data) {
            const { token, refreshToken, khachThue } = result.data;
            return {
              id: khachThue._id || khachThue.id || 'tenant',
              email: khachThue.email || '',
              name: khachThue.hoTen || 'Khách thuê',
              role: 'TENANT',
              phone: khachThue.soDienThoai || '',
              avatar: khachThue.anhDaiDien || '',
              accessToken: token,
              refreshToken: refreshToken || '',
              emailVerified: true,
              accessTokenExpires: Date.now() + 10 * 60 * 60 * 1000,
              requirePasswordChange: result.data.requirePasswordChange || false,
            };
          }

          throw new Error(result.message || 'Đăng nhập thất bại');
        } catch (error: any) {
          console.error('Tenant Auth error:', error);
          throw new Error(error.message || 'Lỗi hệ thống');
        }
      }
    })
  ],
  session: {
    strategy: 'jwt',
    maxAge: 30 * 24 * 60 * 60, // 30 days
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role;
        token.phone = user.phone;
        token.avatar = user.avatar;
        token.accessToken = user.accessToken;
        token.refreshToken = user.refreshToken;
        token.emailVerified = user.emailVerified as boolean | undefined;
        token.accessTokenExpires = user.accessTokenExpires;
        token.requirePasswordChange = user.requirePasswordChange;
      }
      return token;
    },
    async session({ session, token }) {
      if (token) {
        session.user.id = token.sub!;
        session.user.role = token.role as string;
        session.user.phone = token.phone as string;
        session.user.avatar = token.avatar as string;
        session.user.emailVerified = token.emailVerified as boolean;
        session.user.requirePasswordChange = token.requirePasswordChange as boolean;
        session.accessToken = token.accessToken;
        session.error = token.error as string | undefined;
      }
      return session;
    }
  },
  pages: {
    signIn: '/khach-thue/dang-nhap',
    error: '/khach-thue/dang-nhap',
  },
  secret: process.env.NEXTAUTH_SECRET || 'secret-key-qlyphongtro',
};

async function refreshAccessToken(token: Record<string, unknown>) {
  try {
    const res = await fetch(`${BACKEND_URL}/api/auth/refresh`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken: token.refreshToken }),
    });

    const result = await res.json();

    if (res.ok && result.success && result.data) {
      const data = result.data;
      return {
        ...token,
        accessToken: data.token,
        refreshToken: data.refreshToken ?? token.refreshToken,
        accessTokenExpires: Date.now() + 10 * 60 * 60 * 1000,
        error: undefined,
      };
    }
    return { ...token, error: 'RefreshAccessTokenError' };
  } catch (error) {
    console.error('Refresh token error:', error);
    return { ...token, error: 'RefreshAccessTokenError' };
  }
}
