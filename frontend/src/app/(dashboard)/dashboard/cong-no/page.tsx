'use client';

import { useState, useEffect } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { FileText, Loader2, Search, Bell, ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight } from 'lucide-react';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Label } from '@/components/ui/label';
import { toast } from 'sonner';

interface CongNoData {
  phongId: string;
  maPhong: string;
  toaNhaId: string | null;
  tenToaNha: string | null;
  khachThueId: string | null;
  tenKhachThue: string | null;
  soDienThoai: string | null;
  tongNo: number;
  noQuaHan: number;
  danhSachHoaDonNo: Record<string, unknown>[];
}

export default function CongNoPage() {
  const [data, setData] = useState<CongNoData[]>([]);
  const [filteredData, setFilteredData] = useState<CongNoData[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  
  // Pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);

  const fetchData = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams({
        page: (pagination.pageIndex + 1).toString(),
        limit: pagination.pageSize.toString()
      });
      // Currently API doesn't support search natively, but we can pass it if we add it later
      
      const res = await fetch(`/api/cong-no?${params.toString()}`);
      if (!res.ok) throw new Error('Không thể tải dữ liệu công nợ');
      const json = await res.json();
      
      let congNoData = [];
      if (json.data && !Array.isArray(json.data)) {
        congNoData = json.data.data || [];
        setTotalElements(json.data.total || 0);
        setTotalPages(json.data.totalPages || 0);
      } else {
        congNoData = json.data || [];
        setTotalElements(congNoData.length);
        setTotalPages(1);
      }
      
      setData(congNoData);
      setFilteredData(congNoData);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Lỗi tải dữ liệu');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [pagination.pageIndex, pagination.pageSize]);

  useEffect(() => {
    if (!search.trim()) {
      setFilteredData(data);
      return;
    }
    const lower = search.toLowerCase();
    const filtered = data.filter(
      (item) =>
        item.maPhong?.toLowerCase().includes(lower) ||
        item.tenKhachThue?.toLowerCase().includes(lower) ||
        item.soDienThoai?.includes(lower) ||
        item.tenToaNha?.toLowerCase().includes(lower)
    );
    setFilteredData(filtered);
  }, [search, data]);

  const handleRemind = (item: CongNoData) => {
    // In a real app, this would call an API to send a reminder (SMS/Zalo/Email)
    toast.success(`Đã gửi thông báo nhắc nợ cho phòng ${item.maPhong} (${item.tenKhachThue})`);
  };

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
  };

  return (
    <div className="flex flex-col gap-6 p-6 max-w-7xl mx-auto w-full">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Quản lý công nợ</h1>
          <p className="text-muted-foreground mt-2">
            Theo dõi và quản lý công nợ khách thuê, phòng, tòa nhà
          </p>
        </div>
      </div>

      <Card>
        <CardHeader className="pb-3">
          <div className="flex justify-between items-center">
            <div>
              <CardTitle>Danh sách nợ</CardTitle>
              <CardDescription>Tổng quan nợ chưa thanh toán</CardDescription>
            </div>
            <div className="relative w-64">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                type="search"
                placeholder="Tìm phòng, khách thuê..."
                className="pl-8"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Tòa nhà</TableHead>
                  <TableHead>Phòng</TableHead>
                  <TableHead>Khách thuê</TableHead>
                  <TableHead>SĐT</TableHead>
                  <TableHead className="text-right">Tổng nợ</TableHead>
                  <TableHead className="text-right">Nợ quá hạn</TableHead>
                  <TableHead className="text-right">Thao tác</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow>
                    <TableCell colSpan={7} className="h-24 text-center">
                      <Loader2 className="mx-auto h-6 w-6 animate-spin text-muted-foreground" />
                    </TableCell>
                  </TableRow>
                ) : filteredData.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={7} className="h-24 text-center">
                      Không có công nợ nào.
                    </TableCell>
                  </TableRow>
                ) : (
                  filteredData.map((item) => (
                    <TableRow key={item.phongId}>
                      <TableCell>{item.tenToaNha || 'N/A'}</TableCell>
                      <TableCell className="font-medium">{item.maPhong}</TableCell>
                      <TableCell>{item.tenKhachThue || 'N/A'}</TableCell>
                      <TableCell>{item.soDienThoai || 'N/A'}</TableCell>
                      <TableCell className="text-right font-bold text-red-600">
                        {formatCurrency(item.tongNo)}
                      </TableCell>
                      <TableCell className="text-right">
                        {item.noQuaHan > 0 ? (
                          <Badge variant="destructive">{formatCurrency(item.noQuaHan)}</Badge>
                        ) : (
                          <span className="text-muted-foreground">-</span>
                        )}
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="flex justify-end gap-2">
                          <Button variant="outline" size="sm" asChild>
                            <a href={`/dashboard/hoa-don?phongId=${item.phongId}`}>
                              <FileText className="h-4 w-4 mr-1" />
                              Hóa đơn
                            </a>
                          </Button>
                          <Button 
                            variant="secondary" 
                            size="sm" 
                            onClick={() => handleRemind(item)}
                            className="bg-amber-100 text-amber-700 hover:bg-amber-200"
                          >
                            <Bell className="h-4 w-4 mr-1" />
                            Nhắc nợ
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
          
          <div className="flex items-center justify-between mt-4 px-2">
            <div className="text-muted-foreground hidden flex-1 text-sm lg:flex">
              Hiển thị {filteredData.length} / {totalElements} công nợ
            </div>
            <div className="flex w-full items-center gap-8 lg:w-fit">
              <div className="hidden items-center gap-2 lg:flex">
                <Label htmlFor="rows-per-page" className="text-sm font-medium">
                  Số hàng mỗi trang
                </Label>
                <Select
                  value={`${pagination.pageSize}`}
                  onValueChange={(value) => {
                    setPagination(prev => ({ ...prev, pageSize: Number(value), pageIndex: 0 }))
                  }}
                >
                  <SelectTrigger size="sm" className="w-20" id="rows-per-page">
                    <SelectValue placeholder={pagination.pageSize} />
                  </SelectTrigger>
                  <SelectContent side="top">
                    {[10, 20, 30, 40, 50].map((pageSize) => (
                      <SelectItem key={pageSize} value={`${pageSize}`}>
                        {pageSize}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="flex w-fit items-center justify-center text-sm font-medium">
                Trang {pagination.pageIndex + 1} / {totalPages || 1}
              </div>
              <div className="ml-auto flex items-center gap-2 lg:ml-0">
                <Button
                  variant="outline"
                  className="hidden h-8 w-8 p-0 lg:flex"
                  onClick={() => setPagination(prev => ({ ...prev, pageIndex: 0 }))}
                  disabled={pagination.pageIndex === 0}
                >
                  <span className="sr-only">Trang đầu</span>
                  <ChevronsLeft className="h-4 w-4" />
                </Button>
                <Button
                  variant="outline"
                  className="size-8 p-0"
                  onClick={() => setPagination(prev => ({ ...prev, pageIndex: Math.max(0, prev.pageIndex - 1) }))}
                  disabled={pagination.pageIndex === 0}
                >
                  <span className="sr-only">Trang trước</span>
                  <ChevronLeft className="h-4 w-4" />
                </Button>
                <Button
                  variant="outline"
                  className="size-8 p-0"
                  onClick={() => setPagination(prev => ({ ...prev, pageIndex: Math.min(totalPages - 1, prev.pageIndex + 1) }))}
                  disabled={pagination.pageIndex >= totalPages - 1}
                >
                  <span className="sr-only">Trang sau</span>
                  <ChevronRight className="h-4 w-4" />
                </Button>
                <Button
                  variant="outline"
                  className="hidden h-8 w-8 p-0 lg:flex"
                  onClick={() => setPagination(prev => ({ ...prev, pageIndex: totalPages - 1 }))}
                  disabled={pagination.pageIndex >= totalPages - 1}
                >
                  <span className="sr-only">Trang cuối</span>
                  <ChevronsRight className="h-4 w-4" />
                </Button>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
