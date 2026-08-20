"use client"

import { useState, useEffect } from "react"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import * as z from "zod"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { toast } from "sonner"
import { Loader2 } from "lucide-react"
import { KhoTaiSan } from "@/types"

const capPhatTatCaSchema = z.object({
  soLuongMoiPhong: z.coerce.number().min(1, "Số lượng mỗi phòng phải > 0"),
  giaTri: z.coerce.number().min(0).optional(),
  ghiChu: z.string().optional()
})

interface CapPhatTatCaDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  khoTaiSan: KhoTaiSan
  accessToken: string
  onSuccess: (result: any) => void
}

export function CapPhatTatCaDialog({ open, onOpenChange, khoTaiSan, accessToken, onSuccess }: CapPhatTatCaDialogProps) {
  const [loading, setLoading] = useState(false)

  const { register, handleSubmit, formState: { errors }, reset } = useForm<any>({
    resolver: zodResolver(capPhatTatCaSchema),
    defaultValues: {
      soLuongMoiPhong: 1,
      giaTri: 0,
      ghiChu: ""
    }
  })

  useEffect(() => {
    if (open) {
      reset({
        soLuongMoiPhong: 1,
        giaTri: 0,
        ghiChu: "",
      })
    }
  }, [open, reset])

  const onSubmit = async (data: any) => {
    setLoading(true)
    try {
      const url = `/api/kho-tai-san/${khoTaiSan.id || khoTaiSan._id}/cap-phat-tat-ca`
        
      const res = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`
        },
        body: JSON.stringify(data)
      })
      const json = await res.json()
      if (json.success) {
        toast.success("Cấp phát bổ sung thành công")
        reset()
        onSuccess(json.data) // Return result data to show a summary
      } else {
        toast.error(json.message || "Có lỗi xảy ra")
      }
    } catch (e: any) {
      toast.error(e.message || "Lỗi kết nối")
    } finally {
      setLoading(false)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Cấp phát bổ sung tất cả phòng</DialogTitle>
          <DialogDescription>
            Hệ thống sẽ duyệt qua tất cả các phòng và cấp phát sao cho mỗi phòng đạt đủ số lượng bạn nhập ở dưới.
            <br/>
            Ví dụ: Nếu kho có 18 tủ lạnh, bạn nhập <strong>1</strong> thì 18 phòng đầu tiên mỗi phòng sẽ nhận 1 cái.
            <br/>
            Khả dụng hiện tại: <strong>{khoTaiSan.soLuongKhaDung || 0}</strong>
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          <div className="grid gap-2">
            <Label htmlFor="soLuongMoiPhong">Số lượng tài sản cho MỖI PHÒNG <span className="text-red-500">*</span></Label>
            <Input id="soLuongMoiPhong" type="number"
              {...register("soLuongMoiPhong")}
            />
            {errors.soLuongMoiPhong && <p className="text-sm text-red-500">{errors.soLuongMoiPhong.message as string}</p>}
          </div>

          <div className="grid gap-2">
            <Label htmlFor="giaTri">Giá trị quy đổi (VND)</Label>
            <Input id="giaTri" type="number" {...register("giaTri")} />
          </div>

          <div className="grid gap-2">
            <Label htmlFor="ghiChu">Ghi chú</Label>
            <Input id="ghiChu" {...register("ghiChu")} />
          </div>

          <DialogFooter className="mt-6">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>Hủy</Button>
            <Button type="submit" disabled={loading || khoTaiSan.soLuongKhaDung === 0}>
              {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Xác nhận Cấp phát
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}

