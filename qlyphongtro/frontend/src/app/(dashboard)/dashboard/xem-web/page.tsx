'use client';

import { useState, useEffect } from 'react';
import { CardContent } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Globe, ExternalLink, RefreshCw, Home, AlertCircle, CheckCircle, Link2, ShieldCheck } from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert';
import { DashboardCard } from '@/components/dashboard/shared-ui';
import { cn } from '@/lib/utils';
import styles from './xem-web-hero.module.css';

export default function XemWebPage() {
  const [url, setUrl] = useState('/xem-phong');
  const [currentUrl, setCurrentUrl] = useState('/xem-phong');
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [iframeLoaded, setIframeLoaded] = useState(false);

  useEffect(() => {
    document.title = 'Xem Web - Dashboard';
  }, []);

  const handleLoadUrl = () => {
    if (!url) return;

    let formattedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://') && !url.startsWith('/')) {
      formattedUrl = 'https://' + url;
    }

    setIsLoading(true);
    setLoadError(false);
    setIframeLoaded(false);
    setCurrentUrl(formattedUrl);

    // Set timeout to detect loading issues
    setTimeout(() => {
      if (!iframeLoaded) {
        setLoadError(true);
        setIsLoading(false);
      }
    }, 10000); // 10 seconds timeout
  };

  const handleRefresh = () => {
    if (currentUrl) {
      setIsLoading(true);
      setLoadError(false);
      setIframeLoaded(false);
      // Force refresh iframe
      const iframe = document.getElementById('web-iframe') as HTMLIFrameElement;
      if (iframe) {
        iframe.src = currentUrl;
      }
      setTimeout(() => {
        if (!iframeLoaded) {
          setLoadError(true);
          setIsLoading(false);
        }
      }, 10000);
    }
  };

  const handleReset = () => {
    setUrl('/xem-phong');
    setCurrentUrl('/xem-phong');
    setLoadError(false);
    setIframeLoaded(false);
    setIsLoading(true);
  };

  const handleIframeLoad = () => {
    setIframeLoaded(true);
    setIsLoading(false);
    setLoadError(false);
  };

  const handleIframeError = () => {
    setLoadError(true);
    setIsLoading(false);
    setIframeLoaded(false);
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleLoadUrl();
    }
  };

  const quickLinks = [
    { name: 'Trang tìm phòng (công khai)', url: '/xem-phong' },
    { name: 'Trang chủ khách thuê', url: '/' },
    { name: 'Đăng nhập khách thuê', url: '/khach-thue/dang-nhap' },
    { name: 'Đăng nhập hệ thống', url: '/dang-nhap' },
  ];

  const heroStatusLabel = loadError
    ? 'Không thể hiển thị website'
    : isLoading
      ? 'Đang tải website'
      : iframeLoaded
        ? 'Website đã sẵn sàng'
        : 'Sẵn sàng nhập link';

  const heroStatusClass = loadError
    ? 'is-error'
    : isLoading
      ? 'is-loading'
      : iframeLoaded
        ? 'is-ready'
        : '';

  return (
    <div className="space-y-6">
      <section className={styles['xem-web-hero']}>
        <div className={styles['xem-web-hero__content']}>
          <div className={styles['xem-web-hero__eyebrow']}>
            <Globe className="h-4 w-4" />
            XEM WEB
          </div>

          <div className={styles['xem-web-hero__title-row']}>
            <h1>Xem Web</h1>
            <span className={cn(styles['xem-web-hero__status-badge'], heroStatusClass && styles[heroStatusClass])}>
              {isLoading ? (
                <RefreshCw className="h-4 w-4 animate-spin" />
              ) : loadError ? (
                <AlertCircle className="h-4 w-4" />
              ) : (
                <CheckCircle className="h-4 w-4" />
              )}
              {heroStatusLabel}
            </span>
          </div>

          <p>
            Dán URL website để xem nhanh, kiểm tra giao diện và mở trang ngay trong khu quản lý.
          </p>

          <div className={styles['xem-web-hero__url-box']}>
            <Input
              type="text"
              placeholder="Nhập URL website..."
              value={url}
              onChange={(e) => setUrl(e.target.value)}
              onKeyPress={handleKeyPress}
              className={styles['xem-web-hero__input']}
            />
            <Button
              onClick={handleLoadUrl}
              disabled={!url || isLoading}
              className={styles['xem-web-hero__button-primary']}
            >
              <Globe className="h-4 w-4 mr-2" />
              Xem ngay
            </Button>
          </div>

          <div className={styles['xem-web-hero__chips']} aria-label="Trạng thái và truy cập nhanh">
            <span className={cn(
              styles['xem-web-hero__chip'],
              loadError ? styles['is-error'] : iframeLoaded ? styles['is-ready'] : ''
            )}>
              {loadError ? <AlertCircle className="h-4 w-4" /> : <Link2 className="h-4 w-4" />}
              {loadError ? 'Không hỗ trợ iframe' : iframeLoaded ? 'Link hợp lệ' : 'Sẵn sàng kiểm tra link'}
            </span>
            <button
              type="button"
              className={styles['xem-web-hero__chip']}
              onClick={() => currentUrl && window.open(currentUrl, '_blank')}
              disabled={!currentUrl}
            >
              <ExternalLink className="h-4 w-4" />
              Hỗ trợ mở tab mới
            </button>
            <span className={styles['xem-web-hero__chip']}>
              <ShieldCheck className="h-4 w-4" />
              Kiểm tra hiển thị an toàn
            </span>
          </div>

          {currentUrl && (
            <div className={styles['xem-web-hero__controls']}>
              <Badge className={styles['xem-web-hero__current-url']}>
                <Globe className="h-3 w-3" />
                {currentUrl}
              </Badge>
              <Button
                variant="outline"
                size="sm"
                onClick={handleRefresh}
                disabled={isLoading}
                className={styles['xem-web-hero__button-secondary']}
                aria-label="Làm mới website"
              >
                <RefreshCw className={`h-4 w-4 ${isLoading ? 'animate-spin' : ''}`} />
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={handleReset}
                className={styles['xem-web-hero__button-secondary']}
                aria-label="Quay về trang mặc định"
              >
                <Home className="h-4 w-4" />
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => window.open(currentUrl, '_blank')}
                className={styles['xem-web-hero__button-secondary']}
                aria-label="Mở website trong tab mới"
              >
                <ExternalLink className="h-4 w-4" />
              </Button>
            </div>
          )}

          <div className={styles['xem-web-hero__quick-links']}>
            {quickLinks.map((link) => (
              <Button
                key={link.name}
                type="button"
                variant="outline"
                size="sm"
                className={styles['xem-web-hero__quick-link']}
                onClick={() => {
                  setUrl(link.url);
                  setCurrentUrl(link.url);
                }}
              >
                {link.name}
              </Button>
            ))}
          </div>
        </div>
      </section>

      {/* Error Alert - CSP/X-Frame-Options Violation */}
      {currentUrl && loadError && (
        <Alert variant="destructive">
          <AlertCircle className="h-4 w-4" />
          <AlertTitle>Không thể tải trang web trong iframe</AlertTitle>
          <AlertDescription className="space-y-3">
            <p>
              Website <strong className="break-all">{currentUrl}</strong> không hỗ trợ hiển thị trực tiếp trong dashboard.
            </p>

            <div className="bg-red-50 border border-red-200 rounded p-3 text-sm space-y-2">
              <p className="font-semibold text-red-900">Lý do bảo mật:</p>
              <ul className="list-disc list-inside space-y-1 text-red-800">
                <li><strong>X-Frame-Options</strong>: Ngăn chặn clickjacking</li>
                <li><strong>Content Security Policy (CSP)</strong>: Giới hạn nguồn nhúng</li>
              </ul>
            </div>

            <div className="bg-yellow-50 border border-yellow-200 rounded p-3 text-sm">
              <p className="font-semibold text-yellow-900 mb-1">Các trang web thường bị chặn:</p>
              <p className="text-yellow-800">
                Google, YouTube, Facebook, Instagram, Twitter, banking apps, AppSheet,
                Gmail, LinkedIn và hầu hết các trang đăng nhập hoặc thanh toán.
              </p>
            </div>

            <div className="bg-green-50 border border-green-200 rounded p-3 text-sm">
              <p className="font-semibold text-green-900 mb-1">Các trang có thể dùng:</p>
              <p className="text-green-800">
                Wikipedia, các trang tin tức, blog cá nhân, tài liệu công khai và các trang cho phép nhúng.
              </p>
            </div>

            <div className="flex gap-2 mt-4">
              <Button
                variant="default"
                size="sm"
                onClick={() => window.open(currentUrl, '_blank')}
              >
                <ExternalLink className="h-4 w-4 mr-2" />
                Mở trong tab mới
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={handleReset}
              >
                <Home className="h-4 w-4 mr-2" />
                Thử trang khác
              </Button>
            </div>
          </AlertDescription>
        </Alert>
      )}

      {/* Success Indicator */}
      {currentUrl && iframeLoaded && !loadError && (
        <Alert className="border-green-200 bg-green-50">
          <CheckCircle className="h-4 w-4 text-green-600" />
          <AlertTitle className="text-green-900">Đã tải thành công</AlertTitle>
          <AlertDescription className="text-green-800">
            Website đang hiển thị bên dưới. Bạn có thể tương tác trực tiếp với trang web.
          </AlertDescription>
        </Alert>
      )}

      {/* Iframe Display */}
      {currentUrl && !loadError && (
        <DashboardCard className="overflow-hidden border-0 shadow-sm ring-1 ring-[#E5E0D8]">
          <CardContent className="p-0">
            <div className="relative w-full" style={{ height: 'calc(100vh - 500px)', minHeight: '600px' }}>
              {isLoading && (
                <div className="absolute inset-0 flex items-center justify-center bg-gray-50 z-10">
                  <div className="text-center">
                    <RefreshCw className="h-8 w-8 animate-spin mx-auto mb-2 text-gray-400" />
                    <p className="text-sm text-gray-600">Đang tải trang...</p>
                    <p className="text-xs text-gray-500 mt-2">Nếu không tải được sau 10 giây, website có thể chặn iframe</p>
                  </div>
                </div>
              )}
              <iframe
                id="web-iframe"
                src={currentUrl}
                className="w-full h-full border-0 rounded-lg"
                title="Trình xem web"
                sandbox="allow-same-origin allow-scripts allow-forms allow-popups allow-popups-to-escape-sandbox"
                onLoad={handleIframeLoad}
                onError={handleIframeError}
              />
            </div>
          </CardContent>
        </DashboardCard>
      )}

      {/* Empty State */}
      {!currentUrl && (
        <DashboardCard className="overflow-hidden border-0 shadow-sm ring-1 ring-[#E5E0D8]">
          <CardContent className="py-16">
            <div className="text-center space-y-4">
              <Globe className="h-16 w-16 mx-auto text-gray-300" />
              <div>
                <h3 className="text-lg font-semibold text-gray-900">Chưa có website nào được tải</h3>
                <p className="text-sm text-gray-600 mt-2">
                  Nhập địa chỉ website ở trên hoặc chọn một liên kết nhanh để bắt đầu.
                </p>
              </div>
            </div>
          </CardContent>
        </DashboardCard>
      )}

      {/* Info Card */}
      <DashboardCard className="overflow-hidden border-0 shadow-sm ring-1 ring-[#4FA7A0]/30 bg-[#4FA7A0]/10">
        <CardContent className="p-5 md:p-6">
          <div className="flex items-start gap-3">
            <div className="text-[#243B5A]">
              <svg className="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="flex-1 space-y-2">
              <h4 className="text-sm font-semibold text-[#243B5A]">Hướng dẫn sử dụng</h4>
              <div className="text-sm text-[#243B5A] space-y-2">
                <p>
                  <strong>Cơ chế bảo mật iframe:</strong> Nhiều website sử dụng <code className="bg-[#4FA7A0]/15 px-1 rounded">X-Frame-Options</code>
                  hoặc <code className="bg-[#4FA7A0]/15 px-1 rounded">Content-Security-Policy</code> để ngăn chặn việc nhúng vào iframe,
                  bảo vệ người dùng khỏi các cuộc tấn công clickjacking.
                </p>
                <p>
                  <strong>Giải pháp:</strong> Nếu website bị chặn, sử dụng nút <strong>&quot;Mở trong tab mới&quot;</strong> để
                  xem trang web trong cửa sổ riêng biệt.
                </p>
                <p>
                  <strong>Mẹo:</strong> Các trang tin tức, Wikipedia và tài liệu công khai thường cho phép nhúng iframe.
                  Các trang mạng xã hội, banking và email thường bị chặn.
                </p>
              </div>
            </div>
          </div>
        </CardContent>
      </DashboardCard>
    </div>
  );
}
