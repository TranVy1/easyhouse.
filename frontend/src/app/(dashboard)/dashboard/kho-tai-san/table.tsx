"use client"

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Button } from "@/components/ui/button"
import { MoreHorizontal, FileEdit, Trash2, ArrowRightLeft, History } from "lucide-react"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
  DropdownMenuSeparator,
} from "@/components/ui/dropdown-menu"
import { KhoTaiSan } from "@/types"

interface KhoTaiSanDataTableProps {
  data: KhoTaiSan[]
  onEdit: (item: KhoTaiSan) => void
  onDelete: (item: KhoTaiSan) => void
  onCapPhat: (item: KhoTaiSan) => void
  onThuHoi: (item: KhoTaiSan) => void
  onLichSu: (item: KhoTaiSan) => void
}

export function KhoTaiSanDataTable({
  data,
  onEdit,
  onDelete,
  onCapPhat,
  onThuHoi,
  onLichSu
}: KhoTaiSanDataTableProps) {
  return (
    <div className="w-full">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Hình ảnh</TableHead>
            <TableHead>Tên tài sản</TableHead>
            <TableHead className="text-center">Tổng kho</TableHead>
            <TableHead className="text-center text-green-600">Khả dụng</TableHead>
            <TableHead className="text-center text-blue-600">Đã cấp</TableHead>
            <TableHead className="text-center text-red-600">Hư hỏng</TableHead>
            <TableHead>Tình trạng</TableHead>
            <TableHead className="text-right">Thao tác</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {data.map((item) => (
            <TableRow key={item.id || item._id}>
              <TableCell>
                {item.hinhAnh ? (
                  <img src={item.hinhAnh} alt={item.tenTaiSan} className="w-12 h-12 object-cover rounded-md" />
                ) : (
                  <div className="w-12 h-12 bg-gray-100 flex items-center justify-center rounded-md text-xs text-gray-400">Trống</div>
                )}
              </TableCell>
              <TableCell className="font-medium">{item.tenTaiSan}</TableCell>
              <TableCell className="text-center font-semibold">{item.tongSoLuong}</TableCell>
              <TableCell className="text-center text-green-600 font-semibold">{item.soLuongKhaDung}</TableCell>
              <TableCell className="text-center text-blue-600 font-semibold">{item.soLuongDaCapPhat}</TableCell>
              <TableCell className="text-center text-red-600 font-semibold">{item.soLuongHuHong}</TableCell>
              <TableCell>{item.tinhTrang}</TableCell>
              <TableCell className="text-right">
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" className="h-8 w-8 p-0">
                      <span className="sr-only">Open menu</span>
                      <MoreHorizontal className="h-4 w-4" />
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <DropdownMenuItem onClick={() => onCapPhat(item)}>
                      <ArrowRightLeft className="mr-2 h-4 w-4 text-green-600" />
                      Cấp phát
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => onThuHoi(item)}>
                      <ArrowRightLeft className="mr-2 h-4 w-4 text-blue-600" />
                      Thu hồi
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => onLichSu(item)}>
                      <History className="mr-2 h-4 w-4" />
                      Lịch sử
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={() => onEdit(item)}>
                      <FileEdit className="mr-2 h-4 w-4" />
                      Sửa
                    </DropdownMenuItem>
                    <DropdownMenuItem 
                      onClick={() => onDelete(item)}
                      className="text-red-600 focus:text-red-600"
                    >
                      <Trash2 className="mr-2 h-4 w-4" />
                      Xóa
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  )
}
