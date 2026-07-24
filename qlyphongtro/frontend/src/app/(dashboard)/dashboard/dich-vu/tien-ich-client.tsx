"use client";

import { useState, useEffect, useCallback } from "react";
import { Plus, Pencil, Trash2 } from "lucide-react";
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
import { toast } from "sonner";
import { ApiResponse } from "@/types";
import { unwrapPageData } from "@/lib/api-response";
import { DashboardCard } from "@/components/dashboard/shared-ui";
import { useSession } from "next-auth/react";

interface TienIch {
  _id: string;
  ten: string;
  bieuTuong?: string;
}

export function TienIchClient() {
  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const [tienIchList, setTienIchList] = useState<TienIch[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [selectedTienIch, setSelectedTienIch] = useState<TienIch | null>(null);
  
  const [formData, setFormData] = useState({
    ten: "",
    bieuTuong: ""
  });

  const fetchTienIch = useCallback(async () => {
    try {
      setIsLoading(true);
      const res = await fetch("/api/tien-ich", {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const data: ApiResponse<TienIch[]> = await res.json();
      if (data.success) {
        setTienIchList(unwrapPageData<TienIch>(data.data));
      }
    } catch (error) {
      console.error("Lỗi khi tải tiện ích:", error);
      toast.error("Không thể tải danh sách tiện ích");
    } finally {
      setIsLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) fetchTienIch();
  }, [accessToken, fetchTienIch]);

  const handleOpenDialog = (tienIch?: TienIch) => {
    if (tienIch) {
      setSelectedTienIch(tienIch);
      setFormData({
        ten: tienIch.ten || "",
        bieuTuong: tienIch.bieuTuong || ""
      });
    } else {
      setSelectedTienIch(null);
      setFormData({
        ten: "",
        bieuTuong: ""
      });
    }
    setIsDialogOpen(true);
  };

  const handleSave = async () => {
    try {
      const url = selectedTienIch ? `/api/tien-ich/${selectedTienIch._id}` : "/api/tien-ich";
      const method = selectedTienIch ? "PUT" : "POST";

      const res = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(formData),
      });

      const data: ApiResponse<TienIch> = await res.json();

      if (data.success) {
        toast.success(data.message);
        setIsDialogOpen(false);
        fetchTienIch();
      } else {
        toast.error(data.message);
      }
    } catch (error) {
      console.error("Lỗi khi lưu tiện ích:", error);
      toast.error("Đã xảy ra lỗi khi lưu tiện ích");
    }
  };

  const handleDelete = async () => {
    if (!selectedTienIch) return;
    try {
      const res = await fetch(`/api/tien-ich/${selectedTienIch._id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const data: ApiResponse<void> = await res.json();
      
      if (data.success) {
        toast.success(data.message);
        setIsDeleteDialogOpen(false);
        fetchTienIch();
      } else {
        toast.error(data.message);
      }
    } catch (error) {
      console.error("Lỗi khi xóa tiện ích:", error);
      toast.error("Đã xảy ra lỗi khi xóa tiện ích");
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-end">
        <Button onClick={() => handleOpenDialog()}>
          <Plus className="mr-2 h-4 w-4" /> Thêm tiện ích
        </Button>
      </div>

      <DashboardCard className="overflow-hidden border-0 shadow-sm ring-1 ring-[#E5E0D8]">
        <Table>
          <TableHeader className="bg-[#F8F3EC]">
            <TableRow>
              <TableHead className="font-semibold text-[#243B5A]">Tên tiện ích</TableHead>
              <TableHead className="font-semibold text-[#243B5A]">Biểu tượng (Icon)</TableHead>
              <TableHead className="w-[100px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={3} className="text-center h-24 text-gray-500">Đang tải...</TableCell>
              </TableRow>
            ) : tienIchList.length === 0 ? (
              <TableRow>
                <TableCell colSpan={3} className="text-center h-24 text-gray-500">Không có dữ liệu</TableCell>
              </TableRow>
            ) : (
              tienIchList.map((ti) => (
                <TableRow key={ti._id} className="hover:bg-[#F8F3EC]/50 transition-colors">
                  <TableCell className="font-medium text-[#243B5A]">{ti.ten}</TableCell>
                  <TableCell className="text-gray-600">{ti.bieuTuong}</TableCell>
                  <TableCell>
                    <div className="flex space-x-2 justify-end">
                      <Button variant="ghost" size="icon" onClick={() => handleOpenDialog(ti)} className="h-8 w-8 text-[#267D76] hover:text-[#1a5c56] hover:bg-[#267D76]/10">
                        <Pencil className="h-4 w-4" />
                      </Button>
                      <Button variant="ghost" size="icon" onClick={() => { setSelectedTienIch(ti); setIsDeleteDialogOpen(true); }} className="h-8 w-8 text-red-500 hover:text-red-700 hover:bg-red-50">
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </DashboardCard>

      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{selectedTienIch ? "Sửa tiện ích" : "Thêm tiện ích mới"}</DialogTitle>
            <DialogDescription>
              Điền thông tin tiện ích vào form bên dưới.
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="tenTienIch" className="text-right">Tên tiện ích</Label>
              <Input 
                id="tenTienIch" 
                className="col-span-3" 
                value={formData.ten}
                onChange={(e) => setFormData({...formData, ten: e.target.value})}
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="bieuTuong" className="text-right">Biểu tượng</Label>
              <Input 
                id="bieuTuong" 
                className="col-span-3" 
                placeholder="VD: wifi, tv, air-vent"
                value={formData.bieuTuong}
                onChange={(e) => setFormData({...formData, bieuTuong: e.target.value})}
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
            <DialogTitle>Xác nhận xóa</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn xóa tiện ích <strong>{selectedTienIch?.ten}</strong>? 
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDeleteDialogOpen(false)}>Hủy</Button>
            <Button variant="destructive" onClick={handleDelete}>Xóa</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
