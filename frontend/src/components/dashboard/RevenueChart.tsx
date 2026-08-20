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
import { Card, CardContent } from "@/components/ui/card";
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
      <div className="h-[400px] flex items-center justify-center border-dashed rounded-2xl border-2 border-gray-200">
        <div className="text-center text-[#6B7A8C]">
          <p>Chưa có dữ liệu doanh thu</p>
        </div>
      </div>
    );
  }

  const CustomTooltip = ({ active, payload, label }: any) => {
    if (active && payload && payload.length) {
      return (
        <div className="bg-white/95 backdrop-blur-sm p-4 border border-[#E8DED2] rounded-xl shadow-lg text-sm">
          <p className="font-bold mb-2 text-[#243B5A]">{label}</p>
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
    <div className="h-[350px] w-full min-w-0">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart
          data={data}
          margin={{ top: 0, right: 10, left: -20, bottom: 0 }}
        >
          <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E8DED2" />
          <XAxis dataKey="label" tickLine={false} axisLine={false} tick={{ fontSize: 12, fill: '#6B7A8C', fontWeight: 500 }} dy={10} />
          <YAxis
            tickFormatter={(value) => `${(value / 1000000).toFixed(0)}Tr`}
            tickLine={false}
            axisLine={false}
            tick={{ fontSize: 12, fill: '#6B7A8C', fontWeight: 500 }}
            dx={-10}
          />
          <Tooltip content={<CustomTooltip />} cursor={{ fill: '#F8F3EC', opacity: 0.5 }} />
          <Legend wrapperStyle={{ paddingTop: '20px', fontSize: '13px', fontWeight: 500 }} iconType="circle" iconSize={8} />
          <Bar dataKey="expectedRevenue" name="Phải thu" fill="#243B5A" radius={[4, 4, 0, 0]} barSize={16} />
          <Bar dataKey="collectedRevenue" name="Đã thu" fill="#4FA7A0" radius={[4, 4, 0, 0]} barSize={16} />
          <Bar dataKey="outstanding" name="Còn nợ" fill="#F2A45B" radius={[4, 4, 0, 0]} barSize={16} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
