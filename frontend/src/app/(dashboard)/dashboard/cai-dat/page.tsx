'use client';

import { useState, useEffect, useCallback } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Label } from '@/components/ui/label';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { 
  Settings, 
  Type,
  Save,
  Monitor
} from 'lucide-react';

export default function CaiDatPage() {
  const [fontSettings, setFontSettings] = useState({
    fontFamily: 'Inter',
    fontSize: 'medium',
    lineHeight: 'normal',
    fontWeight: 'normal'
  });

  useEffect(() => {
    document.title = 'Cài đặt';
  }, []);

  // Load settings from localStorage when component mounts
  useEffect(() => {
    const savedFontSettings = localStorage.getItem('fontSettings');
    if (savedFontSettings) {
      const parsedSettings = JSON.parse(savedFontSettings);
      setFontSettings(parsedSettings);
    }

    const savedUiSettings = localStorage.getItem('uiSettings');
    if (savedUiSettings) {
      const parsedUiSettings = JSON.parse(savedUiSettings);
      setUiSettings(parsedUiSettings);
      applyTheme(parsedUiSettings.theme);
      applyDensity(parsedUiSettings.density);
    }
  }, []);

  const applyFontSettings = useCallback(() => {
    // Áp dụng font family cho toàn bộ document
    document.documentElement.style.setProperty('--font-family', fontSettings.fontFamily);
    document.body.style.fontFamily = fontSettings.fontFamily;
    
    // Áp dụng font size
    const fontSizeMap: Record<string, string> = {
      'small': '14px',
      'medium': '16px', 
      'large': '18px',
      'extra-large': '20px'
    };
    document.documentElement.style.setProperty('--font-size-base', fontSizeMap[fontSettings.fontSize]);
    document.body.style.fontSize = fontSizeMap[fontSettings.fontSize];
    
    // Áp dụng line height
    const lineHeightMap: Record<string, string> = {
      'tight': '1.2',
      'normal': '1.5',
      'relaxed': '1.75',
      'loose': '2'
    };
    document.documentElement.style.setProperty('--line-height-base', lineHeightMap[fontSettings.lineHeight]);
    document.body.style.lineHeight = lineHeightMap[fontSettings.lineHeight];
    
    // Áp dụng font weight
    const fontWeightMap: Record<string, string> = {
      'light': '300',
      'normal': '400',
      'medium': '500',
      'semibold': '600',
      'bold': '700'
    };
    document.documentElement.style.setProperty('--font-weight-base', fontWeightMap[fontSettings.fontWeight]);
    
    // Áp dụng cho tất cả các elements
    const allElements = document.querySelectorAll('*');
    allElements.forEach(el => {
      const element = el as HTMLElement;
      if (!element.style.fontFamily) {
        element.style.fontFamily = fontSettings.fontFamily;
      }
      if (!element.style.lineHeight) {
        element.style.lineHeight = lineHeightMap[fontSettings.lineHeight];
      }
    });
  }, [fontSettings]);

  // Apply settings whenever fontSettings changes
  useEffect(() => {
    applyFontSettings();
  }, [applyFontSettings]);

  const [uiSettings, setUiSettings] = useState({
    theme: 'light',
    density: 'comfortable'
  });

  const applyTheme = (theme: string) => {
    if (theme === 'dark') {
      document.documentElement.classList.add('dark');
    } else if (theme === 'light') {
      document.documentElement.classList.remove('dark');
    } else if (theme === 'auto') {
      // Auto theme based on system preference
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      if (prefersDark) {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    }
  };

  const applyDensity = (density: string) => {
    // Remove existing density classes
    document.body.classList.remove('density-compact', 'density-comfortable', 'density-spacious');
    // Add new density class
    document.body.classList.add(`density-${density}`);
    
    // Apply density styles
    const densityStyles: Record<string, Record<string, string>> = {
      'compact': {
        '--spacing-base': '0.5rem',
        '--padding-base': '0.75rem',
        '--gap-base': '0.5rem'
      },
      'comfortable': {
        '--spacing-base': '1rem',
        '--padding-base': '1rem',
        '--gap-base': '1rem'
      },
      'spacious': {
        '--spacing-base': '1.5rem',
        '--padding-base': '1.5rem',
        '--gap-base': '1.5rem'
      }
    };
    
    Object.entries(densityStyles[density]).forEach(([property, value]) => {
      document.documentElement.style.setProperty(property, value);
    });
  };

  const handleSaveFontSettings = () => {
    console.log('Saving font settings:', fontSettings);
    localStorage.setItem('fontSettings', JSON.stringify(fontSettings));
    alert('Đã lưu cài đặt font chữ thành công!');
  };

  const handleThemeChange = (theme: string) => {
    const newUiSettings = { ...uiSettings, theme };
    setUiSettings(newUiSettings);
    applyTheme(theme);
    localStorage.setItem('uiSettings', JSON.stringify(newUiSettings));
  };

  const handleDensityChange = (density: string) => {
    const newUiSettings = { ...uiSettings, density };
    setUiSettings(newUiSettings);
    applyDensity(density);
    localStorage.setItem('uiSettings', JSON.stringify(newUiSettings));
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6 md:space-y-8 pb-10">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl md:text-2xl lg:text-3xl font-bold text-slate-900">Cài đặt hệ thống</h1>
          <p className="text-xs md:text-sm text-slate-600">Tùy chỉnh font chữ, màu sắc và mật độ hiển thị</p>
        </div>
        <div className="p-2 bg-slate-100 rounded-full">
          <Settings className="h-6 w-6 text-slate-500 animate-spin-slow" />
        </div>
      </div>

      <div className="grid grid-cols-1 gap-6">
        {/* Font Settings */}
        <Card className="border-none shadow-xl shadow-slate-200/50 overflow-hidden">
          <CardHeader className="bg-slate-50/50 border-b border-slate-100 p-6">
            <CardTitle className="flex items-center gap-3 text-lg font-bold text-slate-800">
              <div className="p-2 bg-blue-100 rounded-lg text-blue-600">
                <Type className="h-5 w-5" />
              </div>
              Cấu hình Font chữ
            </CardTitle>
            <CardDescription>
              Tùy chỉnh kiểu chữ và kích thước để tối ưu trải nghiệm đọc
            </CardDescription>
          </CardHeader>
          <CardContent className="p-6 md:p-8 space-y-8">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {/* Font Family */}
              <div className="space-y-3">
                <Label htmlFor="fontFamily" className="text-sm font-semibold text-slate-700">Font chữ hệ thống</Label>
                <Select 
                  value={fontSettings.fontFamily} 
                  onValueChange={(value) => setFontSettings(prev => ({ ...prev, fontFamily: value }))}
                >
                  <SelectTrigger className="h-11 transition-all focus:ring-2 focus:ring-blue-500/20">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {['Inter', 'Roboto', 'Open Sans', 'Lato', 'Montserrat', 'Poppins', 'Nunito'].map(font => (
                      <SelectItem key={font} value={font}>{font}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {/* Font Size */}
              <div className="space-y-3">
                <Label htmlFor="fontSize" className="text-sm font-semibold text-slate-700">Kích thước hiển thị</Label>
                <Select 
                  value={fontSettings.fontSize} 
                  onValueChange={(value) => setFontSettings(prev => ({ ...prev, fontSize: value }))}
                >
                  <SelectTrigger className="h-11 transition-all focus:ring-2 focus:ring-blue-500/20">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="small">Nhỏ (14px)</SelectItem>
                    <SelectItem value="medium">Bình thường (16px)</SelectItem>
                    <SelectItem value="large">Lớn (18px)</SelectItem>
                    <SelectItem value="extra-large">Rất lớn (20px)</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Line Height */}
              <div className="space-y-3">
                <Label htmlFor="lineHeight" className="text-sm font-semibold text-slate-700">Khoảng cách dòng</Label>
                <Select 
                  value={fontSettings.lineHeight} 
                  onValueChange={(value) => setFontSettings(prev => ({ ...prev, lineHeight: value }))}
                >
                  <SelectTrigger className="h-11 transition-all focus:ring-2 focus:ring-blue-500/20">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="tight">Chặt chẽ</SelectItem>
                    <SelectItem value="normal">Mặc định</SelectItem>
                    <SelectItem value="relaxed">Thoải mái</SelectItem>
                    <SelectItem value="loose">Rộng rãi</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Font Weight */}
              <div className="space-y-3">
                <Label htmlFor="fontWeight" className="text-sm font-semibold text-slate-700">Độ đậm của chữ</Label>
                <Select 
                  value={fontSettings.fontWeight} 
                  onValueChange={(value) => setFontSettings(prev => ({ ...prev, fontWeight: value }))}
                >
                  <SelectTrigger className="h-11 transition-all focus:ring-2 focus:ring-blue-500/20">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="light">Mỏng</SelectItem>
                    <SelectItem value="normal">Bình thường</SelectItem>
                    <SelectItem value="medium">Trung bình</SelectItem>
                    <SelectItem value="semibold">Đậm vừa</SelectItem>
                    <SelectItem value="bold">Rất đậm</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            {/* Preview Section */}
            <div className="space-y-3 pt-4">
              <Label className="text-sm font-semibold text-slate-700">Bản xem trước trực tiếp</Label>
              <div className="p-6 md:p-8 rounded-2xl bg-slate-900 text-slate-100 shadow-inner border border-slate-800">
                <p 
                  style={{
                    fontFamily: fontSettings.fontFamily,
                    fontSize: fontSettings.fontSize === 'small' ? '14px' : 
                             fontSettings.fontSize === 'medium' ? '16px' :
                             fontSettings.fontSize === 'large' ? '18px' : '20px',
                    lineHeight: fontSettings.lineHeight === 'tight' ? '1.2' :
                               fontSettings.lineHeight === 'normal' ? '1.5' :
                               fontSettings.lineHeight === 'relaxed' ? '1.75' : '2',
                    fontWeight: fontSettings.fontWeight === 'light' ? '300' :
                               fontSettings.fontWeight === 'normal' ? '400' :
                               fontSettings.fontWeight === 'medium' ? '500' :
                               fontSettings.fontWeight === 'semibold' ? '600' : '700'
                  }}
                  className="transition-all duration-300"
                >
                  &quot;Giao diện người dùng tuyệt vời không chỉ ở vẻ ngoài, mà còn ở cách nó hoạt động và cảm giác mà nó mang lại.&quot; 
                  Hệ thống quản lý phòng trọ chuyên nghiệp - Nâng tầm trải nghiệm quản lý của bạn.
                </p>
              </div>
            </div>

            <Button onClick={handleSaveFontSettings} size="lg" className="w-full h-12 shadow-lg shadow-blue-500/20 bg-blue-600 hover:bg-blue-700 transition-all">
              <Save className="h-5 w-5 mr-2" />
              Lưu thay đổi kiểu chữ
            </Button>
          </CardContent>
        </Card>

        {/* UI Settings */}
        <Card className="border-none shadow-xl shadow-slate-200/50 overflow-hidden">
          <CardHeader className="bg-slate-50/50 border-b border-slate-100 p-6">
            <CardTitle className="flex items-center gap-3 text-lg font-bold text-slate-800">
              <div className="p-2 bg-purple-100 rounded-lg text-purple-600">
                <Monitor className="h-5 w-5" />
              </div>
              Giao diện & Trải nghiệm
            </CardTitle>
            <CardDescription>
              Tùy chỉnh chủ đề và mật độ hiển thị của các thành phần UI
            </CardDescription>
          </CardHeader>
          <CardContent className="p-6 md:p-8 space-y-8">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div className="space-y-3">
                <Label htmlFor="theme" className="text-sm font-semibold text-slate-700">Chế độ hiển thị (Theme)</Label>
                <Select value={uiSettings.theme} onValueChange={handleThemeChange}>
                  <SelectTrigger className="h-11 transition-all focus:ring-2 focus:ring-purple-500/20">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="light">🌞 Chế độ Sáng</SelectItem>
                    <SelectItem value="dark">🌙 Chế độ Tối</SelectItem>
                    <SelectItem value="auto">🖥️ Theo hệ thống</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-3">
                <Label htmlFor="density" className="text-sm font-semibold text-slate-700">Mật độ hiển thị (Density)</Label>
                <Select value={uiSettings.density} onValueChange={handleDensityChange}>
                  <SelectTrigger className="h-11 transition-all focus:ring-2 focus:ring-purple-500/20">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="compact">Chặt chẽ (Gọn gàng)</SelectItem>
                    <SelectItem value="comfortable">Thoải mái (Mặc định)</SelectItem>
                    <SelectItem value="spacious">Rộng rãi (Nhiều khoảng trắng)</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <Button 
              variant="outline"
              size="lg"
              className="w-full h-12 border-slate-200 hover:bg-slate-50 text-slate-700 transition-all font-semibold"
              onClick={() => {
                localStorage.setItem('uiSettings', JSON.stringify(uiSettings));
                alert('Đã lưu cài đặt giao diện thành công!');
              }}
            >
              <Save className="h-5 w-5 mr-2" />
              Lưu cài đặt giao diện
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
