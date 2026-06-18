import { useState, useEffect } from "react";
import { format } from "date-fns";
import { toast } from "sonner";
import { useSession } from "next-auth/react";
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
  const { data: session } = useSession();

  // Helper to get initial future date and time (minimum 2 hours in the future)
  const getInitialDateTime = () => {
    const now = new Date();
    // Add 2 hours for a safe margin
    now.setHours(now.getHours() + 2);
    
    // If the time is past 18:00 (6 PM) or before 08:00 (8 AM), set to next business day at 09:00 AM
    const hours = now.getHours();
    if (hours >= 18 || hours < 8) {
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      return {
        ngayHen: format(tomorrow, "yyyy-MM-dd"),
        gioHen: "09:00"
      };
    }
    
    // Round to next hour
    const roundedHours = now.getMinutes() > 0 ? now.getHours() + 1 : now.getHours();
    if (roundedHours >= 24) {
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      return {
        ngayHen: format(tomorrow, "yyyy-MM-dd"),
        gioHen: "09:00"
      };
    }
    const formattedHour = String(roundedHours).padStart(2, '0');
    return {
      ngayHen: format(now, "yyyy-MM-dd"),
      gioHen: `${formattedHour}:00`
    };
  };

  const initialDateTime = getInitialDateTime();

  const [formData, setFormData] = useState({
    hoTen: "",
    soDienThoai: "",
    email: "",
    ngayHen: initialDateTime.ngayHen,
    gioHen: initialDateTime.gioHen,
    ghiChu: "",
    honeypot: "",
  });

  // Autofill user info if logged in
  useEffect(() => {
    if (isOpen && session?.user) {
      setFormData((prev) => ({
        ...prev,
        hoTen: session.user.name || prev.hoTen,
        soDienThoai: (session.user as any).phone || prev.soDienThoai,
        email: session.user.email || prev.email,
      }));
    }
  }, [isOpen, session]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.hoTen || !formData.soDienThoai || !formData.ngayHen || !formData.gioHen) {
      toast.error("Vui lòng điền đầy đủ các trường bắt buộc");
      return;
    }

    const ngayHenDate = new Date(`${formData.ngayHen}T${formData.gioHen}:00+07:00`);
    if (ngayHenDate <= new Date()) {
      toast.error("Thời gian hẹn phải ở tương lai");
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
      const ngayHenIso = ngayHenDate.toISOString();

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
          honeypot: formData.honeypot,
        }),
      });
      
      if (!res.ok) {
        let errorMessage = "Đã xảy ra lỗi. Vui lòng thử lại.";
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

      const data = await res.json();
      if (data.success) {
        toast.success("Đặt lịch xem phòng thành công. Chúng tôi sẽ liên hệ lại sớm nhất.");
        onClose();
        const resetDateTime = getInitialDateTime();
        setFormData({
          hoTen: "",
          soDienThoai: "",
          email: "",
          ngayHen: resetDateTime.ngayHen,
          gioHen: resetDateTime.gioHen,
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
                autoComplete="off"
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
                autoComplete="off"
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
                autoComplete="off"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="grid gap-2">
                <Label htmlFor="ngayHen">Ngày hẹn <span className="text-red-500">*</span></Label>
                <Input
                  id="ngayHen"
                  type="date"
                  min={format(new Date(), "yyyy-MM-dd")}
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
