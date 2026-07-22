"use client"

import { useState, useEffect, useRef } from "react"
import { useSession } from "next-auth/react"
import { toast } from "sonner"
import { Upload, X, Image as ImageIcon, Loader2 } from "lucide-react"
import { TaiSanPhong, ToaNha, Phong } from "@/types"

import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

interface FormProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  initialData: TaiSanPhong | null
  toaNhas: ToaNha[]
  onSuccess: () => void
}

export function TaiSanPhongForm({ open, onOpenChange, initialData, toaNhas, onSuccess }: FormProps) {
  const { data: session } = useSession()
  const accessToken = session?.accessToken
  const fileInputRef = useRef<HTMLInputElement>(null)

  const [nhaTroId, setNhaTroId] = useState<string>(initialData?.nhaTroId || "")
  const [phongs, setPhongs] = useState<Phong[]>([])
  const [isLoadingPhongs, setIsLoadingPhongs] = useState(false)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [isUploading, setIsUploading] = useState(false)
  const [previewUrl, setPreviewUrl] = useState<string>(initialData?.anhTaiSan || "")

  const [formData, setFormData] = useState({
    phongId: initialData?.phongId || "",
    khoTaiSanId: initialData?.khoTaiSanId || "",
    tenTaiSan: initialData?.tenTaiSan || "",
    soLuong: initialData?.soLuong || 1,
    giaTri: initialData?.giaTri || 0,
    tinhTrang: initialData?.tinhTrang || "Mới",
    ghiChu: initialData?.ghiChu || "",
    anhTaiSan: initialData?.anhTaiSan || "",
  })

  useEffect(() => {
    if (!nhaTroId || !accessToken) {
      setPhongs([])
      return
    }
    const fetchPhongs = async () => {
      setIsLoadingPhongs(true)
      try {
        const res = await fetch(`/api/phong/nha-tro/${nhaTroId}`, {
          headers: { Authorization: `Bearer ${accessToken}` },
        })
        const json = await res.json()
        if (json.success) {
          setPhongs(Array.isArray(json.data) ? json.data : (json.data?.data || []))
        } else {
          setPhongs([])
        }
      } catch (e) {
        console.error("Lỗi tải danh sách phòng:", e)
        setPhongs([])
      } finally {
        setIsLoadingPhongs(false)
      }
    }
    fetchPhongs()
  }, [nhaTroId, accessToken])

  const [khoTaiSans, setKhoTaiSans] = useState<any[]>([])
  const [isLoadingKho, setIsLoadingKho] = useState(false)

  useEffect(() => {
    if (!nhaTroId || !accessToken) {
      setKhoTaiSans([])
      return
    }
    const fetchKho = async () => {
      setIsLoadingKho(true)
      try {
        const res = await fetch(`/api/kho-tai-san/nha-tro/${nhaTroId}`, {
          headers: { Authorization: `Bearer ${accessToken}` },
        })
        const json = await res.json()
        if (json.success) {
          setKhoTaiSans(Array.isArray(json.data) ? json.data : [])
        } else {
          setKhoTaiSans([])
        }
      } catch (e) {
        console.error("Lỗi tải danh sách kho tài sản:", e)
        setKhoTaiSans([])
      } finally {
        setIsLoadingKho(false)
      }
    }
    fetchKho()
  }, [nhaTroId, accessToken])

  const handleSelectKhoTaiSan = (khoId: string) => {
    const selected = khoTaiSans.find(k => k.id === khoId || k._id === khoId)
    if (selected) {
      setFormData(prev => ({
        ...prev,
        khoTaiSanId: selected.id || selected._id,
        tenTaiSan: selected.tenTaiSan,
        giaTri: selected.giaTri || 0,
        tinhTrang: selected.tinhTrang || "Mới",
        anhTaiSan: selected.hinhAnh || ""
      }))
      setPreviewUrl(selected.hinhAnh || "")
    }
  }

  const handleImageUpload = async (file: File) => {
    if (!file) return
    if (file.size > 10 * 1024 * 1024) {
      toast.error("Ảnh quá lớn. Tối đa 10MB")
      return
    }
    if (!file.type.startsWith("image/")) {
      toast.error("Chỉ chấp nhận file ảnh")
      return
    }

    // Show local preview immediately
    const localUrl = URL.createObjectURL(file)
    setPreviewUrl(localUrl)
    setIsUploading(true)

    try {
      const form = new FormData()
      form.append("file", file)
      const res = await fetch("/api/upload", {
        method: "POST",
        headers: { Authorization: `Bearer ${accessToken}` },
        body: form,
      })
      const result = await res.json()
      if (result.success) {
        const url = result.data?.url || result.data?.secureUrl || result.data?.secure_url || ""
        setFormData(prev => ({ ...prev, anhTaiSan: url }))
        setPreviewUrl(url)
        toast.success("Tải ảnh lên thành công")
      } else {
        toast.error(result.error || "Lỗi khi tải ảnh lên")
        setPreviewUrl(formData.anhTaiSan)
      }
    } catch (err) {
      toast.error("Có lỗi khi tải ảnh lên")
      setPreviewUrl(formData.anhTaiSan)
    } finally {
      setIsUploading(false)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!formData.khoTaiSanId || !formData.phongId) {
      toast.error("Vui lòng chọn tài sản từ kho và chọn phòng")
      return
    }

    setIsSubmitting(true)
    try {
      let res
      if (initialData?.id || initialData?._id) {
        res = await fetch(`/api/tai-san-phong/${initialData.id || initialData._id}`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
          },
          body: JSON.stringify(formData),
        })
      } else {
        res = await fetch(`/api/tai-san-phong/phong/${formData.phongId}`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
          },
          body: JSON.stringify(formData),
        })
      }

      const result = await res.json()
      if (result.success) {
        toast.success(initialData ? "Cập nhật tài sản thành công" : "Thêm tài sản thành công")
        onSuccess()
      } else {
        toast.error(result.error || result.message || "Lỗi khi lưu tài sản")
      }
    } catch (err) {
      toast.error("Có lỗi xảy ra khi lưu tài sản")
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[560px] max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{initialData ? "Sửa tài sản" : "Thêm tài sản mới"}</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-4 mt-2">
          {/* Tòa nhà & Phòng */}
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Tòa nhà <span className="text-red-500">*</span></Label>
              <Select
                value={nhaTroId}
                onValueChange={(val) => {
                  setNhaTroId(val)
                  setFormData(prev => ({ ...prev, phongId: "" }))
                }}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Chọn Tòa nhà" />
                </SelectTrigger>
                <SelectContent>
                  {toaNhas.map((t) => (
                    <SelectItem key={String(t.id || t._id)} value={String(t.id || t._id)}>
                      {t.tenToaNha}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label>Phòng <span className="text-red-500">*</span></Label>
              <Select
                value={formData.phongId}
                onValueChange={(val) => setFormData(prev => ({ ...prev, phongId: val }))}
                disabled={!nhaTroId || isLoadingPhongs}
              >
                <SelectTrigger>
                  <SelectValue placeholder={isLoadingPhongs ? "Đang tải..." : "Chọn phòng"} />
                </SelectTrigger>
                <SelectContent>
                  {phongs.map((p) => (
                    <SelectItem key={String(p.id || p._id)} value={String(p.id || p._id)}>
                      {p.ten || p.maPhong}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Tài sản từ kho */}
          <div className="space-y-2">
            <Label>Tài sản từ kho <span className="text-red-500">*</span></Label>
            <Select
              value={formData.khoTaiSanId}
              onValueChange={handleSelectKhoTaiSan}
              disabled={!!initialData || !nhaTroId || isLoadingKho}
            >
              <SelectTrigger>
                <SelectValue placeholder={isLoadingKho ? "Đang tải..." : "Chọn tài sản từ kho"} />
              </SelectTrigger>
              <SelectContent>
                {khoTaiSans.map((k) => (
                  <SelectItem 
                    key={String(k.id || k._id)} 
                    value={String(k.id || k._id)}
                    disabled={k.soLuongKhaDung <= 0}
                  >
                    {k.tenTaiSan} (Khả dụng: {k.soLuongKhaDung})
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Số lượng & Giá trị */}
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="soLuong">Số lượng</Label>
              <Input
                id="soLuong"
                type="number"
                min="1"
                value={formData.soLuong}
                onChange={(e) => setFormData(prev => ({ ...prev, soLuong: parseInt(e.target.value) || 1 }))}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="giaTri">Giá trị (VNĐ)</Label>
              <Input
                id="giaTri"
                type="number"
                min="0"
                value={formData.giaTri}
                onChange={(e) => setFormData(prev => ({ ...prev, giaTri: parseInt(e.target.value) || 0 }))}
              />
            </div>
          </div>

          {/* Tình trạng */}
          <div className="space-y-2">
            <Label>Tình trạng</Label>
            <Select
              value={formData.tinhTrang}
              onValueChange={(val) => setFormData(prev => ({ ...prev, tinhTrang: val }))}
            >
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
          </div>

          {/* Upload ảnh */}
          <div className="space-y-2">
            <Label>Ảnh tài sản</Label>
            <input
              ref={fileInputRef}
              type="file"
              accept="image/*"
              className="hidden"
              onChange={(e) => {
                const file = e.target.files?.[0]
                if (file) handleImageUpload(file)
                e.target.value = ""
              }}
            />
            {previewUrl ? (
              <div className="relative group rounded-lg overflow-hidden border border-gray-200 w-full h-40">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={previewUrl}
                  alt="Ảnh tài sản"
                  className="w-full h-full object-cover"
                />
                {isUploading && (
                  <div className="absolute inset-0 bg-black/50 flex items-center justify-center">
                    <Loader2 className="h-8 w-8 text-white animate-spin" />
                  </div>
                )}
                {!isUploading && (
                  <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-2">
                    <Button
                      type="button"
                      size="sm"
                      variant="secondary"
                      onClick={() => fileInputRef.current?.click()}
                    >
                      <Upload className="h-4 w-4 mr-1" />
                      Đổi ảnh
                    </Button>
                    <Button
                      type="button"
                      size="sm"
                      variant="destructive"
                      onClick={() => {
                        setPreviewUrl("")
                        setFormData(prev => ({ ...prev, anhTaiSan: "" }))
                      }}
                    >
                      <X className="h-4 w-4" />
                    </Button>
                  </div>
                )}
              </div>
            ) : (
              <button
                type="button"
                onClick={() => fileInputRef.current?.click()}
                className="w-full h-32 border-2 border-dashed border-gray-200 rounded-lg flex flex-col items-center justify-center gap-2 text-gray-500 hover:border-[#4FA7A0] hover:text-[#4FA7A0] hover:bg-[#4FA7A0]/5 transition-colors cursor-pointer"
              >
                <ImageIcon className="h-8 w-8" />
                <span className="text-sm font-medium">Nhấn để tải ảnh lên</span>
                <span className="text-xs text-gray-400">PNG, JPG, WEBP • Tối đa 10MB</span>
              </button>
            )}
          </div>

          {/* Ghi chú */}
          <div className="space-y-2">
            <Label htmlFor="ghiChu">Ghi chú</Label>
            <Textarea
              id="ghiChu"
              value={formData.ghiChu}
              onChange={(e) => setFormData(prev => ({ ...prev, ghiChu: e.target.value }))}
              placeholder="Ghi chú thêm về tài sản..."
              rows={3}
            />
          </div>

          <div className="flex justify-end gap-3 pt-2">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)} disabled={isSubmitting || isUploading}>
              Hủy
            </Button>
            <Button type="submit" disabled={isSubmitting || isUploading}>
              {isSubmitting ? (
                <><Loader2 className="h-4 w-4 mr-2 animate-spin" />Đang xử lý...</>
              ) : initialData ? "Lưu thay đổi" : "Thêm tài sản"}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  )
}
