const fs = require('fs');
const path = 'frontend/src/app/(dashboard)/dashboard/hop-dong/page.tsx';
const content = fs.readFileSync(path, 'utf8');

const startStr = 'const handleDownload = async (hopDong: HopDong) => {';
const startIndex = content.indexOf(startStr);
if (startIndex !== -1) {
  const nextFuncStr = 'const ensureISODate = (dateStr: string) => {';
  const endIndex = content.indexOf(nextFuncStr, startIndex);
  
  if (endIndex !== -1) {
    let handleDownloadContent = content.substring(startIndex, endIndex);
    
    const tryIndex = handleDownloadContent.indexOf('try {');
    const catchIndex = handleDownloadContent.indexOf('} catch (error) {');
    
    let tryBody = handleDownloadContent.substring(tryIndex + 5, catchIndex);
    
    let body = tryBody.replace(/const phongInfo = getPhongInfo\(hopDong\.phong\);\r?\n\s*const nguoiDaiDien = getKhachThueName\(hopDong\.nguoiDaiDien\);\r?\n\s*\/\/ Lấy thông tin chi tiết của người đại diện\r?\n\s*const nguoiDaiDienObj = khachThueList\.find\(kt => \{[\s\S]*?\}\);\r?\n\s*/, '');
    
    body = body.replace(/nguoiDaiDienObj\?\.hoTen \|\| nguoiDaiDien/g, 'nguoiDaiDienObj?.hoTen || nguoiDaiDienName');
    
    let exportCode = `import { Document, Packer, Paragraph, TextRun, AlignmentType } from 'docx';
import { saveAs } from 'file-saver';

export const generateAndDownloadHopDong = async (
  hopDong: any,
  phongInfo: { maPhong: string; toaNha: string },
  nguoiDaiDienName: string,
  nguoiDaiDienObj: any,
  formatCurrency: (amount: number) => string
) => {
  try {
${body}
    return true;
  } catch (error) {
    console.error('Error generating Word document:', error);
    throw error;
  }
};
`;
    fs.writeFileSync('frontend/src/lib/export-hop-dong.ts', exportCode, 'utf8');
    console.log('Created export-hop-dong.ts');
    
    const importDocxRegex = /import \{ Document, Packer, Paragraph, TextRun, AlignmentType \} from 'docx';\r?\nimport \{ saveAs \} from 'file-saver';/;
    let newContent = content.replace(importDocxRegex, "import { generateAndDownloadHopDong } from '@/lib/export-hop-dong';");
    
    const newHandleDownload = `const handleDownload = async (hopDong: HopDong) => {
    try {
      const phongInfo = getPhongInfo(hopDong.phong);
      const nguoiDaiDienName = getKhachThueName(hopDong.nguoiDaiDien);
      const nguoiDaiDienObj = khachThueList.find(kt => {
        const ktId = typeof kt._id === 'object' ? (kt._id as { _id: string })._id : kt._id;
        const daiDienId = typeof hopDong.nguoiDaiDien === 'object' ? (hopDong.nguoiDaiDien as { _id: string })._id : hopDong.nguoiDaiDien;
        return ktId === daiDienId;
      });
      await generateAndDownloadHopDong(hopDong, phongInfo, nguoiDaiDienName, nguoiDaiDienObj, formatCurrency);
      toast.success('Đã tải xuống hợp đồng thành công!');
    } catch (error) {
      toast.error('Có lỗi xảy ra khi tạo file Word');
    }
  };

  `;
  
    newContent = newContent.replace(handleDownloadContent, newHandleDownload);
    fs.writeFileSync(path, newContent, 'utf8');
    console.log('Updated page.tsx');
  } else {
    console.log("Could not find nextFuncStr");
  }
} else {
  console.log("Could not find startIndex");
}
