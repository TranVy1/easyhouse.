"use client";

import { useState, useEffect } from "react";
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer
} from "recharts";
import Link from "next/link";
import { CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { DashboardCard, HeroActionButton } from "@/components/dashboard/shared-ui";
import { toast } from "sonner";
import { BaoCaoTongQuan, ApiResponse } from "@/types";
import { DollarSign, Percent, AlertCircle, FileText, Download, ArrowRight, Wrench, Wallet } from "lucide-react";
import { useSession } from "next-auth/react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";

export function BaoCaoClient() {
  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const [baoCao, setBaoCao] = useState<BaoCaoTongQuan | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchBaoCao = async () => {
      try {
        const res = await fetch("/api/bao-cao/tong-quan", {
          headers: { Authorization: `Bearer ${accessToken}` },
        });
        const data: ApiResponse<BaoCaoTongQuan> = await res.json();
        
        if (data.success) {
          // Xử lý đảo ngược danh sách biểu đồ vì backend trả từ tháng cũ đến tháng mới
          setBaoCao(data.data || null);
        } else {
          toast.error(data.message || "Lỗi khi tải báo cáo");
        }
      } catch (error) {
        console.error("Lỗi khi tải dữ liệu báo cáo:", error);
        toast.error("Không thể tải báo cáo");
      } finally {
        setIsLoading(false);
      }
    };

    if (accessToken) fetchBaoCao();
  }, [accessToken]);

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount);
  };

  const tyLeThu = baoCao ? (baoCao.doanhThu > 0 ? (baoCao.tienDaThu / baoCao.doanhThu) * 100 : 0) : 0;

  if (isLoading) {
    return <div className="p-8 text-center text-gray-500">Đang tải báo cáo...</div>;
  }

  if (!baoCao) {
    return <div className="p-8 text-center text-red-500">Không có dữ liệu báo cáo</div>;
  }

  const hasOperationalAttention =
    baoCao.tienChuaThu > 0 ||
    baoCao.suCoCanXuLy > 0 ||
    baoCao.hopDongSapHetHan > 0 ||
    baoCao.tyLeLapDay < 80;
  const hasCriticalAttention = baoCao.suCoCanXuLy >= 10 || baoCao.tyLeLapDay < 50;
  const heroStatus = hasCriticalAttention
    ? { label: "Có chỉ số cần xử lý", className: "is-danger" }
    : hasOperationalAttention
      ? { label: "Cần chú ý vận hành", className: "" }
      : { label: "Vận hành ổn định", className: "is-stable" };
  const debtTone = baoCao.tienChuaThu > 0 ? "is-orange" : "is-teal";
  const occupancyTone = baoCao.tyLeLapDay < 80 ? "is-orange" : "is-teal";
  const incidentTone = baoCao.suCoCanXuLy > 0 ? "is-orange" : "is-teal";
  const expiringContractTone = baoCao.hopDongSapHetHan > 0 ? "is-orange" : "is-teal";

  return (
    <div className="space-y-6">
      <section className="bao-cao-hero" aria-labelledby="bao-cao-hero-title">
        <div className="bao-cao-hero__content">
          <div className="bao-cao-hero__eyebrow">
            <FileText className="h-4 w-4" aria-hidden="true" />
            BÁO CÁO & THỐNG KÊ
          </div>

          <div className="bao-cao-hero__title-row">
            <h1 id="bao-cao-hero-title">Báo cáo & Thống kê</h1>
            <span className={`bao-cao-hero__status-badge ${heroStatus.className}`}>
              {heroStatus.label}
            </span>
          </div>

          <p>
            Theo dõi doanh thu, công nợ, tỷ lệ lấp đầy và các chỉ số vận hành quan trọng trong một nơi.
          </p>

          <div className="bao-cao-hero__insight">
            Doanh thu tháng này đạt <strong>{formatCurrency(baoCao.doanhThu)}</strong>, còn{" "}
            <strong>{formatCurrency(baoCao.tienChuaThu)}</strong> công nợ và có{" "}
            <strong>{baoCao.suCoCanXuLy}</strong> sự cố cần xử lý.
          </div>

          <div className="bao-cao-hero__chips" aria-label="Tóm tắt báo cáo hiện tại">
            <span className="bao-cao-hero__chip">Đã thu {formatCurrency(baoCao.tienDaThu)}</span>
            <span className="bao-cao-hero__chip">Tỷ lệ đã thu {tyLeThu.toFixed(1)}%</span>
            <span className="bao-cao-hero__chip">{baoCao.bieuDoDoanhThu.length} tháng dữ liệu</span>
          </div>
        </div>

        <div className="bao-cao-hero__actions">
          <HeroActionButton variant="secondary" className="bao-cao-hero__button bao-cao-hero__button-primary gap-2" onClick={() => toast.success("Đang tải báo cáo...")}>
            <Download className="h-4 w-4" /> Xuất báo cáo
          </HeroActionButton>
        </div>

        <div className="bao-cao-hero__stats">
          <article className="bao-cao-hero__stat-card is-navy">
            <div className="bao-cao-hero__stat-top">
              <span>Doanh thu tháng này</span>
              <DollarSign className="h-5 w-5" />
            </div>
            <strong>{formatCurrency(baoCao.doanhThu)}</strong>
            <small>Đã thu trong kỳ: {formatCurrency(baoCao.tienDaThu)}</small>
          </article>

          <article className={`bao-cao-hero__stat-card ${debtTone}`}>
            <div className="bao-cao-hero__stat-top">
              <span>Công nợ</span>
              <Wallet className="h-5 w-5" />
            </div>
            <strong>{formatCurrency(baoCao.tienChuaThu)}</strong>
            <small>Tiền chưa thu</small>
          </article>

          <article className={`bao-cao-hero__stat-card ${occupancyTone}`}>
            <div className="bao-cao-hero__stat-top">
              <span>Tỷ lệ lấp đầy</span>
              <Percent className="h-5 w-5" />
            </div>
            <strong>{baoCao.tyLeLapDay.toFixed(1)}%</strong>
            <small>Hiệu suất khai thác phòng</small>
          </article>

          <article className={`bao-cao-hero__stat-card ${incidentTone}`}>
            <div className="bao-cao-hero__stat-top">
              <span>Sự cố cần xử lý</span>
              <AlertCircle className="h-5 w-5" />
            </div>
            <strong>{baoCao.suCoCanXuLy}</strong>
            <small>Cần ưu tiên vận hành</small>
          </article>

          <article className={`bao-cao-hero__stat-card ${expiringContractTone}`}>
            <div className="bao-cao-hero__stat-top">
              <span>HĐ sắp hết hạn</span>
              <FileText className="h-5 w-5" />
            </div>
            <strong>{baoCao.hopDongSapHetHan}</strong>
            <small>Trong 30 ngày tới</small>
          </article>
        </div>
      </section>

      <div className="grid gap-4 md:grid-cols-2 animate-in fade-in slide-in-from-bottom-8 duration-500">
        <DashboardCard className="col-span-1 md:col-span-2 overflow-hidden border-0 shadow-[0_12px_28px_rgba(15,23,42,0.08)] ring-1 ring-[#E5E0D8]">
          <CardHeader className="border-b bg-gradient-to-r from-[#F8F3EC] to-white pb-4">
            <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
              <div>
                <CardTitle className="text-lg font-bold text-[#243B5A]">Biểu đồ doanh thu</CardTitle>
                <CardDescription className="text-slate-500 mt-1">So sánh tổng doanh thu và số tiền thực tế đã thu được trong 6 tháng qua</CardDescription>
              </div>
              <Badge variant="outline" className="bg-[#4FA7A0]/10 px-3 py-1.5 text-[#267D76] border-[#4FA7A0]/30 font-semibold whitespace-nowrap shadow-sm">
                Tỷ lệ đã thu tháng này: {tyLeThu.toFixed(1)}%
              </Badge>
            </div>
          </CardHeader>
          <CardContent className="h-[400px] pt-6 bg-white">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart
                data={baoCao.bieuDoDoanhThu}
                margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
              >
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E8DED2" opacity={0.6} />
                <XAxis dataKey="thang" axisLine={false} tickLine={false} tick={{fill: '#6B7A8C', fontWeight: 500}} dy={10} />
                <YAxis 
                  tickFormatter={(value) => `${(value / 1000000).toFixed(0)}Tr`}
                  axisLine={false} 
                  tickLine={false}
                  tick={{fill: '#6B7A8C', fontWeight: 500}}
                  dx={-10}
                />
                <Tooltip 
                  formatter={(value: number) => [formatCurrency(value), undefined]}
                  labelFormatter={(label) => `Tháng ${label}`}
                  cursor={{fill: '#F8F3EC', opacity: 0.6}}
                  contentStyle={{
                    borderRadius: '16px', 
                    border: '1px solid #E8DED2', 
                    boxShadow: '0 20px 40px -15px rgba(15,23,42,0.15)',
                    padding: '12px 16px',
                    backgroundColor: 'rgba(255, 255, 255, 0.98)'
                  }}
                  itemStyle={{ fontWeight: 600 }}
                  labelStyle={{ fontWeight: 600, color: '#6B7A8C', marginBottom: '8px' }}
                />
                <Legend iconType="circle" wrapperStyle={{paddingTop: '20px', fontWeight: 500, color: '#243B5A'}} />
                <Bar dataKey="doanhThu" name="Tổng doanh thu" fill="#243B5A" radius={[6, 6, 0, 0]} maxBarSize={60} />
                <Bar dataKey="daThu" name="Đã thu" fill="#4FA7A0" radius={[6, 6, 0, 0]} maxBarSize={60} />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </DashboardCard>
      </div>

      {/* Khối phân tích phụ */}
      <div className="grid gap-4 md:grid-cols-3">
        {/* Công nợ */}
        <DashboardCard className="border-t-4 border-t-red-500 border-x-0 border-b-0 shadow-[0_8px_20px_rgba(15,23,42,0.06)] hover:-translate-y-1 transition-all duration-300 animate-in fade-in slide-in-from-bottom-6 delay-75">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-semibold text-slate-500 flex items-center gap-2">
              <Wallet className="h-4 w-4 text-red-500" />
              Cần thu hồi công nợ
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="mt-1 text-2xl font-extrabold text-red-600 tabular-nums tracking-tight">
              {formatCurrency(baoCao.tienChuaThu)}
            </div>
            <p className="mt-2 text-sm text-slate-500 leading-snug">
              Tổng tiền chưa thu từ các hóa đơn quá hạn hoặc chưa thanh toán.
            </p>
            <Button variant="outline" className="mt-5 w-full justify-between border-red-200 text-red-600 hover:bg-red-50 hover:text-red-700" asChild>
              <Link href="/dashboard/cong-no">
                Kiểm tra hóa đơn <ArrowRight className="h-4 w-4 ml-2" />
              </Link>
            </Button>
          </CardContent>
        </DashboardCard>

        {/* Hợp đồng */}
        <DashboardCard className="border-t-4 border-t-[#243B5A] border-x-0 border-b-0 shadow-[0_8px_20px_rgba(15,23,42,0.06)] hover:-translate-y-1 transition-all duration-300 animate-in fade-in slide-in-from-bottom-6 delay-150">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-semibold text-slate-500 flex items-center gap-2">
              <FileText className="h-4 w-4 text-[#243B5A]" />
              Hợp đồng sắp hết hạn
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="mt-1 text-2xl font-extrabold text-[#243B5A] tabular-nums tracking-tight">
              {baoCao.hopDongSapHetHan} <span className="text-base font-medium text-slate-400">hợp đồng</span>
            </div>
            <p className="mt-2 text-sm text-slate-500 leading-snug">
              Các hợp đồng sẽ hết hạn trong vòng 30 ngày tới cần được gia hạn.
            </p>
            <Button variant="outline" className="mt-5 w-full justify-between border-[#E8DED2] text-[#243B5A] hover:bg-[#F8F3EC]" asChild>
              <Link href="/dashboard/hop-dong">
                Xem danh sách <ArrowRight className="h-4 w-4 ml-2" />
              </Link>
            </Button>
          </CardContent>
        </DashboardCard>

        {/* Sự cố */}
        <DashboardCard className="border-t-4 border-t-[#F2A45B] border-x-0 border-b-0 shadow-[0_8px_20px_rgba(15,23,42,0.06)] hover:-translate-y-1 transition-all duration-300 animate-in fade-in slide-in-from-bottom-6 delay-300">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-semibold text-slate-500 flex items-center gap-2">
              <Wrench className="h-4 w-4 text-[#F2A45B]" />
              Sự cố vận hành
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="mt-1 text-2xl font-extrabold text-[#243B5A] tabular-nums tracking-tight">
              {baoCao.suCoCanXuLy} <span className="text-base font-medium text-slate-400">yêu cầu</span>
            </div>
            <p className="mt-2 text-sm text-slate-500 leading-snug">
              Yêu cầu sửa chữa hoặc khiếu nại từ khách thuê đang chờ xử lý.
            </p>
            <Button variant="outline" className="mt-5 w-full justify-between border-[#E8DED2] text-[#243B5A] hover:bg-[#F8F3EC]" asChild>
              <Link href="/dashboard/su-co">
                Xử lý ngay <ArrowRight className="h-4 w-4 ml-2" />
              </Link>
            </Button>
          </CardContent>
        </DashboardCard>
      </div>
    </div>
  );
}
