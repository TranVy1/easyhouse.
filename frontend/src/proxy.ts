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
    const isApi = req.nextUrl.pathname.startsWith('/api/');
    // Doc ca phien khach thue cho /api/: withAuth ben duoi chi duoc cau hinh voi
    // cookie cua admin, nen req.nextauth.token luon null khi nguoi dung la khach
    // thue. Khong doc them o day thi moi request /api/ khong the tu dat header
    // Authorization (dien hinh la <iframe src> xem PDF hop dong) se bi 403.
    const tenantToken = (isTenantDashboard || isApi)
      ? await getToken({
          req,
          secret: process.env.NEXTAUTH_SECRET,
          cookieName: tenantSessionCookie.name,
        })
      : null;
    const tenantRole = typeof tenantToken?.role === 'string'
      ? tenantToken.role.replace(/^ROLE_/, '').toUpperCase()
      : '';

    console.log('PROXY DEBUG: isTenantDashboard=', isTenantDashboard, 'tenantToken=', !!tenantToken, 'tenantRole=', tenantRole, 'SECRET_PREFIX=', (process.env.NEXTAUTH_SECRET || '').substring(0, 5));

    if (isTenantDashboard && (!tenantToken || tenantRole !== 'TENANT')) {
      return NextResponse.redirect(new URL('/khach-thue/dang-nhap', req.url));
    }

    const tenantAccessToken = typeof tenantToken?.accessToken === 'string'
      ? tenantToken.accessToken
      : '';
    const adminAccessToken = typeof accessToken === 'string' ? accessToken : '';

    // Mot trinh duyet co the giu DONG THOI ca hai phien (vua test admin vua test
    // khach thue). Neu cu uu tien admin thi request tu cong khach thue se mang
    // token admin — va neu token do het han (accessTokenExpires chi 15 phut) thi
    // backend tra 403, dien hinh la <iframe> xem PDF hop dong.
    // Chon theo NGU CANH goi: request phat ra tu cong khach thue thi dung token
    // khach thue. Referer la thu duy nhat cho biet ngu canh, vi duong dan /api/
    // cua hai ben giong het nhau.
    const referer = req.headers.get('referer') || '';
    const laNguCanhKhachThue = referer.includes('/khach-thue/')
      || req.nextUrl.pathname.startsWith('/api/auth-tenant/');

    const conHan = (t: unknown) =>
      typeof t === 'number' ? Date.now() < t : true;
    const adminConHan = conHan(req.nextauth.token?.accessTokenExpires);
    const tenantConHan = conHan(tenantToken?.accessTokenExpires);

    const uuTien = laNguCanhKhachThue
      ? [
          { token: tenantAccessToken, conHan: tenantConHan },
          { token: adminAccessToken, conHan: adminConHan },
        ]
      : [
          { token: adminAccessToken, conHan: adminConHan },
          { token: tenantAccessToken, conHan: tenantConHan },
        ];

    // Uu tien token dung ngu canh VA con han; neu ca hai het han thi van gui cai
    // dung ngu canh de backend tra loi 401/403 co y nghia thay vi khong gui gi.
    const tokenDeGan =
      uuTien.find((x) => x.token.length > 0 && x.conHan)?.token
      || uuTien.find((x) => x.token.length > 0)?.token
      || '';

    if (
      isApi &&
      !isNextAuthEndpoint(req.nextUrl.pathname) &&
      !requestHeaders.has('Authorization') &&
      tokenDeGan.length > 0
    ) {
      requestHeaders.set('Authorization', `Bearer ${tokenDeGan}`);
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
