"use client"

import { useState } from "react"
import { useSession } from "next-auth/react"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import * as z from "zod"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { toast } from "sonner"
import { Loader2, Upload } from "lucide-react"
import { KhoTaiSan } from "@/types"

const formSchema = z.object({
  nhaTroId: z.string().min(1, "Nhà trọ ID không được trống"),
  tenTaiSan: z.string().min(1, "Tên tài sản không được để trống"),
  hinhAnh: z.string().optional(),
  tongSoLuong: z.coerce.number().min(0, "Số lượng phải >= 0"),
  tinhTrang: z.string().min(1, "Vui lòng chọn tình trạng"),
  ghiChu: z.string().optional(),
})

type FormValues = z.infer<typeof formSchema>

interface KhoTaiSanFormProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  initialData: KhoTaiSan | null
  nhaTroId: string
  onSuccess: () => void
}

export function KhoTaiSanForm({ open, onOpenChange, initialData, nhaTroId, onSuccess }: KhoTaiSanFormProps) {
  const { data: session } = useSession()
  const accessToken = session?.accessToken
  
  const [loading, setLoading] = useState(false)
  const [isUploading, setIsUploading] = useState(false)

  const { register, handleSubmit, formState: { errors }, setValue, watch } = useForm<FormValues>({
    resolver: zodResolver(formSchema) as any,
    defaultValues: {
      nhaTroId: initialData?.nhaTroId || nhaTroId,
      tenTaiSan: initialData?.tenTaiSan || "",
      hinhAnh: initialData?.hinhAnh || "",
      tongSoLuong: initialData?.tongSoLuong || 0,
      tinhTrang: initialData?.tinhTrang || "Mới",
      ghiChu: initialData?.ghiChu || "",
    }
  })

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file || !accessToken) return

    setIsUploading(true)
    try {
      const formData = new FormData()
      formData.append("file", file)
      const res = await fetch("/api/upload", {
        method: "POST",
        headers: { Authorization: `Bearer ${accessToken}` },
        body: formData,
      })
      const result = await res.json()
      if (result.success) {
        const url = result.data?.url || result.data?.secure_url || ""
        setValue("hinhAnh", url, { shouldValidate: true })
        toast.success("Tải ảnh lên thành công")
      } else {
        toast.error(result.message || "Lỗi khi tải ảnh lên")
      }
    } catch (err) {
      toast.error("Có lỗi khi tải ảnh lên")
    } finally {
      setIsUploading(false)
    }
  }

  const onSubmit = async (data: FormValues) => {
    if (!accessToken) return
    setLoading(true)
    try {
      const url = initialData 
        ? `/api/kho-tai-san/${initialData.id || initialData._id}`
        : `/api/kho-tai-san`
      const method = initialData ? "PUT" : "POST"
      
      const res = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`
        },
        body: JSON.stringify(data)
      })
      const json = await res.json()
      if (json.success) {
        toast.success(initialData ? "Đã cập nhật kho" : "Đã nhập kho tài sản mới")
        onSuccess()
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
          <DialogTitle>{initialData ? "Sửa tài sản kho" : "Thêm tài sản vào kho"}</DialogTitle>
          <DialogDescription>
            {initialData ? "Chỉnh sửa thông tin tài sản trong kho hoặc nhập thêm số lượng." : "Tạo mới một loại tài sản trong kho để sau này cấp phát."}
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit as any)} className="space-y-4">
          <div className="grid gap-2">
            <Label htmlFor="tenTaiSan">Tên tài sản <span className="text-red-500">*</span></Label>
            <Input id="tenTaiSan" {...register("tenTaiSan")} />
            {errors.tenTaiSan && <p className="text-sm text-red-500">{errors.tenTaiSan.message}</p>}
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="grid gap-2">
              <Label htmlFor="tongSoLuong">Tổng số lượng <span className="text-red-500">*</span></Label>
              <Input id="tongSoLuong" type="number" min={initialData ? initialData.soLuongDaCapPhat : 0} {...register("tongSoLuong")} />
              {errors.tongSoLuong && <p className="text-sm text-red-500">{errors.tongSoLuong.message}</p>}
            </div>
            <div className="grid gap-2">
              <Label htmlFor="tinhTrang">Tình trạng <span className="text-red-500">*</span></Label>
              <Select value={watch("tinhTrang")} onValueChange={(val) => setValue("tinhTrang", val)}>
                <SelectTrigger>
                  <SelectValue placeholder="Chọn tình trạng" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="Mới">Mới</SelectItem>
                  <SelectItem value="Tốt">Tốt</SelectItem>
                  <SelectItem value="Bình thường">Bình thường</SelectItem>
                  <SelectItem value="Cũ">Cũ</SelectItem>
                  <SelectItem value="Hư hỏng">Hư hỏng</SelectItem>
                </SelectContent>
              </Select>
              {errors.tinhTrang && <p className="text-sm text-red-500">{errors.tinhTrang.message}</p>}
            </div>
          </div>

          <div className="grid gap-2">
            <Label htmlFor="hinhAnh">Hình ảnh</Label>
            <div className="flex gap-2 items-center">
              <Input id="hinhAnh" {...register("hinhAnh")} placeholder="https://..." className="flex-1" />
              <div className="relative">
                <Input
                  type="file"
                  accept="image/*"
                  className="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10"
                  onChange={handleImageUpload}
                  disabled={isUploading}
                />
                <Button type="button" variant="outline" disabled={isUploading}>
                  {isUploading ? <Loader2 className="h-4 w-4 animate-spin" /> : <Upload className="h-4 w-4" />}
                </Button>
              </div>
            </div>
            {watch("hinhAnh") && (
              <div className="mt-2 w-24 h-24 rounded overflow-hidden border">
                <img src={watch("hinhAnh")} alt="Preview" className="w-full h-full object-cover" />
              </div>
            )}
          </div>

          <div className="grid gap-2">
            <Label htmlFor="ghiChu">Ghi chú</Label>
            <Input id="ghiChu" {...register("ghiChu")} />
          </div>

          <DialogFooter className="mt-6">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>Hủy</Button>
            <Button type="submit" disabled={loading}>
              {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              {initialData ? "Lưu thay đổi" : "Tạo mới"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}
