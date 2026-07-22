"use client"

import { useState, useEffect, useCallback } from "react"
import { useSession } from "next-auth/react"
import { Search, Plus, RefreshCw, Box, CheckCircle2, AlertTriangle, Download, FileUp } from "lucide-react"
import { toast } from "sonner"
import { TaiSanPhong, ToaNha, Phong } from "@/types"
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
import { TaiSanPhongDataTable } from "./table"
import { TaiSanPhongForm } from "./form"
import { ConfirmActionDialog } from "@/components/ui/confirm-action-dialog"
import { TaiSanPhongImportDialog } from "./TaiSanPhongImportDialog"

export default function TaiSanPhongPage() {
  const { data: session } = useSession()
  const accessToken = session?.accessToken

  const [data, setData] = useState<TaiSanPhong[]>([])
  const [toaNhas, setToaNhas] = useState<ToaNha[]>([])
  const [phongs, setPhongs] = useState<Phong[]>([])

  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [search, setSearch] = useState("")
  const [filters, setFilters] = useState({
    nhaTroId: "all",
    phongId: "all",
    tinhTrang: "all",
  })

  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 })
  const [total, setTotal] = useState(0)
  const [totalPages, setTotalPages] = useState(1)

  const [isFormOpen, setIsFormOpen] = useState(false)
  const [isImportOpen, setIsImportOpen] = useState(false)
  const [editingItem, setEditingItem] = useState<TaiSanPhong | null>(null)

  const [isConfirmOpen, setIsConfirmOpen] = useState(false)
  const [itemToDelete, setItemToDelete] = useState<TaiSanPhong | null>(null)
  const [isDeleting, setIsDeleting] = useState(false)

  useEffect(() => {
    document.title = "Quản lý Tài sản | EasyHouse"
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
      }
    } catch (e) {
      console.error("Lỗi tải danh sách tòa nhà:", e)
    }
  }, [accessToken])

  const fetchPhongs = useCallback(async () => {
    if (!accessToken || filters.nhaTroId === "all") {
      setPhongs([])
      return
    }
    try {
      const res = await fetch(`/api/phong/nha-tro/${filters.nhaTroId}`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      const json = await res.json()
      if (json.success) {
        setPhongs(Array.isArray(json.data) ? json.data : (json.data?.data || []))
      }
    } catch (e) {
      console.error("Lỗi tải danh sách phòng:", e)
    }
  }, [accessToken, filters.nhaTroId])

  useEffect(() => {
    fetchToaNhas()
  }, [fetchToaNhas])

  useEffect(() => {
    fetchPhongs()
  }, [fetchPhongs])

  const fetchData = useCallback(async (isRefresh = false) => {
    if (!accessToken) return
    if (isRefresh) {
      setRefreshing(true)
    } else {
      setLoading(true)
    }
    setError(null)

    try {
      const query = new URLSearchParams()
      if (search) query.set("keyword", search)
      if (filters.nhaTroId !== "all") query.set("nhaTroId", filters.nhaTroId)
      if (filters.phongId !== "all") query.set("phongId", filters.phongId)
      if (filters.tinhTrang !== "all") query.set("tinhTrang", filters.tinhTrang)
      query.set("page", String(pagination.pageIndex + 1))
      query.set("limit", String(pagination.pageSize))

      const res = await fetch(`/api/tai-san-phong?${query.toString()}`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      const json = await res.json()
      if (json.success) {
        setData(json.data.data || json.data.content || [])
        setTotal(json.data.total || json.data.totalElements || 0)
        setTotalPages(json.data.totalPages || 1)
      } else {
        throw new Error(json.message || "Không thể tải dữ liệu")
      }
    } catch (e: any) {
      setError(e.message || "Đã xảy ra lỗi")
    } finally {
      setLoading(false)
      setRefreshing(false)
    }
  }, [accessToken, search, filters, pagination])

  useEffect(() => {
    fetchData()
  }, [fetchData])

  const handleCreate = () => {
    setEditingItem(null)
    setIsFormOpen(true)
  }

  const handleEdit = (item: TaiSanPhong) => {
    setEditingItem(item)
    setIsFormOpen(true)
  }

  const handleDelete = (item: TaiSanPhong) => {
    setItemToDelete(item)
    setIsConfirmOpen(true)
  }

  const confirmDelete = async () => {
    if (!itemToDelete) return
    setIsDeleting(true)
    try {
      const res = await fetch(`/api/tai-san-phong/${itemToDelete.id || itemToDelete._id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      const json = await res.json()
      if (json.success) {
        toast.success("Đã xóa tài sản")
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

  const handleFormSuccess = () => {
    setIsFormOpen(false)
    fetchData()
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Quản lý tài sản phòng</h1>
          <p className="text-muted-foreground">Kiểm soát trang thiết bị, nội thất ở tất cả các phòng.</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Button variant="outline" size="sm" asChild>
            <a href="/api/tai-san-phong/import/template" download>
              <Download className="mr-2 h-4 w-4" />
              Tải file mẫu
            </a>
          </Button>
          <Button variant="outline" size="sm" onClick={() => setIsImportOpen(true)}>
            <FileUp className="mr-2 h-4 w-4" />
            Import CSV
          </Button>
          <Button variant="outline" size="sm" onClick={() => fetchData(true)} disabled={loading || refreshing}>
            <RefreshCw className={`mr-2 h-4 w-4 ${refreshing ? "animate-spin" : ""}`} />
            Làm mới
          </Button>
          <Button size="sm" onClick={handleCreate}>
            <Plus className="mr-2 h-4 w-4" />
            Thêm tài sản
          </Button>
        </div>
      </div>

      <div className="grid gap-6 grid-cols-1 md:grid-cols-3">
        <DashboardKpiCard
          title="Tổng tài sản"
          value={total.toString()}
          icon={<Box className="h-5 w-5" />}
          hint="Thiết bị đang quản lý"
        />
        <DashboardKpiCard
          title="Mới / Tốt"
          value={data.filter(x => ["Mới", "Tốt"].includes(x.tinhTrang)).length.toString() + (total > data.length ? "+" : "")}
          icon={<CheckCircle2 className="h-5 w-5" />}
          hint="Trong trang hiện tại"
        />
        <DashboardKpiCard
          title="Cũ / Hư hỏng"
          value={data.filter(x => ["Cũ", "Hư hỏng"].includes(x.tinhTrang)).length.toString() + (total > data.length ? "+" : "")}
          icon={<AlertTriangle className="h-5 w-5" />}
          hint="Cần sửa chữa hoặc thay thế"
        />
      </div>

      <div className="flex flex-col gap-4 sm:flex-row sm:items-center bg-white p-4 rounded-xl shadow-sm border border-border/50 flex-wrap">
        <div className="relative flex-1 min-w-[200px]">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Tìm kiếm tài sản..."
            className="pl-9 bg-gray-50/50"
            value={search}
            onChange={(e) => {
              setSearch(e.target.value)
              setPagination(prev => ({ ...prev, pageIndex: 0 }))
            }}
          />
        </div>

        <Select
          value={filters.nhaTroId}
          onValueChange={(val) => {
            setFilters(prev => ({ ...prev, nhaTroId: val, phongId: "all" }))
            setPagination(prev => ({ ...prev, pageIndex: 0 }))
          }}
        >
          <SelectTrigger className="w-full sm:w-[180px] bg-gray-50/50">
            <SelectValue placeholder="Tất cả Tòa nhà" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tất cả Tòa nhà</SelectItem>
            {toaNhas.map(t => (
              <SelectItem key={String(t.id || t._id)} value={String(t.id || t._id)}>{t.tenToaNha}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select
          value={filters.phongId}
          onValueChange={(val) => {
            setFilters(prev => ({ ...prev, phongId: val }))
            setPagination(prev => ({ ...prev, pageIndex: 0 }))
          }}
          disabled={filters.nhaTroId === "all"}
        >
          <SelectTrigger className="w-full sm:w-[160px] bg-gray-50/50">
            <SelectValue placeholder="Tất cả Phòng" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tất cả Phòng</SelectItem>
            {phongs.map(p => (
              <SelectItem key={String(p.id || p._id)} value={String(p.id || p._id)}>{p.ten || p.maPhong}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select
          value={filters.tinhTrang}
          onValueChange={(val) => {
            setFilters(prev => ({ ...prev, tinhTrang: val }))
            setPagination(prev => ({ ...prev, pageIndex: 0 }))
          }}
        >
          <SelectTrigger className="w-full sm:w-[150px] bg-gray-50/50">
            <SelectValue placeholder="Tình trạng" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Mọi tình trạng</SelectItem>
            <SelectItem value="Mới">Mới</SelectItem>
            <SelectItem value="Tốt">Tốt</SelectItem>
            <SelectItem value="Bình thường">Bình thường</SelectItem>
            <SelectItem value="Cũ">Cũ</SelectItem>
            <SelectItem value="Hư hỏng">Hư hỏng</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {error ? (
        <ErrorState title="Lỗi tải dữ liệu" description={error} onRetry={() => fetchData(true)} />
      ) : loading ? (
        <div className="space-y-4">
          <div className="h-10 animate-pulse rounded-md bg-muted" />
          <div className="h-[400px] animate-pulse rounded-xl bg-muted" />
        </div>
      ) : data.length === 0 ? (
        <EmptyState
          title="Không có tài sản nào"
          description="Nhấn 'Thêm tài sản' để bắt đầu quản lý thiết bị."
        />
      ) : (
        <div className="bg-white rounded-xl shadow-sm border border-border/50 overflow-hidden">
          <TaiSanPhongDataTable
            data={data}
            onEdit={handleEdit}
            onDelete={handleDelete}
            pagination={pagination}
            setPagination={setPagination}
            total={total}
            pageCount={totalPages}
          />
        </div>
      )}

      {isFormOpen && (
        <TaiSanPhongForm
          open={isFormOpen}
          onOpenChange={setIsFormOpen}
          initialData={editingItem}
          toaNhas={toaNhas}
          onSuccess={handleFormSuccess}
        />
      )}

      <ConfirmActionDialog
        open={isConfirmOpen}
        onOpenChange={setIsConfirmOpen}
        title="Xác nhận xóa tài sản"
        description={`Bạn có chắc muốn xóa tài sản ${itemToDelete?.tenTaiSan}? Thao tác này không thể hoàn tác.`}
        confirmText="Xóa tài sản"
        variant="destructive"
        loading={isDeleting}
        onConfirm={confirmDelete}
      />

      <TaiSanPhongImportDialog
        open={isImportOpen}
        onOpenChange={setIsImportOpen}
        onSuccess={() => {
          setIsImportOpen(false)
          fetchData(true)
        }}
        accessToken={session?.accessToken || ""}
      />
    </div>
  )
}
