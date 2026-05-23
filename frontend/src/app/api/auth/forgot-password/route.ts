import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // TODO: Implement forgot password logic or forward to backend when backend endpoint is ready
    console.log('Forgot password requested for:', body.email);
    
    return NextResponse.json(
      { success: true, message: 'Nếu email tồn tại, chúng tôi đã gửi hướng dẫn khôi phục mật khẩu.' },
      { status: 200 }
    );
  } catch {
    return NextResponse.json(
      { success: false, message: 'Đã có lỗi xảy ra' },
      { status: 500 }
    );
  }
}
