import 'next-auth';
import { DefaultSession } from 'next-auth';

declare module 'next-auth' {
  interface Session {
    user: {
      id?: string;
      role?: string;
      phone?: string;
      avatar?: string;
      emailVerified?: boolean;
      requirePasswordChange?: boolean;
    } & DefaultSession['user'];
    accessToken?: unknown;
    /** Set to 'RefreshAccessTokenError' when refresh token is expired/revoked */
    error?: string;
  }

  interface User {
    id?: string;
    role?: string;
    phone?: string;
    avatar?: string;
    accessToken?: unknown;
    refreshToken?: string;
    emailVerified?: boolean;
    accessTokenExpires?: number;
    requirePasswordChange?: boolean;
  }
}

declare module 'next-auth/jwt' {
  interface JWT {
    role?: string;
    phone?: string;
    avatar?: string;
    accessToken?: unknown;
    refreshToken?: string;
    emailVerified?: boolean;
    accessTokenExpires?: number;
    error?: string;
    requirePasswordChange?: boolean;
  }
}
