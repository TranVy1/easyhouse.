'use client';

import { useState, useEffect, useCallback } from 'react';
import { Button } from '@/components/ui/button';
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
  Monitor,
  Eye,
  CheckCircle2,
  Layout,
  SunMoon,
  Maximize,
  TextSelect
} from 'lucide-react';

export default function CaiDatPage() {
  const [fontSettings, setFontSettings] = useState({
    fontFamily: 'Inter',
    fontSize: 'medium',
    lineHeight: 'normal',
    fontWeight: 'normal'
  });

  const [uiSettings, setUiSettings] = useState({
    theme: 'light',
    density: 'comfortable'
  });

  const [fontSaveStatus, setFontSaveStatus] = useState<'idle' | 'saving' | 'success'>('idle');
  const [uiSaveStatus, setUiSaveStatus] = useState<'idle' | 'saving' | 'success'>('idle');
  const [activeTab, setActiveTab] = useState('font-settings');

  useEffect(() => {
    document.title = 'Cài đặt hệ thống';
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
    const activeDensity = density || 'comfortable';
    
    // Remove existing density classes
    document.body.classList.remove('density-compact', 'density-comfortable', 'density-spacious');
    // Add new density class
    document.body.classList.add(`density-${activeDensity}`);
    
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
    
    const styles = densityStyles[activeDensity] || densityStyles['comfortable'];
    Object.entries(styles).forEach(([property, value]) => {
      document.documentElement.style.setProperty(property, value);
    });
  };

  const handleSaveFontSettings = () => {
    setFontSaveStatus('saving');
    setTimeout(() => {
      localStorage.setItem('fontSettings', JSON.stringify(fontSettings));
      setFontSaveStatus('success');
      setTimeout(() => setFontSaveStatus('idle'), 3000);
    }, 500);
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

  const handleSaveUiSettings = () => {
    setUiSaveStatus('saving');
    setTimeout(() => {
      localStorage.setItem('uiSettings', JSON.stringify(uiSettings));
      setUiSaveStatus('success');
      setTimeout(() => setUiSaveStatus('idle'), 3000);
    }, 500);
  };

  return (
    <div className="max-w-[1180px] mx-auto space-y-8 pb-12 settings-page px-4 md:px-6 xl:px-0">
      <style dangerouslySetInnerHTML={{
        __html: `
          .cai-dat-hero {
            position: relative;
            isolation: isolate;
            overflow: hidden;
            min-height: 300px;
            border-radius: 32px;
            padding: 42px 48px;
            color: #ffffff;
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif !important;
            background-image:
              linear-gradient(
                90deg,
                rgba(13, 35, 61, 0.96) 0%,
                rgba(18, 58, 82, 0.88) 42%,
                rgba(18, 88, 105, 0.36) 68%,
                rgba(18, 88, 105, 0.08) 100%
              ),
              url("/images/cai-dat-hero-bg.png");
            background-size: cover;
            background-position: center right;
            background-repeat: no-repeat;
            border: 1px solid rgba(255, 255, 255, 0.16);
            box-shadow: 0 26px 70px rgba(36, 59, 90, 0.22);
            animation: caiDatHeroIn 560ms cubic-bezier(0.22, 1, 0.36, 1) both;
          }

          .cai-dat-hero * {
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif !important;
          }

          .cai-dat-hero::before {
            content: "";
            position: absolute;
            inset: 0;
            background-image:
              linear-gradient(rgba(255,255,255,0.06) 1px, transparent 1px),
              linear-gradient(90deg, rgba(255,255,255,0.06) 1px, transparent 1px);
            background-size: 36px 36px;
            opacity: 0.35;
            pointer-events: none;
          }

          .cai-dat-hero__clouds {
            position: absolute;
            inset: 0;
            z-index: 1;
            pointer-events: none;
            overflow: hidden;
          }

          .cai-dat-hero__clouds::before,
          .cai-dat-hero__clouds::after {
            content: "";
            position: absolute;
            width: 180px;
            height: 56px;
            border-radius: 999px;
            background:
              radial-gradient(circle at 25% 52%, rgba(255,255,255,0.20) 0 28px, transparent 29px),
              radial-gradient(circle at 48% 35%, rgba(255,255,255,0.16) 0 34px, transparent 35px),
              radial-gradient(circle at 72% 54%, rgba(255,255,255,0.14) 0 26px, transparent 27px);
            opacity: 0.34;
            filter: blur(0.5px);
            animation: caiDatCloudMove 38s linear infinite;
          }

          .cai-dat-hero__clouds::before {
            top: 18%;
            left: -220px;
          }

          .cai-dat-hero__clouds::after {
            top: 62%;
            left: -280px;
            transform: scale(0.72);
            opacity: 0.24;
            animation-duration: 50s;
            animation-delay: -16s;
          }

          .cai-dat-hero__content {
            position: relative;
            z-index: 2;
            max-width: 620px;
            animation: caiDatContentIn 620ms cubic-bezier(0.22, 1, 0.36, 1) both;
            animation-delay: 80ms;
          }

          .cai-dat-hero__eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: rgba(255, 255, 255, 0.84);
            font-size: 13px;
            font-weight: 850;
            letter-spacing: 0.08em;
            text-transform: uppercase;
          }

          .cai-dat-hero__title-row {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            margin-top: 12px;
          }

          .cai-dat-hero h1 {
            max-width: 620px;
            margin: 0;
            color: #ffffff;
            font-size: 50px;
            line-height: 1.04;
            font-weight: 850;
            letter-spacing: 0;
            text-shadow: 0 8px 28px rgba(3, 18, 33, 0.28);
          }

          .cai-dat-hero p {
            max-width: 650px;
            margin-top: 18px;
            color: rgba(255, 255, 255, 0.88);
            font-size: 18px;
            line-height: 1.55;
            font-weight: 600;
            text-shadow: 0 6px 24px rgba(3, 18, 33, 0.22);
          }

          .cai-dat-hero__status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 38px;
            padding: 8px 14px;
            border-radius: 999px;
            color: #7FFFE0;
            font-size: 14px;
            font-weight: 800;
            background: rgba(79, 167, 160, 0.16);
            border: 1px solid rgba(127, 255, 224, 0.24);
            backdrop-filter: blur(14px);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.12), 0 12px 28px rgba(3, 18, 33, 0.14);
            white-space: nowrap;
          }

          .cai-dat-hero__status-dot {
            width: 8px;
            height: 8px;
            border-radius: 999px;
            background: #7FFFE0;
            box-shadow: 0 0 12px rgba(127, 255, 224, 0.8);
          }

          .cai-dat-hero__chips {
            position: relative;
            z-index: 2;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 24px;
          }

          .cai-dat-hero__chip {
            display: inline-flex;
            align-items: center;
            min-height: 40px;
            padding: 9px 15px;
            border-radius: 999px;
            color: #ffffff;
            font-size: 14px;
            font-weight: 750;
            background: rgba(255, 255, 255, 0.13);
            border: 1px solid rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(14px);
            transition:
              transform 180ms ease-out,
              background-color 180ms ease-out,
              border-color 180ms ease-out;
          }

          .cai-dat-hero__chip:hover {
            transform: translateY(-1px);
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.28);
          }

          @keyframes caiDatCloudMove {
            from { translate: 0 0; }
            to { translate: calc(100vw + 520px) 0; }
          }

          @keyframes caiDatHeroIn {
            from { opacity: 0; transform: translateY(14px); }
            to { opacity: 1; transform: translateY(0); }
          }

          @keyframes caiDatContentIn {
            from { opacity: 0; transform: translateY(12px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
          }

          .settings-field {
            display: grid;
            gap: 8px;
          }

          .settings-field label {
            color: #243B5A;
            font-weight: 800;
            font-size: 14px;
          }

          .settings-field p {
            margin: 0;
            color: #6B7A90;
            font-size: 13px;
            line-height: 1.45;
          }

          .settings-select {
            min-height: 48px !important;
            border-radius: 14px !important;
            border: 1px solid rgba(226, 218, 207, 0.9) !important;
            background: rgba(255, 255, 255, 0.92) !important;
            box-shadow: 0 2px 4px rgba(36, 59, 90, 0.02) !important;
            transition: border-color 180ms ease, box-shadow 180ms ease, background-color 180ms ease !important;
          }

          .settings-select:hover {
            border-color: rgba(79, 167, 160, 0.5) !important;
          }

          .settings-select:focus,
          .settings-select[data-state="open"] {
            border-color: rgba(79, 167, 160, 0.75) !important;
            box-shadow: 0 0 0 4px rgba(79, 167, 160, 0.14) !important;
            outline: none !important;
          }

          .settings-card {
            overflow: hidden;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.94);
            border: 1px solid rgba(226, 218, 207, 0.85);
            box-shadow: 0 20px 54px rgba(36, 59, 90, 0.06);
            backdrop-filter: blur(16px);
            animation: settingsCardIn 520ms cubic-bezier(0.22, 1, 0.36, 1) both;
            scroll-margin-top: 100px;
          }

          .settings-card:nth-child(1) { animation-delay: 80ms; }
          .settings-card:nth-child(2) { animation-delay: 140ms; }
          .settings-card:nth-child(3) { animation-delay: 200ms; }

          .settings-card__header {
            padding: 24px 28px;
            background: linear-gradient(135deg, rgba(248, 243, 236, 0.86), rgba(255, 255, 255, 0.92));
            border-bottom: 1px solid rgba(226, 218, 207, 0.82);
          }

          .settings-card__body {
            padding: 28px;
          }

          .settings-preview {
            border-radius: 24px;
            padding: 26px;
            background: linear-gradient(135deg, #243B5A 0%, #315C72 100%);
            color: #ffffff;
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.12), 0 12px 30px rgba(36, 59, 90, 0.15);
          }

          .settings-save-button {
            min-height: 48px;
            border-radius: 16px;
            font-weight: 800;
            color: #ffffff;
            background: linear-gradient(135deg, #243B5A 0%, #315C72 100%);
            box-shadow: 0 14px 34px rgba(36, 59, 90, 0.24);
            transition: transform 220ms ease, box-shadow 220ms ease, opacity 220ms ease;
          }

          .settings-save-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 18px 42px rgba(36, 59, 90, 0.3);
            background: linear-gradient(135deg, #1B2E47 0%, #2A4F62 100%);
          }

          .settings-save-button:active {
            transform: translateY(0);
          }

          @keyframes settingsCardIn {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
          }

          @media (prefers-reduced-motion: reduce) {
            .cai-dat-hero,
            .cai-dat-hero__content,
            .cai-dat-hero__chip,
            .cai-dat-hero__status-badge,
            .settings-card,
            .settings-save-button,
            .settings-select,
            .cai-dat-hero__clouds::before,
            .cai-dat-hero__clouds::after {
              animation: none !important;
              transition: none !important;
              transform: none !important;
              translate: none !important;
            }
          }

          @media (max-width: 1024px) {
            .settings-page {
              max-width: 100%;
            }

            .cai-dat-hero {
              padding: 34px 32px;
              background-position: 64% center;
            }

            .cai-dat-hero__content {
              max-width: 620px;
            }

            .cai-dat-hero h1 {
              font-size: 46px;
            }
          }

          @media (max-width: 768px) {
            .cai-dat-hero {
              min-height: auto;
              padding: 28px 22px;
              border-radius: 24px;
              background-position: 72% center;
              background-image:
                linear-gradient(
                  90deg,
                  rgba(13, 35, 61, 0.98) 0%,
                  rgba(18, 58, 82, 0.94) 58%,
                  rgba(18, 88, 105, 0.78) 100%
                ),
                url("/images/cai-dat-hero-bg.png");
            }

            .cai-dat-hero h1 {
              font-size: 38px;
            }

            .cai-dat-hero p {
              font-size: 16px;
            }

            .cai-dat-hero__chips {
              gap: 8px;
            }

            .cai-dat-hero__chip {
              min-height: 36px;
              padding: 8px 12px;
              font-size: 13px;
            }
            .settings-card__header,
            .settings-card__body {
              padding: 20px;
            }
            .settings-save-button {
              width: 100%;
            }
          }
        `
      }} />

      {/* Hero Header */}
      <section className="cai-dat-hero flex flex-col justify-center" aria-labelledby="cai-dat-hero-title">
        <div className="cai-dat-hero__clouds" aria-hidden="true"></div>
        <div className="cai-dat-hero__content">
          <div className="cai-dat-hero__eyebrow">Cài đặt hệ thống</div>
          <div className="cai-dat-hero__title-row">
            <h1 id="cai-dat-hero-title">Giao diện & Tùy chỉnh</h1>
            <span className="cai-dat-hero__status-badge">
              <span className="cai-dat-hero__status-dot" aria-hidden="true"></span>
              Cài đặt đang áp dụng
            </span>
          </div>
          <p>
            Tùy chỉnh font chữ, theme, mật độ hiển thị và trải nghiệm sử dụng dashboard.
          </p>
          <div className="cai-dat-hero__chips" aria-label="Các nhóm cài đặt giao diện">
            <span className="cai-dat-hero__chip">Font chữ</span>
            <span className="cai-dat-hero__chip">Theme</span>
            <span className="cai-dat-hero__chip">Mật độ hiển thị</span>
            <span className="cai-dat-hero__chip">Preview trực tiếp</span>
          </div>
        </div>
      </section>

      <div className="grid grid-cols-1 lg:grid-cols-[280px_1fr] gap-8 items-start">
        {/* Left Column: Navigation / Summary */}
        <div className="space-y-6 sticky top-24 hidden lg:block">
          <div className="settings-card p-6 space-y-4">
            <h3 className="font-extrabold text-[#243B5A] text-lg mb-2">Menu Cài đặt</h3>
            <nav className="space-y-1.5 flex flex-col">
              <a 
                href="#font-settings" 
                onClick={() => setActiveTab('font-settings')}
                className={`flex items-center gap-3 px-4 py-3 rounded-xl font-semibold transition-colors ${activeTab === 'font-settings' ? 'bg-[#4FA7A0]/10 text-[#4FA7A0]' : 'hover:bg-black/5 text-[#6B7A90]'}`}
              >
                <Type className="w-5 h-5" />
                Hiển thị & Font chữ
              </a>
              <a 
                href="#ui-settings" 
                onClick={() => setActiveTab('ui-settings')}
                className={`flex items-center gap-3 px-4 py-3 rounded-xl font-semibold transition-colors ${activeTab === 'ui-settings' ? 'bg-[#4FA7A0]/10 text-[#4FA7A0]' : 'hover:bg-black/5 text-[#6B7A90]'}`}
              >
                <Monitor className="w-5 h-5" />
                Giao diện & Trải nghiệm
              </a>
              <a 
                href="#preview-settings" 
                onClick={() => setActiveTab('preview-settings')}
                className={`flex items-center gap-3 px-4 py-3 rounded-xl font-semibold transition-colors ${activeTab === 'preview-settings' ? 'bg-[#4FA7A0]/10 text-[#4FA7A0]' : 'hover:bg-black/5 text-[#6B7A90]'}`}
              >
                <Eye className="w-5 h-5" />
                Bản xem trước
              </a>
            </nav>
          </div>

          <div className="settings-card p-6 space-y-5 bg-gradient-to-br from-[#F8F3EC] to-white border-[#E2DACF]">
            <h3 className="font-extrabold text-[#243B5A] flex items-center gap-2">
              <Settings className="w-5 h-5 text-[#4FA7A0]" />
              Cài đặt hiện tại
            </h3>
            <div className="space-y-3.5 text-sm">
              <div className="flex justify-between items-center">
                <span className="text-[#6B7A90] font-medium">Font chữ:</span>
                <span className="font-bold text-[#243B5A] bg-white px-2.5 py-1 rounded-md shadow-sm border border-gray-100">{fontSettings.fontFamily}</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-[#6B7A90] font-medium">Cỡ chữ:</span>
                <span className="font-bold text-[#243B5A] bg-white px-2.5 py-1 rounded-md shadow-sm border border-gray-100">
                  {fontSettings.fontSize === 'small' ? 'Nhỏ' : fontSettings.fontSize === 'medium' ? 'Bình thường' : fontSettings.fontSize === 'large' ? 'Lớn' : 'Rất lớn'}
                </span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-[#6B7A90] font-medium">Theme:</span>
                <span className="font-bold text-[#243B5A] bg-white px-2.5 py-1 rounded-md shadow-sm border border-gray-100">
                  {uiSettings.theme === 'light' ? 'Sáng' : uiSettings.theme === 'dark' ? 'Tối' : 'Hệ thống'}
                </span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-[#6B7A90] font-medium">Mật độ:</span>
                <span className="font-bold text-[#243B5A] bg-white px-2.5 py-1 rounded-md shadow-sm border border-gray-100">
                  {uiSettings.density === 'compact' ? 'Gọn' : uiSettings.density === 'comfortable' ? 'Thoải mái' : 'Rộng rãi'}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Right Column: Settings Cards */}
        <div className="space-y-8">
          
          {/* Font Settings Card */}
          <div id="font-settings" className="settings-card">
            <div className="settings-card__header">
              <div className="flex items-center gap-3 mb-2">
                <div className="p-2.5 bg-[#4FA7A0]/15 rounded-xl text-[#4FA7A0] shadow-sm">
                  <TextSelect className="w-6 h-6" />
                </div>
                <h2 className="text-xl font-extrabold text-[#243B5A]">Hiển thị & Font chữ</h2>
              </div>
              <p className="text-[#6B7A90] md:ml-[56px] text-sm md:text-base">Điều chỉnh font, kích thước, khoảng cách và độ đậm để tối ưu khả năng đọc.</p>
            </div>
            <div className="settings-card__body">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-7 mb-8">
                <div className="settings-field">
                  <Label htmlFor="fontFamily">Font chữ hệ thống</Label>
                  <p>Chọn kiểu chữ sử dụng trong toàn bộ dashboard.</p>
                  <Select 
                    value={fontSettings.fontFamily} 
                    onValueChange={(value) => setFontSettings(prev => ({ ...prev, fontFamily: value }))}
                  >
                    <SelectTrigger className="settings-select mt-1">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {['Inter', 'Roboto', 'Open Sans', 'Lato', 'Montserrat', 'Poppins', 'Nunito'].map(font => (
                        <SelectItem key={font} value={font}>{font}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div className="settings-field">
                  <Label htmlFor="fontSize">Kích thước hiển thị</Label>
                  <p>Điều chỉnh độ lớn chữ cho phù hợp màn hình.</p>
                  <Select 
                    value={fontSettings.fontSize} 
                    onValueChange={(value) => setFontSettings(prev => ({ ...prev, fontSize: value }))}
                  >
                    <SelectTrigger className="settings-select mt-1">
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

                <div className="settings-field">
                  <Label htmlFor="lineHeight">Khoảng cách dòng</Label>
                  <p>Tối ưu khả năng đọc của nội dung dài.</p>
                  <Select 
                    value={fontSettings.lineHeight} 
                    onValueChange={(value) => setFontSettings(prev => ({ ...prev, lineHeight: value }))}
                  >
                    <SelectTrigger className="settings-select mt-1">
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

                <div className="settings-field">
                  <Label htmlFor="fontWeight">Độ đậm văn bản</Label>
                  <p>Cân bằng giữa độ rõ và cảm giác nhẹ mắt.</p>
                  <Select 
                    value={fontSettings.fontWeight} 
                    onValueChange={(value) => setFontSettings(prev => ({ ...prev, fontWeight: value }))}
                  >
                    <SelectTrigger className="settings-select mt-1">
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

              <div className="flex flex-col sm:flex-row items-center justify-between pt-6 border-t border-[#E2DACF]/60 gap-4">
                <div 
                  className={`text-sm font-bold text-green-600 flex items-center gap-2 transition-all duration-300 ${fontSaveStatus === 'success' ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-2'}`}
                >
                  <CheckCircle2 className="w-5 h-5" /> Đã lưu cài đặt font chữ
                </div>
                <Button 
                  onClick={handleSaveFontSettings} 
                  className="settings-save-button px-8 w-full sm:w-auto"
                  disabled={fontSaveStatus === 'saving'}
                >
                  <Save className={`w-5 h-5 mr-2 ${fontSaveStatus === 'saving' ? 'animate-pulse' : ''}`} />
                  {fontSaveStatus === 'saving' ? 'Đang lưu...' : 'Lưu thay đổi kiểu chữ'}
                </Button>
              </div>
            </div>
          </div>

          {/* UI Settings Card */}
          <div id="ui-settings" className="settings-card">
            <div className="settings-card__header">
              <div className="flex items-center gap-3 mb-2">
                <div className="p-2.5 bg-[#F2A45B]/15 rounded-xl text-[#F2A45B] shadow-sm">
                  <Layout className="w-6 h-6" />
                </div>
                <h2 className="text-xl font-extrabold text-[#243B5A]">Giao diện & Trải nghiệm</h2>
              </div>
              <p className="text-[#6B7A90] md:ml-[56px] text-sm md:text-base">Tùy chỉnh theme, mật độ hiển thị và cảm giác thao tác trong dashboard.</p>
            </div>
            <div className="settings-card__body">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-7 mb-8">
                <div className="settings-field">
                  <Label htmlFor="theme">Chế độ hiển thị (Theme)</Label>
                  <p>Lựa chọn màu sắc tổng thể của hệ thống.</p>
                  <Select value={uiSettings.theme} onValueChange={handleThemeChange}>
                    <SelectTrigger className="settings-select mt-1">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="light"><span className="flex items-center gap-2"><SunMoon className="w-4 h-4 text-orange-500" /> Sáng</span></SelectItem>
                      <SelectItem value="dark"><span className="flex items-center gap-2"><SunMoon className="w-4 h-4 text-indigo-500" /> Tối</span></SelectItem>
                      <SelectItem value="auto"><span className="flex items-center gap-2"><Monitor className="w-4 h-4 text-gray-500" /> Theo hệ thống</span></SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="settings-field">
                  <Label htmlFor="density">Mật độ hiển thị (Density)</Label>
                  <p>Khoảng cách giữa các thành phần giao diện.</p>
                  <Select value={uiSettings.density} onValueChange={handleDensityChange}>
                    <SelectTrigger className="settings-select mt-1">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="compact"><span className="flex items-center gap-2"><Maximize className="w-4 h-4 rotate-45" /> Gọn gàng</span></SelectItem>
                      <SelectItem value="comfortable"><span className="flex items-center gap-2"><Maximize className="w-4 h-4" /> Thoải mái</span></SelectItem>
                      <SelectItem value="spacious"><span className="flex items-center gap-2"><Maximize className="w-4 h-4 scale-125" /> Rộng rãi</span></SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="flex flex-col sm:flex-row items-center justify-between pt-6 border-t border-[#E2DACF]/60 gap-4">
                <div 
                  className={`text-sm font-bold text-green-600 flex items-center gap-2 transition-all duration-300 ${uiSaveStatus === 'success' ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-2'}`}
                >
                  <CheckCircle2 className="w-5 h-5" /> Đã lưu cài đặt giao diện
                </div>
                <Button 
                  onClick={handleSaveUiSettings} 
                  className="settings-save-button px-8 w-full sm:w-auto"
                  disabled={uiSaveStatus === 'saving'}
                >
                  <Save className={`w-5 h-5 mr-2 ${uiSaveStatus === 'saving' ? 'animate-pulse' : ''}`} />
                  {uiSaveStatus === 'saving' ? 'Đang lưu...' : 'Lưu cài đặt giao diện'}
                </Button>
              </div>
            </div>
          </div>

          {/* Preview Card */}
          <div id="preview-settings" className="settings-card">
            <div className="settings-card__header">
              <div className="flex items-center gap-3 mb-2">
                <div className="p-2.5 bg-indigo-500/15 rounded-xl text-indigo-500 shadow-sm">
                  <Eye className="w-6 h-6" />
                </div>
                <h2 className="text-xl font-extrabold text-[#243B5A]">Bản xem trước trực tiếp</h2>
              </div>
              <p className="text-[#6B7A90] md:ml-[56px] text-sm md:text-base">Mô phỏng giao diện với các cấu hình hiện tại đang được chọn.</p>
            </div>
            <div className="settings-card__body bg-[#F8F3EC]/40">
              <div className="settings-preview">
                <div 
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
                  <div className="bg-white text-[#243B5A] rounded-2xl p-6 shadow-xl border border-white/20">
                    <div className="flex justify-between items-start mb-5">
                      <div>
                        <h4 className="font-extrabold text-lg mb-1">Tiêu đề mẫu giao diện</h4>
                        <p className="text-[#6B7A90] text-sm">Đây là một đoạn mô tả ngắn về khối dữ liệu.</p>
                      </div>
                      <span className="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold shadow-sm">Hoạt động</span>
                    </div>
                    
                    <div className="space-y-5">
                      <div className="flex flex-col gap-2">
                        <label className="text-sm font-bold text-[#243B5A]">Tên khách thuê</label>
                        <div className="border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm text-gray-500 bg-gray-50/50 shadow-inner">Nguyễn Văn A</div>
                      </div>
                      
                      <div className="border border-gray-100 rounded-xl overflow-hidden shadow-sm">
                        <div className="bg-gray-50/80 px-4 py-3 border-b border-gray-100 flex justify-between text-xs font-bold text-gray-500 uppercase tracking-wider">
                          <span>Dịch vụ</span>
                          <span>Đơn giá</span>
                        </div>
                        <div className="px-4 py-3 flex justify-between text-sm bg-white">
                          <span className="font-medium">Tiền điện</span>
                          <span className="font-bold text-[#4FA7A0]">3,500đ / kWh</span>
                        </div>
                      </div>
                      
                      <div className="flex justify-end pt-2">
                        <button className="bg-gradient-to-r from-[#4FA7A0] to-[#3d8b85] text-white px-5 py-2.5 rounded-xl text-sm font-bold shadow-[0_8px_16px_rgba(79,167,160,0.25)] hover:shadow-[0_12px_20px_rgba(79,167,160,0.35)] hover:-translate-y-0.5 transition-all">
                          Xác nhận thay đổi
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}

