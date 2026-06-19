const fs = require('fs');
const filePath = 'f:/qlyphongtro/frontend/src/components/ui/phong-form.tsx';
let content = fs.readFileSync(filePath, 'utf-8');

// 1. Add state for tangList
if (!content.includes('const [tangList, setTangList] = useState')) {
  content = content.replace(
    'const [formData, setFormData] = useState({',
    `const [tangList, setTangList] = useState<{soTang: number, tenTang: string}[]>([]);\n  const [formData, setFormData] = useState({`
  );
}

// 2. Add useEffect to fetch floors when building changes
const fetchFloorsEffect = `
  // Fetch floors when toaNha changes
  useEffect(() => {
    if (formData.toaNha) {
      fetch(\`/api/toa-nha/\${formData.toaNha}/tang\`, {
        headers: accessToken ? { Authorization: \`Bearer \${accessToken}\` } : {},
      })
        .then(res => res.json())
        .then(result => {
          if (result.success && Array.isArray(result.data)) {
            // Sort by soTang
            const sorted = result.data.sort((a: any, b: any) => a.soTang - b.soTang);
            setTangList(sorted);
            
            // If current tang is not in the list and we have floors, maybe select the first one, 
            // but let's keep it if we are editing to not overwrite
            if (!phong && sorted.length > 0) {
              setFormData(prev => ({ ...prev, tang: sorted[0].soTang }));
            }
          }
        })
        .catch(console.error);
    } else {
      setTangList([]);
    }
  }, [formData.toaNha, accessToken, phong]);
`;

if (!content.includes('// Fetch floors when toaNha changes')) {
  content = content.replace(
    '// Cập nhật formData khi phong thay đổi',
    fetchFloorsEffect + '\n  // Cập nhật formData khi phong thay đổi'
  );
}

// 3. Replace Tầng Input with Select
const tangInputRegex = /<Label htmlFor="tang" className="text-sm">Tầng<\/Label>\s*<Input\s*id="tang"\s*type="number"\s*min="1"\s*value=\{formData\.tang\}\s*onChange=\{\(e\) => setFormData\(prev => \(\{ \.\.\.prev, tang: parseInt\(e\.target\.value\) \|\| 1 \}\)\)\}\s*className="text-sm"\s*\/>/m;

const tangSelectContent = `<Label htmlFor="tang" className="text-sm">Tầng</Label>
              <Select value={formData.tang.toString()} onValueChange={(value) => setFormData(prev => ({ ...prev, tang: parseInt(value) }))}>
                <SelectTrigger className="text-sm">
                  <SelectValue placeholder="Chọn tầng" />
                </SelectTrigger>
                <SelectContent className="max-h-[200px]">
                  {tangList.length > 0 ? tangList.map((t) => (
                    <SelectItem key={t.soTang} value={t.soTang.toString()} className="text-sm">
                      {t.tenTang || \`Tầng \${t.soTang}\`}
                    </SelectItem>
                  )) : (
                    <SelectItem value={formData.tang.toString()} className="text-sm">Tầng {formData.tang}</SelectItem>
                  )}
                </SelectContent>
              </Select>`;

if (tangInputRegex.test(content)) {
  content = content.replace(tangInputRegex, tangSelectContent);
}

fs.writeFileSync(filePath, content, 'utf-8');
console.log('Update PhongForm successful');
