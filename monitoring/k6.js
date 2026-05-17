import http from 'k6/http';
import { check, sleep } from 'k6';
import { randomIntBetween, randomString } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';

// -------------------------------------------------------------
// 1. Cấu hình K6 (Stages, Thresholds)
// -------------------------------------------------------------
export const options = {
    // Kịch bản (stages): Tăng giảm số lượng VUs (Virtual Users) theo thời gian
    stages: [
        { duration: '10s', target: 10 },  // Ramp-up lên 10 users trong 10s
        { duration: '20s', target: 50 },  // Ramp-up lên 50 users trong 20s
        { duration: '30s', target: 100 }, // Ramp-up lên 100 users trong 30s
        { duration: '10s', target: 0 },   // Ramp-down về 0 users trong 10s để kết thúc
    ],
    
    // Ngưỡng thất bại (Thresholds)
    thresholds: {
        'http_req_duration': ['p(95)<2000', 'p(99)<3000'], // 95% request phải < 2s, 99% < 3s
        'http_req_failed': ['rate<0.05'],                  // Tỷ lệ lỗi (error rate) phải < 5%
    },
};

// -------------------------------------------------------------
// 2. Thiết lập Biến & Headers
// -------------------------------------------------------------
// host.docker.internal:8080 giúp K6 container gọi tới Spring Boot trên máy Host
const BASE_URL = 'http://host.docker.internal:8080';

// Thay bằng token thật nếu backend bắt buộc phải có Authorization JWT
const TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.MockToken'; 

// -------------------------------------------------------------
// 3. Logic giả lập User (Kịch bản test)
// -------------------------------------------------------------
export default function () {
    const headers = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${TOKEN}`,
    };

    // ==========================================
    // SCENARIO A: GET danh sách Hóa Đơn
    // ==========================================
    const getRes = http.get(`${BASE_URL}/api/hoa-don`, { headers });
    
    // Kiểm tra tính hợp lệ của response
    check(getRes, {
        'GET /api/hoa-don status is 200': (r) => r.status === 200,
        'GET /api/hoa-don response time < 2s': (r) => r.timings.duration < 2000,
    });
    
    // Tạm dừng ngẫu nhiên từ 1 đến 3 giây để giống người dùng thật đọc dữ liệu
    sleep(randomIntBetween(1, 3)); 

    // ==========================================
    // SCENARIO B: POST tạo mới 1 Hóa Đơn (Random Data)
    // ==========================================
    // Sinh dữ liệu rác (Mock Data) sử dụng k6-utils
    const payload = JSON.stringify({
        maHoaDon: `HD_${randomString(8, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')}`,
        soTien: randomIntBetween(1000000, 5000000),
        ngayTao: new Date().toISOString(),
        trangThai: 'CHUA_THANH_TOAN',
        ghiChu: 'Load testing by k6'
    });

    const postRes = http.post(`${BASE_URL}/api/hoa-don`, payload, { headers });
    
    // Kiểm tra POST thành công (có thể là 200 hoặc 201 Created)
    check(postRes, {
        'POST /api/hoa-don status is 200 or 201': (r) => r.status === 200 || r.status === 201,
    });
    
    // Tạm dừng 1 chút trước khi vòng lặp lặp lại
    sleep(randomIntBetween(1, 2));
}
