'use client';

import { useState, useEffect, useCallback } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Bell, CheckCircle2, Clock, Info, FileText, Banknote, AlertTriangle } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { ThongBao } from '@/types';
import { useTenantDashboard } from '../context';

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
        // Update local state
        setNotifications(notifications.map(n => {
          if (n.id === id || n._id === id) {
            return {
              ...n,
              daDoc: [...(n.daDoc || []), currentUserId] // Optimistic update
            };
          }
          return n;
        }));
        
        // Refresh context unread count
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
    
    // Simplistic loop for MVP. In reality, we'd want a bulk API
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
      hour: '2-digit', minute: '2-digit',
      day: '2-digit', month: '2-digit', year: 'numeric'
    });
  };

  const isRead = (notification: ThongBao) => {
    if (!currentUserId || !notification.daDoc) return false;
    return notification.daDoc.includes(currentUserId);
  };

  const getIcon = (type: string) => {
    switch (type) {
      case 'hoaDon':
      case 'INVOICE':
        return <FileText className="h-5 w-5 text-blue-500" />;
      case 'thanhToan':
      case 'PAYMENT':
        return <Banknote className="h-5 w-5 text-green-500" />;
      case 'suCo':
      case 'INCIDENT':
        return <AlertTriangle className="h-5 w-5 text-orange-500" />;
      case 'hopDong':
      case 'CONTRACT':
        return <FileText className="h-5 w-5 text-purple-500" />;
      default:
        return <Info className="h-5 w-5 text-gray-500" />;
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  const unreadCount = notifications.filter(n => !isRead(n)).length;

  return (
    <div className="p-4 md:p-8 max-w-4xl mx-auto space-y-6 pb-24 md:pb-8">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Thông Báo</h1>
          <p className="text-muted-foreground mt-1">Cập nhật mới nhất từ quản lý nhà trọ</p>
        </div>
        
        {unreadCount > 0 && (
          <Button variant="outline" onClick={markAllAsRead} className="shrink-0">
            <CheckCircle2 className="mr-2 h-4 w-4" />
            Đánh dấu đọc tất cả ({unreadCount})
          </Button>
        )}
      </div>

      {notifications.length === 0 ? (
        <Card className="bg-gray-50 border-dashed border-2">
          <CardContent className="flex flex-col items-center justify-center p-12 text-center space-y-4">
            <div className="bg-gray-100 p-4 rounded-full text-gray-400">
              <Bell className="h-12 w-12" />
            </div>
            <div>
              <h3 className="font-bold text-lg text-gray-800">Không có thông báo</h3>
              <p className="text-sm text-gray-500 mt-1 max-w-md mx-auto">
                Bạn chưa nhận được thông báo nào từ hệ thống.
              </p>
            </div>
          </CardContent>
        </Card>
      ) : (
        <Card>
          <div className="divide-y">
            {notifications.map((notification) => {
              const id = notification.id || notification._id;
              const read = isRead(notification);
              
              return (
                <div 
                  key={id as string} 
                  className={`p-4 md:p-5 flex gap-4 transition-colors ${read ? 'bg-white' : 'bg-blue-50/50 hover:bg-blue-50'} cursor-pointer`}
                  onClick={() => !read && markAsRead(id as string)}
                >
                  <div className={`mt-1 shrink-0 bg-white p-2 rounded-full border ${!read ? 'border-blue-200 shadow-sm' : 'border-gray-100'}`}>
                    {getIcon(notification.loai as string)}
                  </div>
                  
                  <div className="flex-1 space-y-1">
                    <div className="flex justify-between items-start">
                      <h4 className={`text-base ${read ? 'font-medium text-gray-800' : 'font-bold text-gray-900'}`}>
                        {notification.tieuDe}
                      </h4>
                      {!read && (
                        <span className="w-2.5 h-2.5 rounded-full bg-blue-600 shrink-0 mt-1.5 hidden md:block"></span>
                      )}
                    </div>
                    
                    <p className={`text-sm ${read ? 'text-gray-600' : 'text-gray-800'}`}>
                      {notification.noiDung}
                    </p>
                    
                    <div className="flex items-center gap-1.5 text-xs text-gray-500 mt-2">
                      <Clock className="h-3.5 w-3.5" />
                      {formatDate(notification.ngayGui || notification.taoLuc)}
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
