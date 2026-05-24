"use client";

import { useState, useEffect } from "react";
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer,
  LineChart, Line
} from "recharts";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { toast } from "sonner";
import { BaoCaoTongQuan, ApiResponse } from "@/types";
import { DollarSign, Percent, AlertCircle, FileText, ArrowUpRight, ArrowDownRight } from "lucide-react";

export function BaoCaoClient() {
  const [baoCao, setBaoCao] = useState<BaoCaoTongQuan | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchBaoCao = async () => {
      try {
        const res = await fetch("/api/bao-cao/tong-quan");
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

    fetchBaoCao();
  }, []);

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount);
  };

  if (isLoading) {
    return <div className="p-8 text-center text-gray-500">Đang tải báo cáo...</div>;
  }

  if (!baoCao) {
    return <div className="p-8 text-center text-red-500">Không có dữ liệu báo cáo</div>;
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-xl md:text-2xl font-bold text-gray-900">Báo cáo & Thống kê</h1>
        <p className="text-xs md:text-sm text-gray-600">Tổng quan tình hình kinh doanh, doanh thu và vận hành.</p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Doanh thu tháng này</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">{formatCurrency(baoCao.doanhThu)}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Đã thu: <span className="font-medium text-green-600">{formatCurrency(baoCao.tienDaThu)}</span>
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Tiền chưa thu (Công nợ)</CardTitle>
            <AlertCircle className="h-4 w-4 text-red-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">{formatCurrency(baoCao.tienChuaThu)}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Cần đốc thúc khách hàng thanh toán
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Tỷ lệ lấp đầy</CardTitle>
            <Percent className="h-4 w-4 text-blue-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-blue-600">{baoCao.tyLeLapDay.toFixed(1)}%</div>
            <p className="text-xs text-muted-foreground mt-1">
              Tỷ lệ phòng đang cho thuê trên tổng số phòng
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Sự cố cần xử lý</CardTitle>
            <AlertCircle className="h-4 w-4 text-orange-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-orange-600">{baoCao.suCoCanXuLy}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Sự cố đang chờ hoặc đang xử lý
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Hợp đồng sắp hết hạn</CardTitle>
            <FileText className="h-4 w-4 text-purple-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-purple-600">{baoCao.hopDongSapHetHan}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Trong 30 ngày tới
            </p>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        <Card className="col-span-1 md:col-span-2">
          <CardHeader>
            <CardTitle>Biểu đồ doanh thu (6 tháng gần nhất)</CardTitle>
            <CardDescription>So sánh tổng doanh thu và số tiền thực tế đã thu được</CardDescription>
          </CardHeader>
          <CardContent className="h-[400px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart
                data={baoCao.bieuDoDoanhThu}
                margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
              >
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="thang" />
                <YAxis 
                  tickFormatter={(value) => `${(value / 1000000).toFixed(0)}Tr`}
                />
                <Tooltip 
                  formatter={(value: number) => formatCurrency(value)}
                  labelFormatter={(label) => `Tháng ${label}`}
                />
                <Legend />
                <Bar dataKey="doanhThu" name="Tổng doanh thu" fill="#8884d8" />
                <Bar dataKey="daThu" name="Đã thu" fill="#82ca9d" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
