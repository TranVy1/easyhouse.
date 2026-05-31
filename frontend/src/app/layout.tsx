import type { Metadata } from "next";
import "./globals.css";
import { Toaster } from "@/components/ui/sonner";
import { ErrorBoundary } from "@/components/error-boundary";

export const metadata: Metadata = {
  title: {
    template: "%s | EasyHouse",
    default: "EasyHouse - Quản lý Phòng Trọ",
  },
  description:
    "Hệ thống quản lý phòng trọ hiện đại. Tìm kiếm, đặt lịch xem phòng, theo dõi hóa đơn và hợp đồng thuê nhà dễ dàng với EasyHouse.",
  keywords: [
    "phòng trọ",
    "thuê phòng",
    "quản lý phòng trọ",
    "easyhouse",
    "cho thuê",
    "hóa đơn tiền phòng",
    "hợp đồng thuê nhà",
  ],
  openGraph: {
    title: "EasyHouse - Quản lý Phòng Trọ",
    description:
      "Tìm kiếm và thuê phòng trọ dễ dàng, tiện lợi. Quản lý hợp đồng, hóa đơn và bảo trì trong một nơi.",
    type: "website",
    locale: "vi_VN",
    siteName: "EasyHouse",
  },
  robots: {
    index: true,
    follow: true,
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="vi">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="antialiased">
        <ErrorBoundary>
          {children}
        </ErrorBoundary>
        <Toaster />
      </body>
    </html>
  );
}
