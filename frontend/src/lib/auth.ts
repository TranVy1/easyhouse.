import CredentialsProvider from 'next-auth/providers/credentials';
import { NextAuthOptions } from 'next-auth';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8080';

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
          const res = await fetch(`${BACKEND_URL}/api/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              email: credentials.email.toLowerCase(),
              matKhau: credentials.matKhau
            })
          });

          if (res.ok) {
            const result = await res.json();
            if (result.success && result.data) {
              const user = result.data;
              return {
                id: user.id || '1',
                email: user.email,
                name: user.hoTen || user.name || 'User',
                role: user.vaiTro || user.role || 'LANDLORD',
                phone: user.soDienThoai || user.phone || '',
                avatar: user.anhDaiDien || user.avatar || '',
                accessToken: user.token,
                refreshToken: user.refreshToken || '',
                emailVerified: user.emailVerified ?? true,
                // Store token expiry (access token = 1 hour from now)
                accessTokenExpires: Date.now() + 60 * 60 * 1000,
              };
            }
          }
          
          // Try to get error message from response
          try {
            const err = await res.json();
            throw new Error(err.message || 'Đăng nhập thất bại');
          } catch {
            return null;
          }
        } catch (error) {
          console.error('Auth error:', error);
          return null;
        }
      }
    }),
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

          if (res.ok) {
            const result = await res.json();
            if (result.success && result.data) {
              const { token, refreshToken, khachThue } = result.data;
              return {
                id: khachThue.id || 'tenant',
                email: khachThue.email || '',
                name: khachThue.hoTen || 'Khách thuê',
                role: 'TENANT',
                phone: khachThue.soDienThoai || '',
                avatar: khachThue.anhDaiDien || '',
                accessToken: token,
                refreshToken: refreshToken || '',
                emailVerified: true,
                accessTokenExpires: Date.now() + 60 * 60 * 1000,
              };
            }
          }
          
          try {
            const err = await res.json();
            throw new Error(err.message || 'Đăng nhập thất bại');
          } catch {
            return null;
          }
        } catch (error) {
          console.error('Tenant Auth error:', error);
          return null;
        }
      }
    })
  ],
  session: {
    strategy: 'jwt',
    maxAge: 30 * 24 * 60 * 60, // 30 days – matches refresh token lifetime
  },
  callbacks: {
    async jwt({ token, user }) {
      // Initial sign-in: copy user data to token
      if (user) {
        token.role = user.role;
        token.phone = user.phone;
        token.avatar = user.avatar;
        token.accessToken = user.accessToken;
        token.refreshToken = user.refreshToken;
        token.emailVerified = user.emailVerified as boolean | undefined;
        token.accessTokenExpires = user.accessTokenExpires;
      }

      // If access token has NOT expired, return as-is
      if (typeof token.accessTokenExpires === 'number' && Date.now() < token.accessTokenExpires) {
        return token;
      }

      // Access token has expired – try to refresh
      return await refreshAccessToken(token);
    },
    async session({ session, token }) {
      if (token) {
        session.user.id = token.sub!;
        session.user.role = token.role as string;
        session.user.phone = token.phone as string;
        session.user.avatar = token.avatar as string;
        session.user.emailVerified = token.emailVerified as boolean;
        session.accessToken = token.accessToken;
        // Signal to client if token refresh failed
        session.error = token.error as string | undefined;
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

/**
 * Refresh the access token using the stored refresh token.
 * If refresh fails, force re-login by setting error flag.
 */
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
        accessTokenExpires: Date.now() + 60 * 60 * 1000,
        error: undefined,
      };
    }

    // Refresh failed – force re-login
    return { ...token, error: 'RefreshAccessTokenError' };
  } catch (error) {
    console.error('Refresh token error:', error);
    return { ...token, error: 'RefreshAccessTokenError' };
  }
}
