const fs = require('fs');
const path = require('path');

function walkDir(dir, extFilter, callback) {
  fs.readdirSync(dir).forEach(f => {
    const dirPath = path.join(dir, f);
    if (fs.statSync(dirPath).isDirectory()) {
      walkDir(dirPath, extFilter, callback);
    } else if (extFilter.some(ext => f.endsWith(ext))) {
      callback(path.join(dir, f));
    }
  });
}

walkDir('./frontend/src/app', ['.tsx', '.ts'], (filePath) => {
  let content = fs.readFileSync(filePath, 'utf-8');
  let changed = false;

  // Pattern: const data = result.data; -> const data = Array.isArray(result.data) ? result.data : (result.data?.data || []);
  // We need to be careful not to ruin other things.
  // Actually, an easier regex is replacing `result.data` when it's assigned to a list.
  
  // A safer approach: replace `result.data;` with `(Array.isArray(result.data) ? result.data : (result.data?.data || []));`
  // But wait, it might be `result.data` for a single object (like `getById`).
  
  // Let's just create a helper in frontend:
  // export function extractListData(data: any): any[] { return Array.isArray(data) ? data : (data?.data || []); }
});
