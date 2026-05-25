const fs = require('fs');
const path = require('path');

function walkDir(dir, extFilter, callback) {
  fs.readdirSync(dir).forEach(f => {
    const dirPath = path.join(dir, f);
    const isDirectory = fs.statSync(dirPath).isDirectory();
    if (isDirectory) {
      walkDir(dirPath, extFilter, callback);
    } else if (extFilter.some(ext => f.endsWith(ext))) {
      callback(path.join(dir, f));
    }
  });
}

const feEndpoints = new Set();
walkDir('./frontend/src', ['.ts', '.tsx'], (filePath) => {
  const content = fs.readFileSync(filePath, 'utf-8');
  const regex = /['"`](\/api\/[a-zA-Z0-9/-]+)['"`]/g;
  let match;
  while ((match = regex.exec(content)) !== null) {
    feEndpoints.add(match[1]);
  }
});

const beEndpoints = new Set();
walkDir('./be/src/main/java/com/example/quanlyphongtro', ['.java'], (filePath) => {
  const content = fs.readFileSync(filePath, 'utf-8');
  const regex = /@(Get|Post|Put|Delete|Patch|Request)Mapping\(['"]([^'"]+)['"]\)/g;
  let match;
  while ((match = regex.exec(content)) !== null) {
    beEndpoints.add(`${match[1].toUpperCase()} ${match[2]}`);
  }
});

let output = '# Endpoints Snapshot\n\n## Frontend Calls\n';
Array.from(feEndpoints).sort().forEach(ep => output += `- ${ep}\n`);
output += '\n## Backend Mappings\n';
Array.from(beEndpoints).sort().forEach(ep => output += `- ${ep}\n`);

fs.writeFileSync('./planning/ENDPOINTS_SNAPSHOT.md', output);
console.log('Done writing endpoints to planning/ENDPOINTS_SNAPSHOT.md');
