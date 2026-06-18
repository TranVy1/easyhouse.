"use client";

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  BarChart,
  Bar
} from "recharts";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { formatCurrency } from "@/lib/utils";

interface RevenueData {
  label: string;
  expectedRevenue: number;
  collectedRevenue: number;
  outstanding: number;
}

export function RevenueChart({ data }: { data: RevenueData[] }) {
  if (!data || data.length === 0) {
    return (
      <Card className="col-span-4 h-[400px] flex items-center justify-center border-dashed">
        <div className="text-center text-[#6B7A8C]">
          <p>Chưa có dữ liệu doanh thu</p>
        </div>
      </Card>
    );
  }

  const CustomTooltip = ({ active, payload, label }: any) => {
    if (active && payload && payload.length) {
      return (
        <div className="bg-white p-3 border rounded shadow-md text-sm">
          <p className="font-bold mb-2">{label}</p>
          {payload.map((entry: any, index: number) => (
            <div key={`item-${index}`} className="flex items-center gap-2 mb-1">
              <div className="w-3 h-3 rounded-full" style={{ backgroundColor: entry.color }} />
              <span className="text-[#6B7A8C]">{entry.name}:</span>
              <span className="font-semibold">{formatCurrency(entry.value)}</span>
            </div>
          ))}
        </div>
      );
    }
    return null;
  };

  return (
    <Card className="col-span-4">
      <CardHeader>
        <CardTitle>Doanh thu 12 tháng gần nhất</CardTitle>
        <CardDescription>
          Theo dõi số tiền phải thu, đã thu và còn nợ
        </CardDescription>
      </CardHeader>
      <CardContent className="h-[350px]">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart
            data={data}
            margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
          >
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#eee" />
            <XAxis dataKey="label" tickLine={false} axisLine={false} tick={{ fontSize: 12, fill: '#64748b' }} dy={10} />
            <YAxis 
              tickFormatter={(value) => `${(value / 1000000).toFixed(0)}Tr`}
              tickLine={false}
              axisLine={false}
              tick={{ fontSize: 12, fill: '#64748b' }}
              dx={-10}
            />
            <Tooltip content={<CustomTooltip />} />
            <Legend wrapperStyle={{ paddingTop: '20px' }} />
            <Bar dataKey="expectedRevenue" name="Phải thu" fill="#94a3b8" radius={[4, 4, 0, 0]} barSize={20} />
            <Bar dataKey="collectedRevenue" name="Đã thu" fill="#3b82f6" radius={[4, 4, 0, 0]} barSize={20} />
            <Bar dataKey="outstanding" name="Còn nợ" fill="#ef4444" radius={[4, 4, 0, 0]} barSize={20} />
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
