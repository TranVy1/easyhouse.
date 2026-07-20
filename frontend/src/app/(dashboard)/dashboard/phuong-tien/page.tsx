"use client"

import { useState, useEffect, useCallback } from "react"
import { useSession } from "next-auth/react"
import { Search, Plus, RefreshCw, Car, CheckCircle2, XCircle } from "lucide-react"
import { toast } from "sonner"
import { PhuongTien, ToaNha } from "@/types"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { DashboardCard, DashboardKpiCard } from "@/components/dashboard/shared-ui"
import { EmptyState, ErrorState } from "@/components/dashboard/dashboard-ui"
import { PhuongTienDataTable } from "./table"
import { PhuongTienForm } from "./form"

export default function PhuongTienPage() {
  const { data: session } = useSession()
  const accessToken = session?.accessToken

  const [data, setData] = useState<PhuongTien[]>([])
  const [toaNhas, setToaNhas] = useState<ToaNha[]>([])
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
  const [error, setError] = useState<string | null>(null)
  
  const [search, setSearch] = useState("")
  const [filters, setFilters] = useState({
    nhaTroId: "all",
    trangThai: "all",
  })
  
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 })
  const [total, setTotal] = useState(0)
  const [totalPages, setTotalPages] = useState(1)
  
  const [isFormOpen, setIsFormOpen] = useState(false)
  const [editingItem, setEditingItem] = useState<PhuongTien | null>(null)

  useEffect(() => {
    document.title = "Quản lý Phương tiện | EasyHouse"
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
      if (filters.trangThai !== "all") query.set("trangThai", filters.trangThai)
      query.set("page", String(pagination.pageIndex + 1))
      query.set("limit", String(pagination.pageSize))
      
      const res = await fetch(`/api/phuong-tien?${query.toString()}`, {
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
    fetchToaNhas()
  }, [fetchToaNhas])
  
  useEffect(() => {
    fetchData()
  }, [fetchData])

  const handleCreate = () => {
    setEditingItem(null)
    setIsFormOpen(true)
  }

  const handleEdit = (item: PhuongTien) => {
    setEditingItem(item)
    setIsFormOpen(true)
  }

  const handleDelete = async (item: PhuongTien) => {
    if (!confirm(`Bạn có chắc muốn xóa phương tiện ${item.bienSo}?`)) return
    try {
      const res = await fetch(`/api/phuong-tien/${item.id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${accessToken}` }
      })
      const json = await res.json()
      if (json.success) {
        toast.success("Đã xóa phương tiện")
        fetchData()
      } else {
        throw new Error(json.message)
      }
    } catch (e: any) {
      toast.error(e.message || "Lỗi xóa phương tiện")
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
          <h1 className="text-2xl font-bold tracking-tight">Quản lý phương tiện</h1>
          <p className="text-muted-foreground">Theo dõi xe cộ của khách thuê trong các tòa nhà.</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Button variant="outline" size="sm" onClick={() => fetchData(true)} disabled={loading || refreshing}>
            <RefreshCw className={`mr-2 h-4 w-4 ${refreshing ? "animate-spin" : ""}`} />
            Làm mới
          </Button>
          <Button size="sm" onClick={handleCreate}>
            <Plus className="mr-2 h-4 w-4" />
            Thêm phương tiện
          </Button>
        </div>
      </div>

      <div className="grid gap-6 grid-cols-1 md:grid-cols-3">
        <DashboardKpiCard
          title="Tổng xe"
          value={total.toString()}
          icon={<Car className="h-5 w-5" />}
          hint="Đang quản lý"
        />
        <DashboardKpiCard
          title="Có hiệu lực"
          value={data.filter(x => x.trangThai === "HIEU_LUC").length.toString() + (total > data.length ? "+" : "")}
          icon={<CheckCircle2 className="h-5 w-5" />}
          hint="Trong trang hiện tại"
        />
        <DashboardKpiCard
          title="Hết hiệu lực"
          value={data.filter(x => x.trangThai === "HET_HIEU_LUC").length.toString() + (total > data.length ? "+" : "")}
          icon={<XCircle className="h-5 w-5" />}
          hint="Trong trang hiện tại"
        />
      </div>

      <div className="flex flex-col gap-4 sm:flex-row sm:items-center bg-white p-4 rounded-xl shadow-sm border border-border/50">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Tìm kiếm biển số, mã xe..."
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
            setFilters(prev => ({ ...prev, nhaTroId: val }))
            setPagination(prev => ({ ...prev, pageIndex: 0 }))
          }}
        >
          <SelectTrigger className="w-full sm:w-[200px] bg-gray-50/50">
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
          value={filters.trangThai} 
          onValueChange={(val) => {
            setFilters(prev => ({ ...prev, trangThai: val }))
            setPagination(prev => ({ ...prev, pageIndex: 0 }))
          }}
        >
          <SelectTrigger className="w-full sm:w-[180px] bg-gray-50/50">
            <SelectValue placeholder="Trạng thái" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tất cả trạng thái</SelectItem>
            <SelectItem value="HIEU_LUC">Hiệu lực</SelectItem>
            <SelectItem value="HET_HIEU_LUC">Hết hiệu lực</SelectItem>
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
          title="Không có phương tiện nào"
          description="Nhấn 'Thêm phương tiện' để bắt đầu quản lý xe cộ."
        />
      ) : (
        <div className="bg-white rounded-xl shadow-sm border border-border/50 overflow-hidden">
          <PhuongTienDataTable
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
        <PhuongTienForm
          open={isFormOpen}
          onOpenChange={setIsFormOpen}
          initialData={editingItem}
          toaNhas={toaNhas}
          onSuccess={handleFormSuccess}
        />
      )}
    </div>
  )
}
