import { withAuth, NextRequestWithAuth } from 'next-auth/middleware';
import { getToken } from 'next-auth/jwt';
import { NextResponse } from 'next/server';
import { sessionCookie } from '@/lib/auth-config';

const adminSessionCookie = sessionCookie('easyhouse.admin.session-token');
const tenantSessionCookie = sessionCookie('easyhouse.tenant.session-token');

const isNextAuthEndpoint = (pathname: string) =>
  pathname.startsWith('/api/auth/') || pathname.startsWith('/api/auth-tenant/');

export default withAuth(
  async function proxy(req: NextRequestWithAuth) {
    const requestHeaders = new Headers(req.headers);
    const accessToken = req.nextauth.token?.accessToken;

    const isTenantDashboard = req.nextUrl.pathname.startsWith('/khach-thue/dashboard');
    const tenantToken = isTenantDashboard
      ? await getToken({
          req,
          secret: process.env.NEXTAUTH_SECRET,
          cookieName: tenantSessionCookie.name,
        })
      : null;
    const tenantRole = typeof tenantToken?.role === 'string'
      ? tenantToken.role.replace(/^ROLE_/, '').toUpperCase()
      : '';

    if (isTenantDashboard && (!tenantToken || tenantRole !== 'TENANT')) {
      return NextResponse.redirect(new URL('/khach-thue/dang-nhap', req.url));
    }

    if (
      req.nextUrl.pathname.startsWith('/api/') &&
      !isNextAuthEndpoint(req.nextUrl.pathname) &&
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
