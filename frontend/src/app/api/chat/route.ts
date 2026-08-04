import { NextResponse } from 'next/server';
import { GoogleGenerativeAI } from '@google/generative-ai';

// Initialize Gemini API
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '');

const SYSTEM_INSTRUCTION = `Bạn là nhân viên môi giới chuyên nghiệp và nhiệt tình của hệ thống nhà trọ EasyHouse (Khu vực Hà Nội).
QUY TẮC BẮT BUỘC KHI GIAO TIẾP VỚI KHÁCH HÀNG:
1. Khi khách hỏi tìm phòng: BẠN PHẢI ĐỌC "DANH SÁCH PHÒNG TRỐNG" bên dưới và liệt kê TRỰC TIẾP các phòng phù hợp với yêu cầu của khách (ví dụ giá dưới 5 triệu, diện tích, v.v.).
2. NẾU CÓ NHIỀU PHÒNG PHÙ HỢP: CHỈ ĐỀ XUẤT 1 ĐẾN 2 PHÒNG tốt nhất để tránh làm khách rối. Hãy báo cụ thể: Tên phòng, tên nhà trọ, địa chỉ, diện tích và giá tiền. KHÔNG ĐƯỢC trả lời chung chung kiểu "dao động từ A đến B". Phải show phòng thật!
3. NẾU KHÔNG CÓ PHÒNG PHÙ HỢP: Hãy xin lỗi khách và tư vấn 1-2 phòng gần tầm giá đó nhất có trong danh sách.
4. Thông tin dịch vụ: Điện (3.500đ/kWh), Nước (25.000đ/khối). Liên hệ xem phòng: 0369 963 725 (Zalo/Call).
5. Luôn trả lời từ từ, tự nhiên, thân thiện và cung cấp đầy đủ thông tin trọn vẹn, không bao giờ ngắt câu nửa chừng.
6. Nếu được hỏi về đồ án: Trình bày tự tin kiến trúc hệ thống (Next.js, Spring Boot, PostgreSQL) do sinh viên thực hiện.

Hãy dùng Markdown (in đậm, danh sách) để tư vấn cho khách dễ nhìn.`;

export async function POST(req: Request) {
  try {
    const { messages } = await req.json();

    if (!messages || !Array.isArray(messages) || messages.length === 0) {
      return NextResponse.json({ error: 'Messages are required' }, { status: 400 });
    }

    if (!process.env.GEMINI_API_KEY) {
      return NextResponse.json({
        error: 'Chưa cấu hình GEMINI_API_KEY trong file .env.local'
      }, { status: 500 });
    }

    // Format messages for Gemini history
    let historyData = messages.slice(0, -1);

    // Gemini API strict rule: history must start with a 'user' message
    while (historyData.length > 0 && historyData[0].role === 'bot') {
      historyData.shift();
    }

    const history = historyData.map((msg: any) => ({
      role: msg.role === 'bot' ? 'model' : 'user',
      parts: [{ text: msg.text }],
    }));

    const latestMessage = messages[messages.length - 1].text;

    // Fetch available rooms context
    let dynamicContext = "";
    try {
      // In Docker, the backend is a separate container. BACKEND_URL resolves
      // it through the Compose network; the fallback keeps local development working.
      const backendUrl = process.env.BACKEND_URL || "http://127.0.0.1:8080";
      const roomRes = await fetch(`${backendUrl}/api/public/phong?limit=10`, { cache: 'no-store' });
      if (roomRes.ok) {
        const roomData = await roomRes.json();
        const availableRooms = roomData.data?.data?.filter((r: any) => r.trangThai === 'AVAILABLE') || [];
        if (availableRooms.length > 0) {
          dynamicContext = "\n\n*** DANH SÁCH PHÒNG TRỐNG HIỆN TẠI TỪ DATABASE (Hãy dựa vào đây để tư vấn cho khách) ***\n";
          availableRooms.forEach((r: any) => {
            const formattedPrice = new Intl.NumberFormat('vi-VN').format(r.giaHienTai) + 'đ';
            dynamicContext += `- Phòng: **${r.ten}** | Thuộc nhà: **${r.tenNhaTro}** | Địa chỉ: ${r.diaChiNhaTro} | Giá: ${formattedPrice} | Diện tích: ${r.dienTich}m2\n`;
            if (r.anhDaiDien) {
              dynamicContext += `  Ảnh: ![Ảnh phòng ${r.ten}](${r.anhDaiDien})\n`;
            } else if (r.anhList && r.anhList.length > 0) {
              dynamicContext += `  Ảnh: ![Ảnh phòng ${r.ten}](${r.anhList[0]})\n`;
            }
            dynamicContext += `  Link xem chi tiết: [👉 Bấm vào đây để xem chi tiết phòng](/phong/${r._id})\n\n`;
          });
          dynamicContext += "CHÚ Ý QUAN TRỌNG: Khi gợi ý phòng, BẮT BUỘC phải show ra 'Ảnh' (nếu có) và 'Link xem chi tiết' y hệt như format trên để khách click vào xem!\n";
        }
      }
    } catch (e) {
      console.error("Failed to fetch rooms context:", e);
    }

    // Use gemini-1.5-flash (gemini-2.5-flash does not exist and will crash)
    const model = genAI.getGenerativeModel({
      model: 'gemini-2.5-flash',
      systemInstruction: SYSTEM_INSTRUCTION + dynamicContext,
    });

    const chat = model.startChat({
      history,
      generationConfig: {
        maxOutputTokens: 8192,
        temperature: 0.4,
      },
    });

    const result = await chat.sendMessage(latestMessage);
    const candidate = result.response.candidates?.[0];
    console.log("Gemini Finish Reason:", candidate?.finishReason);

    const responseText = result.response.text();

    return NextResponse.json({ response: responseText });

  } catch (error: any) {
    console.error('Gemini API Error:', error);
    return NextResponse.json({
      error: 'Có lỗi xảy ra khi kết nối với AI. Vui lòng thử lại sau.'
    }, { status: 500 });
  }
}
