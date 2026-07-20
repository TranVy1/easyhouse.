"use client"

import { Edit, Trash2, Box, ChevronLeft, ChevronRight } from "lucide-react"
import { TaiSanPhong } from "@/types"
import { Button } from "@/components/ui/button"

interface DataTableProps {
  data: TaiSanPhong[]
  onEdit: (item: TaiSanPhong) => void
  onDelete: (item: TaiSanPhong) => void
  pagination: { pageIndex: number; pageSize: number }
  setPagination: (updater: any) => void
  total: number
  pageCount: number
}

function formatCurrency(value?: number) {
  if (value == null) return "0 đ"
  return new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND", maximumFractionDigits: 0 }).format(value)
}

export function TaiSanPhongDataTable({
  data,
  onEdit,
  onDelete,
  pagination,
  setPagination,
  total,
  pageCount,
}: DataTableProps) {
  return (
    <div className="w-full flex flex-col">
      <div className="overflow-x-auto">
        <table className="w-full text-sm text-left">
          <thead className="bg-[#FAFAFA] border-b border-gray-200 text-gray-700">
            <tr>
              <th className="px-4 py-3 font-medium whitespace-nowrap">Mã TS</th>
              <th className="px-3 py-3 font-medium whitespace-nowrap w-16">Ảnh</th>
              <th className="px-4 py-3 font-medium whitespace-nowrap">Tên TS</th>
              <th className="px-4 py-3 font-medium whitespace-nowrap">Số lượng</th>
              <th className="px-4 py-3 font-medium whitespace-nowrap">Giá trị</th>
              <th className="px-4 py-3 font-medium whitespace-nowrap">Tình trạng</th>
              <th className="px-4 py-3 font-medium whitespace-nowrap">Thuộc phòng</th>
              <th className="px-4 py-3 font-medium whitespace-nowrap">Thuộc Tòa nhà</th>
              <th className="px-4 py-3 font-medium text-right whitespace-nowrap">Thao tác</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            {data.map((ts) => {
              const idStr = String(ts.id || ts._id || "")
              const maTs = "TS" + idStr.substring(0, 6).toUpperCase()
              return (
                <tr key={idStr} className="bg-white hover:bg-gray-50/50 transition-colors">
                  <td className="px-4 py-3 text-gray-900 font-medium">
                    <div className="flex items-center gap-2">
                      <Box className="w-4 h-4 text-muted-foreground" />
                      {maTs}
                    </div>
                  </td>
                  <td className="px-3 py-2">
                    {ts.anhTaiSan ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img
                        src={ts.anhTaiSan}
                        alt={ts.tenTaiSan}
                        className="h-10 w-10 rounded object-cover border border-gray-100"
                      />
                    ) : (
                      <div className="h-10 w-10 rounded bg-gray-100 flex items-center justify-center">
                        <Box className="h-4 w-4 text-gray-300" />
                      </div>
                    )}
                  </td>
                  <td className="px-4 py-3 text-gray-900">{ts.tenTaiSan}</td>
                  <td className="px-4 py-3 text-gray-900">{ts.soLuong}</td>
                  <td className="px-4 py-3 text-[#E76F51] font-medium">{formatCurrency(ts.giaTri)}</td>
                  <td className="px-4 py-3 text-gray-900">
                    <span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-800">
                      {ts.tinhTrang}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-600">{ts.tenPhong || "-"}</td>
                  <td className="px-4 py-3 text-gray-600">{ts.tenNhaTro || "-"}</td>
                  <td className="px-4 py-3 text-right">
                    <div className="flex items-center justify-end gap-2">
                      <Button variant="ghost" size="icon" onClick={() => onEdit(ts)} className="h-8 w-8 text-muted-foreground hover:text-[#4FA7A0] hover:bg-[#4FA7A0]/10">
                        <Edit className="h-4 w-4" />
                      </Button>
                      <Button variant="ghost" size="icon" onClick={() => onDelete(ts)} className="h-8 w-8 text-muted-foreground hover:text-red-600 hover:bg-red-50">
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>

      <div className="flex flex-col sm:flex-row items-center justify-between px-4 py-3 border-t border-gray-200 bg-gray-50/50 gap-4">
        <div className="text-sm text-muted-foreground text-center sm:text-left">
          Đang xem <span className="font-medium text-foreground">{data.length}</span> / <span className="font-medium text-foreground">{total}</span> tài sản
        </div>
        <div className="flex items-center gap-2 justify-center sm:justify-end">
          <Button
            variant="outline"
            size="sm"
            className="gap-1"
            onClick={() => setPagination((p: any) => ({ ...p, pageIndex: Math.max(0, p.pageIndex - 1) }))}
            disabled={pagination.pageIndex === 0}
          >
            <ChevronLeft className="h-4 w-4" />
            <span className="hidden sm:inline">Trước</span>
          </Button>
          <span className="text-sm font-medium">
            Trang {pagination.pageIndex + 1} / {pageCount || 1}
          </span>
          <Button
            variant="outline"
            size="sm"
            className="gap-1"
            onClick={() => setPagination((p: any) => ({ ...p, pageIndex: Math.min(pageCount - 1, p.pageIndex + 1) }))}
            disabled={pagination.pageIndex >= pageCount - 1}
          >
            <span className="hidden sm:inline">Sau</span>
            <ChevronRight className="h-4 w-4" />
          </Button>
        </div>
      </div>
    </div>
  )
}
