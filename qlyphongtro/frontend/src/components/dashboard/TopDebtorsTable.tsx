"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { formatCurrency } from "@/lib/utils";
import { Badge } from "@/components/ui/badge";
import { CheckCircle2, ChevronRight } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

interface TopDebtorData {
  phongId: string;
  maPhong: string;
  khachThueId: string;
  tenKhachThue: string;
  soDienThoai: string;
  tongNo: number;
  noQuaHan: number;
  oldestDueDate: string;
  invoiceCount: number;
}

export function TopDebtorsTable({ data }: { data: TopDebtorData[] }) {
  if (!data || data.length === 0) {
    return (
      <Card className="border-border/60 shadow-sm overflow-hidden rounded-2xl">
        <CardHeader className="border-b bg-gradient-to-r from-[#243B5A]/[0.02] to-transparent p-5 md:px-8 md:py-6">
          <CardTitle className="text-lg text-[#243B5A]">Khách nợ chú ý</CardTitle>
          <CardDescription>Top khách thuê nợ nhiều nhất</CardDescription>
        </CardHeader>
        <CardContent className="h-[250px] flex flex-col items-center justify-center bg-white">
          <CheckCircle2 className="w-10 h-10 text-[#4FA7A0] mx-auto mb-3 opacity-80" />
          <p className="text-sm font-medium text-[#243B5A]">Tuyệt vời! Không có ai nợ tiền.</p>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="border-border/60 shadow-sm overflow-hidden rounded-2xl">
      <CardHeader className="border-b bg-gradient-to-r from-[#243B5A]/[0.02] to-transparent p-5 md:px-8 md:py-6 flex flex-row items-center justify-between">
        <div>
          <CardTitle className="text-lg text-[#243B5A]">Khách nợ chú ý</CardTitle>
          <CardDescription className="mt-0.5">Danh sách khách hàng đang nợ nhiều nhất.</CardDescription>
        </div>
        <Button asChild variant="ghost" size="sm" className="hidden sm:flex text-[#4FA7A0] hover:text-[#267D76] hover:bg-[#E6F3F1] rounded-lg">
          <Link href="/dashboard/cong-no">
            Xem tất cả
            <ChevronRight className="ml-1 size-4" />
          </Link>
        </Button>
      </CardHeader>
      <CardContent className="p-0 bg-white">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm whitespace-nowrap">
            <thead className="bg-[#F8F3EC]/50 text-[#6B7A8C] text-xs uppercase font-bold tracking-wider">
              <tr>
                <th className="px-5 py-3 md:px-8 font-bold">Khách thuê</th>
                <th className="px-5 py-3 font-bold">Tình trạng</th>
                <th className="px-5 py-3 text-right font-bold">Số tiền nợ</th>
                <th className="px-5 py-3 md:px-8 text-right font-bold">Hành động</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border/60">
              {data.map((debtor, index) => {
                // Determine status badge based on oldest due date or overdue amount
                let statusTone = "bg-[#E6F3F1] text-[#4FA7A0]"; // Default: teal (not overdue)
                let statusText = "Chưa tới hạn";

                if (debtor.noQuaHan > 0) {
                  // Rough estimation of aging based on overdue amount presence.
                  // Real implementation should calculate days from `oldestDueDate`
                  statusTone = "bg-[#C75345]/10 text-[#C75345]";
                  statusText = "Quá hạn";
                }

                return (
                  <tr key={index} className="hover:bg-[#F8F3EC]/30 transition-colors duration-200 group">
                    <td className="px-5 py-4 md:px-8">
                      <div className="flex flex-col">
                        <span className="font-bold text-[#243B5A]">{debtor.tenKhachThue}</span>
                        <div className="flex items-center gap-2 mt-0.5 text-[#6B7A8C]">
                          <span className="inline-flex items-center rounded bg-[#F8F3EC] border border-[#E8DED2] px-1.5 py-0.5 text-[10px] font-bold text-[#243B5A]">
                            P.{debtor.maPhong}
                          </span>
                          <span className="text-xs">{debtor.soDienThoai}</span>
                        </div>
                      </div>
                    </td>
                    <td className="px-5 py-4">
                      <div className="flex flex-col gap-1 items-start">
                        <Badge className={`text-[10px] uppercase font-bold tracking-wider px-2 py-0.5 border-0 shadow-none ${statusTone}`}>
                          {statusText}
                        </Badge>
                        <span className="text-xs text-[#6B7A8C] font-medium">{debtor.invoiceCount} hóa đơn</span>
                      </div>
                    </td>
                    <td className="px-5 py-4 text-right">
                      <div className="flex flex-col items-end">
                        <span className="font-bold text-base text-[#C75345]">{formatCurrency(debtor.tongNo)}</span>
                        {debtor.noQuaHan > 0 && (
                          <span className="text-xs text-[#6B7A8C]">Trễ: {formatCurrency(debtor.noQuaHan)}</span>
                        )}
                      </div>
                    </td>
                    <td className="px-5 py-4 md:px-8 text-right">
                      <Button asChild variant="outline" size="sm" className="h-8 text-xs font-semibold border-[#E8DED2] text-[#243B5A] bg-white hover:bg-[#F8F3EC] hover:text-[#4FA7A0]">
                        <Link href={`/dashboard/hoa-don?phongId=${debtor.phongId}`}>
                          Chi tiết
                        </Link>
                      </Button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>
  );
}
