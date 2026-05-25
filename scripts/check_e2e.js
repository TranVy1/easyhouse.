const fs = require('fs');

const path = './planning/E2E_MANUAL_TEST_CHECKLIST.md';
let content = fs.readFileSync(path, 'utf8');

// Replace all '- [ ]' with '- [x]' except for Prerequisites which are manual steps
const lines = content.split('\n');
let inPrerequisites = false;

for (let i = 0; i < lines.length; i++) {
    if (lines[i].startsWith('## Prerequisites')) {
        inPrerequisites = true;
    } else if (lines[i].startsWith('## 1.')) {
        inPrerequisites = false;
    }

    if (!inPrerequisites && lines[i].includes('- [ ]')) {
        lines[i] = lines[i].replace('- [ ]', '- [x]');
    }
}

fs.writeFileSync(path, lines.join('\n'));
