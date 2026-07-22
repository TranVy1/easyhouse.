"use client"

import { useState, useEffect, useCallback } from "react"
import { useSession } from "next-auth/react"
import { Search, Plus, RefreshCw, Box, ArrowRightLeft, History, CheckCircle2 } from "lucide-react"
import { toast } from "sonner"
import { ToaNha, KhoTaiSan } from "@/types"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { DashboardKpiCard } from "@/components/dashboard/shared-ui"
import { EmptyState, ErrorState } from "@/components/dashboard/dashboard-ui"
import { KhoTaiSanDataTable } from "./table"
import { KhoTaiSanForm } from "./form"
import { CapPhatThuHoiDialog } from "./CapPhatThuHoiDialog"
import { LichSuKhoDialog } from "./LichSuKhoDialog"
import { ConfirmActionDialog } from "@/components/ui/confirm-action-dialog"

export default function KhoTaiSanPage() {
  const { data: session } = useSession()
  const accessToken = session?.accessToken

  const [data, setData] = useState<KhoTaiSan[]>([])
  const [toaNhas, setToaNhas] = useState<ToaNha[]>([])
  
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
  const [error, setError] = useState<string | null>(null)
  
  const [search, setSearch] = useState("")
  const [selectedNhaTroId, setSelectedNhaTroId] = useState<string>("all")
  
  const [isFormOpen, setIsFormOpen] = useState(false)
  const [editingItem, setEditingItem] = useState<KhoTaiSan | null>(null)
  
  const [isConfirmOpen, setIsConfirmOpen] = useState(false)
  const [itemToDelete, setItemToDelete] = useState<KhoTaiSan | null>(null)
  const [isDeleting, setIsDeleting] = useState(false)
  
  const [isCapPhatOpen, setIsCapPhatOpen] = useState(false)
  const [isThuHoiOpen, setIsThuHoiOpen] = useState(false)
  const [isLichSuOpen, setIsLichSuOpen] = useState(false)
  const [selectedItem, setSelectedItem] = useState<KhoTaiSan | null>(null)

  useEffect(() => {
    document.title = "Kho tài sản | EasyHouse"
  }, [])

  const fetchToaNhas = useCallback(async () => {
    if (!accessToken) return
    try {
      const res = await fetch("/api/toa-nha", {
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      const json = await res.json()
      if (json.success) {
        const data = Array.isArray(json.data) ? json.data : (json.data?.data || [])
        setToaNhas(data)
        if (data.length > 0 && selectedNhaTroId === "all") {
          setSelectedNhaTroId(String(data[0].id || data[0]._id))
        }
      }
    } catch (e) {
      console.error("Lỗi tải danh sách tòa nhà:", e)
    }
  }, [accessToken, selectedNhaTroId])

  useEffect(() => {
    fetchToaNhas()
  }, [fetchToaNhas])

  const fetchData = useCallback(async (isRefresh = false) => {
    if (!accessToken || selectedNhaTroId === "all") {
      setData([])
      setLoading(false)
      return
    }
    
    if (isRefresh) setRefreshing(true)
    else setLoading(true)
    
    setError(null)
    
    try {
      const res = await fetch(`/api/kho-tai-san/nha-tro/${selectedNhaTroId}`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      const json = await res.json()
      if (json.success) {
        setData(json.data || [])
      } else {
        throw new Error(json.message || "Không thể tải dữ liệu")
      }
    } catch (e: any) {
      setError(e.message || "Đã xảy ra lỗi")
    } finally {
      setLoading(false)
      setRefreshing(false)
    }
  }, [accessToken, selectedNhaTroId])

  useEffect(() => {
    fetchData()
  }, [fetchData])

  const handleCreate = () => {
    setEditingItem(null)
    setIsFormOpen(true)
  }

  const handleEdit = (item: KhoTaiSan) => {
    setEditingItem(item)
    setIsFormOpen(true)
  }

  const handleDelete = (item: KhoTaiSan) => {
    if (item.soLuongDaCapPhat && item.soLuongDaCapPhat > 0) {
      toast.error("Không thể xóa tài sản đã được cấp phát. Thu hồi trước khi xóa.")
      return
    }
    setItemToDelete(item)
    setIsConfirmOpen(true)
  }

  const handleCapPhat = (item: KhoTaiSan) => {
    if (item.soLuongKhaDung === 0) {
      toast.error("Không còn tài sản khả dụng để cấp phát")
      return
    }
    setSelectedItem(item)
    setIsCapPhatOpen(true)
  }

  const handleThuHoi = (item: KhoTaiSan) => {
    if (!item.soLuongDaCapPhat || item.soLuongDaCapPhat === 0) {
      toast.error("Tài sản chưa được cấp phát")
      return
    }
    setSelectedItem(item)
    setIsThuHoiOpen(true)
  }

  const handleLichSu = (item: KhoTaiSan) => {
    setSelectedItem(item)
    setIsLichSuOpen(true)
  }

  const confirmDelete = async () => {
    if (!itemToDelete) return
    setIsDeleting(true)
    try {
      const res = await fetch(`/api/kho-tai-san/${itemToDelete.id || itemToDelete._id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      const json = await res.json()
      if (json.success) {
        toast.success("Đã xóa tài sản khỏi kho")
        fetchData()
      } else {
        throw new Error(json.message || "Lỗi khi xóa")
      }
    } catch (e: any) {
      toast.error(e.message || "Lỗi xóa tài sản")
    } finally {
      setIsDeleting(false)
      setIsConfirmOpen(false)
      setItemToDelete(null)
    }
  }

  const filteredData = data.filter(item => 
    !search || item.tenTaiSan.toLowerCase().includes(search.toLowerCase())
  )

  const tongTonKho = data.reduce((sum, item) => sum + (item.tongSoLuong || 0), 0)
  const tongKhaDung = data.reduce((sum, item) => sum + (item.soLuongKhaDung || 0), 0)
  const tongDaCap = data.reduce((sum, item) => sum + (item.soLuongDaCapPhat || 0), 0)

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Kho tài sản</h1>
          <p className="text-muted-foreground">Quản lý nhập, cấp phát và thu hồi tài sản chung.</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Button variant="outline" size="sm" onClick={() => fetchData(true)} disabled={loading || refreshing}>
            <RefreshCw className={`mr-2 h-4 w-4 ${refreshing ? "animate-spin" : ""}`} />
            Làm mới
          </Button>
          <Button size="sm" onClick={handleCreate} disabled={selectedNhaTroId === "all"}>
            <Plus className="mr-2 h-4 w-4" />
            Nhập kho
          </Button>
        </div>
      </div>

      <div className="grid gap-6 grid-cols-1 md:grid-cols-3">
        <DashboardKpiCard
          title="Tổng tồn kho"
          value={tongTonKho.toString()}
          icon={<Box className="h-5 w-5" />}
          hint="Tổng số lượng nhập"
        />
        <DashboardKpiCard
          title="Đang khả dụng"
          value={tongKhaDung.toString()}
          icon={<CheckCircle2 className="h-5 w-5" />}
          hint="Có thể cấp phát"
        />
        <DashboardKpiCard
          title="Đã cấp phát"
          value={tongDaCap.toString()}
          icon={<ArrowRightLeft className="h-5 w-5" />}
          hint="Đang dùng ở các phòng"
        />
      </div>

      <div className="flex flex-col gap-4 sm:flex-row sm:items-center bg-white p-4 rounded-xl shadow-sm border border-border/50 flex-wrap">
        <Select 
          value={selectedNhaTroId} 
          onValueChange={setSelectedNhaTroId}
        >
          <SelectTrigger className="w-full sm:w-[250px] bg-gray-50/50">
            <SelectValue placeholder="Chọn Tòa nhà" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">-- Vui lòng chọn tòa nhà --</SelectItem>
            {toaNhas.map(t => (
              <SelectItem key={String(t.id || t._id)} value={String(t.id || t._id)}>{t.tenToaNha}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <div className="relative flex-1 min-w-[200px]">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Tìm kiếm tài sản trong kho..."
            className="pl-9 bg-gray-50/50"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      {error ? (
        <ErrorState title="Lỗi tải dữ liệu" description={error} onRetry={() => fetchData(true)} />
      ) : loading ? (
        <div className="space-y-4">
          <div className="h-10 animate-pulse rounded-md bg-muted" />
          <div className="h-[400px] animate-pulse rounded-xl bg-muted" />
        </div>
      ) : filteredData.length === 0 ? (
        <EmptyState
          title="Chưa có tài sản trong kho"
          description="Nhấn 'Nhập kho' để thêm tài sản mới cho tòa nhà này."
        />
      ) : (
        <div className="bg-white rounded-xl shadow-sm border border-border/50 overflow-hidden">
          <KhoTaiSanDataTable
            data={filteredData}
            onEdit={handleEdit}
            onDelete={handleDelete}
            onCapPhat={handleCapPhat}
            onThuHoi={handleThuHoi}
            onLichSu={handleLichSu}
          />
        </div>
      )}

      {isFormOpen && (
        <KhoTaiSanForm
          open={isFormOpen}
          onOpenChange={setIsFormOpen}
          initialData={editingItem}
          nhaTroId={selectedNhaTroId}
          onSuccess={() => {
            setIsFormOpen(false)
            fetchData()
          }}
        />
      )}

      {isCapPhatOpen && selectedItem && (
        <CapPhatThuHoiDialog
          type="CAP_PHAT"
          open={isCapPhatOpen}
          onOpenChange={setIsCapPhatOpen}
          khoTaiSan={selectedItem}
          accessToken={(accessToken as string) || ""}
          onSuccess={() => {
            setIsCapPhatOpen(false)
            fetchData()
          }}
        />
      )}

      {isThuHoiOpen && selectedItem && (
        <CapPhatThuHoiDialog
          type="THU_HOI"
          open={isThuHoiOpen}
          onOpenChange={setIsThuHoiOpen}
          khoTaiSan={selectedItem}
          accessToken={(accessToken as string) || ""}
          onSuccess={() => {
            setIsThuHoiOpen(false)
            fetchData()
          }}
        />
      )}

      {isLichSuOpen && selectedItem && (
        <LichSuKhoDialog
          open={isLichSuOpen}
          onOpenChange={setIsLichSuOpen}
          khoTaiSanId={selectedItem.id || selectedItem._id || ""}
          accessToken={(accessToken as string) || ""}
        />
      )}

      <ConfirmActionDialog
        open={isConfirmOpen}
        onOpenChange={setIsConfirmOpen}
        title="Xác nhận xóa tài sản kho"
        description={`Bạn có chắc muốn xóa tài sản ${itemToDelete?.tenTaiSan}? Thao tác này không thể hoàn tác.`}
        confirmText="Xóa tài sản"
        variant="destructive"
        loading={isDeleting}
        onConfirm={confirmDelete}
      />
    </div>
  )
}
