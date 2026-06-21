"use client";

import { useState, useEffect } from "react";
import { format } from "date-fns";
import { vi } from "date-fns/locale";
import { Plus, Pencil, Trash2, Calendar as CalendarIcon, ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { LichHen, Phong, ApiResponse } from "@/types";
import { unwrapPageData } from "@/lib/api-response";
import { useSession } from "next-auth/react";

export function LichHenClient() {
  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const [lichHenList, setLichHenList] = useState<LichHen[]>([]);
  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [selectedLichHen, setSelectedLichHen] = useState<LichHen | null>(null);
  
  const [formData, setFormData] = useState({
    phongId: "",
    hoTen: "",
    soDienThoai: "",
    email: "",
    ngayHen: "",
    gioHen: "",
    ghiChu: "",
    ghiChuAdmin: "",
    trangThai: "PENDING"
  });

  // Pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);

  // Status transition rules
  const allStatusLabels: Record<string, string> = {
    PENDING: "Chờ duyệt",
    CONFIRMED: "Đã xác nhận",
    COMPLETED: "Hoàn thành",
    CANCELLED: "Đã hủy",
    NO_SHOW: "Khách không đến"
  };
  const getAvailableStatuses = (currentStatus: string): string[] => {
    switch (currentStatus) {
      case 'PENDING': return ['PENDING', 'CONFIRMED', 'CANCELLED'];
      case 'CONFIRMED': return ['CONFIRMED', 'COMPLETED', 'NO_SHOW', 'CANCELLED'];
      default: return [currentStatus]; // Terminal statuses: no change allowed
    }
  };
  const isTerminalStatus = (status: string) => ['COMPLETED', 'CANCELLED', 'NO_SHOW'].includes(status);

  const fetchData = async () => {
    try {
      setIsLoading(true);
      const params = new URLSearchParams({
        page: (pagination.pageIndex + 1).toString(),
        limit: pagination.pageSize.toString()
      });
      
      const [lichHenRes, phongRes] = await Promise.all([
        fetch(`/api/lich-hen?${params.toString()}`, {
          headers: { Authorization: `Bearer ${accessToken}` },
        }),
        fetch("/api/phong?page=1&limit=100&simple=true", {
          headers: { Authorization: `Bearer ${accessToken}` },
        })
      ]);
      
      const lichHenData = await lichHenRes.json();
      const phongData = await phongRes.json();
      
      if (lichHenData.success) {
        if (lichHenData.data && !Array.isArray(lichHenData.data)) {
          setLichHenList(lichHenData.data.data || []);
          setTotalElements(lichHenData.data.total || 0);
          setTotalPages(lichHenData.data.totalPages || 0);
        } else {
          setLichHenList(lichHenData.data || []);
          setTotalElements((lichHenData.data || []).length);
          setTotalPages(1);
        }
      }
      if (phongData.success) {
        setPhongList(unwrapPageData<Phong>(phongData.data));
      }
    } catch (error) {
      console.error("Lỗi khi tải dữ liệu:", error);
      toast.error("Không thể tải danh sách lịch hẹn");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    if (accessToken) fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [accessToken, pagination.pageIndex, pagination.pageSize]);

  const handleOpenDialog = (lichHen?: LichHen) => {
    if (lichHen) {
      setSelectedLichHen(lichHen);
      const date = new Date(lichHen.ngayHen);
      setFormData({
        phongId: lichHen.phongId || (lichHen.phong as { _id?: string })?._id || "",
        hoTen: lichHen.hoTen || "",
        soDienThoai: lichHen.soDienThoai || "",
        email: lichHen.email || "",
        ngayHen: format(date, "yyyy-MM-dd"),
        gioHen: format(date, "HH:mm"),
        ghiChu: lichHen.ghiChu || "",
        ghiChuAdmin: lichHen.ghiChuAdmin || "",
        trangThai: lichHen.trangThai || "PENDING"
      });
    } else {
      setSelectedLichHen(null);
      setFormData({
        phongId: "",
        hoTen: "",
        soDienThoai: "",
        email: "",
        ngayHen: format(new Date(), "yyyy-MM-dd"),
        gioHen: "09:00",
        ghiChu: "",
        ghiChuAdmin: "",
        trangThai: "PENDING"
      });
    }
    setIsDialogOpen(true);
  };

  const handleSave = async () => {
    if (!formData.phongId) {
      toast.error("Vui lòng chọn phòng");
      return;
    }
    if (!formData.hoTen) {
      toast.error("Vui lòng nhập họ tên");
      return;
    }
    if (!formData.soDienThoai) {
      toast.error("Vui lòng nhập số điện thoại");
      return;
    }

    try {
      const url = selectedLichHen ? `/api/lich-hen/${selectedLichHen._id}` : "/api/lich-hen";
      const method = selectedLichHen ? "PUT" : "POST";
      
      const ngayHenIso = new Date(`${formData.ngayHen}T${formData.gioHen}:00+07:00`).toISOString();

      const payload = {
        phongId: formData.phongId,
        hoTen: formData.hoTen,
        soDienThoai: formData.soDienThoai,
        email: formData.email,
        ngayHen: ngayHenIso,
        ghiChu: formData.ghiChu,
        ghiChuAdmin: formData.ghiChuAdmin,
        trangThai: formData.trangThai
      };

      const res = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(payload),
      });

      if (!res.ok) {
        let errorMessage = "Đã xảy ra lỗi khi lưu lịch hẹn";
        try {
          const errorText = await res.text();
          try {
            const errorJson = JSON.parse(errorText);
            errorMessage = errorJson.message || errorJson.error || errorMessage;
          } catch {
            errorMessage = errorText || errorMessage;
          }
        } catch {
          // ignore
        }
        toast.error(errorMessage);
        return;
      }

      const data: ApiResponse<LichHen> = await res.json();

      if (data.success) {
        toast.success(data.message);
        setIsDialogOpen(false);
        fetchData();
      } else {
        toast.error(data.message);
      }
    } catch (error) {
      console.error("Lỗi khi lưu lịch hẹn:", error);
      toast.error("Đã xảy ra lỗi khi lưu lịch hẹn");
    }
  };

  const handleDelete = async () => {
    if (!selectedLichHen) return;
    try {
      const res = await fetch(`/api/lich-hen/${selectedLichHen._id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${accessToken}` },
      });

      if (!res.ok) {
        let errorMessage = "Đã xảy ra lỗi khi hủy lịch hẹn";
        try {
          const errorText = await res.text();
          try {
            const errorJson = JSON.parse(errorText);
            errorMessage = errorJson.message || errorJson.error || errorMessage;
          } catch {
            errorMessage = errorText || errorMessage;
          }
        } catch {
          // ignore
        }
        toast.error(errorMessage);
        return;
      }

      const data: ApiResponse<void> = await res.json();
      
      if (data.success) {
        toast.success(data.message);
        setIsDeleteDialogOpen(false);
        fetchData();
      } else {
        toast.error(data.message);
      }
    } catch (error) {
      console.error("Lỗi khi hủy lịch hẹn:", error);
      toast.error("Đã xảy ra lỗi khi hủy lịch hẹn");
    }
  };

  const handleStatusChange = async (id: string, status: string) => {
    try {
      const res = await fetch(`/api/lich-hen/${id}/status`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({ trangThai: status }),
      });

      if (!res.ok) {
        let errorMessage = "Đã xảy ra lỗi khi cập nhật trạng thái";
        try {
          const errorText = await res.text();
          try {
            const errorJson = JSON.parse(errorText);
            errorMessage = errorJson.message || errorJson.error || errorMessage;
          } catch {
            errorMessage = errorText || errorMessage;
          }
        } catch {
          // ignore
        }
        toast.error(errorMessage);
        return;
      }

      const data: ApiResponse<LichHen> = await res.json();
      
      if (data.success) {
        toast.success("Cập nhật trạng thái thành công");
        fetchData();
      } else {
        toast.error(data.message);
      }
    } catch (error) {
      console.error("Lỗi khi cập nhật trạng thái:", error);
      toast.error("Đã xảy ra lỗi khi cập nhật trạng thái");
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'PENDING': return <Badge variant="outline" className="bg-yellow-50 text-yellow-700 border-yellow-200">Chờ duyệt</Badge>;
      case 'CONFIRMED': return <Badge variant="outline" className="bg-[#4FA7A0]/10 text-[#243B5A] border-[#4FA7A0]/30">Đã xác nhận</Badge>;
      case 'COMPLETED': return <Badge variant="outline" className="bg-green-50 text-green-700 border-green-200">Hoàn thành</Badge>;
      case 'CANCELLED': return <Badge variant="outline" className="bg-red-50 text-red-700 border-red-200">Đã hủy</Badge>;
      case 'NO_SHOW': return <Badge variant="outline" className="bg-gray-50 text-gray-700 border-gray-200">Không đến</Badge>;
      default: return <Badge variant="outline">{status}</Badge>;
    }
  };

  const getPhongName = (phongId: string | undefined) => {
    if (!phongId) return "N/A";
    const phong = phongList.find(p => p._id === phongId || p.id === phongId);
    return phong ? phong.maPhong : "N/A";
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-xl md:text-2xl font-bold text-gray-900">Lịch hẹn xem phòng</h1>
          <p className="text-xs md:text-sm text-gray-600">Quản lý lịch hẹn từ khách vãng lai và portal.</p>
        </div>
      </div>

      <div className="border rounded-md bg-white">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Khách hàng</TableHead>
              <TableHead>Phòng</TableHead>
              <TableHead>Thời gian</TableHead>
              <TableHead>Trạng thái</TableHead>
              <TableHead>Ghi chú</TableHead>
              <TableHead className="text-right">Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-gray-500">Đang tải dữ liệu...</TableCell>
              </TableRow>
            ) : lichHenList.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-gray-500">Không có lịch hẹn nào</TableCell>
              </TableRow>
            ) : (
              lichHenList.map((lh) => (
                <TableRow key={lh._id}>
                  <TableCell>
                    <div className="font-medium text-gray-900">{lh.hoTen}</div>
                    <div className="text-xs text-gray-500">{lh.soDienThoai}</div>
                  </TableCell>
                  <TableCell>
                    <span className="font-medium">{(lh.phong as { maPhong?: string })?.maPhong || getPhongName(lh.phongId)}</span>
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center text-sm">
                      <CalendarIcon className="mr-1 h-3.5 w-3.5 text-gray-400" />
                      {format(new Date(lh.ngayHen), "dd/MM/yyyy HH:mm", { locale: vi })}
                    </div>
                  </TableCell>
                  <TableCell>
                    {getStatusBadge(lh.trangThai)}
                  </TableCell>
                  <TableCell className="max-w-[200px]">
                    <div className="truncate text-[#243B5A]" title={lh.ghiChu}>{lh.ghiChu || "-"}</div>
                    {lh.ghiChuAdmin && (
                      <div className="text-[11px] text-[#243B5A] font-medium truncate mt-0.5" title={lh.ghiChuAdmin}>
                        Admin: {lh.ghiChuAdmin}
                      </div>
                    )}
                  </TableCell>
                  <TableCell>
                    <div className="flex space-x-2 justify-end">
                      {lh.trangThai === 'PENDING' && (
                        <Button variant="outline" size="sm" onClick={() => handleStatusChange(lh._id!, 'CONFIRMED')} className="h-8 text-[#243B5A]">Duyệt</Button>
                      )}
                      {lh.trangThai === 'CONFIRMED' && (
                        <Button variant="outline" size="sm" onClick={() => handleStatusChange(lh._id!, 'COMPLETED')} className="h-8 text-green-600">Hoàn thành</Button>
                      )}
                      <Button variant="ghost" size="icon" onClick={() => handleOpenDialog(lh)}>
                        <Pencil className="h-4 w-4" />
                      </Button>
                      <Button variant="ghost" size="icon" onClick={() => { setSelectedLichHen(lh); setIsDeleteDialogOpen(true); }}>
                        <Trash2 className="h-4 w-4 text-red-500" />
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      <div className="flex items-center justify-between px-2">
        <div className="text-muted-foreground hidden flex-1 text-sm lg:flex">
          Hiển thị {lichHenList.length} / {totalElements} lịch hẹn
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

      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="max-w-xl">
          <DialogHeader>
            <DialogTitle>{selectedLichHen ? "Sửa lịch hẹn" : "Thêm lịch hẹn mới"}</DialogTitle>
            <DialogDescription>
              Điền thông tin lịch hẹn xem phòng của khách hàng.
            </DialogDescription>
          </DialogHeader>
          <div className="grid grid-cols-2 gap-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="phongId">Phòng xem <span className="text-red-500">*</span></Label>
              <Select 
                value={formData.phongId} 
                onValueChange={(value) => setFormData({...formData, phongId: value})}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Chọn phòng" />
                </SelectTrigger>
                <SelectContent>
                  {phongList.map((phong) => (
                    <SelectItem key={phong._id} value={phong._id!}>
                      {phong.maPhong} - {(phong.toaNha as { tenToaNha?: string })?.tenToaNha || "N/A"}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="trangThai">Trạng thái</Label>
              <Select 
                value={formData.trangThai} 
                onValueChange={(value) => setFormData({...formData, trangThai: value})}
                disabled={selectedLichHen ? isTerminalStatus(selectedLichHen.trangThai) : false}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Trạng thái" />
                </SelectTrigger>
                <SelectContent>
                  {getAvailableStatuses(selectedLichHen?.trangThai || 'PENDING').map((s) => (
                    <SelectItem key={s} value={s}>{allStatusLabels[s] || s}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="hoTen">Họ tên khách <span className="text-red-500">*</span></Label>
              <Input 
                id="hoTen" 
                value={formData.hoTen}
                onChange={(e) => setFormData({...formData, hoTen: e.target.value})}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="soDienThoai">Số điện thoại <span className="text-red-500">*</span></Label>
              <Input 
                id="soDienThoai" 
                value={formData.soDienThoai}
                onChange={(e) => setFormData({...formData, soDienThoai: e.target.value})}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="ngayHen">Ngày hẹn</Label>
              <Input 
                id="ngayHen" 
                type="date"
                value={formData.ngayHen}
                onChange={(e) => setFormData({...formData, ngayHen: e.target.value})}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="gioHen">Giờ hẹn</Label>
              <Input 
                id="gioHen" 
                type="time"
                value={formData.gioHen}
                onChange={(e) => setFormData({...formData, gioHen: e.target.value})}
              />
            </div>

            <div className="space-y-2 col-span-2">
              <Label htmlFor="email">Email</Label>
              <Input 
                id="email" 
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({...formData, email: e.target.value})}
              />
            </div>

            <div className="space-y-2 col-span-2">
              <Label htmlFor="ghiChu">Ghi chú từ khách hàng</Label>
              <Input 
                id="ghiChu" 
                value={formData.ghiChu}
                onChange={(e) => setFormData({...formData, ghiChu: e.target.value})}
                disabled
              />
            </div>

            <div className="space-y-2 col-span-2">
              <Label htmlFor="ghiChuAdmin" className="font-bold text-[#243B5A]">Ý kiến / Ghi chú của Admin</Label>
              <Input 
                id="ghiChuAdmin" 
                value={formData.ghiChuAdmin}
                onChange={(e) => setFormData({...formData, ghiChuAdmin: e.target.value})}
                placeholder="Nhập ghi chú phản hồi hoặc ý kiến lưu ý nội bộ..."
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDialogOpen(false)}>Hủy</Button>
            <Button onClick={handleSave}>Lưu</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Xác nhận hủy lịch hẹn</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn hủy lịch hẹn của khách <strong>{selectedLichHen?.hoTen}</strong>? 
              Hành động này không thể hoàn tác.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDeleteDialogOpen(false)}>Hủy</Button>
            <Button variant="destructive" onClick={handleDelete}>Hủy lịch hẹn</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
