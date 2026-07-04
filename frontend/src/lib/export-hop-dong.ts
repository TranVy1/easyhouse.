import { Document, Packer, Paragraph, TextRun, AlignmentType } from 'docx';
import { saveAs } from 'file-saver';

export const generateAndDownloadHopDong = async (
  hopDong: any,
  phongInfo: { maPhong: string; toaNha: string },
  nguoiDaiDienName: string,
  nguoiDaiDienObj: any,
  formatCurrency: (amount: number) => string
) => {
  try {

    // Generate contract content
    const ngayBatDau = new Date(hopDong.ngayBatDau);
    const ngayKetThuc = new Date(hopDong.ngayKetThuc);
    const ngayHienTai = new Date();

    // Tạo document Word
    const doc = new Document({
      sections: [{
        properties: {},
        children: [
          // Header
          new Paragraph({
            children: [
              new TextRun({
                text: "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM",
                bold: true,
                size: 24,
              }),
            ],
            alignment: AlignmentType.CENTER,
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "Độc lập - Tự do - Hạnh phúc",
                bold: true,
                size: 20,
              }),
            ],
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
          }),

          // Title
          new Paragraph({
            children: [
              new TextRun({
                text: "HỢP ĐỒNG THUÊ PHÒNG TRỌ",
                bold: true,
                size: 28,
              }),
            ],
            alignment: AlignmentType.CENTER,
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `(Số: ${hopDong.maHopDong}/HĐTN)`,
                bold: true,
                size: 20,
              }),
            ],
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
          }),

          // Date and location
          new Paragraph({
            children: [
              new TextRun({
                text: `Hôm nay, ngày ${ngayHienTai.getDate()} tháng ${ngayHienTai.getMonth() + 1} năm ${ngayHienTai.getFullYear()};`,
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Tại địa chỉ: ${phongInfo.toaNha}`,
                size: 20,
              }),
            ],
            spacing: { after: 400 },
          }),

          // Parties
          new Paragraph({
            children: [
              new TextRun({
                text: "Chúng tôi gồm:",
                bold: true,
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "1. Đại diện bên cho thuê phòng trọ (Bên A):",
                bold: true,
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "Ông/bà: [Tên chủ nhà] Sinh ngày: [Ngày sinh]",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "Nơi đăng ký hộ khẩu thường trú: [Địa chỉ thường trú]",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "CMND (CCCD) số: [Số CMND] cấp ngày [Ngày cấp] tại: [Nơi cấp]",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "Số điện thoại liên hệ: [Số điện thoại]",
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),

          new Paragraph({
            children: [
              new TextRun({
                text: "2. Bên thuê phòng trọ (Bên B):",
                bold: true,
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Ông/bà: ${nguoiDaiDienObj?.hoTen || nguoiDaiDienName} Sinh ngày: ${nguoiDaiDienObj?.ngaySinh ? new Date(nguoiDaiDienObj.ngaySinh).toLocaleDateString('vi-VN') : '[Ngày sinh]'}`,
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Nơi đăng ký hộ khẩu thường trú: ${nguoiDaiDienObj?.queQuan || '[Quê quán]'}`,
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Số CMND (CCCD): ${nguoiDaiDienObj?.cccd || '[Số CCCD]'} cấp ngày [Ngày cấp] tại: [Nơi cấp]`,
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Số điện thoại liên hệ: ${nguoiDaiDienObj?.soDienThoai || '[Số điện thoại]'}`,
                size: 20,
              }),
            ],
            spacing: { after: 400 },
          }),

          // Agreement
          new Paragraph({
            children: [
              new TextRun({
                text: "Sau khi bàn bạc kỹ lưỡng, hai bên cùng thống nhất như sau:",
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Bên A đồng ý cho bên B thuê 01 phòng ở tại địa chỉ: ${phongInfo.maPhong} - ${phongInfo.toaNha}`,
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Giá thuê: ${formatCurrency(hopDong.giaThue)}/tháng`,
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Hình thức thanh toán: Hàng ${hopDong.chuKyThanhToan === 'thang' ? 'tháng' : hopDong.chuKyThanhToan === 'quy' ? 'quý' : 'năm'} - ngày ${hopDong.ngayThanhToan}`,
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Tiền điện: ${formatCurrency(hopDong.giaDien)}/kWh tính theo chỉ số công tơ, thanh toán vào cuối các tháng.`,
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Tiền nước: ${formatCurrency(hopDong.giaNuoc)}/m³ thanh toán vào cuối các tháng.`,
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Tiền đặt cọc: ${formatCurrency(hopDong.tienCoc)}`,
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: `Hợp đồng có giá trị kể từ ngày ${ngayBatDau.getDate()} tháng ${ngayBatDau.getMonth() + 1} năm ${ngayBatDau.getFullYear()} đến ngày ${ngayKetThuc.getDate()} tháng ${ngayKetThuc.getMonth() + 1} năm ${ngayKetThuc.getFullYear()}.`,
                size: 20,
              }),
            ],
            spacing: { after: 400 },
          }),

          // Responsibilities
          new Paragraph({
            children: [
              new TextRun({
                text: "TRÁCH NHIỆM CỦA CÁC BÊN",
                bold: true,
                size: 24,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "* Trách nhiệm của bên A:",
                bold: true,
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Tạo mọi điều kiện thuận lợi để bên B thực hiện theo hợp đồng.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Cung cấp nguồn điện, nước đầy đủ cho bên B sử dụng.",
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "* Trách nhiệm của bên B:",
                bold: true,
                size: 20,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Thanh toán đầy đủ tiền theo đúng thỏa thuận.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Bảo quản các trang thiết bị và cơ sở vật chất của bên A trang bị cho ban đầu (làm hỏng phải sửa, mất phải đền).",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Không được tự ý sửa chữa, cải tạo cơ sở vật chất khi chưa được sự đồng ý của bên A.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Luôn có ý thức giữ gìn vệ sinh trong và ngoài khu vực phòng trọ.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Bên B phải chấp hành mọi quy định của pháp luật Nhà nước và quy định của địa phương.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Nếu bên B cho khách ở qua đêm thì phải báo trước và được sự đồng ý của bên A, đồng thời phải chịu trách nhiệm về các hành vi vi phạm pháp luật của khách trong thời gian ở lại (nếu có).",
                size: 20,
              }),
            ],
            spacing: { after: 400 },
          }),

          // Common responsibilities
          new Paragraph({
            children: [
              new TextRun({
                text: "TRÁCH NHIỆM CHUNG",
                bold: true,
                size: 24,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Hai bên phải tạo điều kiện thuận lợi cho nhau để thực hiện hợp đồng.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Nếu một trong hai bên vi phạm hợp đồng trong thời gian hợp đồng vẫn còn hiệu lực thì bên còn lại có quyền đơn phương chấm dứt hợp đồng thuê nhà trọ. Ngoài ra, nếu hành vi vi phạm đó gây tổn thất cho bên bị vi phạm thì bên vi phạm sẽ phải bồi thường mọi thiệt hại đã gây ra.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Trong trường hợp muốn chấm dứt hợp đồng trước thời hạn, cần phải báo trước cho bên kia ít nhất 30 ngày và hai bên phải có sự thống nhất với nhau.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Kết thúc hợp đồng, Bên A phải trả lại đầy đủ tiền đặt cọc cho bên B.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Bên nào vi phạm các điều khoản chung thì phải chịu trách nhiệm trước pháp luật.",
                size: 20,
              }),
            ],
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "- Hợp đồng này được lập thành 02 bản và có giá trị pháp lý như nhau, mỗi bên giữ một bản.",
                size: 20,
              }),
            ],
            spacing: { after: 400 },
          }),

          // Additional services
          ...(hopDong.phiDichVu.length > 0 ? [
            new Paragraph({
              children: [
                new TextRun({
                  text: "PHÍ DỊCH VỤ BỔ SUNG:",
                  bold: true,
                  size: 24,
                }),
              ],
              spacing: { after: 200 },
            }),
            ...hopDong.phiDichVu.map((phi: any) =>
              new Paragraph({
                children: [
                  new TextRun({
                    text: `- ${phi.ten}: ${formatCurrency(phi.gia)}`,
                    size: 20,
                  }),
                ],
                spacing: { after: 100 },
              })
            ),
            new Paragraph({
              children: [
                new TextRun({
                  text: "",
                  size: 20,
                }),
              ],
              spacing: { after: 200 },
            }),
          ] : []),

          // Additional terms
          new Paragraph({
            children: [
              new TextRun({
                text: "ĐIỀU KHOẢN BỔ SUNG:",
                bold: true,
                size: 24,
              }),
            ],
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: hopDong.dieuKhoan,
                size: 20,
              }),
            ],
            spacing: { after: 400 },
          }),

          // Signatures
          new Paragraph({
            children: [
              new TextRun({
                text: "ĐẠI DIỆN BÊN A                ĐẠI DIỆN BÊN B",
                bold: true,
                size: 20,
              }),
            ],
            alignment: AlignmentType.CENTER,
            spacing: { after: 200 },
          }),
          new Paragraph({
            children: [
              new TextRun({
                text: "(Ký và ghi họ tên)                (Ký và ghi họ tên)",
                size: 20,
              }),
            ],
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
          }),
        ],
      }],
    });

    // Generate and download Word document
    const buffer = await Packer.toBuffer(doc);
    const uint8Array = new Uint8Array(buffer);
    const blob = new Blob([uint8Array], { type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' });
    saveAs(blob, `hop-dong-${hopDong.maHopDong}.docx`);



    return true;
  } catch (error) {
    console.error('Error generating Word document:', error);
    throw error;
  }
};
