'use client';

import { useState, useEffect, useCallback } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Bell, CheckCircle2, Clock, Info, FileText, Banknote, AlertTriangle } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { ThongBao } from '@/types';
import { useTenantDashboard } from '../context';
import { cn } from '@/lib/utils';
import { chatSocket } from '@/lib/ws-client';

export default function TenantNotificationsPage() {
  const session = useSession()?.data;
  const accessToken = session?.accessToken;
  const { refreshData } = useTenantDashboard();
  const [notifications, setNotifications] = useState<ThongBao[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentUserId, setCurrentUserId] = useState<string>('');

  const fetchNotifications = useCallback(async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/tenant/thong-bao?limit=50', {
        headers: {
          'Authorization': `Bearer ${accessToken}`
        }
      });
      const data = await res.json();
      if (data.success) {
        setNotifications(data.data.data);
      } else {
        toast.error('Không thể tải thông báo');
      }
    } catch (error) {
      console.error('Lỗi khi tải thông báo:', error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) {
      if (session?.user?.id) {
        setCurrentUserId(session.user.id);
      }
      void fetchNotifications();
      
      const unsub = chatSocket.onThongBao(() => {
        void fetchNotifications();
      });
      
      return () => {
        unsub();
      };
    }
  }, [accessToken, session?.user?.id, fetchNotifications]);

  const markAsRead = async (id: string) => {
    try {
      const res = await fetch(`/api/thong-bao/${id}/da-doc`, {
        method: 'PATCH',
        headers: {
          'Authorization': `Bearer ${session?.accessToken}`
        }
      });
      const data = await res.json();
      if (data.success) {
        setNotifications(notifications.map(n => {
          if (n.id === id || n._id === id) {
            return {
              ...n,
              daDoc: [...(n.daDoc || []), currentUserId]
            };
          }
          return n;
        }));
        refreshData();
      }
    } catch (error) {
      console.error('Lỗi đánh dấu đã đọc:', error);
    }
  };

  const markAllAsRead = async () => {
    const unreadIds = notifications.filter(n => !isRead(n)).map(n => n.id || n._id);
    if (unreadIds.length === 0) {
      toast.success('Không có thông báo mới');
      return;
    }
    
    let count = 0;
    for (const id of unreadIds) {
      try {
        await fetch(`/api/thong-bao/${id}/da-doc`, {
          method: 'PATCH',
          headers: { 'Authorization': `Bearer ${session?.accessToken}` }
        });
        count++;
      } catch (e) {
        console.error(e);
      }
    }
    
    toast.success(`Đã đánh dấu đọc ${count} thông báo`);
    fetchNotifications();
    refreshData();
  };

  const formatDate = (dateStr: string | Date | undefined) => {
    if (!dateStr) return '---';
    const date = new Date(dateStr);
    return date.toLocaleString('vi-VN', {
      hour: '2-digit', minute: '2-digit', second: '2-digit',
      day: '2-digit', month: '2-digit', year: 'numeric'
    });
  };

  const isRead = (notification: ThongBao) => {
    if (!currentUserId || !notification.daDoc) return false;
    return notification.daDoc.includes(currentUserId);
  };

  const getIcon = (type: string, read: boolean) => {
    const dim = read ? 'text-gray-400' : '';
    switch (type) {
      case 'hoaDon':
      case 'INVOICE':
        return <FileText className={`h-5 w-5 ${dim || 'text-[#4FA7A0]'}`} />;
      case 'thanhToan':
      case 'PAYMENT':
        return <Banknote className={`h-5 w-5 ${dim || 'text-emerald-500'}`} />;
      case 'suCo':
      case 'INCIDENT':
        return <AlertTriangle className={`h-5 w-5 ${dim || 'text-orange-500'}`} />;
      case 'hopDong':
      case 'CONTRACT':
        return <FileText className={`h-5 w-5 ${dim || 'text-amber-500'}`} />;
      default:
        return <Info className="h-5 w-5 text-gray-400" />;
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-[70vh]">
        <div className="relative flex justify-center items-center">
          <div className="absolute animate-ping inline-flex h-12 w-12 rounded-full bg-[#4FA7A0]/20 opacity-75"></div>
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#4FA7A0] relative z-10"></div>
        </div>
      </div>
    );
  }

  const unreadCount = notifications.filter(n => !isRead(n)).length;

  return (
    <div className="p-4 md:p-8 max-w-4xl mx-auto space-y-8 pb-24 md:pb-8 min-h-screen">
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 border-b pb-6">
        <div>
          <h1 className="text-3xl font-extrabold tracking-tight bg-gradient-to-r from-gray-900 to-gray-500 bg-clip-text text-transparent">
            Thông Báo
          </h1>
          <p className="text-muted-foreground mt-1 text-sm md:text-base">
            Cập nhật mới nhất từ ban quản lý nhà trọ
          </p>
        </div>
        
        {unreadCount > 0 && (
          <Button 
            onClick={markAllAsRead} 
            className="shrink-0 rounded-full shadow-sm hover:shadow-md transition-all bg-[#4FA7A0] hover:bg-[#3F8780]"
          >
            <CheckCircle2 className="mr-2 h-4 w-4" />
            Đánh dấu đọc tất cả ({unreadCount})
          </Button>
        )}
      </div>

      {notifications.length === 0 ? (
        <Card className="shadow-sm border-dashed border-2 border-gray-200">
          <CardContent className="flex flex-col items-center justify-center py-20 px-4 text-center space-y-5">
            <div className="bg-gradient-to-br from-[#4FA7A0]/10 to-[#4FA7A0]/5 p-6 rounded-full ring-1 ring-[#4FA7A0]/20 shadow-inner">
              <Bell className="h-12 w-12 text-[#4FA7A0]/50" />
            </div>
            <div>
              <h3 className="font-bold text-xl text-gray-800">Không có thông báo mới</h3>
              <p className="text-sm text-gray-500 mt-2 max-w-md mx-auto leading-relaxed">
                Bạn đã xem hết tất cả các thông báo. Khi có cập nhật mới từ hệ thống hoặc ban quản lý, chúng sẽ xuất hiện ở đây.
              </p>
            </div>
          </CardContent>
        </Card>
      ) : (
        <Card className="shadow-sm border-gray-100 overflow-hidden">
          <div className="divide-y divide-gray-100/80">
            {notifications.map((notification, idx) => {
              const id = notification.id || notification._id;
              const read = isRead(notification);
              
              return (
                <div 
                  key={id as string} 
                  className={cn(
                    "group relative p-4 md:p-5 flex gap-4 md:gap-5 transition-colors duration-300 ease-out animate-in fade-in slide-in-from-bottom-4",
                    read 
                      ? "bg-white hover:bg-gray-50/50" 
                      : "bg-gradient-to-r from-[#4FA7A0]/[0.08] to-transparent cursor-pointer hover:bg-[#4FA7A0]/[0.12]"
                  )}
                  onClick={() => !read && markAsRead(id as string)}
                  style={{ animationDelay: `${Math.min(idx * 50, 500)}ms`, animationFillMode: 'both' }}
                >
                  {!read && (
                    <div className="absolute left-0 top-0 bottom-0 w-1 bg-[#4FA7A0]" />
                  )}
                  
                  <div className={cn(
                    "mt-0.5 shrink-0 p-3 rounded-2xl flex items-center justify-center transition-transform duration-300 group-hover:scale-110",
                    read ? "bg-gray-50 text-gray-400" : "bg-white shadow-sm ring-1 ring-black/5 text-[#4FA7A0]"
                  )}>
                    {getIcon(notification.loai as string, read)}
                  </div>
                  
                  <div className="flex-1 space-y-1.5 pt-0.5">
                    <div className="flex justify-between items-start gap-4">
                      <h4 className={cn(
                        "text-base tracking-tight transition-colors duration-200", 
                        read ? "font-medium text-gray-600" : "font-semibold text-gray-900 group-hover:text-[#4FA7A0]"
                      )}>
                        {notification.tieuDe}
                      </h4>
                      {!read && (
                        <span className="inline-flex items-center rounded-full bg-red-100 px-2 py-0.5 text-[10px] font-medium text-red-600 ring-1 ring-inset ring-red-500/20 shrink-0 mt-0.5 shadow-sm">
                          Mới
                        </span>
                      )}
                    </div>
                    
                    <p className={cn(
                      "text-sm leading-relaxed whitespace-pre-wrap", 
                      read ? "text-gray-500" : "text-gray-700"
                    )}>
                      {notification.noiDung}
                    </p>
                    
                    <div className="flex items-center gap-1.5 text-xs text-gray-400 mt-3 pt-2 border-t border-gray-50/50">
                      <Clock className="h-3.5 w-3.5" />
                      {formatDate(notification.ngayGui || (notification as any).ngayTao)}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </Card>
      )}
    </div>
  );
}
