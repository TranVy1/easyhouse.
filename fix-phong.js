const fs = require('fs');
const file = 'f:/qlyphongtro/frontend/src/components/ui/phong-form.tsx';
let content = fs.readFileSync(file, 'utf-8');

const oldStr = `              </Select>
                type="number"
                min="1"
                value={formData.dienTich}`;

const newStr = `              </Select>
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
                type="number"
                min="1"
                value={formData.dienTich}`;

content = content.replace(oldStr, newStr);

fs.writeFileSync(file, content, 'utf-8');
console.log('Fixed phong-form');
