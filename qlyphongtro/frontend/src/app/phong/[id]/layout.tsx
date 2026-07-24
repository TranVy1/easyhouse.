import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Xem chi tiết phòng',
  description: 'Xem thông tin chi tiết phòng trọ, giá thuê, tiện ích và đặt lịch hẹn xem phòng ngay hôm nay.',
  openGraph: {
    title: 'Chi tiết phòng cho thuê | EasyHouse',
    description: 'Khám phá hình ảnh, tiện nghi và giá thuê chi tiết của phòng. Đặt lịch xem phòng miễn phí qua EasyHouse.',
    type: 'article',
  },
};

export default function PhongDetailLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
