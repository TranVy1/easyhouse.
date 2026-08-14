"use client"

import { useCallback, useEffect, useState } from "react"
import { useSession } from "next-auth/react"
import { toast } from "sonner"
import { Plus, RefreshCw, Car, Pencil, Ban } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { CauHinhPhiXe, ToaNha } from "@/types"

const blankForm = { loaiXe: "Xe máy", donGia: "", hieuLucTu: new Date().toISOString().slice(0, 10), hieuLucDen: "", ghiChu: "" }

export default function CauHinhPhiXePage() {
  const { data: session } = useSession()
  const token = session?.accessToken
  const [toaNhas, setToaNhas] = useState<ToaNha[]>([])
  const [nhaTroId, setNhaTroId] = useState("")
  const [plans, setPlans] = useState<CauHinhPhiXe[]>([])
  const [loading, setLoading] = useState(false)
  const [editing, setEditing] = useState<CauHinhPhiXe | null>(null)
  const [form, setForm] = useState(blankForm)

  const headers = token ? { Authorization: `Bearer ${token}` } : {}
  const loadBuildings = useCallback(async () => {
    if (!token) return
    const response = await fetch("/api/toa-nha", { headers })
    const result = await response.json()
    if (!result.success) throw new Error(result.message || "Không thể tải tòa nhà")
    const rows = Array.isArray(result.data) ? result.data : result.data?.data || []
    setToaNhas(rows)
    if (!nhaTroId && rows[0]) setNhaTroId(String(rows[0].id || rows[0]._id))
  }, [token, nhaTroId])

  const loadPlans = useCallback(async () => {
    if (!token || !nhaTroId) return
    setLoading(true)
    try {
      const response = await fetch(`/api/cau-hinh-phi-xe?nhaTroId=${nhaTroId}`, { headers })
      const result = await response.json()
      if (!result.success) throw new Error(result.message || "Không thể tải biểu phí xe")
      setPlans(result.data || [])
    } catch (error: any) { toast.error(error.message || "Không thể tải biểu phí xe") } finally { setLoading(false) }
  }, [token, nhaTroId])

  useEffect(() => { loadBuildings().catch(error => toast.error(error.message)) }, [loadBuildings])
  useEffect(() => { loadPlans() }, [loadPlans])

  const change = (key: keyof typeof blankForm, value: string) => setForm(current => ({ ...current, [key]: value }))
  const submit = async (event: React.FormEvent) => {
    event.preventDefault()
    if (!token || !nhaTroId) return
    const payload = { ...form, nhaTroId, donGia: Number(form.donGia), hieuLucDen: form.hieuLucDen || null, dangApDung: true }
    if (!payload.loaiXe || !payload.hieuLucTu || Number.isNaN(payload.donGia) || payload.donGia < 0) return toast.error("Hãy nhập đầy đủ loại xe, đơn giá và ngày hiệu lực")
    try {
      const id = editing?.id || editing?._id
      const response = await fetch(id ? `/api/cau-hinh-phi-xe/${id}` : "/api/cau-hinh-phi-xe", { method: id ? "PUT" : "POST", headers: { ...headers, "Content-Type": "application/json" }, body: JSON.stringify(payload) })
      const result = await response.json()
      if (!result.success) throw new Error(result.message || "Không thể lưu biểu phí xe")
      toast.success(id ? "Đã cập nhật biểu phí xe" : "Đã thêm biểu phí xe")
      setEditing(null); setForm(blankForm); loadPlans()
    } catch (error: any) { toast.error(error.message || "Không thể lưu biểu phí xe") }
  }

  const edit = (plan: CauHinhPhiXe) => { setEditing(plan); setForm({ loaiXe: plan.loaiXe, donGia: String(plan.donGia), hieuLucTu: String(plan.hieuLucTu).slice(0, 10), hieuLucDen: plan.hieuLucDen ? String(plan.hieuLucDen).slice(0, 10) : "", ghiChu: plan.ghiChu || "" }) }
  const deactivate = async (plan: CauHinhPhiXe) => {
    const id = plan.id || plan._id
    if (!id || !window.confirm(`Ngừng hiệu lực biểu phí ${plan.loaiXe}?`)) return
    try {
      const response = await fetch(`/api/cau-hinh-phi-xe/${id}`, { method: "DELETE", headers })
      const result = await response.json()
      if (!result.success) throw new Error(result.message || "Không thể ngừng biểu phí")
      toast.success("Đã ngừng hiệu lực biểu phí xe"); loadPlans()
    } catch (error: any) { toast.error(error.message || "Không thể ngừng biểu phí") }
  }

  return <div className="space-y-6">
    <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between"><div><h1 className="text-2xl font-bold">Biểu phí xe</h1><p className="text-muted-foreground">Đơn giá theo tòa nhà, loại xe và ngày hiệu lực; hóa đơn tự tách theo phiên bản giá.</p></div><Button variant="outline" onClick={loadPlans} disabled={loading}><RefreshCw className={`mr-2 h-4 w-4 ${loading ? "animate-spin" : ""}`} />Tải lại</Button></div>
    <div className="rounded-xl border bg-white p-4"><label className="mb-2 block text-sm font-medium">Tòa nhà</label><Select value={nhaTroId} onValueChange={setNhaTroId}><SelectTrigger className="max-w-md"><SelectValue placeholder="Chọn tòa nhà" /></SelectTrigger><SelectContent>{toaNhas.map(item => <SelectItem key={String(item.id || item._id)} value={String(item.id || item._id)}>{item.tenToaNha}</SelectItem>)}</SelectContent></Select></div>
    <form onSubmit={submit} className="grid gap-3 rounded-xl border bg-white p-4 md:grid-cols-3"><div className="md:col-span-3 flex items-center gap-2 font-semibold"><Car className="h-5 w-5" />{editing ? "Cập nhật phiên bản biểu phí" : "Thêm phiên bản biểu phí"}</div><Select value={form.loaiXe} onValueChange={value => change("loaiXe", value)}><SelectTrigger><SelectValue /></SelectTrigger><SelectContent><SelectItem value="Xe máy">Xe máy</SelectItem><SelectItem value="Ô tô">Ô tô</SelectItem><SelectItem value="Xe đạp">Xe đạp</SelectItem><SelectItem value="Xe điện">Xe điện</SelectItem></SelectContent></Select><Input type="number" min="0" placeholder="Đơn giá/kỳ (VND)" value={form.donGia} onChange={e => change("donGia", e.target.value)} /><Input type="date" value={form.hieuLucTu} onChange={e => change("hieuLucTu", e.target.value)} /><Input type="date" min={form.hieuLucTu} value={form.hieuLucDen} onChange={e => change("hieuLucDen", e.target.value)} /><Input className="md:col-span-2" placeholder="Ghi chú (không bắt buộc)" value={form.ghiChu} onChange={e => change("ghiChu", e.target.value)} /><div className="flex gap-2"><Button type="submit"><Plus className="mr-2 h-4 w-4" />{editing ? "Lưu" : "Thêm"}</Button>{editing && <Button type="button" variant="outline" onClick={() => { setEditing(null); setForm(blankForm) }}>Hủy</Button>}</div></form>
    <div className="overflow-hidden rounded-xl border bg-white"><table className="w-full text-sm"><thead className="bg-muted/50 text-left"><tr><th className="p-3">Loại xe</th><th className="p-3">Đơn giá/kỳ</th><th className="p-3">Hiệu lực</th><th className="p-3">Trạng thái</th><th className="p-3" /></tr></thead><tbody>{plans.map(plan => <tr key={String(plan.id || plan._id)} className="border-t"><td className="p-3 font-medium">{plan.loaiXe}</td><td className="p-3">{Number(plan.donGia).toLocaleString("vi-VN")} đ</td><td className="p-3">{String(plan.hieuLucTu).slice(0, 10)} {plan.hieuLucDen ? `– ${String(plan.hieuLucDen).slice(0, 10)}` : "– không thời hạn"}</td><td className="p-3">{plan.dangApDung ? "Đang áp dụng" : "Đã ngừng"}</td><td className="p-3"><div className="flex justify-end gap-1"><Button size="icon" variant="ghost" onClick={() => edit(plan)}><Pencil className="h-4 w-4" /></Button>{plan.dangApDung && <Button size="icon" variant="ghost" onClick={() => deactivate(plan)}><Ban className="h-4 w-4" /></Button>}</div></td></tr>)}{!loading && plans.length === 0 && <tr><td className="p-6 text-center text-muted-foreground" colSpan={5}>Chưa có biểu phí xe cho tòa nhà này.</td></tr>}</tbody></table></div>
  </div>
}
