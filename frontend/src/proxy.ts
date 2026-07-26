import { withAuth, NextRequestWithAuth } from 'next-auth/middleware';
import { NextResponse } from 'next/server';
import { sessionCookie } from '@/lib/auth-config';

const adminSessionCookie = sessionCookie('easyhouse.admin.session-token');

export default withAuth(
  function proxy(req: NextRequestWithAuth) {
    const requestHeaders = new Headers(req.headers);
    const accessToken = req.nextauth.token?.accessToken;
    const role = typeof req.nextauth.token?.role === 'string'
      ? req.nextauth.token.role.replace(/^ROLE_/, '').toUpperCase()
      : '';

    if (
      req.nextUrl.pathname.startsWith('/khach-thue/dashboard') &&
      (!req.nextauth.token || role !== 'TENANT')
    ) {
      return NextResponse.redirect(new URL('/khach-thue/dang-nhap', req.url));
    }

    if (
      req.nextUrl.pathname.startsWith('/api/') &&
      !req.nextUrl.pathname.startsWith('/api/auth/') &&
      !requestHeaders.has('Authorization') &&
      typeof accessToken === 'string' &&
      accessToken.length > 0
    ) {
      requestHeaders.set('Authorization', `Bearer ${accessToken}`);
    }

    return NextResponse.next({
      request: {
        headers: requestHeaders,
      },
    });
  },
  {
    // Keep withAuth in sync with authOptions.cookies.sessionToken. Without
    // this, production middleware looks for the default cookie instead of
    // __Host-easyhouse.admin.session-token and redirects valid admins away.
    cookies: {
      sessionToken: { name: adminSessionCookie.name },
    },
    callbacks: {
      authorized: ({ token, req }) => {
        const role = typeof token?.role === 'string'
          ? token.role.replace(/^ROLE_/, '').toUpperCase()
          : '';
        // Protect dashboard routes - require ADMIN role
        if (req.nextUrl.pathname.startsWith('/dashboard')) {
          return role === 'ADMIN';
        }
        if (req.nextUrl.pathname.startsWith('/khach-thue/dashboard')) {
          return true;
        }
        if (req.nextUrl.pathname.startsWith('/api/')) {
          return true;
        }
        return !!token;
      },
    },
  }
);

export const config = {
  matcher: [
    '/dashboard/:path*',
    '/khach-thue/dashboard/:path*',
    '/api/:path*'
  ]
};
