"use client"

import * as React from "react"
import { PhuongTien } from "@/types"
import { Edit, Trash2 } from "lucide-react"
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
            {data.map((item) => (
              <TableRow key={String(item.id || item._id)} className="hover:bg-gray-50/50 transition-colors">
                <TableCell className="text-center">
                  <input type="checkbox" className="rounded border-gray-300" />
                </TableCell>
                <TableCell>
                  <span className="font-medium text-emerald-600">{item.maPt}</span>
                </TableCell>
                <TableCell>
                  <div className="flex items-center justify-center gap-1">
                    <Button
                      variant="ghost"
                      size="icon"
                      className="h-8 w-8 text-slate-600 bg-slate-100 hover:bg-slate-200 hover:text-slate-900 rounded-md"
                      onClick={() => onEdit(item)}
                    >
                      <Edit className="h-4 w-4" />
                      <span className="sr-only">Sửa</span>
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="h-8 w-8 text-red-600 bg-red-100 hover:bg-red-200 hover:text-red-900 rounded-md"
                      onClick={() => onDelete(item)}
                    >
                      <Trash2 className="h-4 w-4" />
                      <span className="sr-only">Xóa</span>
                    </Button>
                  </div>
                </TableCell>
                <TableCell>
                  <div className="flex flex-col">
                    <span className="font-medium text-slate-900">{item.loaiXe}</span>
                    <span className="text-sm text-slate-500">{item.bienSo}</span>
                  </div>
                </TableCell>
                <TableCell>
                  <span className="font-medium text-slate-900">
                    {item.khachThue?.hoTen || "Chưa có"}
                  </span>
                </TableCell>
                <TableCell className="text-center">
                  {item.trangThai === "HIEU_LUC" ? (
                    <Badge className="bg-emerald-100 text-emerald-700 hover:bg-emerald-100 border-none px-2 py-0.5 rounded-sm font-medium">
                      Hiệu lực
                    </Badge>
                  ) : (
                    <Badge variant="secondary" className="bg-slate-100 text-slate-600 hover:bg-slate-100 border-none px-2 py-0.5 rounded-sm font-medium">
                      Hết hiệu lực
                    </Badge>
                  )}
                </TableCell>
                <TableCell>
                  <span className="text-slate-700 font-medium">
                    {item.nhaTro?.tenToaNha || "Chưa xác định"} 
                    {item.phong?.ten ? ` - ${item.phong.ten}` : ""}
                  </span>
                </TableCell>
              </TableRow>
            ))}
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
