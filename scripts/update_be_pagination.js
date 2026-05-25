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

walkDir('./be/src/main/java/com/example/quanlyphongtro/controller', ['.java'], (filePath) => {
  let content = fs.readFileSync(filePath, 'utf-8');
  let changed = false;

  if (content.includes('List<') && content.includes('ApiResponse<List<')) {
    content = content.replace(/import java\.util\.List;/g, 'import java.util.List;\nimport com.example.quanlyphongtro.dto.PaginatedResponse;\nimport com.example.quanlyphongtro.util.PaginationUtils;');
    
    // Replace ApiResponse<List<T>> with ApiResponse<PaginatedResponse<T>>
    content = content.replace(/ApiResponse<List<([a-zA-Z0-9_]+)>>/g, 'ApiResponse<PaginatedResponse<$1>>');
    
    // Replace ApiResponse.success(service.getAll...) with ApiResponse.success(PaginationUtils.paginate(service.getAll...))
    // We need a regex that matches: ApiResponse.success(...) where ... is a method call returning a list
    // This is tricky, but let's do a simple replace:
    content = content.replace(/ApiResponse\.success\(([^,]+Service\.[a-zA-Z0-9_]+\([^)]*\))\)/g, 'ApiResponse.success(PaginationUtils.paginate($1))');
    
    fs.writeFileSync(filePath, content);
    console.log('Updated', filePath);
  }
});
