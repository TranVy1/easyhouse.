import { NextRequest, NextResponse } from 'next/server';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8080';

export async function GET(request: NextRequest) {
  try {
    const token = request.nextUrl.searchParams.get('token');

    if (!token) {
      return NextResponse.json(
        { success: false, message: 'Thiếu mã xác thực email' },
        { status: 400 }
      );
    }

    const response = await fetch(`${BACKEND_URL}/api/auth/verify-email?token=${encodeURIComponent(token)}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    const data = await response.json();
    return NextResponse.json(data, { status: response.status });
  } catch {
    return NextResponse.json(
      { success: false, message: 'Không thể xác thực email lúc này' },
      { status: 500 }
    );
  }
}
