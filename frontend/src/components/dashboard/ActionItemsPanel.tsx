'use client';

import { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { AlertCircle, CheckCircle2 } from 'lucide-react';
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

export function ActionItemsPanel() {
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

  if (loading) return <div className="p-8 text-center text-gray-500">Đang tải...</div>;

  return (
    <Card className="h-full">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <AlertCircle className="w-5 h-5 text-orange-500" />
          Việc Cần Làm Ưu Tiên
        </CardTitle>
        <CardDescription>Các cảnh báo bất thường cần xử lý ngay</CardDescription>
      </CardHeader>
      <CardContent>
        {items.length === 0 ? (
          <div className="text-center text-gray-500 py-8">
            <CheckCircle2 className="w-12 h-12 text-green-400 mx-auto mb-3" />
            <p>Tuyệt vời! Không có cảnh báo bất thường nào.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {items.map((item, idx) => (
              <div key={idx} className="flex flex-col border-l-4 border-red-500 bg-red-50 p-4 rounded-r-md">
                <div className="flex justify-between items-start">
                  <div>
                    <h4 className="font-semibold text-red-900">{item.title}</h4>
                    <p className="text-sm text-red-700 mt-1">{item.description}</p>
                  </div>
                  <span className="text-xs font-bold text-red-600 bg-red-200 px-2 py-1 rounded">
                    {item.priority}
                  </span>
                </div>
                <div className="mt-3 flex gap-2">
                  <Button size="sm" variant="outline" asChild className="bg-white">
                    <Link href={item.href}>Xem phòng</Link>
                  </Button>
                  <Button size="sm" variant="destructive" onClick={() => handleResolve(item.entityId)}>
                    Đã xử lý xong
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
