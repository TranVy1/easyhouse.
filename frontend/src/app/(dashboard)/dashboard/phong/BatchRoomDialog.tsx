"use client"

import { useState } from "react"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import * as z from "zod"
import { toast } from "sonner"
import { X, LayoutTemplate, Info } from "lucide-react"

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { ScrollArea } from "@/components/ui/scroll-area"

const formSchema = z.object({
  nhaTroId: z.string().min(1, "Vui lòng chọn tòa nhà"),
  prefix: z.string().min(1, "Tiền tố không được để trống"),
  start: z.coerce.number().min(1, "Số bắt đầu phải >= 1"),
  end: z.coerce.number().min(1, "Số kết thúc phải >= 1"),
  tang: z.coerce.number().optional(),
  dienTich: z.coerce.number().min(1, "Diện tích phải lớn hơn 0"),
  giaHienTai: z.coerce.number().min(0, "Giá phòng phải >= 0"),
  tienCocMacDinh: z.coerce.number().min(0, "Tiền cọc phải >= 0"),
  soNguoiToiDa: z.coerce.number().min(1, "Số người tối đa >= 1"),
  khuVuc: z.string().optional(),
})

interface BatchRoomDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSuccess: () => void
  toaNhas: { id: string; tenToaNha: string }[]
  accessToken: string
}

export function BatchRoomDialog({
  open,
  onOpenChange,
  onSuccess,
  toaNhas,
  accessToken,
}: BatchRoomDialogProps) {
  const [step, setStep] = useState<"form" | "preview">("form")
  const [loading, setLoading] = useState(false)
  const [previewData, setPreviewData] = useState<any>(null)

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      nhaTroId: "",
      prefix: "Phòng ",
      start: 101,
      end: 105,
      tang: 1,
      dienTich: 20,
      giaHienTai: 3000000,
      tienCocMacDinh: 3000000,
      soNguoiToiDa: 2,
      khuVuc: "",
    },
  })

  const onPreview = async (values: z.infer<typeof formSchema>) => {
    if (values.end < values.start) {
      form.setError("end", { message: "Số kết thúc phải lớn hơn hoặc bằng số bắt đầu" })
      return
    }
    if (values.end - values.start + 1 > 100) {
      toast.error("Chỉ hỗ trợ tạo tối đa 100 phòng một lần")
      return
    }
    
    setLoading(true)
    try {
      const res = await fetch("/api/phong/batch/preview", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(values),
      })
      const json = await res.json()
      if (json.success) {
        setPreviewData({ ...json.data, requestPayload: values })
        setStep("preview")
      } else {
        throw new Error(json.message)
      }
    } catch (e: any) {
      toast.error(e.message || "Lỗi xem trước")
    } finally {
      setLoading(false)
    }
  }

  const onConfirm = async () => {
    if (!previewData?.requestPayload) return
    setLoading(true)
    try {
      const res = await fetch("/api/phong/batch", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(previewData.requestPayload),
      })
      const json = await res.json()
      if (json.success) {
        toast.success(`Tạo thành công ${json.data.totalCreated} phòng`)
        onSuccess()
        onOpenChange(false)
      } else {
        throw new Error(json.message)
      }
    } catch (e: any) {
      toast.error(e.message || "Lỗi tạo phòng")
    } finally {
      setLoading(false)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[600px] p-0 overflow-hidden">
        <DialogHeader className="p-6 pb-0">
          <DialogTitle className="flex items-center gap-2">
            <LayoutTemplate className="w-5 h-5 text-primary" />
            Cấp phát phòng hàng loạt
          </DialogTitle>
          <DialogDescription>
            Tạo nhiều phòng cùng một lúc dựa trên cấu hình tiền tố và khoảng số.
          </DialogDescription>
        </DialogHeader>

        {step === "form" ? (
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onPreview)} className="p-6 space-y-4">
              <ScrollArea className="h-[400px] pr-4">
                <div className="space-y-4">
                  <FormField
                    control={form.control}
                    name="nhaTroId"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Tòa nhà</FormLabel>
                        <Select onValueChange={field.onChange} defaultValue={field.value}>
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="Chọn tòa nhà" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            {toaNhas.map((t) => (
                              <SelectItem key={t.id} value={t.id}>
                                {t.tenToaNha}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <div className="grid grid-cols-3 gap-4">
                    <FormField
                      control={form.control}
                      name="prefix"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Tiền tố</FormLabel>
                          <FormControl>
                            <Input placeholder="Phòng " {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="start"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Từ số</FormLabel>
                          <FormControl>
                            <Input type="number" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="end"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Đến số</FormLabel>
                          <FormControl>
                            <Input type="number" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                  </div>
                  <FormDescription className="flex items-center gap-2">
                    <Info className="w-4 h-4" />
                    Hệ thống sẽ tạo phòng có tên dạng: [Tiền tố][Số]. Ví dụ: Phòng 101
                  </FormDescription>

                  <div className="grid grid-cols-2 gap-4">
                    <FormField
                      control={form.control}
                      name="tang"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Tầng (tùy chọn)</FormLabel>
                          <FormControl>
                            <Input type="number" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="dienTich"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Diện tích (m2)</FormLabel>
                          <FormControl>
                            <Input type="number" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                    <FormField
                      control={form.control}
                      name="giaHienTai"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Giá thuê (VNĐ)</FormLabel>
                          <FormControl>
                            <Input type="number" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="tienCocMacDinh"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Tiền cọc mặc định (VNĐ)</FormLabel>
                          <FormControl>
                            <Input type="number" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                  </div>
                  
                  <FormField
                      control={form.control}
                      name="soNguoiToiDa"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Số người tối đa</FormLabel>
                          <FormControl>
                            <Input type="number" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                </div>
              </ScrollArea>
              <DialogFooter>
                <Button variant="outline" type="button" onClick={() => onOpenChange(false)}>
                  Hủy
                </Button>
                <Button type="submit" disabled={loading}>
                  Xem trước {loading && "..."}
                </Button>
              </DialogFooter>
            </form>
          </Form>
        ) : (
          <div className="p-6 space-y-4">
            <div className="rounded-md bg-blue-50 p-4">
              <h4 className="text-sm font-medium text-blue-800 mb-2">Kết quả xem trước</h4>
              <p className="text-sm text-blue-700">Tổng số yêu cầu: <b>{previewData?.totalRequested}</b></p>
              <p className="text-sm text-green-700">Sẽ tạo mới: <b>{previewData?.totalCreated}</b></p>
              <p className="text-sm text-red-700">Bỏ qua (bị trùng): <b>{previewData?.totalSkipped}</b></p>
            </div>
            
            <div className="space-y-2">
              <h4 className="text-sm font-medium">Danh sách tạo mới:</h4>
              <div className="text-sm text-muted-foreground bg-gray-50 p-2 rounded max-h-[100px] overflow-y-auto">
                {previewData?.createdRooms?.join(", ") || "Không có"}
              </div>
            </div>
            
            {previewData?.skippedRooms?.length > 0 && (
              <div className="space-y-2">
                <h4 className="text-sm font-medium text-red-600">Danh sách bỏ qua (đã tồn tại):</h4>
                <div className="text-sm text-muted-foreground bg-gray-50 p-2 rounded max-h-[100px] overflow-y-auto">
                  {previewData?.skippedRooms?.join(", ")}
                </div>
              </div>
            )}
            
            <DialogFooter className="mt-4">
              <Button variant="outline" onClick={() => setStep("form")}>
                Quay lại
              </Button>
              <Button onClick={onConfirm} disabled={loading || previewData?.totalCreated === 0}>
                Xác nhận tạo {loading && "..."}
              </Button>
            </DialogFooter>
          </div>
        )}
      </DialogContent>
    </Dialog>
  )
}
