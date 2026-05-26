import { useState } from "react";
import { format } from "date-fns";
import { toast } from "sonner";
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
import { Button } from "@/components/ui/button";

interface DatLichHenDialogProps {
  isOpen: boolean;
  onClose: () => void;
  phongId: string;
  maPhong: string;
}

export function DatLichHenDialog({ isOpen, onClose, phongId, maPhong }: DatLichHenDialogProps) {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [formData, setFormData] = useState({
    hoTen: "",
    soDienThoai: "",
    email: "",
    ngayHen: format(new Date(), "yyyy-MM-dd"),
    gioHen: "09:00",
    ghiChu: "",
    honeypot: "",
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.hoTen || !formData.soDienThoai || !formData.ngayHen || !formData.gioHen) {
      toast.error("Vui lòng điền đầy đủ các trường bắt buộc");
      return;
    }

    if (formData.honeypot) {
      // Spam detected via honeypot
      toast.success("Đặt lịch xem phòng thành công. Chúng tôi sẽ liên hệ lại sớm nhất.");
      onClose();
      return;
    }

    try {
      setIsSubmitting(true);
      const ngayHenIso = new Date(`${formData.ngayHen}T${formData.gioHen}:00+07:00`).toISOString();

      const res = await fetch("/api/lich-hen", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          phongId,
          hoTen: formData.hoTen,
          soDienThoai: formData.soDienThoai,
          email: formData.email,
          ngayHen: ngayHenIso,
          ghiChu: formData.ghiChu,
        }),
      });

      const data = await res.json();
      if (data.success) {
        toast.success("Đặt lịch xem phòng thành công. Chúng tôi sẽ liên hệ lại sớm nhất.");
        onClose();
        setFormData({
          hoTen: "",
          soDienThoai: "",
          email: "",
          ngayHen: format(new Date(), "yyyy-MM-dd"),
          gioHen: "09:00",
          ghiChu: "",
          honeypot: "",
        });
      } else {
        toast.error(data.message || "Đã xảy ra lỗi");
      }
    } catch (error) {
      console.error("Lỗi đặt lịch hẹn:", error);
      toast.error("Đã xảy ra lỗi. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="sm:max-w-[425px]">
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>Đặt lịch xem phòng</DialogTitle>
            <DialogDescription>
              Điền thông tin để đặt lịch xem phòng {maPhong}
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-4 py-4">
            <div className="grid gap-2">
              <Label htmlFor="hoTen">Họ và tên <span className="text-red-500">*</span></Label>
              <Input
                id="hoTen"
                value={formData.hoTen}
                onChange={(e) => setFormData({ ...formData, hoTen: e.target.value })}
                placeholder="Nhập họ và tên của bạn"
                required
              />
            </div>
            <div className="grid gap-2">
              <Label htmlFor="soDienThoai">Số điện thoại <span className="text-red-500">*</span></Label>
              <Input
                id="soDienThoai"
                value={formData.soDienThoai}
                onChange={(e) => setFormData({ ...formData, soDienThoai: e.target.value })}
                placeholder="Nhập số điện thoại của bạn"
                required
              />
            </div>
            <div className="grid gap-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                placeholder="Nhập email (không bắt buộc)"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="grid gap-2">
                <Label htmlFor="ngayHen">Ngày hẹn <span className="text-red-500">*</span></Label>
                <Input
                  id="ngayHen"
                  type="date"
                  value={formData.ngayHen}
                  onChange={(e) => setFormData({ ...formData, ngayHen: e.target.value })}
                  required
                />
              </div>
              <div className="grid gap-2">
                <Label htmlFor="gioHen">Giờ hẹn <span className="text-red-500">*</span></Label>
                <Input
                  id="gioHen"
                  type="time"
                  value={formData.gioHen}
                  onChange={(e) => setFormData({ ...formData, gioHen: e.target.value })}
                  required
                />
              </div>
            </div>
            <div className="grid gap-2">
              <Label htmlFor="ghiChu">Ghi chú thêm</Label>
              <Input
                id="ghiChu"
                value={formData.ghiChu}
                onChange={(e) => setFormData({ ...formData, ghiChu: e.target.value })}
                placeholder="Bạn có yêu cầu gì đặc biệt không?"
              />
            </div>
            
            {/* Honeypot field - invisible to real users */}
            <div className="hidden" aria-hidden="true">
              <Label htmlFor="website">Website</Label>
              <Input
                id="website"
                type="text"
                tabIndex={-1}
                value={formData.honeypot}
                onChange={(e) => setFormData({ ...formData, honeypot: e.target.value })}
                autoComplete="off"
              />
            </div>

            <div className="text-xs text-slate-500 mt-2">
              Bằng việc gửi yêu cầu này, bạn đồng ý để chủ phòng/quản lý liên hệ qua số điện thoại và email đã cung cấp.
            </div>
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={onClose} disabled={isSubmitting}>
              Hủy
            </Button>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Đang gửi..." : "Gửi yêu cầu"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
