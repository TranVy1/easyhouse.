"use client";

import {
  PieChart,
  Pie,
  Cell,
  Tooltip,
  Legend,
  ResponsiveContainer
} from "recharts";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { formatCurrency } from "@/lib/utils";

interface DebtAgingData {
  notDue: number;
  overdue1To7: number;
  overdue8To15: number;
  overdue16To30: number;
  overdueOver30: number;
  totalOutstanding: number;
}

const COLORS = ['#94a3b8', '#f59e0b', '#f97316', '#ef4444', '#7f1d1d'];

export function DebtAgingChart({ data }: { data: DebtAgingData | null }) {
  if (!data || data.totalOutstanding === 0) {
    return (
      <Card className="col-span-3 h-[400px] flex items-center justify-center border-dashed">
        <div className="text-center text-slate-500">
          <p>Chưa có công nợ</p>
        </div>
      </Card>
    );
  }

  const chartData = [
    { name: 'Chưa tới hạn', value: data.notDue },
    { name: 'Quá hạn 1-7 ngày', value: data.overdue1To7 },
    { name: 'Quá hạn 8-15 ngày', value: data.overdue8To15 },
    { name: 'Quá hạn 16-30 ngày', value: data.overdue16To30 },
    { name: 'Quá hạn >30 ngày', value: data.overdueOver30 },
  ].filter(item => item.value > 0);

  const CustomTooltip = ({ active, payload }: any) => {
    if (active && payload && payload.length) {
      return (
        <div className="bg-white p-3 border rounded shadow-md text-sm">
          <p className="font-bold mb-1">{payload[0].name}</p>
          <p className="text-slate-700">
            {formatCurrency(payload[0].value)}
          </p>
          <p className="text-xs text-slate-500 mt-1">
            {((payload[0].value / data.totalOutstanding) * 100).toFixed(1)}% tổng nợ
          </p>
        </div>
      );
    }
    return null;
  };

  return (
    <Card className="col-span-3">
      <CardHeader>
        <CardTitle>Phân bổ tuổi nợ</CardTitle>
        <CardDescription>
          Tổng nợ: <strong className="text-red-600">{formatCurrency(data.totalOutstanding)}</strong>
        </CardDescription>
      </CardHeader>
      <CardContent className="h-[300px]">
        <ResponsiveContainer width="100%" height="100%">
          <PieChart>
            <Pie
              data={chartData}
              cx="50%"
              cy="50%"
              innerRadius={60}
              outerRadius={100}
              paddingAngle={2}
              dataKey="value"
            >
              {chartData.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
              ))}
            </Pie>
            <Tooltip content={<CustomTooltip />} />
            <Legend layout="horizontal" verticalAlign="bottom" align="center" />
          </PieChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
