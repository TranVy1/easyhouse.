import Link from "next/link"
import {
  ArrowRight,
  Building2,
  CalendarCheck2,
  Home as HomeIcon,
  ReceiptText,
  ShieldCheck,
  Wrench,
} from "lucide-react"

import { Button } from "@/components/ui/button"

const operationalFeatures = [
  {
    icon: ReceiptText,
    title: "Thu tiền minh bạch",
    description: "Theo dõi hóa đơn, công nợ và thanh toán theo từng phòng.",
  },
  {
    icon: CalendarCheck2,
    title: "Hợp đồng rõ ràng",
    description: "Quản lý cư trú, kỳ thanh toán và thời hạn hợp đồng.",
  },
  {
    icon: Wrench,
    title: "Xử lý yêu cầu",
    description: "Tiếp nhận sự cố và theo dõi tiến độ hỗ trợ.",
  },
]

export default function Home() {
  return (
    <main className="min-h-screen bg-background">
      <header className="border-b bg-card/90">
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 md:px-6">
          <Link href="/" className="flex items-center gap-2.5">
            <span className="flex size-10 items-center justify-center rounded-xl bg-primary text-primary-foreground">
              <Building2 className="size-5" />
            </span>
            <span>
              <span className="block text-base font-semibold leading-tight">EasyHouse</span>
              <span className="block text-xs text-muted-foreground">Quản lý nhà trọ</span>
            </span>
          </Link>
          <div className="flex items-center gap-2">
            <Button variant="ghost" asChild className="hidden sm:inline-flex">
              <Link href="/khach-thue/dang-nhap">Cổng khách thuê</Link>
            </Button>
            <Button asChild>
              <Link href="/dang-nhap">Đăng nhập</Link>
            </Button>
          </div>
        </div>
      </header>

      <section className="border-b bg-card">
        <div className="mx-auto grid max-w-7xl gap-10 px-4 py-12 md:px-6 md:py-20 lg:grid-cols-[1.08fr_0.92fr] lg:items-center">
          <div className="space-y-6">
            <div className="inline-flex items-center gap-2 rounded-full border bg-background px-3 py-1.5 text-sm text-muted-foreground">
              <ShieldCheck className="size-4 text-primary" />
              Vận hành nhà trọ trên một hệ thống
            </div>
            <div className="space-y-4">
              <h1 className="max-w-xl text-4xl font-semibold tracking-tight text-foreground md:text-5xl">
                Tìm phòng dễ dàng. Quản lý rõ ràng.
              </h1>
              <p className="max-w-xl text-base leading-7 text-muted-foreground md:text-lg">
                EasyHouse kết nối người thuê với phòng phù hợp và giúp ban quản lý theo dõi hợp đồng,
                hóa đơn, thanh toán cùng yêu cầu hỗ trợ hàng ngày.
              </p>
            </div>
            <div className="flex flex-col gap-3 sm:flex-row">
              <Button size="lg" asChild>
                <Link href="/xem-phong">
                  <HomeIcon />
                  Tìm phòng đang trống
                </Link>
              </Button>
              <Button size="lg" variant="outline" asChild>
                <Link href="/dang-nhap">
                  Vào trang quản lý
                  <ArrowRight />
                </Link>
              </Button>
            </div>
          </div>

          <div className="rounded-2xl border bg-background p-4 shadow-sm md:p-6">
            <div className="mb-5 flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Quy trình thuê phòng</p>
                <p className="text-xs text-muted-foreground">Nhanh, rõ chi phí, có lịch hẹn</p>
              </div>
              <span className="rounded-full bg-emerald-50 px-3 py-1 text-xs font-medium text-emerald-700">
                Online
              </span>
            </div>
            <div className="space-y-3">
              {[
                ["01", "Tìm phòng", "Lọc phòng theo nhu cầu và xem thông tin chi tiết."],
                ["02", "Đặt lịch xem", "Gửi lịch thuận tiện để quản lý xác nhận."],
                ["03", "Ký và theo dõi", "Nhận hóa đơn, báo sự cố từ cổng khách thuê."],
              ].map(([step, title, detail]) => (
                <div key={step} className="flex gap-4 rounded-xl border bg-card p-4">
                  <span className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-sm font-semibold text-primary">
                    {step}
                  </span>
                  <div>
                    <p className="text-sm font-medium">{title}</p>
                    <p className="mt-1 text-sm leading-5 text-muted-foreground">{detail}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-7xl px-4 py-12 md:px-6 md:py-16">
        <div className="mb-8 max-w-xl">
          <p className="text-sm font-semibold uppercase tracking-[0.14em] text-primary">Cho ban quản lý</p>
          <h2 className="mt-2 text-2xl font-semibold tracking-tight md:text-3xl">Tập trung vào công việc cần làm</h2>
          <p className="mt-3 text-muted-foreground">
            Không cần bảng tính rời rạc để biết phòng nào trống, khoản nào chưa thu hay sự cố nào đang chờ.
          </p>
        </div>
        <div className="grid gap-4 md:grid-cols-3">
          {operationalFeatures.map((feature) => (
            <article key={feature.title} className="rounded-xl border bg-card p-6">
              <div className="mb-4 inline-flex rounded-lg bg-primary/10 p-2.5 text-primary">
                <feature.icon className="size-5" />
              </div>
              <h3 className="font-medium">{feature.title}</h3>
              <p className="mt-2 text-sm leading-6 text-muted-foreground">{feature.description}</p>
            </article>
          ))}
        </div>
      </section>

      <footer className="border-t bg-card">
        <div className="mx-auto flex max-w-7xl flex-col gap-3 px-4 py-6 text-sm text-muted-foreground sm:flex-row sm:items-center sm:justify-between md:px-6">
          <p>EasyHouse - Hệ thống quản lý phòng trọ</p>
          <div className="flex gap-4">
            <Link href="/xem-phong" className="hover:text-foreground">Xem phòng</Link>
            <Link href="/khach-thue/dang-nhap" className="hover:text-foreground">Khách thuê</Link>
          </div>
        </div>
      </footer>
    </main>
  )
}
