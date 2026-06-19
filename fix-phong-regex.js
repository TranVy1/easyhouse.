const fs = require('fs');
const file = 'f:/qlyphongtro/frontend/src/components/ui/phong-form.tsx';
let content = fs.readFileSync(file, 'utf-8');

// Find where "type=\"number\"" is located after "Trống"
const targetStart = content.indexOf('type="number"');
if (targetStart > -1) {
  const badPart = content.substring(content.indexOf('</Select>', content.indexOf('Bảo trì')), content.indexOf('type="number"'));
  
  const replacement = `</Select>
            </div>
          </div>

          {/* Thông tin phòng */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 md:gap-4">
            <div className="space-y-2">
              <Label htmlFor="tang" className="text-sm">Tầng</Label>
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
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="dienTich" className="text-sm">Diện tích (m²)</Label>
              <Input
                id="dienTich"
                `;
  
  content = content.replace(badPart, replacement);
  fs.writeFileSync(file, content, 'utf-8');
  console.log('Fixed');
}
