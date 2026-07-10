import type { Metadata } from "next";
import { Be_Vietnam_Pro, Inter } from "next/font/google";
import "./globals.css";
import { Toaster } from "@/components/ui/sonner";
import { ErrorBoundary } from "@/components/error-boundary";

const beVietnamPro = Be_Vietnam_Pro({
  subsets: ["latin", "vietnamese"],
  weight: ["400", "500", "600", "700", "800", "900"],
  variable: "--font-heading",
  display: "swap",
});

const inter = Inter({
  subsets: ["latin", "latin-ext"],
  weight: ["400", "500", "600", "700", "800", "900"],
  variable: "--font-body",
  display: "swap",
});

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
    <html lang="vi" suppressHydrationWarning>
      <body className={`${beVietnamPro.variable} ${inter.variable} antialiased`} suppressHydrationWarning>
        <ErrorBoundary>
          {children}
        </ErrorBoundary>
        <Toaster />
      </body>
    </html>
  );
}
