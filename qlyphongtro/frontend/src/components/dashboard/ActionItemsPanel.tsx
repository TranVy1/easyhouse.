"use client";

import { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { AlertTriangle, CheckCircle2, ArrowRight, Lightbulb, BellRing } from 'lucide-react';
import { Button } from '@/components/ui/button';
import Link from 'next/link';
import { useSession } from 'next-auth/react';

interface ActionItem {
  type: string;
  priority: string;
  title: string;
  description: string;
  href: string;
  entityId: string;
}

interface TaskItem {
  title: string;
  value: number;
  href: string;
  description: string;
  tone: string;
}

export function ActionItemsPanel({ taskItems = [] }: { taskItems?: TaskItem[] }) {
  const { data: session } = useSession();
  const [items, setItems] = useState<ActionItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchItems = async () => {
      try {
        const res = await fetch('/api/dashboard/analytics/action-items', {
          headers: { 'Authorization': `Bearer ${session?.accessToken}` }
        });
        const data = await res.json();
        if (data.success) {
          setItems(data.data);
        }
      } catch (error) {
        console.error('Failed to fetch action items', error);
      } finally {
        setLoading(false);
      }
    };
    if (session?.accessToken) fetchItems();
  }, [session]);

  const handleResolve = async (id: string) => {
    try {
      const res = await fetch(`/api/meter-alerts/${id}/resolve?status=RESOLVED`, {
        method: 'PATCH',
        headers: { 'Authorization': `Bearer ${session?.accessToken}` }
      });
      if (res.ok) {
        setItems(prev => prev.filter(i => i.entityId !== id));
      }
    } catch (e) {
      console.error(e);
    }
  };

  const hasTasks = taskItems.some(t => t.value > 0) || items.length > 0;

  return (
    <Card className="border-border/60 shadow-sm overflow-hidden rounded-2xl">
      <CardHeader className="border-b bg-gradient-to-r from-[#243B5A]/[0.02] to-transparent p-5 md:px-8 md:py-6">
        <div className="flex items-center gap-3">
          <div className="rounded-xl bg-[#F2A45B]/10 p-2">
            <AlertTriangle className="size-5 text-[#F2A45B]" />
          </div>
          <div>
            <CardTitle className="text-lg text-[#243B5A]">Trung tâm vận hành hôm nay</CardTitle>
            <CardDescription className="mt-0.5">Tổng hợp cảnh báo và gợi ý hành động dành cho bạn.</CardDescription>
          </div>
        </div>
      </CardHeader>
      
      <div className="grid md:grid-cols-2 divide-y md:divide-y-0 md:divide-x divide-border/60">
        
        {/* LEFT COLUMN: CẢNH BÁO ƯU TIÊN */}
        <div className="p-5 md:p-8 bg-[#F8F3EC]/20">
          <h3 className="flex items-center gap-2 text-sm font-bold uppercase tracking-wider text-[#6B7A8C] mb-5">
            <BellRing className="size-4" />
            Cảnh báo ưu tiên
          </h3>
          
          {!hasTasks && !loading ? (
            <div className="text-center py-10 bg-white rounded-xl border border-dashed border-[#E8DED2]">
              <CheckCircle2 className="w-10 h-10 text-[#4FA7A0] mx-auto mb-3 opacity-80" />
              <p className="text-sm font-medium text-[#243B5A]">Mọi thứ đang trong tầm kiểm soát!</p>
              <p className="text-xs text-[#6B7A8C] mt-1">Không có cảnh báo ưu tiên nào.</p>
            </div>
          ) : (
            <div className="space-y-3">
              {/* Core Tasks */}
              {taskItems.filter(t => t.value > 0).map((item) => (
                <Link
                  key={item.title}
                  href={item.href}
                  className="group flex items-center gap-4 rounded-xl border border-border/60 bg-white p-4 transition-all duration-200 hover:border-[#4FA7A0]/25 hover:shadow-sm"
                >
                  <div className={`flex size-10 shrink-0 items-center justify-center rounded-lg text-base font-bold ${item.tone}`}>
                    {item.value}
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-bold text-[#243B5A] group-hover:text-[#4FA7A0] transition-colors">{item.title}</p>
                    <p className="truncate text-xs text-[#6B7A8C] mt-0.5">{item.description}</p>
                  </div>
                  <ArrowRight className="size-4 text-[#6B7A8C]/40 transition-all duration-200 group-hover:translate-x-0.5 group-hover:text-[#4FA7A0]" />
                </Link>
              ))}

              {/* Meter Alerts etc. */}
              {items.map((item, idx) => {
                const isHigh = item.priority === 'HIGH';
                const isMed = item.priority === 'MEDIUM';
                const borderColor = isHigh ? 'border-[#C75345]' : isMed ? 'border-[#F2A45B]' : 'border-[#4FA7A0]';
                const bgColor = isHigh ? 'bg-[#C75345]/5' : isMed ? 'bg-[#F2A45B]/5' : 'bg-[#4FA7A0]/5';
                const titleColor = isHigh ? 'text-[#C75345]' : isMed ? 'text-[#A0673A]' : 'text-[#243B5A]';
                const badgeBg = isHigh ? 'bg-[#C75345]/10 text-[#C75345]' : isMed ? 'bg-[#F2A45B]/15 text-[#A0673A]' : 'bg-[#4FA7A0]/10 text-[#4FA7A0]';
                
                return (
                  <div key={idx} className={`flex flex-col border-l-[3px] border border-border/60 ${borderColor} bg-white p-4 rounded-xl transition-all duration-200 hover:shadow-sm`}>
                    <div className="flex justify-between items-start">
                      <div>
                        <h4 className={`text-sm font-bold ${titleColor}`}>{item.title}</h4>
                        <p className="text-xs text-[#6B7A8C] mt-1">{item.description}</p>
                      </div>
                      <span className={`rounded-full px-2 py-0.5 text-[9px] uppercase font-bold tracking-wider ${badgeBg}`}>
                        {item.priority}
                      </span>
                    </div>
                    <div className="mt-3 flex gap-2">
                      <Button size="sm" variant="outline" asChild className="h-7 text-xs bg-white border-[#E8DED2] hover:bg-[#F8F3EC]">
                        <Link href={item.href}>Xem phòng</Link>
                      </Button>
                      <Button size="sm" variant="ghost" className="h-7 text-xs text-[#C75345] hover:text-[#B04538] hover:bg-[#C75345]/10" onClick={() => handleResolve(item.entityId)}>
                        Đã xử lý xong
                      </Button>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* RIGHT COLUMN: GỢI Ý HÀNH ĐỘNG */}
        <div className="p-5 md:p-8 bg-white">
          <h3 className="flex items-center gap-2 text-sm font-bold uppercase tracking-wider text-[#6B7A8C] mb-5">
            <Lightbulb className="size-4" />
            Gợi ý hành động
          </h3>
          
          <div className="space-y-3">
            <ActionTip 
              title="Nhắc thanh toán hóa đơn quá hạn" 
              desc="Gửi thông báo đến những phòng nợ tiền lâu."
              href="/dashboard/cong-no"
              tone="danger"
            />
            <ActionTip 
              title="Liên hệ khách có hợp đồng sắp hết hạn" 
              desc="Chuẩn bị gia hạn hợp đồng mới hoặc tìm khách mới."
              href="/dashboard/hop-dong"
              tone="warning"
            />
            <ActionTip 
              title="Kiểm tra sự cố đang mở" 
              desc="Phân công bảo trì hoặc liên hệ thợ sửa."
              href="/dashboard/su-co"
              tone="danger"
            />
            <ActionTip 
              title="Xem báo cáo doanh thu" 
              desc="Đánh giá hiệu quả kinh doanh tháng này."
              href="/dashboard/bao-cao"
              tone="default"
            />
          </div>
        </div>

      </div>
    </Card>
  );
}

function ActionTip({ title, desc, href, tone }: { title: string, desc: string, href: string, tone: 'danger' | 'warning' | 'default' }) {
  const hoverBorder = tone === 'danger' ? 'hover:border-[#C75345]/30' : tone === 'warning' ? 'hover:border-[#F2A45B]/40' : 'hover:border-[#4FA7A0]/30';
  const iconColor = tone === 'danger' ? 'text-[#C75345]' : tone === 'warning' ? 'text-[#F2A45B]' : 'text-[#4FA7A0]';

  return (
    <Link href={href} className={`group flex items-start gap-3 rounded-xl border border-transparent p-3 transition-all duration-200 hover:bg-[#F8F3EC]/50 ${hoverBorder}`}>
      <div className={`mt-0.5 flex size-1.5 shrink-0 rounded-full bg-current ${iconColor} group-hover:scale-150 transition-transform`} />
      <div className="min-w-0 flex-1">
        <p className="text-sm font-semibold text-[#243B5A] group-hover:text-[#4FA7A0] transition-colors">{title}</p>
        <p className="text-xs text-[#6B7A8C] mt-0.5">{desc}</p>
      </div>
      <ArrowRight className="size-4 text-[#6B7A8C]/30 transition-all duration-200 group-hover:translate-x-1 group-hover:text-[#4FA7A0]" />
    </Link>
  )
}
