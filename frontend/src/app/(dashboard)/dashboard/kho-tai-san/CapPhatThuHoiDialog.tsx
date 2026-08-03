"use client"

import { useState, useEffect } from "react"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import * as z from "zod"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { toast } from "sonner"
import { Loader2 } from "lucide-react"
import { KhoTaiSan, Phong, ToaNha } from "@/types"

const capPhatSchema = z.object({
  khoTaiSanId: z.string().min(1, "Vui lòng chọn tài sản cấp phát"),
  phongId: z.string().min(1, "Vui lòng chọn phòng"),
  soLuong: z.coerce.number().min(1, "Số lượng phải > 0"),
  giaTri: z.coerce.number().min(0).optional(),
  ghiChu: z.string().optional()
})

const thuHoiSchema = z.object({
  phongId: z.string().min(1, "Vui lòng chọn phòng"),
  soLuong: z.coerce.number().min(1, "Số lượng phải > 0"),
  khaDung: z.boolean(),
  ghiChu: z.string().optional()
})

interface CapPhatThuHoiDialogProps {
  type: "CAP_PHAT" | "THU_HOI"
  open: boolean
  onOpenChange: (open: boolean) => void
  khoTaiSan: KhoTaiSan
  toaNhas: ToaNha[]
  accessToken: string
  onSuccess: () => void
}

export function CapPhatThuHoiDialog({ type, open, onOpenChange, khoTaiSan, toaNhas, accessToken, onSuccess }: CapPhatThuHoiDialogProps) {
  const [loading, setLoading] = useState(false)
  const [phongs, setPhongs] = useState<Phong[]>([])
  const [taiSans, setTaiSans] = useState<KhoTaiSan[]>([])
  const [selectedNhaTroId, setSelectedNhaTroId] = useState("")
  const [isLoadingRooms, setIsLoadingRooms] = useState(false)
  const [isLoadingAssets, setIsLoadingAssets] = useState(false)

  const schema = type === "CAP_PHAT" ? capPhatSchema : thuHoiSchema
  const { register, handleSubmit, formState: { errors }, setValue, watch, reset } = useForm<any>({
    resolver: zodResolver(schema),
    defaultValues: {
      soLuong: 1,
      giaTri: 0,
      khaDung: true,
      ghiChu: ""
    }
  })
  const selectedKhoTaiSanId = watch("khoTaiSanId")
  const selectedPhongId = watch("phongId")
  const selectedKhoTaiSan = type === "CAP_PHAT"
    ? taiSans.find(item => String(item.id || item._id) === selectedKhoTaiSanId)
    : khoTaiSan

  useEffect(() => {
    if (open) {
      setSelectedNhaTroId(type === "CAP_PHAT" ? "" : String(khoTaiSan.nhaTroId || ""))
      reset({
        khoTaiSanId: "",
        phongId: "",
        soLuong: 1,
        giaTri: 0,
        khaDung: true,
        ghiChu: "",
      })
    }
  }, [open, khoTaiSan, reset, type])

  useEffect(() => {
    if (!open || !selectedNhaTroId) return
    setIsLoadingRooms(true)
    fetch(`/api/phong/nha-tro/${selectedNhaTroId}`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      .then(res => res.json())
      .then(json => {
        if (json.success) {
          setPhongs(Array.isArray(json.data) ? json.data : (json.data?.data || []))
        }
      })
      .catch(err => console.error(err))
      .finally(() => setIsLoadingRooms(false))
  }, [open, selectedNhaTroId, accessToken])

  useEffect(() => {
    if (type !== "CAP_PHAT" || !open || !selectedNhaTroId) return
    setIsLoadingAssets(true)
    fetch(`/api/kho-tai-san/nha-tro/${selectedNhaTroId}`, {
      headers: { Authorization: `Bearer ${accessToken}` }
    })
      .then(res => res.json())
      .then(json => {
        if (json.success) {
          setTaiSans((json.data || []).filter((item: KhoTaiSan) => (item.soLuongKhaDung || 0) > 0))
        }
      })
      .catch(err => console.error(err))
      .finally(() => setIsLoadingAssets(false))
  }, [type, open, selectedNhaTroId, accessToken])

  const onSubmit = async (data: any) => {
    setLoading(true)
    try {
      const { khoTaiSanId, ...requestData } = data
      const url = type === "CAP_PHAT" 
        ? `/api/kho-tai-san/${khoTaiSanId}/cap-phat`
        : `/api/kho-tai-san/${khoTaiSan.id || khoTaiSan._id}/thu-hoi`
        
      const res = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`
        },
        body: JSON.stringify(requestData)
      })
      const json = await res.json()
      if (json.success) {
        toast.success(type === "CAP_PHAT" ? "Cấp phát thành công" : "Thu hồi thành công")
        reset()
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
          <DialogTitle>{type === "CAP_PHAT" ? "Cấp phát tài sản" : "Thu hồi tài sản"}</DialogTitle>
          <DialogDescription>
            Tài sản: <strong className="text-black">{selectedKhoTaiSan?.tenTaiSan || "Chưa chọn"}</strong>
            <br/>
            {type === "CAP_PHAT"
              ? `Khả dụng: ${selectedKhoTaiSan?.soLuongKhaDung || 0}`
              : `Đã cấp: ${khoTaiSan.soLuongDaCapPhat}`
            }
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          {type === "CAP_PHAT" && (
            <>
              <div className="grid gap-2">
                <Label>Tòa nhà <span className="text-red-500">*</span></Label>
                <Select
                  value={selectedNhaTroId}
                  onValueChange={(value) => {
                    setSelectedNhaTroId(value)
                    setValue("phongId", "")
                    setValue("khoTaiSanId", "")
                  }}
                >
                  <SelectTrigger><SelectValue placeholder="Chọn tòa nhà" /></SelectTrigger>
                  <SelectContent>
                    {toaNhas.map(nhaTro => (
                      <SelectItem key={String(nhaTro.id || nhaTro._id)} value={String(nhaTro.id || nhaTro._id)}>
                        {nhaTro.tenToaNha}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

            </>
          )}

          <div className="grid gap-2">
            <Label htmlFor="phongId">Phòng <span className="text-red-500">*</span></Label>
            <Select onValueChange={(val) => setValue("phongId", val)} disabled={!selectedNhaTroId || isLoadingRooms}>
              <SelectTrigger>
                <SelectValue placeholder={isLoadingRooms ? "Đang tải..." : "Chọn phòng"} />
              </SelectTrigger>
              <SelectContent>
                {phongs.map(p => (
                  <SelectItem key={String(p.id || p._id)} value={String(p.id || p._id)}>{p.ten || p.maPhong}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            {errors.phongId && <p className="text-sm text-red-500">{errors.phongId.message as string}</p>}
          </div>

          {type === "CAP_PHAT" && (
            <div className="grid gap-2">
              <Label htmlFor="khoTaiSanId">Tài sản cấp phát <span className="text-red-500">*</span></Label>
              <Select value={selectedKhoTaiSanId || ""} onValueChange={(value) => setValue("khoTaiSanId", value)} disabled={!selectedPhongId || isLoadingAssets}>
                <SelectTrigger><SelectValue placeholder={isLoadingAssets ? "Đang tải..." : "Chọn tài sản"} /></SelectTrigger>
                <SelectContent>
                  {taiSans.map(item => (
                    <SelectItem key={String(item.id || item._id)} value={String(item.id || item._id)}>
                      {item.tenTaiSan} (còn {item.soLuongKhaDung})
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {errors.khoTaiSanId && <p className="text-sm text-red-500">{errors.khoTaiSanId.message as string}</p>}
            </div>
          )}

          <div className="grid gap-2">
            <Label htmlFor="soLuong">Số lượng <span className="text-red-500">*</span></Label>
            <Input id="soLuong" type="number"
              max={type === "CAP_PHAT" ? selectedKhoTaiSan?.soLuongKhaDung : khoTaiSan.soLuongDaCapPhat}
              {...register("soLuong")}
            />
            {errors.soLuong && <p className="text-sm text-red-500">{errors.soLuong.message as string}</p>}
          </div>

          {type === "CAP_PHAT" && (
            <div className="grid gap-2">
              <Label htmlFor="giaTri">Giá trị quy đổi (VND)</Label>
              <Input id="giaTri" type="number" {...register("giaTri")} />
            </div>
          )}

          {type === "THU_HOI" && (
            <div className="grid gap-2">
              <Label htmlFor="khaDung">Tình trạng thu hồi</Label>
              <Select 
                defaultValue="true" 
                onValueChange={(val) => setValue("khaDung", val === "true")}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Tình trạng" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="true">Còn tốt (Khả dụng)</SelectItem>
                  <SelectItem value="false">Hư hỏng</SelectItem>
                </SelectContent>
              </Select>
            </div>
          )}

          <div className="grid gap-2">
            <Label htmlFor="ghiChu">Ghi chú</Label>
            <Input id="ghiChu" {...register("ghiChu")} />
          </div>

          <DialogFooter className="mt-6">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>Hủy</Button>
            <Button type="submit" disabled={loading}>
              {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              {type === "CAP_PHAT" ? "Xác nhận Cấp phát" : "Xác nhận Thu hồi"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}
