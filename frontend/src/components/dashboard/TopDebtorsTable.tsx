"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { formatCurrency } from "@/lib/utils";
import { Badge } from "@/components/ui/badge";

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
      <Card className="col-span-3">
        <CardHeader>
          <CardTitle>Top khách nợ</CardTitle>
          <CardDescription>Không có khách nợ</CardDescription>
        </CardHeader>
        <CardContent className="h-[250px] flex items-center justify-center border-dashed rounded-lg m-4 mt-0">
          <p className="text-[#6B7A8C]">Tuyệt vời! Không có ai nợ tiền.</p>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="col-span-3">
      <CardHeader>
        <CardTitle>Top khách nợ</CardTitle>
        <CardDescription>Danh sách khách nợ nhiều nhất</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          {data.map((debtor, index) => (
            <div key={index} className="flex items-center justify-between p-3 bg-[#F8F3EC] rounded-lg border">
              <div>
                <p className="font-semibold">{debtor.maPhong} - {debtor.tenKhachThue}</p>
                <div className="flex gap-2 text-xs text-[#6B7A8C] mt-1">
                  <span>{debtor.invoiceCount} hóa đơn nợ</span>
                  <span>|</span>
                  <span>{debtor.soDienThoai}</span>
                </div>
              </div>
              <div className="text-right">
                <p className="font-bold text-red-600">{formatCurrency(debtor.tongNo)}</p>
                {debtor.noQuaHan > 0 && (
                  <Badge variant="destructive" className="mt-1 text-[10px]">
                    Quá hạn: {formatCurrency(debtor.noQuaHan)}
                  </Badge>
                )}
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
