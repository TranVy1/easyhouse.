const http = require('http');

async function fetchAPI(path, options = {}) {
    return new Promise((resolve, reject) => {
        const req = http.request(`http://localhost:8080${path}`, {
            method: options.method || 'GET',
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            }
        }, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
                try {
                    const parsed = JSON.parse(data);
                    resolve({ status: res.statusCode, data: parsed });
                } catch (e) {
                    resolve({ status: res.statusCode, text: data });
                }
            });
        });
        req.on('error', reject);
        if (options.body) req.write(JSON.stringify(options.body));
        req.end();
    });
}

async function runE2E() {
    console.log("=== STARTING E2E API TEST ===");
    try {
        // 1. Toa Nha
        console.log("1. Creating Toa Nha...");
        const buildingRes = await fetchAPI('/api/toa-nha', {
            method: 'POST',
            body: {
                tenToaNha: 'E2E Building',
                diaChi: { soNha: '123', duong: 'E2E', phuong: 'P1', quan: 'Q1', thanhPho: 'HCM' },
                moTa: 'Test',
                tienNghiChung: ['Wifi']
            }
        });
        if (buildingRes.status !== 200 || !buildingRes.data.success) throw new Error("Failed to create Toa Nha: " + JSON.stringify(buildingRes));
        const buildingId = buildingRes.data.data.id || buildingRes.data.data._id;
        console.log("   -> Success. ID:", buildingId);

        // 2. Phong
        console.log("2. Creating Phong...");
        const roomRes = await fetchAPI('/api/phong', {
            method: 'POST',
            body: {
                nhaTroId: buildingId,
                maPhong: 'P101-E2E',
                tang: 1,
                dienTich: 20,
                giaThue: 3000000,
                tienCoc: 3000000,
                soNguoiToiDa: 2,
                trangThai: 'AVAILABLE',
                tienNghi: ['Giuong']
            }
        });
        if (roomRes.status !== 200 || !roomRes.data.success) throw new Error("Failed to create Phong: " + JSON.stringify(roomRes));
        const roomId = roomRes.data.data.id || roomRes.data.data._id;
        console.log("   -> Success. ID:", roomId);

        // 3. Khach Thue
        console.log("3. Creating Khach Thue...");
        const tenantRes = await fetchAPI('/api/khach-thue', {
            method: 'POST',
            body: {
                hoTen: 'E2E Tenant',
                soDienThoai: '0123456789',
                cccd: '079012345678',
                email: 'e2e@tenant.com'
            }
        });
        if (tenantRes.status !== 200 || !tenantRes.data.success) throw new Error("Failed to create Khach Thue: " + JSON.stringify(tenantRes));
        const tenantId = tenantRes.data.data.id || tenantRes.data.data._id;
        console.log("   -> Success. ID:", tenantId);

        // 4. Hop Dong
        console.log("4. Creating Hop Dong...");
        const contractRes = await fetchAPI('/api/hop-dong', {
            method: 'POST',
            body: {
                maHopDong: 'HD-E2E-001',
                phong: roomId,
                khachThueId: [tenantId],
                nguoiDaiDien: tenantId,
                ngayBatDau: new Date().toISOString().split('T')[0],
                ngayKetThuc: new Date(Date.now() + 180 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
                giaThue: 3000000,
                tienCoc: 3000000,
                chuKyThanhToan: 'MONTHLY',
                ngayThanhToanHangThang: 5,
                tuDongGiaHan: false,
                chiSoDienBanDau: 100,
                chiSoNuocBanDau: 50,
                phiDichVu: [
                    { dichVuId: null, ten: 'Điện', gia: 3500, soLuong: 1, loaiTinhPhi: 'PER_UNIT' },
                    { dichVuId: null, ten: 'Nước', gia: 20000, soLuong: 1, loaiTinhPhi: 'PER_UNIT' }
                ]
            }
        });
        if (contractRes.status !== 200 || !contractRes.data.success) throw new Error("Failed to create Hop Dong: " + JSON.stringify(contractRes));
        const contractId = contractRes.data.data.id || contractRes.data.data._id;
        console.log("   -> Success. ID:", contractId);

        // 5. Chi So Dien Nuoc
        console.log("5. Recording Chi So Dien Nuoc...");
        const meterRes = await fetchAPI('/api/chi-so-dien-nuoc', {
            method: 'POST',
            body: {
                phongId: roomId,
                kyGhi: new Date().toISOString().slice(0, 7), // YYYY-MM
                chiSoDienMoi: 150,
                chiSoNuocMoi: 60,
                ghiChu: 'E2E Test'
            }
        });
        if (meterRes.status !== 200 || !meterRes.data.success) throw new Error("Failed to record Meter: " + JSON.stringify(meterRes));
        const meterId = meterRes.data.data.id || meterRes.data.data._id;
        console.log("   -> Success. ID:", meterId);

        // 6. Hoa Don
        console.log("6. Generating Hoa Don...");
        const invoiceRes = await fetchAPI('/api/hoa-don', {
            method: 'POST',
            body: {
                phongId: roomId,
                kyHoaDon: new Date().toISOString().slice(0, 7),
                hanThanhToan: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
                ghiChu: 'E2E Invoice'
            }
        });
        if (invoiceRes.status !== 200 || !invoiceRes.data.success) throw new Error("Failed to generate Invoice: " + JSON.stringify(invoiceRes));
        const invoiceId = invoiceRes.data.data.id || invoiceRes.data.data._id;
        console.log("   -> Success. ID:", invoiceId);
        
        // 7. Thanh Toan
        console.log("7. Recording Thanh Toan...");
        const paymentRes = await fetchAPI('/api/thanh-toan', {
            method: 'POST',
            body: {
                hoaDonId: invoiceId,
                soTien: invoiceRes.data.data.tongTien,
                phuongThuc: 'CHUYEN_KHOAN',
                ngayThanhToan: new Date().toISOString().split('T')[0],
                ghiChu: 'E2E Payment'
            }
        });
        if (paymentRes.status !== 200 || !paymentRes.data.success) throw new Error("Failed to record Payment: " + JSON.stringify(paymentRes));
        console.log("   -> Success. ID:", paymentRes.data.data.id || paymentRes.data.data._id);

        console.log("=== ALL E2E API TESTS PASSED SUCCESSFULLY ===");
    } catch (err) {
        console.error("E2E TEST FAILED:", err.message);
    }
}

runE2E();
