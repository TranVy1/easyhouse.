import type { Metadata } from "next";
import "./globals.css";
import { Toaster } from "@/components/ui/sonner";


export const metadata: Metadata = {
  title: {
    template: "%s | EasyHouse",
    default: "EasyHouse - Quản lý Phòng Trọ",
  },
  description: "Hệ thống quản lý phòng trọ hiện đại, dễ dàng tìm kiếm và đặt lịch xem phòng trực tuyến.",
  keywords: ["phòng trọ", "thuê phòng", "quản lý phòng trọ", "easyhouse", "cho thuê"],
  openGraph: {
    title: "EasyHouse - Quản lý Phòng Trọ",
    description: "Tìm kiếm và thuê phòng trọ dễ dàng, tiện lợi với EasyHouse.",
    type: "website",
    locale: "vi_VN",
    siteName: "EasyHouse",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="vi">
      <body
        className="antialiased font-sans"
      >
        {children}
        <Toaster />
      </body>
    </html>
  );
}
