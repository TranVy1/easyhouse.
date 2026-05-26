import { withAuth, NextRequestWithAuth } from 'next-auth/middleware';
import { NextResponse } from 'next/server';

export default withAuth(
  function middleware(req: NextRequestWithAuth) {
    const requestHeaders = new Headers(req.headers);
    const accessToken = req.nextauth.token?.accessToken;

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
    callbacks: {
      authorized: ({ token, req }) => {
        // Protect admin routes
        if (req.nextUrl.pathname.startsWith('/dashboard/quan-ly-tai-khoan')) {
          return token?.role === 'ADMIN' || token?.role === 'ROLE_ADMIN';
        }
        // Protect cau-hinh-gia route
        if (req.nextUrl.pathname.startsWith('/dashboard/cau-hinh-gia')) {
          return token?.role === 'ADMIN' || token?.role === 'ROLE_ADMIN' || token?.role === 'LANDLORD' || token?.role === 'STAFF';
        }
        // Protect dashboard routes
        if (req.nextUrl.pathname.startsWith('/dashboard')) {
          return !!token && token.role !== 'TENANT';
        }
        if (req.nextUrl.pathname.startsWith('/khach-thue/dashboard')) {
          return !!token && token.role === 'TENANT';
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
    '/khach-thue/:path*',
    '/api/:path*'
  ]
};
