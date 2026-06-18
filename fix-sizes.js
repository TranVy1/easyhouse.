const fs = require('fs');
const files = [
  'f:/qlyphongtro/frontend/src/components/ui/image-upload.tsx',
  'f:/qlyphongtro/frontend/src/components/ui/image-carousel.tsx',
  'f:/qlyphongtro/frontend/src/components/ui/cccd-upload.tsx',
  'f:/qlyphongtro/frontend/src/app/(dashboard)/dashboard/phong/page.tsx'
];

files.forEach(file => {
  if (!fs.existsSync(file)) return;
  let content = fs.readFileSync(file, 'utf-8');
  if (content.includes('sizes="100vw"')) {
    content = content.replace(/sizes="100vw"/g, 'sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"');
    fs.writeFileSync(file, content);
    console.log('Updated ' + file);
  }
});
