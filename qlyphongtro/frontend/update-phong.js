const fs = require('fs');
const filePath = 'f:/qlyphongtro/frontend/src/app/(dashboard)/dashboard/phong/page.tsx';
const lines = fs.readFileSync(filePath, 'utf-8').split('\n');
const startIdx = 871; // line 872 (0-indexed)
const newLines = lines.slice(0, startIdx).concat(lines.slice(1246));
const finalContent = newLines.join('\n').replace(
  "import { PhongDataTable } from './table';",
  "import { PhongDataTable } from './table';\nimport { PhongForm } from '@/components/ui/phong-form';"
);
fs.writeFileSync(filePath, finalContent, 'utf-8');
console.log('Updated phong/page.tsx');
