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
import { Badge } from "@/components/ui/badge"
import { MoreHorizontal, FileEdit, Trash2, ArrowRightLeft, History, PackageOpen } from "lucide-react"
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
  onCapPhatTatCa: (item: KhoTaiSan) => void
  onThuHoi: (item: KhoTaiSan) => void
  onLichSu: (item: KhoTaiSan) => void
}

export function KhoTaiSanDataTable({
  data,
  onEdit,
  onDelete,
  onCapPhat,
  onCapPhatTatCa,
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
          {data.length === 0 ? (
            <TableRow>
              <TableCell colSpan={8} className="h-64 text-center">
                <div className="flex flex-col items-center justify-center space-y-3 text-muted-foreground">
                  <div className="flex h-16 w-16 items-center justify-center rounded-full bg-muted/30">
                    <PackageOpen className="h-8 w-8 text-muted-foreground/60" />
                  </div>
                  <p className="text-sm font-medium">Chưa có tài sản nào trong kho</p>
                  <p className="text-xs text-muted-foreground/70 max-w-sm text-center">
                    Bấm "Thêm mới" để tạo danh mục thiết bị, nội thất và công cụ quản lý cho khu trọ của bạn.
                  </p>
                </div>
              </TableCell>
            </TableRow>
          ) : (
            data.map((item) => (
            <TableRow key={item.id || item._id}>
              <TableCell>
                {item.hinhAnh ? (
                  <img src={item.hinhAnh} alt={item.tenTaiSan} className="w-12 h-12 object-cover rounded-xl shadow-xs border border-border/50" />
                ) : (
                  <div className="w-12 h-12 bg-muted/40 flex items-center justify-center rounded-xl text-[10px] text-muted-foreground border border-border/50 shadow-xs">Trống</div>
                )}
              </TableCell>
              <TableCell className="font-medium">{item.tenTaiSan}</TableCell>
              <TableCell className="text-center font-bold text-[#243B5A] bg-[#243B5A]/5 rounded-l-sm">{item.tongSoLuong}</TableCell>
              <TableCell className="text-center font-bold text-emerald-600 bg-emerald-50">{item.soLuongKhaDung}</TableCell>
              <TableCell className="text-center font-bold text-blue-600 bg-blue-50">{item.soLuongDaCapPhat}</TableCell>
              <TableCell className="text-center font-bold text-red-600 bg-red-50 rounded-r-sm">{item.soLuongHuHong}</TableCell>
              <TableCell>
                <Badge variant={item.tinhTrang === 'Tốt' ? 'success' : item.tinhTrang === 'Bình thường' ? 'info' : 'destructive'} className="font-medium shadow-none">
                  {item.tinhTrang || 'Bình thường'}
                </Badge>
              </TableCell>
              <TableCell className="text-right">
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" className="h-8 w-8 p-0">
                      <span className="sr-only">Open menu</span>
                      <MoreHorizontal className="h-4 w-4" />
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end" className="w-48">
                    <DropdownMenuItem onClick={() => onCapPhat(item)}>
                      <ArrowRightLeft className="mr-2 h-4 w-4 text-emerald-600" />
                      Cấp phát 1 phòng
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => onCapPhatTatCa(item)}>
                      <ArrowRightLeft className="mr-2 h-4 w-4 text-purple-600" />
                      Cấp phát bổ sung
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => onThuHoi(item)}>
                      <ArrowRightLeft className="mr-2 h-4 w-4 text-blue-600" />
                      Thu hồi
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => onLichSu(item)}>
                      <History className="mr-2 h-4 w-4 text-slate-500" />
                      Lịch sử
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={() => onEdit(item)}>
                      <FileEdit className="mr-2 h-4 w-4 text-slate-500" />
                      Sửa thông tin
                    </DropdownMenuItem>
                    <DropdownMenuItem 
                      onClick={() => onDelete(item)}
                      className="text-red-600 focus:text-red-600 focus:bg-red-50"
                    >
                      <Trash2 className="mr-2 h-4 w-4" />
                      Xóa tài sản
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </TableCell>
            </TableRow>
          )))}
        </TableBody>
      </Table>
    </div>
  )
}

