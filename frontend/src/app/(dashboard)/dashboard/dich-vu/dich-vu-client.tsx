"use client";

import { useState, useEffect } from "react";
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
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { toast } from "sonner";
import { DichVu, ApiResponse } from "@/types";
import { unwrapPageData } from "@/lib/api-response";

export function DichVuClient() {
  const [dichVuList, setDichVuList] = useState<DichVu[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [selectedDichVu, setSelectedDichVu] = useState<DichVu | null>(null);
  
  const [formData, setFormData] = useState({
    tenDichVu: "",
    loaiTinhPhi: "FIXED",
    donVi: "",
    donGiaMacDinh: 0,
    batBuoc: false
  });

  const fetchDichVu = async () => {
    try {
      setIsLoading(true);
      const res = await fetch("/api/dich-vu");
      const data: ApiResponse<DichVu[]> = await res.json();
      if (data.success) {
        setDichVuList(unwrapPageData<DichVu>(data.data));
      }
    } catch (error) {
      console.error("Lỗi khi tải dịch vụ:", error);
      toast.error("Không thể tải danh sách dịch vụ");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchDichVu();
  }, []);

  const handleOpenDialog = (dichVu?: DichVu) => {
    if (dichVu) {
      setSelectedDichVu(dichVu);
      setFormData({
        tenDichVu: dichVu.tenDichVu || "",
        loaiTinhPhi: dichVu.loaiTinhPhi || "FIXED",
        donVi: dichVu.donVi || "",
        donGiaMacDinh: dichVu.donGiaMacDinh || 0,
        batBuoc: dichVu.batBuoc || false
      });
    } else {
      setSelectedDichVu(null);
      setFormData({
        tenDichVu: "",
        loaiTinhPhi: "FIXED",
        donVi: "",
        donGiaMacDinh: 0,
        batBuoc: false
      });
    }
    setIsDialogOpen(true);
  };

  const handleSave = async () => {
    try {
      const url = selectedDichVu ? `/api/dich-vu/${selectedDichVu._id}` : "/api/dich-vu";
      const method = selectedDichVu ? "PUT" : "POST";

      const res = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      const data: ApiResponse<DichVu> = await res.json();

      if (data.success) {
        toast.success(data.message);
        setIsDialogOpen(false);
        fetchDichVu();
      } else {
        toast.error(data.message);
      }
    } catch (error) {
      console.error("Lỗi khi lưu dịch vụ:", error);
      toast.error("Đã xảy ra lỗi khi lưu dịch vụ");
    }
  };

  const handleDelete = async () => {
    if (!selectedDichVu) return;
    try {
      const res = await fetch(`/api/dich-vu/${selectedDichVu._id}`, {
        method: "DELETE",
      });
      const data: ApiResponse<void> = await res.json();
      
      if (data.success) {
        toast.success(data.message);
        setIsDeleteDialogOpen(false);
        fetchDichVu();
      } else {
        toast.error(data.message);
      }
    } catch (error) {
      console.error("Lỗi khi xóa dịch vụ:", error);
      toast.error("Đã xảy ra lỗi khi xóa dịch vụ");
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-end">
        <Button onClick={() => handleOpenDialog()}>
          <Plus className="mr-2 h-4 w-4" /> Thêm dịch vụ
        </Button>
      </div>

      <div className="border rounded-md">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Tên dịch vụ</TableHead>
              <TableHead>Loại tính phí</TableHead>
              <TableHead>Đơn vị</TableHead>
              <TableHead className="text-right">Đơn giá mặc định</TableHead>
              <TableHead className="text-center">Bắt buộc</TableHead>
              <TableHead className="w-[100px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center">Đang tải...</TableCell>
              </TableRow>
            ) : dichVuList.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center">Không có dữ liệu</TableCell>
              </TableRow>
            ) : (
              dichVuList.map((dv) => (
                <TableRow key={dv._id}>
                  <TableCell className="font-medium">{dv.tenDichVu}</TableCell>
                  <TableCell>{dv.loaiTinhPhi}</TableCell>
                  <TableCell>{dv.donVi}</TableCell>
                  <TableCell className="text-right">
                    {new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(dv.donGiaMacDinh || 0)}
                  </TableCell>
                  <TableCell className="text-center">
                    {dv.batBuoc ? "Có" : "Không"}
                  </TableCell>
                  <TableCell>
                    <div className="flex space-x-2 justify-end">
                      <Button variant="ghost" size="icon" onClick={() => handleOpenDialog(dv)}>
                        <Pencil className="h-4 w-4" />
                      </Button>
                      <Button variant="ghost" size="icon" onClick={() => { setSelectedDichVu(dv); setIsDeleteDialogOpen(true); }}>
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

      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{selectedDichVu ? "Sửa dịch vụ" : "Thêm dịch vụ mới"}</DialogTitle>
            <DialogDescription>
              Điền thông tin dịch vụ vào form bên dưới.
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="tenDichVu" className="text-right">Tên dịch vụ</Label>
              <Input 
                id="tenDichVu" 
                className="col-span-3" 
                value={formData.tenDichVu}
                onChange={(e) => setFormData({...formData, tenDichVu: e.target.value})}
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="loaiTinhPhi" className="text-right">Loại tính phí</Label>
              <div className="col-span-3">
                <Select 
                  value={formData.loaiTinhPhi} 
                  onValueChange={(value) => setFormData({...formData, loaiTinhPhi: value})}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Chọn loại tính phí" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="FIXED">Cố định (FIXED)</SelectItem>
                    <SelectItem value="PER_PERSON">Theo người (PER_PERSON)</SelectItem>
                    <SelectItem value="PER_ROOM">Theo phòng (PER_ROOM)</SelectItem>
                    <SelectItem value="PER_UNIT">Theo chỉ số (PER_UNIT)</SelectItem>
                    <SelectItem value="PERCENT">Phần trăm (PERCENT)</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="donVi" className="text-right">Đơn vị tính</Label>
              <Input 
                id="donVi" 
                className="col-span-3" 
                placeholder="VD: kWh, m3, người, tháng"
                value={formData.donVi}
                onChange={(e) => setFormData({...formData, donVi: e.target.value})}
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="donGiaMacDinh" className="text-right">Đơn giá</Label>
              <Input 
                id="donGiaMacDinh" 
                type="number"
                className="col-span-3" 
                value={formData.donGiaMacDinh}
                onChange={(e) => setFormData({...formData, donGiaMacDinh: Number(e.target.value)})}
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="batBuoc" className="text-right">Bắt buộc</Label>
              <div className="col-span-3 flex items-center space-x-2">
                <Checkbox 
                  id="batBuoc" 
                  checked={formData.batBuoc}
                  onCheckedChange={(checked) => setFormData({...formData, batBuoc: checked === true})}
                />
                <label htmlFor="batBuoc" className="text-sm font-medium leading-none">
                  Dịch vụ bắt buộc khi lập hợp đồng
                </label>
              </div>
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
              Bạn có chắc chắn muốn xóa dịch vụ <strong>{selectedDichVu?.tenDichVu}</strong>? 
              Hành động này không thể hoàn tác và có thể ảnh hưởng đến các hợp đồng đang sử dụng dịch vụ này.
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
