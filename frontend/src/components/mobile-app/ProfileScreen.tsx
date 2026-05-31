'use client';
import { useState, useEffect, useCallback } from "react";
import {
  User, FileText, Receipt, AlertTriangle,
  LogOut, Bot, ChevronRight, ExternalLink, Shield,
  CheckCircle2, Clock, XCircle,
  Phone, Mail, MapPin, Home, Zap, Droplets,
  RefreshCw, ChevronDown, Pencil, Lock, Eye, EyeOff,
  Save, X, CheckCircle
} from "lucide-react";
import Link from "next/link";
import { useSession, signOut } from "next-auth/react";

// ─── Types ────────────────────────────────────────────────────────────────────
interface UserProfile {
  name?: string;
  email?: string;
  phone?: string;
  address?: string;
  avatar?: string;
  role?: string;
}

interface HopDong {
  _id: string;
  maHopDong?: string;
  ngayBatDau?: string;
  ngayKetThuc?: string;
  giaThue?: number;
  tienCoc?: number;
  trangThai?: string;
  chuKyThanhToan?: string;
  phong?: { maPhong?: string; _id?: string };
  dieuKhoan?: string;
  filePdf?: string;
}

interface HoaDon {
  _id: string;
  maHoaDon?: string;
  thang?: number;
  nam?: number;
  tongTien?: number;
  daTra?: number;
  conLai?: number;
  trangThai?: string;
  hanThanhToan?: string;
  tienPhong?: number;
  tienDien?: number;
  tienNuoc?: number;
}

interface SuCo {
  _id: string;
  tieuDe?: string;
  loaiSuCo?: string;
  mucDoUuTien?: string;
  trangThai?: string;
  ngayBaoCao?: string;
  ngayHoanThanh?: string;
  moTa?: string;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
const fmt = (n?: number) =>
  n != null ? n.toLocaleString("vi-VN") + "đ" : "—";

const fmtDate = (d?: string) => {
  if (!d) return "—";
  try { return new Date(d).toLocaleDateString("vi-VN"); }
  catch { return d; }
};

// ─── Status maps ──────────────────────────────────────────────────────────────
const contractStatusMap: Record<string, { label: string; cls: string; icon: React.ReactNode }> = {
  hoatDong:    { label: "Đang hiệu lực",    cls: "text-emerald-700 bg-emerald-50 border-emerald-200", icon: <CheckCircle2 size={11}/> },
  choKichHoat: { label: "Chờ kích hoạt",   cls: "text-amber-700   bg-amber-50   border-amber-200",   icon: <Clock size={11}/> },
  hetHan:      { label: "Hết hạn",          cls: "text-red-700    bg-red-50    border-red-200",       icon: <XCircle size={11}/> },
  daKetThuc:   { label: "Đã kết thúc",      cls: "text-slate-600  bg-slate-50  border-slate-200",     icon: <XCircle size={11}/> },
  daHuy:       { label: "Đã hủy",           cls: "text-red-700    bg-red-50    border-red-200",       icon: <XCircle size={11}/> },
  nhap:        { label: "Nháp",             cls: "text-slate-500  bg-slate-50  border-slate-200",     icon: <Clock size={11}/> },
};

const invoiceStatusMap: Record<string, { label: string; cls: string }> = {
  UNPAID:  { label: "Chưa thanh toán",       cls: "text-red-700    bg-red-50    border-red-200" },
  PARTIAL: { label: "Thanh toán một phần",   cls: "text-amber-700  bg-amber-50  border-amber-200" },
  PAID:    { label: "Đã thanh toán",         cls: "text-emerald-700 bg-emerald-50 border-emerald-200" },
  OVERDUE: { label: "Quá hạn",              cls: "text-red-800   bg-red-100   border-red-300" },
};

const incidentStatusMap: Record<string, { label: string; cls: string }> = {
  PENDING:     { label: "Chờ xử lý",  cls: "text-amber-700 bg-amber-50  border-amber-200" },
  IN_PROGRESS: { label: "Đang xử lý", cls: "text-blue-700  bg-blue-50   border-blue-200" },
  RESOLVED:    { label: "Đã xử lý",   cls: "text-emerald-700 bg-emerald-50 border-emerald-200" },
  CLOSED:      { label: "Đã đóng",    cls: "text-slate-600 bg-slate-100  border-slate-200" },
};

const priorityCls: Record<string, string> = {
  low: "text-slate-500", medium: "text-amber-600",
  high: "text-red-600",  urgent: "text-red-800 font-black",
};
const priorityLabel: Record<string, string> = {
  low: "Thấp", medium: "Trung bình", high: "Cao", urgent: "Khẩn cấp",
};

// ─── Shared UI atoms ──────────────────────────────────────────────────────────
function Badge({ label, cls }: { label: string; cls: string }) {
  return (
    <span className={`inline-flex items-center gap-1 text-[10px] font-bold px-2.5 py-1 rounded-full border ${cls}`}>
      {label}
    </span>
  );
}

function SectionTitle({ title, sub }: { title: string; sub?: string }) {
  return (
    <div className="mb-5">
      <h2 className="text-sm font-black text-slate-800 uppercase tracking-widest">{title}</h2>
      {sub && <p className="text-xs text-slate-400 mt-0.5">{sub}</p>}
    </div>
  );
}

function Loader() {
  return (
    <div className="flex items-center justify-center py-14 gap-2.5 text-slate-400">
      <RefreshCw size={16} className="animate-spin text-indigo-500" />
      <span className="text-sm font-medium">Đang tải...</span>
    </div>
  );
}

function Empty({ icon, title, desc }: { icon: React.ReactNode; title: string; desc: string }) {
  return (
    <div className="flex flex-col items-center py-14 gap-3 text-center">
      <div className="w-14 h-14 rounded-2xl bg-slate-50 border border-slate-100 flex items-center justify-center text-slate-300">
        {icon}
      </div>
      <div>
        <p className="text-sm font-bold text-slate-600">{title}</p>
        <p className="text-xs text-slate-400 mt-1 max-w-xs leading-relaxed">{desc}</p>
      </div>
    </div>
  );
}

function FormInput({
  label, value, onChange, type = "text", placeholder, disabled, rightElement,
}: {
  label: string;
  value: string;
  onChange?: (v: string) => void;
  type?: string;
  placeholder?: string;
  disabled?: boolean;
  rightElement?: React.ReactNode;
}) {
  return (
    <div>
      <label className="block text-[10px] font-bold text-slate-500 uppercase tracking-wider mb-1.5">
        {label}
      </label>
      <div className="relative">
        <input
          type={type}
          value={value}
          onChange={e => onChange?.(e.target.value)}
          placeholder={placeholder}
          disabled={disabled}
          className={`w-full px-3.5 py-2.5 rounded-xl border text-sm font-medium outline-none transition-all
            ${disabled
              ? "bg-slate-50 border-slate-100 text-slate-400 cursor-not-allowed"
              : "bg-white border-slate-200 text-slate-800 focus:border-indigo-400 focus:ring-2 focus:ring-indigo-50"
            }
            ${rightElement ? "pr-11" : ""}
          `}
        />
        {rightElement && (
          <div className="absolute right-3 top-1/2 -translate-y-1/2">{rightElement}</div>
        )}
      </div>
    </div>
  );
}

// ─── Toast ────────────────────────────────────────────────────────────────────
function Toast({ msg, type, onClose }: { msg: string; type: "success" | "error"; onClose: () => void }) {
  useEffect(() => {
    const t = setTimeout(onClose, 3500);
    return () => clearTimeout(t);
  }, [onClose]);
  return (
    <div className={`fixed bottom-6 left-1/2 -translate-x-1/2 z-50 flex items-center gap-3 px-5 py-3.5 rounded-2xl shadow-xl text-sm font-bold transition-all
      ${type === "success" ? "bg-emerald-600 text-white" : "bg-red-600 text-white"}`}>
      {type === "success" ? <CheckCircle size={16} /> : <X size={16} />}
      {msg}
    </div>
  );
}

// ─── Profile Info + Edit ──────────────────────────────────────────────────────
function ProfileInfo({ profile, session, onRefresh }: {
  profile: UserProfile | null;
  session: any;
  onRefresh: () => void;
}) {
  const [editing, setEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState({ name: "", phone: "", address: "" });
  const [toast, setToast] = useState<{ msg: string; type: "success" | "error" } | null>(null);

  // Sync form when profile loads
  useEffect(() => {
    if (profile) {
      setForm({
        name: profile.name || session?.user?.name || "",
        phone: profile.phone || session?.user?.phone || "",
        address: profile.address || "",
      });
    }
  }, [profile, session]);

  const handleSave = async () => {
    setSaving(true);
    try {
      const res = await fetch("/api/user/profile", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: form.name, phone: form.phone, address: form.address }),
      });
      const data = await res.json();
      if (res.ok && data.success !== false) {
        setToast({ msg: "Cập nhật thành công!", type: "success" });
        setEditing(false);
        onRefresh();
      } else {
        setToast({ msg: data.message || "Cập nhật thất bại", type: "error" });
      }
    } catch {
      setToast({ msg: "Lỗi kết nối máy chủ", type: "error" });
    } finally {
      setSaving(false);
    }
  };

  const email = profile?.email || session?.user?.email || "—";

  return (
    <div>
      {toast && <Toast msg={toast.msg} type={toast.type} onClose={() => setToast(null)} />}

      <div className="flex items-center justify-between mb-5">
        <SectionTitle title="Thông tin cá nhân" sub="Chỉnh sửa tên, số điện thoại và địa chỉ của bạn" />
        {!editing ? (
          <button
            onClick={() => setEditing(true)}
            className="flex items-center gap-1.5 text-xs font-bold text-indigo-600 bg-indigo-50 hover:bg-indigo-100 px-3 py-1.5 rounded-xl transition-colors cursor-pointer"
          >
            <Pencil size={12} /> Chỉnh sửa
          </button>
        ) : (
          <div className="flex gap-2">
            <button
              onClick={() => { setEditing(false); }}
              className="flex items-center gap-1 text-xs font-bold text-slate-500 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-xl transition-colors cursor-pointer"
            >
              <X size={12} /> Hủy
            </button>
            <button
              onClick={handleSave}
              disabled={saving}
              className="flex items-center gap-1.5 text-xs font-bold text-white bg-indigo-600 hover:bg-indigo-700 px-3 py-1.5 rounded-xl transition-colors cursor-pointer disabled:opacity-60"
            >
              {saving ? <RefreshCw size={12} className="animate-spin" /> : <Save size={12} />}
              Lưu lại
            </button>
          </div>
        )}
      </div>

      <div className="space-y-3">
        <FormInput
          label="Họ và tên"
          value={editing ? form.name : (profile?.name || session?.user?.name || "")}
          onChange={v => setForm(f => ({ ...f, name: v }))}
          placeholder="Nguyễn Văn A"
          disabled={!editing}
        />
        <FormInput
          label="Địa chỉ email"
          value={email}
          disabled
          placeholder="email@example.com"
        />
        <FormInput
          label="Số điện thoại"
          value={editing ? form.phone : (profile?.phone || session?.user?.phone || "")}
          onChange={v => setForm(f => ({ ...f, phone: v }))}
          placeholder="0901234567"
          disabled={!editing}
        />
        <FormInput
          label="Địa chỉ"
          value={editing ? form.address : (profile?.address || "")}
          onChange={v => setForm(f => ({ ...f, address: v }))}
          placeholder="123 Đường ABC, Quận 1, TP.HCM"
          disabled={!editing}
        />
      </div>

      {!editing && (
        <div className="flex items-start gap-2.5 mt-5 bg-indigo-50 border border-indigo-100 rounded-xl p-3.5">
          <Shield size={14} className="text-indigo-400 shrink-0 mt-0.5" />
          <p className="text-xs text-indigo-700 leading-relaxed">
            Email không thể tự thay đổi. Để cập nhật email, liên hệ chủ trọ hoặc gửi yêu cầu hỗ trợ.
          </p>
        </div>
      )}
    </div>
  );
}

// ─── Change Password ──────────────────────────────────────────────────────────
function ChangePassword() {
  const [form, setForm] = useState({ oldPassword: "", newPassword: "", confirm: "" });
  const [show, setShow] = useState({ old: false, new: false, confirm: false });
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<{ msg: string; type: "success" | "error" } | null>(null);

  const handleSubmit = async () => {
    if (!form.oldPassword || !form.newPassword) {
      setToast({ msg: "Vui lòng điền đầy đủ thông tin", type: "error" }); return;
    }
    if (form.newPassword.length < 6) {
      setToast({ msg: "Mật khẩu mới phải ít nhất 6 ký tự", type: "error" }); return;
    }
    if (form.newPassword !== form.confirm) {
      setToast({ msg: "Xác nhận mật khẩu không khớp", type: "error" }); return;
    }
    setSaving(true);
    try {
      const res = await fetch("/api/user/change-password", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ oldPassword: form.oldPassword, newPassword: form.newPassword }),
      });
      const data = await res.json();
      if (res.ok && data.success !== false) {
        setToast({ msg: "Đổi mật khẩu thành công!", type: "success" });
        setForm({ oldPassword: "", newPassword: "", confirm: "" });
      } else {
        setToast({ msg: data.message || "Mật khẩu hiện tại không đúng", type: "error" });
      }
    } catch {
      setToast({ msg: "Lỗi kết nối máy chủ", type: "error" });
    } finally {
      setSaving(false);
    }
  };

  return (
    <div>
      {toast && <Toast msg={toast.msg} type={toast.type} onClose={() => setToast(null)} />}

      <SectionTitle title="Đổi mật khẩu" sub="Đặt lại mật khẩu để bảo vệ tài khoản của bạn" />

      <div className="space-y-3">
        <FormInput
          label="Mật khẩu hiện tại"
          value={form.oldPassword}
          onChange={v => setForm(f => ({ ...f, oldPassword: v }))}
          type={show.old ? "text" : "password"}
          placeholder="••••••••"
          rightElement={
            <button onClick={() => setShow(s => ({ ...s, old: !s.old }))} className="text-slate-400 hover:text-slate-600 cursor-pointer">
              {show.old ? <EyeOff size={15} /> : <Eye size={15} />}
            </button>
          }
        />
        <FormInput
          label="Mật khẩu mới"
          value={form.newPassword}
          onChange={v => setForm(f => ({ ...f, newPassword: v }))}
          type={show.new ? "text" : "password"}
          placeholder="Ít nhất 6 ký tự"
          rightElement={
            <button onClick={() => setShow(s => ({ ...s, new: !s.new }))} className="text-slate-400 hover:text-slate-600 cursor-pointer">
              {show.new ? <EyeOff size={15} /> : <Eye size={15} />}
            </button>
          }
        />
        <FormInput
          label="Xác nhận mật khẩu mới"
          value={form.confirm}
          onChange={v => setForm(f => ({ ...f, confirm: v }))}
          type={show.confirm ? "text" : "password"}
          placeholder="Nhập lại mật khẩu mới"
          rightElement={
            <button onClick={() => setShow(s => ({ ...s, confirm: !s.confirm }))} className="text-slate-400 hover:text-slate-600 cursor-pointer">
              {show.confirm ? <EyeOff size={15} /> : <Eye size={15} />}
            </button>
          }
        />
      </div>

      {/* Password strength hint */}
      {form.newPassword.length > 0 && (
        <div className="mt-3 flex gap-1.5 items-center">
          {[6, 10, 14].map((min, i) => (
            <div key={i} className={`h-1 flex-1 rounded-full transition-colors ${
              form.newPassword.length >= min
                ? i === 0 ? "bg-red-400" : i === 1 ? "bg-amber-400" : "bg-emerald-500"
                : "bg-slate-200"
            }`} />
          ))}
          <span className="text-[10px] text-slate-400 font-semibold ml-1">
            {form.newPassword.length < 6 ? "Quá ngắn" : form.newPassword.length < 10 ? "Trung bình" : "Mạnh"}
          </span>
        </div>
      )}

      <button
        onClick={handleSubmit}
        disabled={saving}
        className="mt-5 w-full flex items-center justify-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 rounded-xl text-sm transition-colors disabled:opacity-60 cursor-pointer shadow-md shadow-indigo-100"
      >
        {saving ? <RefreshCw size={15} className="animate-spin" /> : <Lock size={15} />}
        {saving ? "Đang lưu..." : "Cập nhật mật khẩu"}
      </button>
    </div>
  );
}

// ─── Contract Section ─────────────────────────────────────────────────────────
function ContractSection() {
  const [contracts, setContracts] = useState<HopDong[]>([]);
  const [loading, setLoading] = useState(true);
  const [expanded, setExpanded] = useState<string | null>(null);

  useEffect(() => {
    fetch("/api/tenant/hop-dong?limit=5")
      .then(r => r.json())
      .then(d => {
        const items = d?.data?.items || d?.data?.data || d?.data || [];
        setContracts(Array.isArray(items) ? items : []);
      })
      .catch(() => setContracts([]))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <Loader />;

  return (
    <div>
      <SectionTitle title="Hợp đồng thuê nhà" sub="Thông tin hợp đồng điện tử của bạn" />
      {contracts.length === 0 ? (
        <Empty icon={<FileText size={26} />} title="Chưa có hợp đồng" desc="Chưa có hợp đồng nào được ghi nhận trong hệ thống." />
      ) : (
        <div className="space-y-3">
          {contracts.map(hd => {
            const st = contractStatusMap[hd.trangThai || ""] || contractStatusMap["nhap"];
            const isOpen = expanded === hd._id;
            const isActive = hd.trangThai === "hoatDong";
            let progress = 0, daysLeft = 0;
            if (isActive && hd.ngayBatDau && hd.ngayKetThuc) {
              const start = new Date(hd.ngayBatDau).getTime();
              const end = new Date(hd.ngayKetThuc).getTime();
              const now = Date.now();
              progress = Math.min(100, Math.max(0, ((now - start) / (end - start)) * 100));
              daysLeft = Math.max(0, Math.round((end - now) / 86400000));
            }

            return (
              <div key={hd._id} className="rounded-2xl border border-slate-100 bg-white overflow-hidden shadow-sm">
                <button
                  onClick={() => setExpanded(isOpen ? null : hd._id)}
                  className="w-full flex items-center gap-3 px-4 py-3.5 text-left hover:bg-slate-50 transition-colors cursor-pointer"
                >
                  <div className={`w-8 h-8 rounded-xl flex items-center justify-center shrink-0 ${isActive ? "bg-emerald-100 text-emerald-600" : "bg-slate-100 text-slate-400"}`}>
                    <FileText size={15} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-bold text-slate-800 truncate">{hd.maHopDong || "Hợp đồng thuê nhà"}</p>
                    <p className="text-xs text-slate-400 mt-0.5">
                      Phòng {hd.phong?.maPhong || "—"} · {fmtDate(hd.ngayBatDau)} → {fmtDate(hd.ngayKetThuc)}
                    </p>
                  </div>
                  <Badge label={st.label} cls={st.cls} />
                  <ChevronDown size={14} className={`text-slate-300 shrink-0 transition-transform ${isOpen ? "rotate-180" : ""}`} />
                </button>

                {isOpen && (
                  <div className="border-t border-slate-50 px-4 py-4 space-y-4 bg-slate-50/40">
                    <div className="grid grid-cols-2 gap-2.5">
                      <Stat label="Giá thuê / tháng" value={fmt(hd.giaThue)} accent />
                      <Stat label="Tiền cọc" value={fmt(hd.tienCoc)} />
                      <Stat label="Ngày bắt đầu" value={fmtDate(hd.ngayBatDau)} />
                      <Stat label="Ngày kết thúc" value={fmtDate(hd.ngayKetThuc)} />
                    </div>
                    {isActive && (
                      <div className="space-y-1.5">
                        <div className="flex justify-between text-xs font-semibold text-slate-500">
                          <span>Tiến độ hợp đồng</span>
                          <span className="text-slate-700">{daysLeft} ngày còn lại</span>
                        </div>
                        <div className="h-2 bg-slate-200 rounded-full overflow-hidden">
                          <div className="h-full bg-indigo-500 rounded-full" style={{ width: `${progress}%` }} />
                        </div>
                      </div>
                    )}
                    {hd.filePdf && (
                      <a href={hd.filePdf} target="_blank" rel="noopener noreferrer"
                        className="flex items-center justify-center gap-2 w-full border border-indigo-200 text-indigo-700 bg-white py-2.5 rounded-xl text-xs font-bold hover:bg-indigo-50 transition-colors">
                        <ExternalLink size={13} /> Xem hợp đồng PDF
                      </a>
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

function Stat({ label, value, accent }: { label: string; value: string; accent?: boolean }) {
  return (
    <div className="bg-white rounded-xl border border-slate-100 p-3">
      <p className="text-[9px] font-bold text-slate-400 uppercase tracking-wider">{label}</p>
      <p className={`text-sm font-black mt-1 ${accent ? "text-indigo-600" : "text-slate-800"}`}>{value}</p>
    </div>
  );
}

// ─── Invoices Section ─────────────────────────────────────────────────────────
function InvoicesSection() {
  const [invoices, setInvoices] = useState<HoaDon[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("/api/tenant/hoa-don?limit=10")
      .then(r => r.json())
      .then(d => {
        const items = d?.data?.items || d?.data?.data || d?.data || [];
        setInvoices(Array.isArray(items) ? items : []);
      })
      .catch(() => setInvoices([]))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <Loader />;

  const unpaidCount = invoices.filter(i => i.trangThai === "UNPAID" || i.trangThai === "PARTIAL" || i.trangThai === "OVERDUE").length;

  return (
    <div>
      <div className="flex items-start justify-between mb-5">
        <SectionTitle title="Hóa đơn tiền phòng" sub="Lịch sử thanh toán hàng tháng" />
        {unpaidCount > 0 && (
          <span className="text-[10px] font-black bg-red-500 text-white px-2.5 py-1 rounded-full shadow-sm">
            {unpaidCount} chưa trả
          </span>
        )}
      </div>

      {invoices.length === 0 ? (
        <Empty icon={<Receipt size={26} />} title="Chưa có hóa đơn" desc="Chưa có hóa đơn nào được tạo cho phòng của bạn." />
      ) : (
        <div className="space-y-3">
          {invoices.map(hd => {
            const st = invoiceStatusMap[hd.trangThai || ""] || { label: hd.trangThai || "—", cls: "text-slate-600 bg-slate-50 border-slate-200" };
            const isPaid = hd.trangThai === "PAID";

            return (
              <div key={hd._id} className="rounded-2xl border border-slate-100 bg-white p-4 shadow-sm">
                <div className="flex items-center gap-3">
                  <div className={`w-9 h-9 rounded-xl flex items-center justify-center shrink-0 ${isPaid ? "bg-emerald-100 text-emerald-600" : "bg-red-100 text-red-500"}`}>
                    <Receipt size={16} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between gap-2">
                      <p className="text-sm font-bold text-slate-800">Tháng {hd.thang}/{hd.nam}</p>
                      <Badge label={st.label} cls={st.cls} />
                    </div>
                    <p className="text-[10px] text-slate-400 mt-0.5">{hd.maHoaDon} · Hạn: {fmtDate(hd.hanThanhToan)}</p>
                  </div>
                </div>

                <div className="mt-3 pt-3 border-t border-slate-50 flex items-center justify-between">
                  <div className="flex gap-3">
                    {hd.tienPhong != null && (
                      <span className="text-[10px] text-slate-500 flex items-center gap-0.5 font-semibold">
                        <Home size={9} className="text-slate-400" /> {fmt(hd.tienPhong)}
                      </span>
                    )}
                    {hd.tienDien != null && (
                      <span className="text-[10px] text-slate-500 flex items-center gap-0.5 font-semibold">
                        <Zap size={9} className="text-amber-400" /> {fmt(hd.tienDien)}
                      </span>
                    )}
                    {hd.tienNuoc != null && (
                      <span className="text-[10px] text-slate-500 flex items-center gap-0.5 font-semibold">
                        <Droplets size={9} className="text-blue-400" /> {fmt(hd.tienNuoc)}
                      </span>
                    )}
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-black text-slate-900">{fmt(hd.tongTien)}</p>
                    {!isPaid && hd.conLai != null && hd.conLai > 0 && (
                      <p className="text-[10px] text-red-500 font-bold">Còn: {fmt(hd.conLai)}</p>
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

// ─── Incidents Section ────────────────────────────────────────────────────────
function IncidentsSection() {
  const [incidents, setIncidents] = useState<SuCo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("/api/tenant/su-co?limit=10")
      .then(r => r.json())
      .then(d => {
        const items = d?.data?.items || d?.data?.data || d?.data || [];
        setIncidents(Array.isArray(items) ? items : []);
      })
      .catch(() => setIncidents([]))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <Loader />;

  return (
    <div>
      <SectionTitle title="Báo cáo sự cố" sub="Lịch sử yêu cầu sửa chữa và bảo trì" />
      {incidents.length === 0 ? (
        <Empty icon={<AlertTriangle size={26} />} title="Không có sự cố" desc="Bạn chưa gửi yêu cầu sửa chữa hay báo cáo sự cố nào." />
      ) : (
        <div className="space-y-3">
          {incidents.map(sc => {
            const st = incidentStatusMap[sc.trangThai || ""] || { label: sc.trangThai || "—", cls: "text-slate-600 bg-slate-100 border-slate-200" };
            const isDone = sc.trangThai === "RESOLVED" || sc.trangThai === "CLOSED";
            const pri = sc.mucDoUuTien || "";
            return (
              <div key={sc._id} className="rounded-2xl border border-slate-100 bg-white p-4 shadow-sm">
                <div className="flex items-start gap-3">
                  <div className={`w-8 h-8 rounded-xl flex items-center justify-center shrink-0 ${isDone ? "bg-emerald-100 text-emerald-600" : "bg-amber-100 text-amber-600"}`}>
                    <AlertTriangle size={14} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-2">
                      <p className="text-sm font-bold text-slate-800 leading-snug flex-1">{sc.tieuDe || "Sự cố"}</p>
                      <Badge label={st.label} cls={st.cls} />
                    </div>
                    <div className="flex items-center gap-3 mt-1 flex-wrap">
                      {pri && (
                        <span className={`text-[10px] font-bold ${priorityCls[pri] || "text-slate-500"}`}>
                          {priorityLabel[pri] || pri}
                        </span>
                      )}
                      <span className="text-[10px] text-slate-400">Báo cáo: {fmtDate(sc.ngayBaoCao)}</span>
                      {sc.ngayHoanThanh && (
                        <span className="text-[10px] text-emerald-600 font-semibold">Xong: {fmtDate(sc.ngayHoanThanh)}</span>
                      )}
                    </div>
                    {sc.moTa && <p className="text-xs text-slate-500 mt-2 leading-relaxed line-clamp-2">{sc.moTa}</p>}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

// ─── Sidebar nav ──────────────────────────────────────────────────────────────
type Section = "profile" | "password" | "contract" | "bills" | "incidents";

const NAV: { section: Section; icon: React.ReactNode; label: string }[] = [
  { section: "profile",   icon: <User size={16} />,         label: "Thông tin cá nhân" },
  { section: "password",  icon: <Lock size={16} />,         label: "Đổi mật khẩu" },
  { section: "contract",  icon: <FileText size={16} />,     label: "Hợp đồng thuê nhà" },
  { section: "bills",     icon: <Receipt size={16} />,      label: "Hóa đơn phòng" },
  { section: "incidents", icon: <AlertTriangle size={16} />,label: "Báo cáo sự cố" },
];

function SideNavItem({ item, active, onClick }: { item: typeof NAV[0]; active: Section; onClick: (s: Section) => void }) {
  const isActive = item.section === active;
  return (
    <button
      onClick={() => onClick(item.section)}
      className={`w-full flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-sm font-semibold transition-all cursor-pointer
        ${isActive
          ? "bg-indigo-600 text-white shadow-md shadow-indigo-200/60"
          : "text-slate-600 hover:bg-slate-50"}`}
    >
      <span className={isActive ? "text-white/80" : "text-slate-400"}>{item.icon}</span>
      <span className="flex-1 text-left truncate">{item.label}</span>
      <ChevronRight size={13} className={isActive ? "text-white/50" : "text-slate-200"} />
    </button>
  );
}

// ─── Main Component ───────────────────────────────────────────────────────────
export function ProfileScreen({ onOpenChat }: { onOpenChat: () => void }) {
  const { data: session, status } = useSession();
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [profileLoading, setProfileLoading] = useState(true);
  const [activeSection, setActiveSection] = useState<Section>("profile");

  const loadProfile = useCallback(() => {
    if (status !== "authenticated") return;
    setProfileLoading(true);
    fetch("/api/user/profile")
      .then(r => r.json())
      .then(d => setUserProfile(d?.data || null))
      .catch(() => setUserProfile(null))
      .finally(() => setProfileLoading(false));
  }, [status]);

  useEffect(() => { loadProfile(); }, [loadProfile]);

  // ── Unauthenticated ──
  if (status === "unauthenticated") {
    return (
      <div className="flex flex-col h-full bg-slate-50 overflow-y-auto items-center justify-center px-6 py-20">
        <div className="w-20 h-20 rounded-full bg-indigo-50 flex items-center justify-center mb-6">
          <User size={36} className="text-indigo-400" />
        </div>
        <h2 className="text-xl font-black text-slate-800 text-center">Bạn chưa đăng nhập</h2>
        <p className="text-slate-500 text-sm text-center mt-2 max-w-sm leading-relaxed">
          Đăng nhập để xem thông tin hợp đồng, hóa đơn và nhận hỗ trợ từ quản lý nhà trọ.
        </p>
        <Link href="/dang-nhap"
          className="mt-8 w-full max-w-xs py-3.5 bg-indigo-600 text-white text-center font-bold rounded-2xl shadow-lg shadow-indigo-200 hover:bg-indigo-700 transition-all text-sm">
          Đăng nhập ngay
        </Link>
        <Link href="/dang-ky"
          className="mt-3 w-full max-w-xs py-3.5 bg-white border border-slate-200 text-slate-700 text-center font-bold rounded-2xl hover:bg-slate-50 transition-all text-sm shadow-sm">
          Đăng ký tài khoản
        </Link>
      </div>
    );
  }

  // ── Loading ──
  if (status === "loading" || (status === "authenticated" && profileLoading)) {
    return (
      <div className="flex h-full items-center justify-center gap-2.5 text-slate-400">
        <RefreshCw size={18} className="animate-spin text-indigo-500" />
        <span className="font-semibold text-sm">Đang tải hồ sơ...</span>
      </div>
    );
  }

  const displayName = userProfile?.name || session?.user?.name || "Khách thuê";
  const displayAvatar = userProfile?.avatar || session?.user?.avatar || null;
  const displayEmail = userProfile?.email || session?.user?.email || "";

  return (
    <div className="flex flex-col min-h-full bg-slate-100 overflow-y-auto">

      {/* ── Hero ── */}
      <div className="bg-indigo-700 px-4 md:px-8 pt-12 pb-14 relative overflow-hidden shrink-0">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,_var(--tw-gradient-stops))] from-indigo-500/30 via-transparent to-transparent pointer-events-none" />
        <div className="relative max-w-4xl mx-auto flex items-center gap-4">
          {displayAvatar ? (
            <img src={displayAvatar} alt={displayName}
              className="w-14 h-14 sm:w-16 sm:h-16 rounded-2xl border-2 border-white/30 object-cover shadow-lg shrink-0" />
          ) : (
            <div className="w-14 h-14 sm:w-16 sm:h-16 rounded-2xl border-2 border-white/30 bg-indigo-600 flex items-center justify-center shadow-lg shrink-0">
              <User size={24} className="text-white/70" />
            </div>
          )}
          <div className="flex-1 min-w-0">
            <p className="text-indigo-300 text-[10px] font-bold uppercase tracking-widest">Tài khoản khách thuê</p>
            <h1 className="text-white font-black text-lg sm:text-xl leading-tight truncate mt-0.5">{displayName}</h1>
            <p className="text-indigo-300 text-xs mt-0.5 truncate">{displayEmail}</p>
          </div>
          <div className="shrink-0 hidden sm:block">
            <span className="text-[10px] font-black text-indigo-700 bg-white/90 px-3 py-1.5 rounded-full shadow">
              Khách thuê
            </span>
          </div>
        </div>
      </div>

      {/* ── Body ── */}
      <div className="max-w-4xl w-full mx-auto px-3 sm:px-6 md:px-8 -mt-5 pb-16 flex flex-col md:flex-row gap-4 relative z-10">

        {/* ── Sidebar ── */}
        <div className="w-full md:w-52 shrink-0">
          <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
            <div className="px-4 pt-4 pb-1">
              <p className="text-[9px] font-black text-slate-400 uppercase tracking-widest">Điều hướng</p>
            </div>
            <div className="p-2 space-y-0.5">
              {NAV.map(item => (
                <SideNavItem key={item.section} item={item} active={activeSection} onClick={setActiveSection} />
              ))}
            </div>

            <div className="mx-3 my-1 h-px bg-slate-100" />

            <div className="p-2 space-y-0.5 pb-3">
              <button
                onClick={onOpenChat}
                className="w-full flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-colors cursor-pointer"
              >
                <Bot size={16} className="text-slate-400" />
                <span className="flex-1 text-left">AI Trợ Lý</span>
                <span className="text-[8px] bg-indigo-600 text-white px-1.5 py-0.5 rounded-full font-bold">Mới</span>
              </button>
              <button
                onClick={() => signOut({ callbackUrl: '/dang-nhap' })}
                className="w-full flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-sm font-semibold text-red-500 hover:bg-red-50 transition-colors cursor-pointer"
              >
                <LogOut size={16} className="text-red-400" />
                <span>Đăng xuất</span>
              </button>
            </div>
          </div>
        </div>

        {/* ── Content ── */}
        <div className="flex-1 min-w-0">
          <div className="bg-white rounded-2xl border border-slate-100 shadow-sm p-5 sm:p-6 min-h-96">
            {activeSection === "profile"   && <ProfileInfo profile={userProfile} session={session} onRefresh={loadProfile} />}
            {activeSection === "password"  && <ChangePassword />}
            {activeSection === "contract"  && <ContractSection />}
            {activeSection === "bills"     && <InvoicesSection />}
            {activeSection === "incidents" && <IncidentsSection />}
          </div>
        </div>
      </div>
    </div>
  );
}
