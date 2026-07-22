"use client"

import { useState, useEffect } from "react"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Loader2 } from "lucide-react"
import { LichSuKhoTaiSan } from "@/types"

interface LichSuKhoDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  khoTaiSanId: string
  accessToken: string
}

export function LichSuKhoDialog({ open, onOpenChange, khoTaiSanId, accessToken }: LichSuKhoDialogProps) {
  const [loading, setLoading] = useState(false)
  const [data, setData] = useState<LichSuKhoTaiSan[]>([])

  useEffect(() => {
    if (open && khoTaiSanId) {
      setLoading(true)
      fetch(`/api/kho-tai-san/${khoTaiSanId}/lich-su`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      .then(res => res.json())
      .then(json => {
        if (json.success) {
          setData(json.data || [])
        }
      })
      .catch(err => console.error(err))
      .finally(() => setLoading(false))
    }
  }, [open, khoTaiSanId, accessToken])

  const formatLoaiGiaoDich = (loai: string) => {
    switch(loai) {
      case "NHAP_KHO": return <span className="text-green-600 font-medium">Nhập kho</span>
      case "XUAT_KHO": return <span className="text-orange-600 font-medium">Xuất kho</span>
      case "CAP_PHAT": return <span className="text-blue-600 font-medium">Cấp phát</span>
      case "THU_HOI_TOT": return <span className="text-emerald-600 font-medium">Thu hồi (Tốt)</span>
      case "THU_HOI_HONG": return <span className="text-red-600 font-medium">Thu hồi (Hỏng)</span>
      default: return <span>{loai}</span>
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl max-h-[80vh] overflow-hidden flex flex-col">
        <DialogHeader>
          <DialogTitle>Lịch sử giao dịch kho</DialogTitle>
        </DialogHeader>
        
        <div className="flex-1 overflow-auto mt-4 border rounded-md">
          {loading ? (
            <div className="flex justify-center items-center h-32">
              <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
            </div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Ngày</TableHead>
                  <TableHead>Loại</TableHead>
                  <TableHead>Phòng</TableHead>
                  <TableHead className="text-right">Số lượng</TableHead>
                  <TableHead>Ghi chú</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {data.map((item) => (
                  <TableRow key={item.id}>
                    <TableCell className="whitespace-nowrap">
                      {item.taoLuc ? new Date(item.taoLuc).toLocaleString("vi-VN") : "-"}
                    </TableCell>
                    <TableCell>{formatLoaiGiaoDich(item.loaiGiaoDich)}</TableCell>
                    <TableCell>{item.tenPhong || "-"}</TableCell>
                    <TableCell className="text-right font-semibold">
                      {item.soLuong}
                    </TableCell>
                    <TableCell className="text-sm text-muted-foreground">{item.ghiChu || "-"}</TableCell>
                  </TableRow>
                ))}
                {data.length === 0 && !loading && (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center h-24 text-muted-foreground">
                      Không có lịch sử giao dịch
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          )}
        </div>
      </DialogContent>
    </Dialog>
  )
}
