import { NextRequest, NextResponse } from 'next/server';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8080';

type RouteContext = {
  params: Promise<{ path?: string[] }>;
};

async function proxyAuthKhachThue(
  request: NextRequest,
  context: RouteContext,
  method: 'GET' | 'POST'
) {
  try {
    const params = await context.params;
    const path = params.path?.join('/') || '';
    const query = request.nextUrl.search || '';
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    };

    const authorization = request.headers.get('authorization');
    if (authorization) {
      headers.Authorization = authorization;
    }

    const response = await fetch(`${BACKEND_URL}/api/auth/khach-thue/${path}${query}`, {
      method,
      headers,
      body: method === 'POST' ? JSON.stringify(await request.json()) : undefined,
    });

    const data = await response.json();
    return NextResponse.json(data, { status: response.status });
  } catch {
    return NextResponse.json(
      { success: false, message: 'Không thể kết nối máy chủ khách thuê' },
      { status: 500 }
    );
  }
}

export async function GET(request: NextRequest, context: RouteContext) {
  return proxyAuthKhachThue(request, context, 'GET');
}

export async function POST(request: NextRequest, context: RouteContext) {
  return proxyAuthKhachThue(request, context, 'POST');
}
