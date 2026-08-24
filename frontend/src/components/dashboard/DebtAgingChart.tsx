"use client";

import {
  PieChart,
  Pie,
  Cell,
  Tooltip,
  Legend,
  Label,
  ResponsiveContainer
} from "recharts";
import { TooltipProps } from "recharts";
import { ValueType, NameType } from "recharts/types/component/DefaultTooltipContent";
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

const COLORS = ['#8CCBC5', '#F2A45B', '#E8956A', '#C75345', '#7f1d1d'];

export function DebtAgingChart({ data }: { data: DebtAgingData | null }) {
  if (!data || data.totalOutstanding === 0) {
    return (
      <Card className="col-span-3 h-[400px] flex items-center justify-center border-dashed">
        <div className="text-center text-[#6B7A8C]">
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

  const CustomTooltip = ({ active, payload }: TooltipProps<ValueType, NameType>) => {
    if (active && payload && payload.length) {
      return (
        <div className="bg-white/95 backdrop-blur-sm p-4 border border-[#E8DED2] rounded-xl shadow-lg text-sm">
          <p className="font-bold mb-1 text-[#243B5A]">{payload[0].name}</p>
          <p className="text-[#243B5A]">
            {formatCurrency(payload[0].value)}
          </p>
          <p className="text-xs text-[#6B7A8C] mt-1">
            {((payload[0].value / data.totalOutstanding) * 100).toFixed(1)}% tổng nợ
          </p>
        </div>
      );
    }
    return null;
  };

  return (
    <Card className="col-span-3 border-border/60 shadow-sm overflow-hidden rounded-2xl bg-white">
      <CardHeader className="pb-4 border-b bg-gradient-to-r from-[#243B5A]/[0.02] to-transparent">
        <CardTitle className="text-lg text-[#243B5A]">Phân bổ tuổi nợ</CardTitle>
        <CardDescription>
          Tổng nợ: <strong className="text-[#C75345] text-base">{formatCurrency(data.totalOutstanding)}</strong>
        </CardDescription>
      </CardHeader>
      <CardContent className="h-[350px] p-6 pt-8">
        <ResponsiveContainer width="100%" height="100%">
          <PieChart margin={{ top: 0, right: 0, bottom: 20, left: 0 }}>
            <Pie
              data={chartData}
              cx="50%"
              cy="50%"
              innerRadius={75}
              outerRadius={110}
              paddingAngle={3}
              dataKey="value"
              stroke="none"
            >
              {chartData.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} className="drop-shadow-sm hover:opacity-90 transition-opacity" />
              ))}
              <Label
                position="center"
                content={({ viewBox }) => {
                  if (viewBox && 'cx' in viewBox && 'cy' in viewBox) {
                    return (
                      <text x={viewBox.cx} y={viewBox.cy} textAnchor="middle" dominantBaseline="middle">
                        <tspan x={viewBox.cx} y={(viewBox.cy || 0) - 10} className="fill-[#243B5A] text-lg font-black tracking-tighter">
                          {formatCurrency(data.totalOutstanding)}
                        </tspan>
                        <tspan x={viewBox.cx} y={(viewBox.cy || 0) + 12} className="fill-[#6B7A8C] text-[10px] uppercase font-bold tracking-wider">
                          Tổng nợ
                        </tspan>
                      </text>
                    );
                  }
                }}
              />
            </Pie>
            <Tooltip content={<CustomTooltip />} />
            <Legend layout="horizontal" verticalAlign="bottom" align="center" iconType="circle" iconSize={8} wrapperStyle={{ fontSize: '13px', fontWeight: 500, paddingTop: '10px' }} />
          </PieChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
