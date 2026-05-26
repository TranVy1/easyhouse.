import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Danh sách phòng cho thuê',
  description: 'Khám phá danh sách các phòng trọ tiện nghi, giá cả hợp lý. Dễ dàng lọc theo khu vực, giá cả và tiện ích.',
  openGraph: {
    title: 'Danh sách phòng cho thuê | EasyHouse',
    description: 'Tìm phòng trọ, căn hộ dịch vụ ưng ý nhất tại EasyHouse với nhiều tiện ích.',
    type: 'website',
  },
};

export default function XemPhongLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
