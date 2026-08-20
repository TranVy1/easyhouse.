"use client"

import * as React from "react"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import * as z from "zod"
import { toast } from "sonner"
import { useSession } from "next-auth/react"
import { X, Image as ImageIcon, Upload, Loader2, Edit2 } from "lucide-react"

import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogClose,
} from "@/components/ui/dialog"
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"
import { PhuongTien, KhachThue } from "@/types"

const formSchema = z.object({
  anhXe: z.string().optional(),
  loaiPhuongTien: z.string().min(1, "Loại phương tiện không được để trống"),
  tenDongXe: z.string().min(1, "Tên dòng xe không được để trống"),
  mauXe: z.string().min(1, "Màu xe không được để trống"),
  bienSo: z.string().min(1, "Biển số xe không được để trống"),
  soVeXe: z.string().optional(),
  hoatDong: z.boolean().default(true),
  nhaTroId: z.string().min(1, "Không xác định được tòa nhà của khách thuê"),
  phongId: z.string().min(1, "Không xác định được phòng của khách thuê"),
  khachThueId: z.string().min(1, "Vui lòng chọn khách hàng"),
  hieuLucTu: z.string().min(1, "Vui lòng chọn ngày bắt đầu hiệu lực"),
  hieuLucDen: z.string().optional(),
})

interface Props {
  open: boolean
  onOpenChange: (open: boolean) => void
  initialData: PhuongTien | null
  onSuccess: () => void
}

export function PhuongTienForm({ open, onOpenChange, initialData, onSuccess }: Props) {
  const { data: session } = useSession()
  const accessToken = session?.accessToken

  const [khachThues, setKhachThues] = React.useState<KhachThue[]>([])
  const [isLoadingKhachThues, setIsLoadingKhachThues] = React.useState(false)
  const [isUploading, setIsUploading] = React.useState(false)

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema) as any,
    defaultValues: {
      anhXe: initialData?.anhXe || "",
      loaiPhuongTien: initialData?.loaiPhuongTien || "",
      tenDongXe: initialData?.tenDongXe || "",
      mauXe: initialData?.mauXe || "",
      bienSo: initialData?.bienSo || "",
      soVeXe: initialData?.soVeXe || "",
      hoatDong: initialData ? initialData.trangThai === "HIEU_LUC" : true,
      nhaTroId: initialData?.nhaTroId ? String(initialData.nhaTroId) : "",
      phongId: initialData?.phongId ? String(initialData.phongId) : "",
      khachThueId: initialData?.khachThueId ? String(initialData.khachThueId) : "",
      hieuLucTu: initialData?.hieuLucTu ? String(initialData.hieuLucTu).slice(0, 10) : new Date().toISOString().slice(0, 10),
      hieuLucDen: initialData?.hieuLucDen ? String(initialData.hieuLucDen).slice(0, 10) : "",
    },
  })

  const watchKhachThueId = form.watch("khachThueId")

  React.useEffect(() => {
    form.reset({
      anhXe: initialData?.anhXe || "",
      loaiPhuongTien: initialData?.loaiPhuongTien || "",
      tenDongXe: initialData?.tenDongXe || "",
      mauXe: initialData?.mauXe || "",
      bienSo: initialData?.bienSo || "",
      soVeXe: initialData?.soVeXe || "",
      hoatDong: initialData ? initialData.trangThai === "HIEU_LUC" : true,
      nhaTroId: initialData?.nhaTroId ? String(initialData.nhaTroId) : "",
      phongId: initialData?.phongId ? String(initialData.phongId) : "",
      khachThueId: initialData?.khachThueId ? String(initialData.khachThueId) : "",
      hieuLucTu: initialData?.hieuLucTu ? String(initialData.hieuLucTu).slice(0, 10) : new Date().toISOString().slice(0, 10),
      hieuLucDen: initialData?.hieuLucDen ? String(initialData.hieuLucDen).slice(0, 10) : "",
    })
  }, [form, initialData, open])

  React.useEffect(() => {
    if (!accessToken) {
      setKhachThues([])
      return
    }
    const fetchKhachThues = async () => {
      setIsLoadingKhachThues(true)
      try {
        const res = await fetch(`/api/khach-thue?trangThai=dangThue&limit=1000`, {
          headers: { Authorization: `Bearer ${accessToken}` }
        })
        const json = await res.json()
        if (json.success) setKhachThues(Array.isArray(json.data) ? json.data : (json.data?.data || []))
      } catch (e) {
        console.error(e)
      } finally {
        setIsLoadingKhachThues(false)
      }
    }
    fetchKhachThues()
  }, [accessToken])

  const selectedKhachThue = khachThues.find(k => String(k.id || k._id) === watchKhachThueId)
  const selectedPhong = selectedKhachThue?.hopDongHienTai?.phong
  const selectedToaNha = selectedPhong?.toaNha

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file || !accessToken) return

    if (file.size > 10 * 1024 * 1024) {
      toast.error("Dung lượng file tối đa 10MB")
      return
    }

    setIsUploading(true)
    const formData = new FormData()
    formData.append("file", file)
    formData.append("resourceType", "image")

    try {
      const res = await fetch("/api/upload", {
        method: "POST",
        headers: { Authorization: `Bearer ${accessToken}` },
        body: formData,
      })
      const data = await res.json()
      if (data.success) {
        form.setValue("anhXe", data.data.url)
        toast.success("Tải ảnh thành công")
      } else {
        throw new Error(data.message)
      }
    } catch (error: any) {
      toast.error(error.message || "Lỗi tải ảnh lên")
    } finally {
      setIsUploading(false)
    }
  }

  const onSubmit = async (values: z.infer<typeof formSchema>) => {
    if (!accessToken) return
    try {
      const url = initialData
        ? `/api/phuong-tien/${initialData.id || initialData._id}`
        : `/api/phuong-tien`
      const method = initialData ? "PUT" : "POST"

      const payload = {
        ...values,
        loaiXe: `${values.loaiPhuongTien} - ${values.tenDongXe}`, // For backward compatibility
        trangThai: values.hoatDong ? "HIEU_LUC" : "HET_HIEU_LUC",
        phongId: values.phongId || null,
        khachThueId: values.khachThueId || null,
      }

      const res = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`
        },
        body: JSON.stringify(payload)
      })

      const json = await res.json()
      if (json.success) {
        toast.success(initialData ? "Cập nhật phương tiện thành công" : "Thêm phương tiện thành công")
        onSuccess()
      } else {
        throw new Error(json.message)
      }
    } catch (e: any) {
      toast.error(e.message || "Đã xảy ra lỗi")
    }
  }

  const currentAnhXe = form.watch("anhXe")

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[700px] bg-white border-slate-200 text-slate-900 p-0 gap-0 hide-close-button">
        <DialogHeader className="p-4 border-b border-slate-200">
          <DialogTitle className="text-[#4FA7A0] font-bold text-lg uppercase tracking-wider">PHƯƠNG TIỆN</DialogTitle>
          <Button variant="ghost" size="icon" onClick={() => onOpenChange(false)} className="text-slate-500 hover:text-slate-700 hover:bg-slate-100 rounded-full h-8 w-8">
            <X className="h-5 w-5" />
          </Button>
        </DialogHeader>

        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="p-6 space-y-6">

            {/* Image Upload Area */}
            <div className="flex flex-col items-center justify-center space-y-3 mb-8">
              <div className="relative group">
                <input
                  type="file"
                  accept="image/png, image/jpeg, image/jpg"
                  className="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10"
                  onChange={handleImageUpload}
                  disabled={isUploading}
                />
                <div className="w-28 h-28 border-2 border-dashed border-slate-200 rounded-xl flex items-center justify-center bg-slate-50 overflow-hidden transition-colors group-hover:border-slate-300">
                  {isUploading ? (
                    <Loader2 className="w-8 h-8 text-slate-500 animate-spin" />
                  ) : currentAnhXe ? (
                    <img src={currentAnhXe} alt="Xe" className="w-full h-full object-cover" />
                  ) : (
                    <ImageIcon className="w-8 h-8 text-slate-400" />
                  )}
                </div>
                {/* Edit Badge */}
                <div className="absolute -top-3 -right-3 w-8 h-8 bg-white border border-slate-200 rounded-full flex items-center justify-center pointer-events-none z-20 shadow-lg">
                  <Edit2 className="w-4 h-4 text-slate-500" />
                </div>
              </div>
              <p className="text-sm text-slate-500">Định dạng cho phép: PNG, JPG, JPEG. Dung lượng tối đa 10MB</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">

              <div className="md:col-span-2">
                <FormField
                  control={form.control}
                  name="loaiPhuongTien"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className="text-slate-700 font-medium">Loại phương tiện <span className="text-red-500">*</span></FormLabel>
                      <Select onValueChange={field.onChange} value={field.value}>
                        <FormControl>
                          <SelectTrigger className="bg-white border-slate-200 text-slate-900 h-11">
                            <SelectValue placeholder="Chọn" />
                          </SelectTrigger>
                        </FormControl>
                        <SelectContent className="bg-white border-slate-200 text-slate-900">
                          <SelectItem value="Xe máy">Xe máy</SelectItem>
                          <SelectItem value="Ô tô">Ô tô</SelectItem>
                          <SelectItem value="Xe đạp">Xe đạp</SelectItem>
                          <SelectItem value="Xe điện">Xe điện</SelectItem>
                        </SelectContent>
                      </Select>
                      <FormMessage className="text-red-400" />
                    </FormItem>
                  )}
                />
              </div>

              <FormField
                control={form.control}
                name="tenDongXe"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-slate-700 font-medium">Tên dòng xe <span className="text-red-500">*</span></FormLabel>
                    <FormControl>
                      <Input placeholder="Honda Airblade" className="bg-white border-slate-200 text-slate-900 h-11 placeholder:text-slate-400" {...field} />
                    </FormControl>
                    <FormMessage className="text-red-400" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="mauXe"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-slate-700 font-medium">Màu xe <span className="text-red-500">*</span></FormLabel>
                    <FormControl>
                      <Input placeholder="Đen nhám" className="bg-white border-slate-200 text-slate-900 h-11 placeholder:text-slate-400" {...field} />
                    </FormControl>
                    <FormMessage className="text-red-400" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="bienSo"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-slate-700 font-medium">Biển số xe <span className="text-red-500">*</span></FormLabel>
                    <FormControl>
                      <Input placeholder="29T2-686.68" className="bg-white border-slate-200 text-slate-900 h-11 placeholder:text-slate-400" {...field} />
                    </FormControl>
                    <FormMessage className="text-red-400" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="soVeXe"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-slate-700 font-medium">Số vé xe</FormLabel>
                    <FormControl>
                      <Input placeholder="No.19" className="bg-white border-slate-200 text-slate-900 h-11 placeholder:text-slate-400" {...field} />
                    </FormControl>
                    <FormMessage className="text-red-400" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="hieuLucTu"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-slate-700 font-medium">Hiệu lực từ <span className="text-red-500">*</span></FormLabel>
                    <FormControl><Input type="date" className="bg-white border-slate-200 text-slate-900 h-11" {...field} /></FormControl>
                    <FormMessage className="text-red-400" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="hieuLucDen"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-slate-700 font-medium">Hiệu lực đến</FormLabel>
                    <FormControl><Input type="date" min={form.watch("hieuLucTu")} className="bg-white border-slate-200 text-slate-900 h-11" {...field} /></FormControl>
                    <FormMessage className="text-red-400" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="hoatDong"
                render={({ field }) => (
                  <FormItem className="flex flex-col justify-between">
                    <FormLabel className="text-slate-700 font-medium mb-1 pt-1">Hoạt động</FormLabel>
                    <FormControl>
                      <div className="h-11 flex items-center">
                        <Switch
                          checked={field.value}
                          onCheckedChange={field.onChange}
                          className="data-[state=checked]:bg-[#4FA7A0]"
                        />
                      </div>
                    </FormControl>
                    <FormMessage className="text-red-400" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="khachThueId"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-slate-700 font-medium">Khách hàng <span className="text-red-500">*</span></FormLabel>
                    <Select
                      onValueChange={(val) => {
                        field.onChange(val);
                        const selectedK = khachThues.find(k => String(k.id || k._id) === val);
                        const phong = selectedK?.hopDongHienTai?.phong;
                        const phongId = phong?._id || phong?.id;
                        const nhaTroId = phong?.toaNha?._id || phong?.toaNha?.id;
                        form.setValue("phongId", phongId ? String(phongId) : "", { shouldValidate: true });
                        form.setValue("nhaTroId", nhaTroId ? String(nhaTroId) : "", { shouldValidate: true });
                      }}
                      value={field.value ?? ""}
                      disabled={isLoadingKhachThues}
                    >
                      <FormControl>
                        <SelectTrigger className="bg-white border-slate-200 text-slate-900 h-11">
                          <SelectValue placeholder={isLoadingKhachThues ? "Đang tải..." : "Chọn"} />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent className="bg-white border-slate-200 text-slate-900">
                        {khachThues.map((k) => (
                          <SelectItem key={String(k.id || k._id)} value={String(k.id || k._id)}>
                            {k.hoTen} {k.soDienThoai ? `- ${k.soDienThoai}` : ""}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    <FormMessage className="text-red-400" />
                  </FormItem>
                  )}
                />

              <FormItem>
                <FormLabel className="text-slate-700 font-medium">Toà nhà</FormLabel>
                <Input
                  value={selectedToaNha?.tenToaNha || (watchKhachThueId ? "Chưa có thông tin tòa nhà" : "Chọn khách hàng để tự động điền")}
                  readOnly
                  className="bg-slate-50 border-slate-200 text-slate-600 h-11"
                />
              </FormItem>

              <FormItem>
                <FormLabel className="text-slate-700 font-medium">Phòng</FormLabel>
                <Input
                  value={selectedPhong?.maPhong || (watchKhachThueId ? "Chưa có thông tin phòng" : "Chọn khách hàng để tự động điền")}
                  readOnly
                  className="bg-slate-50 border-slate-200 text-slate-600 h-11"
                />
              </FormItem>
            </div>

            <div className="bg-amber-50 text-amber-600 border border-amber-200 rounded-lg p-3 text-sm flex items-start gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="shrink-0"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
              <p>
                <strong>Lưu ý:</strong> Mỗi xe được tính theo biểu phí của tòa nhà, loại xe và khoảng thời gian hiệu lực. Không có quy tắc miễn phí xe ngầm.
              </p>
            </div>

            <div className="flex justify-end pt-4">
              {/* We don't have a specific submit button in the design screenshot, but we need one. */}
              <Button type="submit" className="bg-[#4FA7A0] hover:bg-[#3D8580] text-white px-8 h-11" disabled={form.formState.isSubmitting || isUploading}>
                {form.formState.isSubmitting ? "Đang lưu..." : "Lưu thay đổi"}
              </Button>
            </div>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  )
}



