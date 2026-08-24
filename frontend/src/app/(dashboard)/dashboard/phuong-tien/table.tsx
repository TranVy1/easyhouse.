"use client"

import * as React from "react"
import { PhuongTien } from "@/types"
import { Edit, Trash2, CarFront } from "lucide-react"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

interface Props {
  data: PhuongTien[]
  onEdit: (item: PhuongTien) => void
  onDelete: (item: PhuongTien) => void
  pagination: { pageIndex: number; pageSize: number }
  setPagination: React.Dispatch<React.SetStateAction<{ pageIndex: number; pageSize: number }>>
  total: number
  pageCount: number
}

export function PhuongTienDataTable({
  data,
  onEdit,
  onDelete,
  pagination,
  setPagination,
  total,
  pageCount,
}: Props) {
  return (
    <div>
      <div className="overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow className="bg-gray-50/50 hover:bg-gray-50/50">
              <TableHead className="w-[50px] text-center">
                <input type="checkbox" className="rounded border-gray-300" disabled />
              </TableHead>
              <TableHead className="font-semibold whitespace-nowrap">Mã PT</TableHead>
              <TableHead className="font-semibold text-center whitespace-nowrap">Thao tác</TableHead>
              <TableHead className="font-semibold whitespace-nowrap">Thông tin xe</TableHead>
              <TableHead className="font-semibold whitespace-nowrap">Khách hàng</TableHead>
              <TableHead className="font-semibold whitespace-nowrap text-center">Trạng thái</TableHead>
              <TableHead className="font-semibold whitespace-nowrap">Vị trí</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.length === 0 ? (
              <TableRow>
                <TableCell colSpan={7} className="h-64 text-center">
                  <div className="flex flex-col items-center justify-center space-y-3 text-muted-foreground">
                    <div className="flex h-16 w-16 items-center justify-center rounded-full bg-muted/30">
                      <CarFront className="h-8 w-8 text-muted-foreground/60" />
                    </div>
                    <p className="text-sm font-medium">Chưa có phương tiện nào</p>
                    <p className="text-xs text-muted-foreground/70 max-w-sm text-center">
                      Bạn có thể đăng ký mới xe máy, ô tô cho khách thuê tại đây để quản lý bãi xe dễ dàng hơn.
                    </p>
                  </div>
                </TableCell>
              </TableRow>
            ) : (
              data.map((item) => (
              <TableRow key={String(item.id || item._id)} className="hover:bg-slate-50 transition-colors">
                <TableCell className="text-center">
                  <input type="checkbox" className="rounded border-gray-300" />
                </TableCell>
                <TableCell>
                  <span className="font-bold text-[#243B5A] bg-[#243B5A]/5 px-2 py-0.5 rounded uppercase tracking-wide text-xs">{item.maPt}</span>
                </TableCell>
                <TableCell>
                  <div className="flex items-center justify-center gap-1">
                    <Button
                      variant="ghost"
                      size="icon"
                      className="h-8 w-8 text-slate-500 bg-slate-50 hover:bg-slate-100 hover:text-slate-900 rounded-lg shadow-xs"
                      onClick={() => onEdit(item)}
                    >
                      <Edit className="h-4 w-4" />
                      <span className="sr-only">Sửa</span>
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="h-8 w-8 text-red-500 bg-red-50 hover:bg-red-100 hover:text-red-700 rounded-lg shadow-xs"
                      onClick={() => onDelete(item)}
                    >
                      <Trash2 className="h-4 w-4" />
                      <span className="sr-only">Xóa</span>
                    </Button>
                  </div>
                </TableCell>
                <TableCell>
                  <div className="flex flex-col">
                    <span className="font-bold text-slate-900 text-sm">{item.loaiXe}</span>
                    <span className="text-xs font-semibold text-slate-500 tracking-wider bg-slate-100/70 w-fit px-1.5 py-0.5 rounded mt-0.5 border border-slate-200/50">{item.bienSo}</span>
                  </div>
                </TableCell>
                <TableCell>
                  <span className="font-medium text-[#243B5A] text-sm">
                    {item.khachThue?.hoTen || "Chưa có"}
                  </span>
                </TableCell>
                <TableCell className="text-center">
                  {item.trangThai === "HIEU_LUC" ? (
                    <Badge className="bg-emerald-50 text-emerald-700 hover:bg-emerald-100 border-none px-2 py-0.5 rounded-md font-bold shadow-none">
                      Đang gửi
                    </Badge>
                  ) : (
                    <Badge variant="secondary" className="bg-slate-100 text-slate-500 hover:bg-slate-200 border-none px-2 py-0.5 rounded-md font-bold shadow-none">
                      Hủy/Không gửi
                    </Badge>
                  )}
                </TableCell>
                <TableCell>
                  <span className="text-slate-600 font-medium text-sm flex items-center gap-1.5">
                    <span className="w-1.5 h-1.5 rounded-full bg-slate-400"></span>
                    {item.nhaTro?.tenToaNha || "Chưa xác định"} 
                    {item.phong?.ten ? ` - Ph. ${item.phong.ten}` : ""}
                  </span>
                </TableCell>
              </TableRow>
            )))}
          </TableBody>
        </Table>
      </div>
      
      <div className="flex items-center justify-between px-4 py-4 border-t">
        <div className="text-sm text-muted-foreground">
          Hiển thị trang {pagination.pageIndex + 1} / {pageCount} ({total} kết quả)
        </div>
        <div className="flex items-center space-x-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => setPagination(prev => ({ ...prev, pageIndex: Math.max(0, prev.pageIndex - 1) }))}
            disabled={pagination.pageIndex === 0}
          >
            Trang trước
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setPagination(prev => ({ ...prev, pageIndex: Math.min(pageCount - 1, prev.pageIndex + 1) }))}
            disabled={pagination.pageIndex >= pageCount - 1}
          >
            Trang sau
          </Button>
        </div>
      </div>
    </div>
  )
}
