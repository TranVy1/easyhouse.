"use client"

import { useCallback, useEffect, useMemo, useState, type FormEvent } from "react"
import { useSession } from "next-auth/react"
import {
  Bolt,
  CalendarDays,
  ChevronLeft,
  ChevronRight,
  Droplets,
  FileCheck2,
  Image as ImageIcon,
  Pencil,
  Plus,
  RefreshCw,
  Trash2,
} from "lucide-react"
import { toast } from "sonner"

import { EmptyState, ErrorState } from "@/components/dashboard/dashboard-ui"
import { DashboardCard, HeroActionButton } from "@/components/dashboard/shared-ui"
import { ImageUpload } from "@/components/ui/image-upload"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Textarea } from "@/components/ui/textarea"
import { unwrapPageData } from "@/lib/api-response"
import type { ApiResponse, ChiSoDienNuoc, LoaiChiSo, PaginatedResponse, Phong, TrangThaiChiSo } from "@/types"

type ReadingFormData = {
  toaNhaId: string
  phongId: string
  loai: LoaiChiSo
  kyNam: number
  kyThang: number
  ngayGhi: string
  chiSoCu: number
  chiSoMoi: number
  trangThai: "DRAFT" | "CONFIRMED"
  ghiChu: string
  anhDongHo: string
}

const today = new Date()

const blankForm = (): ReadingFormData => ({
  toaNhaId: "",
  phongId: "",
  loai: "ELECTRICITY",
  kyNam: today.getFullYear(),
  kyThang: today.getMonth() + 1,
  ngayGhi: today.toISOString().slice(0, 10),
  chiSoCu: 0,
  chiSoMoi: 0,
  trangThai: "DRAFT",
  ghiChu: "",
  anhDongHo: "",
})

const readingId = (item: ChiSoDienNuoc) => item._id || item.id || ""

const roomId = (room: Phong) => String(room._id || room.id || "")

const buildingId = (room: Phong) => String(
  (room.toaNha as any)?._id || (room.toaNha as any)?.id || room.nhaTroId || "",
)

const isRentedRoom = (room: Phong) => room.trangThai === "RENTED" || room.trangThai === "dangThue"

const roomName = (item: ChiSoDienNuoc) => {
  if (typeof item.phong === "object" && item.phong !== null) {
    return item.phong.maPhong || item.phong.ten || "Chưa xác định"
  }
  return "Chưa xác định"
}

function statusBadge(status?: TrangThaiChiSo) {
  switch (status) {
    case "CONFIRMED":
      return <Badge className="border-transparent bg-[#4FA7A0]/15 text-[#243B5A]">Đã chốt</Badge>
    case "BILLED":
      return <Badge className="border-transparent bg-[#4FA7A0]/15 text-[#267D76]">Đã lên hóa đơn</Badge>
    case "CANCELLED":
      return <Badge variant="secondary">Đã hủy</Badge>
    default:
      return <Badge variant="outline">Bản nháp</Badge>
  }
}

function ReadingSkeleton() {
  return (
    <div className="space-y-6" aria-label="Đang tải chỉ số điện nước">
      <div className="h-20 animate-pulse rounded-xl bg-muted" />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {Array.from({ length: 4 }, (_, index) => (
          <div key={index} className="h-32 animate-pulse rounded-xl bg-muted" />
        ))}
      </div>
      <div className="h-[420px] animate-pulse rounded-xl bg-muted" />
    </div>
  )
}

export default function ChiSoDienNuocPage() {
  const accessToken = useSession()?.data?.accessToken
  const [data, setData] = useState<ChiSoDienNuoc[]>([])
  const [buildings, setBuildings] = useState<any[]>([])
  const [rooms, setRooms] = useState<Phong[]>([])
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [formOpen, setFormOpen] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [editing, setEditing] = useState<ChiSoDienNuoc | null>(null)
  const [cancelTarget, setCancelTarget] = useState<ChiSoDienNuoc | null>(null)
  const [formData, setFormData] = useState<ReadingFormData>(blankForm)
  const [filters, setFilters] = useState({
    toaNhaId: "all",
    phongId: "all",
    loai: "all",
    trangThai: "all",
    kyThang: String(today.getMonth() + 1),
    kyNam: String(today.getFullYear()),
  })
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 })
  const [totalElements, setTotalElements] = useState(0)
  const [totalPages, setTotalPages] = useState(0)

  useEffect(() => {
    document.title = "Chỉ số điện nước | EasyHouse"
  }, [])

  const fetchBuildings = useCallback(async () => {
    try {
      const response = await fetch("/api/toa-nha?page=1&limit=100", {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      })
      const result = await response.json()
      if (response.ok && result.success) setBuildings(unwrapPageData(result.data))
    } catch {
      setBuildings([])
    }
  }, [accessToken])

  const fetchRooms = useCallback(async () => {
    try {
      const response = await fetch("/api/phong?page=1&limit=100&simple=true", {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      })
      const result: ApiResponse<Phong[] | PaginatedResponse<Phong>> = await response.json()
      if (response.ok && result.success) setRooms(unwrapPageData(result.data))
    } catch {
      setRooms([])
    }
  }, [accessToken])

  const fetchReadings = useCallback(
    async (isRefresh = false) => {
      if (isRefresh) {
        setRefreshing(true)
      } else {
        setLoading(true)
      }
      setError(null)

      try {
        const params = new URLSearchParams({
          page: String(pagination.pageIndex + 1),
          limit: String(pagination.pageSize),
          sort: "kyNam,desc",
        })
        if (filters.phongId !== "all") params.set("phongId", filters.phongId)
        if (filters.toaNhaId !== "all") params.set("nhaTroId", filters.toaNhaId)
        if (filters.loai !== "all") params.set("loai", filters.loai)
        if (filters.trangThai !== "all") params.set("trangThai", filters.trangThai)
        if (filters.kyThang !== "all") params.set("kyThang", filters.kyThang)
        if (filters.kyNam !== "all") params.set("kyNam", filters.kyNam)

        const response = await fetch(`/api/chi-so-dien-nuoc?${params.toString()}`, {
          headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
        })
        const result: ApiResponse<PaginatedResponse<ChiSoDienNuoc>> = await response.json()
        if (!response.ok || !result.success || !result.data) {
          throw new Error(result.message || "Không thể tải dữ liệu chỉ số.")
        }
        setData(result.data.data || [])
        setTotalElements(result.data.total || 0)
        setTotalPages(result.data.totalPages || 0)
      } catch (requestError) {
        setData([])
        setError(requestError instanceof Error ? requestError.message : "Không thể kết nối máy chủ.")
      } finally {
        setLoading(false)
        setRefreshing(false)
      }
    },
    [accessToken, filters, pagination.pageIndex, pagination.pageSize],
  )

  useEffect(() => {
    fetchBuildings()
    fetchRooms()
  }, [fetchBuildings, fetchRooms])

  useEffect(() => {
    fetchReadings()
  }, [fetchReadings])

  const pageTotals = useMemo(
    () => ({
      electricity: data.filter((item) => item.loai === "ELECTRICITY").reduce((sum, item) => sum + (item.tieuThu || 0), 0),
      water: data.filter((item) => item.loai === "WATER").reduce((sum, item) => sum + (item.tieuThu || 0), 0),
      confirmed: data.filter((item) => item.trangThai === "CONFIRMED" || item.trangThai === "BILLED").length,
    }),
    [data],
  )

  const hasDraftReadings = useMemo(
    () => data.some((item) => item.trangThai === "DRAFT"),
    [data],
  )

  const rentableRoomsForForm = useMemo(() => {
    const selectedRoomId = editing
      ? String(typeof editing.phong === "string" ? editing.phong : editing.phong?._id || editing.phong?.id || "")
      : ""
    return rooms.filter((room) => isRentedRoom(room) || roomId(room) === selectedRoomId)
  }, [editing, rooms])

  const periodLabel = filters.kyThang !== "all" && filters.kyNam !== "all"
    ? `Tháng ${filters.kyThang}/${filters.kyNam}`
    : ""

  const updateFilter = (key: keyof typeof filters, value: string) => {
    setPagination((current) => ({ ...current, pageIndex: 0 }))
    if (key === "toaNhaId") {
      setFilters((current) => ({ ...current, toaNhaId: value, phongId: "all" }))
    } else {
      setFilters((current) => ({ ...current, [key]: value }))
    }
  }

  const openCreate = () => {
    setEditing(null)
    setFormData({
      ...blankForm(),
      kyThang: filters.kyThang === "all" ? today.getMonth() + 1 : Number(filters.kyThang),
      kyNam: filters.kyNam === "all" ? today.getFullYear() : Number(filters.kyNam),
      toaNhaId: filters.toaNhaId === "all" ? "" : filters.toaNhaId,
      phongId: filters.phongId === "all" ? "" : filters.phongId,
      loai: filters.loai === "WATER" ? "WATER" : "ELECTRICITY",
    })
    setFormOpen(true)
  }

  const openEdit = (item: ChiSoDienNuoc) => {
    setEditing(item)
    const pId = typeof item.phong === "string" ? item.phong : item.phong._id || item.phong.id || ""
    const roomInfo = rooms.find(r => (r._id || r.id) === pId)
    const tId = roomInfo ? ((roomInfo.toaNha as any)?._id || (roomInfo.toaNha as any)?.id || roomInfo.nhaTroId || "") : ""
    setFormData({
      toaNhaId: String(tId),
      phongId: pId,
      loai: item.loai || "ELECTRICITY",
      kyNam: item.kyNam || today.getFullYear(),
      kyThang: item.kyThang || today.getMonth() + 1,
      ngayGhi: item.ngayGhi ? new Date(item.ngayGhi).toISOString().slice(0, 10) : today.toISOString().slice(0, 10),
      chiSoCu: item.chiSoCu || 0,
      chiSoMoi: item.chiSoMoi || 0,
      trangThai: item.trangThai === "CONFIRMED" ? "CONFIRMED" : "DRAFT",
      ghiChu: item.ghiChu || "",
      anhDongHo: item.anhDongHo || "",
    })
    setFormOpen(true)
  }

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    if (!formData.phongId) {
      toast.error("Vui lòng chọn phòng.")
      return
    }
    if (formData.chiSoMoi < formData.chiSoCu) {
      toast.error("Chỉ số mới không được nhỏ hơn chỉ số cũ.")
      return
    }

    setSubmitting(true)
    try {
      const id = editing ? readingId(editing) : ""
      const response = await fetch(id ? `/api/chi-so-dien-nuoc/${id}` : "/api/chi-so-dien-nuoc", {
        method: id ? "PUT" : "POST",
        headers: {
          "Content-Type": "application/json",
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify(formData),
      })
      const result: ApiResponse<ChiSoDienNuoc> = await response.json()
      if (!response.ok || !result.success) throw new Error(result.message || "Không thể lưu chỉ số.")
      toast.success(id ? "Đã cập nhật chỉ số." : "Đã ghi chỉ số mới.")
      setFormOpen(false)
      await fetchReadings(true)
    } catch (submitError) {
      toast.error(submitError instanceof Error ? submitError.message : "Không thể lưu chỉ số.")
    } finally {
      setSubmitting(false)
    }
  }

  const handleCancel = async () => {
    if (!cancelTarget) return

    setSubmitting(true)
    try {
      const id = readingId(cancelTarget)
      const isBilled = cancelTarget.trangThai === "BILLED"
      const response = await fetch(`/api/chi-so-dien-nuoc/${id}`, {
        method: isBilled ? "PUT" : "DELETE",
        headers: {
          ...(isBilled ? { "Content-Type": "application/json" } : {}),
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: isBilled ? JSON.stringify({ trangThai: "CANCELLED" }) : undefined,
      })
      const result: ApiResponse<unknown> = await response.json()
      if (!response.ok || !result.success) throw new Error(result.message || "Không thể hủy chỉ số.")
      toast.success("Đã hủy chỉ số.")
      setCancelTarget(null)
      await fetchReadings(true)
    } catch (cancelError) {
      toast.error(cancelError instanceof Error ? cancelError.message : "Không thể hủy chỉ số.")
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) return <ReadingSkeleton />

  if (error) {
    return <ErrorState title="Không tải được chỉ số" description={error} onRetry={() => fetchReadings()} />
  }

  return (
    <div className="space-y-6 lg:space-y-8">
      <section className="chi-so-dien-nuoc-hero">
        <div className="chi-so-dien-nuoc-hero__content">
          <div className="chi-so-dien-nuoc-hero__eyebrow">
            <Droplets className="h-4 w-4" aria-hidden="true" />
            {"CH\u1EC8 S\u1ED0 \u0110I\u1EC6N N\u01AF\u1EDAC"}
          </div>

          <div className="chi-so-dien-nuoc-hero__title-row">
            <h1>{"Ch\u1EC9 s\u1ED1 \u0111i\u1EC7n n\u01B0\u1EDBc"}</h1>
            <span className={`chi-so-dien-nuoc-hero__status-badge ${hasDraftReadings ? "is-warning" : ""}`}>
              {hasDraftReadings ? "C\u1EA7n ghi b\u1ED5 sung" : "S\u1EB5n s\u00E0ng ch\u1ED1t ch\u1EC9 s\u1ED1"}
            </span>
          </div>

          <p>{"Ghi v\u00E0 ch\u1ED1t s\u1ED1 \u0111o tr\u01B0\u1EDBc khi l\u1EADp h\u00F3a \u0111\u01A1n; b\u1EA3n ghi \u0111\u00E3 l\u00EAn h\u00F3a \u0111\u01A1n \u0111\u01B0\u1EE3c kh\u00F3a ch\u1EC9nh s\u1EEDa."}</p>

          {data.length > 0 ? (
            <div className="chi-so-dien-nuoc-hero__insight">
              {"Hi\u1EC7n c\u00F3 "}<strong>{totalElements}{" b\u1EA3n ghi"}</strong>{" ph\u00F9 h\u1EE3p, "}<strong>{pageTotals.electricity}{" kWh"}</strong>{" \u0111i\u1EC7n v\u00E0 "}
              <strong>{pageTotals.water}{" m\u00B3"}</strong>{" n\u01B0\u1EDBc c\u1EA7n theo d\u00F5i trong k\u1EF3 n\u00E0y."}
            </div>
          ) : (
            <div className="chi-so-dien-nuoc-hero__insight">{"Ch\u01B0a c\u00F3 b\u1EA3n ghi ph\u00F9 h\u1EE3p v\u1EDBi b\u1ED9 l\u1ECDc hi\u1EC7n t\u1EA1i."}</div>
          )}

          <div className="chi-so-dien-nuoc-hero__chips">
            {periodLabel ? <span className="chi-so-dien-nuoc-hero__chip">{"K\u1EF3: "}{periodLabel}</span> : null}
            <span className="chi-so-dien-nuoc-hero__chip">{totalElements}{" b\u1EA3n ghi"}</span>
            <span className="chi-so-dien-nuoc-hero__chip">{"\u0110\u00E3 ch\u1ED1t "}{pageTotals.confirmed}/{data.length}</span>
            <span className="chi-so-dien-nuoc-hero__chip">{pageTotals.electricity}{" kWh"}</span>
            <span className="chi-so-dien-nuoc-hero__chip">{pageTotals.water}{" m\u00B3"}</span>
          </div>

        </div>

        <div className="chi-so-dien-nuoc-hero__actions">
          <HeroActionButton
            variant="secondary"
            className="chi-so-dien-nuoc-hero__button chi-so-dien-nuoc-hero__button-secondary"
            onClick={() => fetchReadings(true)}
            disabled={refreshing}
          >
            <RefreshCw className={`h-4 w-4 sm:mr-2 ${refreshing ? "animate-spin" : ""}`} />
            <span className="hidden sm:inline">{refreshing ? "\u0110ang t\u1EA3i" : "L\u00E0m m\u1EDBi"}</span>
          </HeroActionButton>
          <HeroActionButton
            variant="default"
            className="chi-so-dien-nuoc-hero__button chi-so-dien-nuoc-hero__button-primary"
            onClick={openCreate}
          >
            <Plus className="h-4 w-4 sm:mr-2" />
            <span className="hidden sm:inline">{"Ghi ch\u1EC9 s\u1ED1"}</span>
          </HeroActionButton>
        </div>
      </section>

      {/* Thống kê chỉ số điện nước - Stats Section */}
      <section className="mt-6 mb-2">
        <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
          <article className="chi-so-dien-nuoc-hero__stat-card chi-so-dien-nuoc-hero__stat-card--neutral">
            <div className="chi-so-dien-nuoc-hero__stat-top">
              <span>{"B\u1EA3n ghi ph\u00F9 h\u1EE3p"}</span>
              <CalendarDays className="h-5 w-5" aria-hidden="true" />
            </div>
            <strong>{totalElements}</strong>
            <small>{"S\u1EB5n s\u00E0ng ki\u1EC3m tra trong k\u1EF3"}</small>
          </article>
          <article className="chi-so-dien-nuoc-hero__stat-card chi-so-dien-nuoc-hero__stat-card--electric">
            <div className="chi-so-dien-nuoc-hero__stat-top">
              <span>{"\u0110i\u1EC7n tr\u00EAn trang"}</span>
              <Bolt className="h-5 w-5" aria-hidden="true" />
            </div>
            <strong>{pageTotals.electricity}{" kWh"}</strong>
            <small>{"T\u1ED5ng \u0111i\u1EC7n \u0111\u00E3 ghi nh\u1EADn"}</small>
          </article>
          <article className="chi-so-dien-nuoc-hero__stat-card chi-so-dien-nuoc-hero__stat-card--water">
            <div className="chi-so-dien-nuoc-hero__stat-top">
              <span>{"N\u01B0\u1EDBc tr\u00EAn trang"}</span>
              <Droplets className="h-5 w-5" aria-hidden="true" />
            </div>
            <strong>{pageTotals.water}{" m\u00B3"}</strong>
            <small>{"T\u1ED5ng n\u01B0\u1EDBc \u0111\u00E3 ghi nh\u1EADn"}</small>
          </article>
          <article className="chi-so-dien-nuoc-hero__stat-card chi-so-dien-nuoc-hero__stat-card--success">
            <div className="chi-so-dien-nuoc-hero__stat-top">
              <span>{"\u0110\u00E3 ch\u1ED1t / l\u1EADp H\u0110"}</span>
              <FileCheck2 className="h-5 w-5" aria-hidden="true" />
            </div>
            <strong>{pageTotals.confirmed}</strong>
            <small>{"\u0110\u00E3 kh\u00F3a ch\u1EC9nh s\u1EEDa"}</small>
          </article>
        </div>
      </section>

      <DashboardCard className="overflow-hidden">
        <CardHeader className="border-b bg-[#F2E8DC]/70 p-5 md:p-6 pb-4">
          <CardTitle className="text-lg text-[#243B5A]">Danh sách chỉ số</CardTitle>
          <CardDescription className="mt-1">Lọc theo kỳ, phòng, loại và trạng thái trên toàn bộ dữ liệu được phép truy cập.</CardDescription>
          <div className="grid gap-2 pt-4 sm:grid-cols-2 lg:grid-cols-6">
            <Select value={filters.toaNhaId} onValueChange={(value) => updateFilter("toaNhaId", value)}>
              <SelectTrigger className="w-full"><SelectValue placeholder="Tất cả tòa nhà" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tất cả tòa nhà</SelectItem>
                {buildings.map((b) => <SelectItem key={b._id || b.id} value={b._id || b.id || ""}>{b.tenToaNha || b.ten}</SelectItem>)}
              </SelectContent>
            </Select>
            <Select value={filters.phongId} onValueChange={(value) => updateFilter("phongId", value)} disabled={filters.toaNhaId !== "all" && rooms.filter(room => {
                const tId = (room.toaNha as any)?._id || (room.toaNha as any)?.id || room.nhaTroId;
                return String(tId) === filters.toaNhaId;
            }).length === 0}>
              <SelectTrigger className="w-full"><SelectValue placeholder="Tất cả phòng" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tất cả phòng</SelectItem>
                {rooms.filter(room => {
                  if (filters.toaNhaId === "all") return true;
                  const tId = (room.toaNha as any)?._id || (room.toaNha as any)?.id || room.nhaTroId;
                  return String(tId) === filters.toaNhaId;
                }).map((room) => (
                  <SelectItem key={room._id || room.id} value={room._id || room.id || ""}>{room.maPhong}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            <Select value={filters.loai} onValueChange={(value) => updateFilter("loai", value)}>
              <SelectTrigger className="w-full"><SelectValue /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Điện và nước</SelectItem>
                <SelectItem value="ELECTRICITY">Điện</SelectItem>
                <SelectItem value="WATER">Nước</SelectItem>
              </SelectContent>
            </Select>
            <Select value={filters.trangThai} onValueChange={(value) => updateFilter("trangThai", value)}>
              <SelectTrigger className="w-full"><SelectValue /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Mọi trạng thái</SelectItem>
                <SelectItem value="DRAFT">Bản nháp</SelectItem>
                <SelectItem value="CONFIRMED">Đã chốt</SelectItem>
                <SelectItem value="BILLED">Đã lên hóa đơn</SelectItem>
                <SelectItem value="CANCELLED">Đã hủy</SelectItem>
              </SelectContent>
            </Select>
            <Select value={filters.kyThang} onValueChange={(value) => updateFilter("kyThang", value)}>
              <SelectTrigger className="w-full"><SelectValue /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tất cả tháng</SelectItem>
                {Array.from({ length: 12 }, (_, index) => index + 1).map((month) => (
                  <SelectItem key={month} value={String(month)}>Tháng {month}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            <Input
              type="number"
              min={2020}
              value={filters.kyNam === "all" ? "" : filters.kyNam}
              placeholder="Năm"
              onChange={(event) => updateFilter("kyNam", event.target.value || "all")}
            />
          </div>
        </CardHeader>
        <CardContent className="p-4 md:p-6">
          {data.length === 0 ? (
            <EmptyState title="Chưa có chỉ số phù hợp" description="Đổi bộ lọc hoặc ghi chỉ số mới cho kỳ đang chọn." />
          ) : (
            <>
              <div className="hidden overflow-hidden rounded-xl border md:block">
                <Table>
                  <TableHeader className="bg-muted/60">
                    <TableRow>
                      <TableHead>Kỳ / Phòng</TableHead>
                      <TableHead>Loại</TableHead>
                      <TableHead className="text-right">Chỉ số cũ</TableHead>
                      <TableHead className="text-right">Chỉ số mới</TableHead>
                      <TableHead className="text-right">Tiêu thụ</TableHead>
                      <TableHead>Trạng thái</TableHead>
                      <TableHead className="text-right">Thao tác</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {data.map((item) => (
                      <TableRow key={readingId(item)}>
                        <TableCell>
                          <p className="font-medium">{item.kyThang}/{item.kyNam}</p>
                          <p className="text-xs text-muted-foreground">{roomName(item)}</p>
                        </TableCell>
                        <TableCell>{item.loai === "ELECTRICITY" ? "Điện" : "Nước"}</TableCell>
                        <TableCell className="text-right">{item.chiSoCu || 0}</TableCell>
                        <TableCell className="text-right">{item.chiSoMoi || 0}</TableCell>
                        <TableCell className="text-right font-semibold">{item.tieuThu || 0}</TableCell>
                        <TableCell>{statusBadge(item.trangThai)}</TableCell>
                        <TableCell className="text-right">
                          <div className="flex justify-end gap-1">
                            {item.anhDongHo ? (
                              <Button asChild size="icon-sm" variant="ghost">
                                <a href={item.anhDongHo} target="_blank" rel="noopener noreferrer" aria-label="Xem ảnh đồng hồ">
                                  <ImageIcon />
                                </a>
                              </Button>
                            ) : null}
                            <Button
                              size="icon-sm"
                              variant="ghost"
                              onClick={() => openEdit(item)}
                              disabled={item.trangThai === "BILLED" || item.trangThai === "CANCELLED"}
                              aria-label="Chỉnh sửa"
                            >
                              <Pencil />
                            </Button>
                            <Button
                              size="icon-sm"
                              variant="ghost"
                              className="text-destructive"
                              onClick={() => setCancelTarget(item)}
                              disabled={item.trangThai === "CANCELLED"}
                              aria-label="Hủy bản ghi"
                            >
                              <Trash2 />
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
              <div className="space-y-3 md:hidden">
                {data.map((item) => (
                  <article key={readingId(item)} className="rounded-xl border p-4">
                    <div className="flex items-start justify-between gap-2">
                      <div>
                        <p className="font-medium">{roomName(item)}</p>
                        <p className="text-sm text-muted-foreground">
                          {item.loai === "ELECTRICITY" ? "Điện" : "Nước"} · Kỳ {item.kyThang}/{item.kyNam}
                        </p>
                      </div>
                      {statusBadge(item.trangThai)}
                    </div>
                    <div className="mt-4 grid grid-cols-3 gap-2 rounded-lg bg-muted/50 p-3 text-center text-sm">
                      <div><p className="text-xs text-muted-foreground">Cũ</p><p className="mt-1 font-medium">{item.chiSoCu || 0}</p></div>
                      <div><p className="text-xs text-muted-foreground">Mới</p><p className="mt-1 font-medium">{item.chiSoMoi || 0}</p></div>
                      <div><p className="text-xs text-muted-foreground">Dùng</p><p className="mt-1 font-semibold text-primary">{item.tieuThu || 0}</p></div>
                    </div>
                    <div className="mt-3 flex w-full flex-wrap items-center gap-2 sm:gap-3">
                      <Button variant="outline" className="flex-1" onClick={() => openEdit(item)} disabled={item.trangThai === "BILLED" || item.trangThai === "CANCELLED"}>
                        Chỉnh sửa
                      </Button>
                      <Button variant="outline" className="flex-1 text-destructive" onClick={() => setCancelTarget(item)} disabled={item.trangThai === "CANCELLED"}>
                        Hủy
                      </Button>
                    </div>
                  </article>
                ))}
              </div>
            </>
          )}
          {totalPages > 0 ? (
            <div className="mt-6 flex flex-col gap-3 border-t pt-4 sm:flex-row sm:items-center sm:justify-between">
              <p className="text-sm text-muted-foreground">Hiển thị {data.length} / {totalElements} bản ghi</p>
              <div className="flex items-center justify-between gap-3">
                <Select value={String(pagination.pageSize)} onValueChange={(value) => setPagination({ pageIndex: 0, pageSize: Number(value) })}>
                  <SelectTrigger size="sm" className="w-24"><SelectValue /></SelectTrigger>
                  <SelectContent side="top">
                    {[10, 20, 50].map((size) => <SelectItem key={size} value={String(size)}>{size} dòng</SelectItem>)}
                  </SelectContent>
                </Select>
                <span className="text-sm font-medium">Trang {pagination.pageIndex + 1} / {totalPages}</span>
                <div className="flex gap-1">
                  <Button size="icon-sm" variant="outline" disabled={pagination.pageIndex === 0} onClick={() => setPagination((current) => ({ ...current, pageIndex: current.pageIndex - 1 }))}>
                    <ChevronLeft />
                    <span className="sr-only">Trang trước</span>
                  </Button>
                  <Button size="icon-sm" variant="outline" disabled={pagination.pageIndex + 1 >= totalPages} onClick={() => setPagination((current) => ({ ...current, pageIndex: current.pageIndex + 1 }))}>
                    <ChevronRight />
                    <span className="sr-only">Trang sau</span>
                  </Button>
                </div>
              </div>
            </div>
          ) : null}
        </CardContent>
      </DashboardCard>

      <Dialog open={formOpen} onOpenChange={setFormOpen}>
        <DialogContent className="max-h-[92vh] overflow-y-auto sm:max-w-2xl">
          <DialogHeader>
            <DialogTitle>{editing ? "Cập nhật chỉ số" : "Ghi chỉ số mới"}</DialogTitle>
            <DialogDescription>
              Chỉ lưu nháp hoặc chốt số đo tại đây. Trạng thái lập hóa đơn được cập nhật tự động.
            </DialogDescription>
          </DialogHeader>
          <form className="space-y-5" onSubmit={handleSubmit}>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <Label>Tòa nhà</Label>
                <Select value={formData.toaNhaId} onValueChange={(value) => setFormData((current) => ({ ...current, toaNhaId: value, phongId: "" }))} disabled={Boolean(editing)}>
                  <SelectTrigger className="w-full"><SelectValue placeholder="Chọn tòa nhà" /></SelectTrigger>
                  <SelectContent>
                    {buildings.map((b) => <SelectItem key={b._id || b.id} value={b._id || b.id || ""}>{b.tenToaNha || b.ten}</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Phòng</Label>
                <Select value={formData.phongId} onValueChange={(value) => setFormData((current) => ({ ...current, phongId: value }))} disabled={Boolean(editing) || !formData.toaNhaId}>
                  <SelectTrigger className="w-full"><SelectValue placeholder="Chọn phòng" /></SelectTrigger>
                  <SelectContent>
                    {rentableRoomsForForm
                      .filter((room) => buildingId(room) === String(formData.toaNhaId))
                      .map((room) => <SelectItem key={roomId(room)} value={roomId(room)}>{room.maPhong}</SelectItem>)}
                  </SelectContent>
                </Select>
                {!editing ? <p className="text-xs text-muted-foreground">Chỉ hiển thị phòng đang có hợp đồng hiệu lực.</p> : null}
              </div>
              <div className="space-y-2">
                <Label>Loại chỉ số</Label>
                <Select value={formData.loai} onValueChange={(value: LoaiChiSo) => setFormData((current) => ({ ...current, loai: value }))} disabled={Boolean(editing)}>
                  <SelectTrigger className="w-full"><SelectValue /></SelectTrigger>
                  <SelectContent><SelectItem value="ELECTRICITY">Điện</SelectItem><SelectItem value="WATER">Nước</SelectItem></SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Tháng</Label>
                <Input type="number" min={1} max={12} value={formData.kyThang} onChange={(event) => setFormData((current) => ({ ...current, kyThang: Number(event.target.value) }))} disabled={Boolean(editing)} />
              </div>
              <div className="space-y-2">
                <Label>Năm</Label>
                <Input type="number" min={2020} value={formData.kyNam} onChange={(event) => setFormData((current) => ({ ...current, kyNam: Number(event.target.value) }))} disabled={Boolean(editing)} />
              </div>
              <div className="space-y-2">
                <Label>Chỉ số cũ</Label>
                <Input type="number" min={0} value={formData.chiSoCu} onChange={(event) => setFormData((current) => ({ ...current, chiSoCu: Number(event.target.value) }))} />
              </div>
              <div className="space-y-2">
                <Label>Chỉ số mới</Label>
                <Input type="number" min={0} value={formData.chiSoMoi} onChange={(event) => setFormData((current) => ({ ...current, chiSoMoi: Number(event.target.value) }))} />
              </div>
              <div className="space-y-2">
                <Label>Tiêu thụ</Label>
                <Input value={Math.max(0, formData.chiSoMoi - formData.chiSoCu)} disabled />
              </div>
              <div className="space-y-2">
                <Label>Trạng thái</Label>
                <Select value={formData.trangThai} onValueChange={(value: "DRAFT" | "CONFIRMED") => setFormData((current) => ({ ...current, trangThai: value }))}>
                  <SelectTrigger className="w-full"><SelectValue /></SelectTrigger>
                  <SelectContent><SelectItem value="DRAFT">Lưu nháp</SelectItem><SelectItem value="CONFIRMED">Chốt chỉ số</SelectItem></SelectContent>
                </Select>
              </div>
              <div className="space-y-2 sm:col-span-2">
                <Label>Ngày ghi</Label>
                <Input type="date" value={formData.ngayGhi} onChange={(event) => setFormData((current) => ({ ...current, ngayGhi: event.target.value }))} />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Ghi chú</Label>
              <Textarea value={formData.ghiChu} onChange={(event) => setFormData((current) => ({ ...current, ghiChu: event.target.value }))} placeholder="Ghi chú khi đọc đồng hồ..." />
            </div>
            <ImageUpload imageUrl={formData.anhDongHo} onImageChange={(url) => setFormData((current) => ({ ...current, anhDongHo: url }))} label={formData.loai === "ELECTRICITY" ? "Ảnh đồng hồ điện" : "Ảnh đồng hồ nước"} />
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setFormOpen(false)}>Hủy</Button>
              <Button type="submit" disabled={submitting}>{submitting ? "Đang lưu..." : editing ? "Lưu thay đổi" : "Ghi chỉ số"}</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      <Dialog open={Boolean(cancelTarget)} onOpenChange={(open) => !open && setCancelTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Hủy bản ghi chỉ số?</DialogTitle>
            <DialogDescription>
              Bản ghi {cancelTarget ? roomName(cancelTarget) : ""} kỳ {cancelTarget?.kyThang}/{cancelTarget?.kyNam} sẽ được chuyển sang trạng thái đã hủy và giữ lại để đối soát.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setCancelTarget(null)}>Giữ lại</Button>
            <Button variant="destructive" onClick={handleCancel} disabled={submitting}>{submitting ? "Đang hủy..." : "Xác nhận hủy"}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
