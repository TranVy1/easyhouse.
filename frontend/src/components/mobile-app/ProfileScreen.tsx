'use client';
import { useState, useEffect, useCallback } from "react";
import type { ReactNode } from "react";
import {
  User, FileText, Receipt, AlertTriangle,
  LogOut, Bot, ChevronRight, ExternalLink,
  CheckCircle2, Clock, XCircle,
  Home, Zap, Droplets, Mail, Phone, MapPin, ShieldCheck,
  RefreshCw, ChevronDown, Pencil, Lock, Eye, EyeOff,
  Save, X, CheckCircle, ArrowLeft
} from "lucide-react";
import Link from "next/link";
import { useSession, signOut } from "next-auth/react";
import type { Session } from "next-auth";
import { z } from "zod";
import { api, ApiError } from "@/lib/api";
import { useRouter } from "next/navigation";

// ─── Types ────────────────────────────────────────────────────────────────────
interface UserProfile {
  name?: string;
  email?: string;
  phone?: string;
  address?: string;
  avatar?: string;
  role?: string;
  isActive?: boolean;
  trangThai?: string;
  status?: string;
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

const EMPTY_VALUE = "Chưa cập nhật";

const roleLabels: Record<string, string> = {
  admin: "Admin",
  ADMIN: "Admin",
  chuNha: "Chủ trọ",
  LANDLORD: "Chủ trọ",
  nhanVien: "Nhân viên",
  STAFF: "Nhân viên",
  khachThue: "Khách thuê",
  TENANT: "Khách thuê",
};

const statusLabels: Record<string, string> = {
  hoatDong: "Hoạt động",
  ACTIVE: "Hoạt động",
  INACTIVE: "Chưa xác minh",
  chuaKichHoat: "Chưa xác minh",
  tamKhoa: "Tạm khóa",
  khoa: "Tạm khóa",
  BANNED: "Tạm khóa",
};

const getRoleLabel = (role?: string) => {
  if (!role) return undefined;
  return roleLabels[role] || role;
};

const getStatusLabel = (profile?: UserProfile | null) => {
  const status = profile?.trangThai || profile?.status;
  if (status) return statusLabels[status] || status;
  if (typeof profile?.isActive === "boolean") return profile.isActive ? "Hoạt động" : "Chưa xác minh";
  return undefined;
};

const getInitials = (name?: string) => {
  const safeName = (name || "").trim();
  if (!safeName || safeName === EMPTY_VALUE) return "";
  return safeName
    .split(/\s+/)
    .map(part => part[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);
};

const contractStatusMap: Record<string, { label: string; cls: string; icon: ReactNode }> = {
  hoatDong: { label: "Đang hiệu lực", cls: "text-[#267D76] bg-[#4FA7A0]/10 border-[#4FA7A0]/30", icon: <CheckCircle2 size={11} /> },
  ACTIVE: { label: "Đang hiệu lực", cls: "text-emerald-700 bg-emerald-50 border-emerald-200", icon: <CheckCircle2 size={11} /> },
  PENDING: { label: "Chờ cọc", cls: "text-orange-700   bg-orange-50   border-orange-200", icon: <Clock size={11} /> },
  EXPIRED: { label: "Hết hạn", cls: "text-red-700    bg-red-50    border-red-200", icon: <XCircle size={11} /> },
  TERMINATED: { label: "Đã kết thúc", cls: "text-slate-600  bg-slate-50  border-slate-200", icon: <XCircle size={11} /> },
  CANCELLED: { label: "Đã hủy", cls: "text-red-700    bg-red-50    border-red-200", icon: <XCircle size={11} /> },
  DRAFT: { label: "Nháp", cls: "text-slate-500  bg-slate-50  border-slate-200", icon: <Clock size={11} /> },
  // Fallback map
  choKichHoat: { label: "Chờ kích hoạt", cls: "text-amber-700   bg-amber-50   border-amber-200", icon: <Clock size={11} /> },
  hetHan: { label: "Hết hạn", cls: "text-red-700    bg-red-50    border-red-200", icon: <XCircle size={11} /> },
  daKetThuc: { label: "Đã kết thúc", cls: "text-[#6B7A8C]  bg-[#F8F3EC]  border-[#E8DED2]", icon: <XCircle size={11} /> },
  daHuy: { label: "Đã hủy", cls: "text-red-700    bg-red-50    border-red-200", icon: <XCircle size={11} /> },
  nhap: { label: "Nháp", cls: "text-[#6B7A8C]  bg-[#F8F3EC]  border-[#E8DED2]", icon: <Clock size={11} /> },
};

const invoiceStatusMap: Record<string, { label: string; cls: string }> = {
  UNPAID: { label: "Chưa thanh toán", cls: "text-red-700    bg-red-50    border-red-200" },
  PARTIAL: { label: "Thanh toán một phần", cls: "text-amber-700  bg-amber-50  border-amber-200" },
  PAID: { label: "Đã thanh toán", cls: "text-[#267D76] bg-[#4FA7A0]/10 border-[#4FA7A0]/30" },
  OVERDUE: { label: "Quá hạn", cls: "text-red-800   bg-red-100   border-red-300" },
};

const incidentStatusMap: Record<string, { label: string; cls: string }> = {
  PENDING: { label: "Chờ xử lý", cls: "text-amber-700 bg-amber-50  border-amber-200" },
  IN_PROGRESS: { label: "Đang xử lý", cls: "text-[#243B5A]  bg-[#4FA7A0]/10   border-[#4FA7A0]/30" },
  RESOLVED: { label: "Đã xử lý", cls: "text-[#267D76] bg-[#4FA7A0]/10 border-[#4FA7A0]/30" },
  CLOSED: { label: "Đã đóng", cls: "text-[#6B7A8C] bg-slate-100  border-[#E8DED2]" },
};

const priorityCls: Record<string, string> = {
  low: "text-[#6B7A8C]", medium: "text-amber-600",
  high: "text-red-600", urgent: "text-red-800 font-black",
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
      <h2 className="text-sm font-black text-[#243B5A] uppercase tracking-widest">{title}</h2>
      {sub && <p className="text-xs text-[#6B7A8C] mt-0.5">{sub}</p>}
    </div>
  );
}

function Skeleton({ className }: { className?: string }) {
  return (
    <div className={`animate-pulse bg-slate-200 rounded-xl ${className ?? ""}`} />
  );
}

function SectionSkeleton() {
  return (
    <div className="space-y-3">
      <div className="flex items-center gap-3 mb-5">
        <Skeleton className="h-4 w-28" />
        <Skeleton className="h-6 w-16 ml-auto rounded-xl" />
      </div>
      {[1, 2, 3].map(i => (
        <div key={i} className="bg-white rounded-2xl border border-[#E8DED2] p-4 space-y-2.5 shadow-sm">
          <div className="flex items-center gap-3">
            <Skeleton className="w-9 h-9 rounded-xl" />
            <div className="flex-1 space-y-1.5">
              <Skeleton className="h-3.5 w-3/4" />
              <Skeleton className="h-2.5 w-1/2" />
            </div>
            <Skeleton className="h-5 w-16 rounded-full" />
          </div>
          <Skeleton className="h-px w-full mt-1" />
          <div className="flex justify-between">
            <Skeleton className="h-3 w-20" />
            <Skeleton className="h-3 w-16" />
          </div>
        </div>
      ))}
    </div>
  );
}

function Loader() {
  return <SectionSkeleton />;
}


function Empty({ icon, title, desc }: { icon: ReactNode; title: string; desc: string }) {
  return (
    <div className="flex flex-col items-center py-14 gap-3 text-center">
      <div className="w-14 h-14 rounded-2xl bg-[#F8F3EC] border border-[#E8DED2] flex items-center justify-center text-slate-300">
        {icon}
      </div>
      <div>
        <p className="text-sm font-bold text-[#6B7A8C]">{title}</p>
        <p className="text-xs text-[#6B7A8C] mt-1 max-w-xs leading-relaxed">{desc}</p>
      </div>
    </div>
  );
}

function FormInput({
  label, value, onChange, type = "text", placeholder, disabled, rightElement, icon,
}: {
  label: string;
  value: string;
  onChange?: (v: string) => void;
  type?: string;
  placeholder?: string;
  disabled?: boolean;
  rightElement?: ReactNode;
  icon?: ReactNode;
}) {
  return (
    <div>
      <label className="mb-2 block text-[11px] font-extrabold uppercase tracking-[0.14em] text-[#6B7C8F]">
        {label}
      </label>
      <div className="relative">
        {icon && (
          <div className="absolute left-4 top-1/2 -translate-y-1/2 text-[#6B7C8F]">
            {icon}
          </div>
        )}
        <input
          type={type}
          value={value}
          onChange={e => onChange?.(e.target.value)}
          placeholder={placeholder}
          disabled={disabled}
          className={`w-full rounded-2xl border py-3.5 text-sm font-semibold outline-none transition-all
            ${disabled
              ? "bg-white border-[#E8DED1] text-[#243B5A] cursor-not-allowed shadow-sm"
              : "bg-white border-[#E8DED1] text-[#243B5A] shadow-sm focus:border-[#4FA7A0] focus:ring-4 focus:ring-[#4FA7A0]/10"
            }
            ${rightElement ? "pr-11" : ""}
            ${icon ? "pl-11" : "pl-4"}
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
      ${type === "success" ? "bg-[#4FA7A0] text-white" : "bg-red-600 text-white"}`}>
      {type === "success" ? <CheckCircle size={16} /> : <X size={16} />}
      {msg}
    </div>
  );
}

// ─── Zod Schemas ─────────────────────────────────────────────────────────────
const profileSchema = z.object({
  name: z.string().min(2, "Tên phải có ít nhất 2 ký tự").max(100),
  phone: z.string().regex(/^(0|\+84)[0-9]{8,10}$/, "Số điện thoại không hợp lệ").or(z.literal("")),
  address: z.string().max(200).optional(),
});

const passwordSchema = z.object({
  oldPassword: z.string().min(1, "Vui lòng nhập mật khẩu hiện tại"),
  newPassword: z.string().min(6, "Mật khẩu mới phải ít nhất 6 ký tự").max(100),
  confirm: z.string(),
}).refine(d => d.newPassword === d.confirm, {
  message: "Xác nhận mật khẩu không khớp",
  path: ["confirm"],
});

type ProfileForm = z.infer<typeof profileSchema>;
type PasswordForm = z.infer<typeof passwordSchema>;

// ─── Profile Info + Edit ──────────────────────────────────────────────────────
function ProfileInfo({ profile, session, onRefresh }: {
  profile: UserProfile | null;
  session: Session | null;
  onRefresh: () => void;
}) {
  const [editing, setEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState<ProfileForm>({ name: "", phone: "", address: "" });
  const [errors, setErrors] = useState<Partial<Record<keyof ProfileForm, string>>>({});
  const [toast, setToast] = useState<{ msg: string; type: "success" | "error" } | null>(null);

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
    const parsed = profileSchema.safeParse(form);
    if (!parsed.success) {
      const fieldErrors: Partial<Record<keyof ProfileForm, string>> = {};
      parsed.error.issues.forEach((e: import('zod').ZodIssue) => {
        const key = e.path[0] as keyof ProfileForm;
        if (!fieldErrors[key]) fieldErrors[key] = e.message;
      });
      setErrors(fieldErrors);
      return;
    }
    setErrors({});
    setSaving(true);
    try {
      await api.put("/api/user/profile", parsed.data);
      setToast({ msg: "Cập nhật thành công!", type: "success" });
      setEditing(false);
      onRefresh();
    } catch (e) {
      setToast({ msg: e instanceof ApiError ? e.message : "Cập nhật thất bại", type: "error" });
    } finally {
      setSaving(false);
    }
  };

  const email = profile?.email || session?.user?.email || EMPTY_VALUE;
  const displayName = profile?.name || session?.user?.name || EMPTY_VALUE;
  const displayPhone = profile?.phone || session?.user?.phone || "Chưa cập nhật số điện thoại";
  const displayAddress = profile?.address || "Chưa cập nhật địa chỉ";

  const setField = (key: keyof ProfileForm) => (v: string) => {
    setForm(f => ({ ...f, [key]: v }));
    if (errors[key]) setErrors(e => ({ ...e, [key]: undefined }));
  };

  return (
    <div>
      {toast && <Toast msg={toast.msg} type={toast.type} onClose={() => setToast(null)} />}

      <div className="mb-7 flex flex-col gap-4 border-b border-[#E8DED1] pb-5 sm:flex-row sm:items-start sm:justify-between">
        <div>
          <h2 className="text-2xl font-extrabold tracking-tight text-[#243B5A]">Thông tin cá nhân</h2>
          <p className="mt-1 text-sm font-medium leading-relaxed text-[#6B7C8F]">
            Chỉnh sửa tên, số điện thoại và địa chỉ của bạn
          </p>
        </div>
        {!editing ? (
          <button
            onClick={() => setEditing(true)}
            className="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-gradient-to-r from-[#243B5A] to-[#2D62B7] px-5 py-3 text-sm font-extrabold text-white shadow-lg shadow-[#243B5A]/20 transition hover:from-[#1E314B] hover:to-[#24569F] sm:w-auto"
          >
            <Pencil size={16} /> Chỉnh sửa
          </button>
        ) : (
          <div className="flex w-full flex-col gap-2 sm:w-auto sm:flex-row">
            <button
              onClick={() => { setEditing(false); setErrors({}); }}
              className="inline-flex items-center justify-center gap-2 rounded-2xl border border-[#E8DED1] bg-white px-5 py-3 text-sm font-extrabold text-[#243B5A] transition hover:bg-[#F8F3EC]"
            >
              <X size={15} /> Hủy
            </button>
            <button
              onClick={handleSave}
              disabled={saving}
              className="inline-flex items-center justify-center gap-2 rounded-2xl bg-gradient-to-r from-[#243B5A] to-[#2D62B7] px-5 py-3 text-sm font-extrabold text-white shadow-lg shadow-[#243B5A]/20 transition hover:from-[#1E314B] hover:to-[#24569F] disabled:opacity-60"
            >
              {saving ? <RefreshCw size={15} className="animate-spin" /> : <Save size={15} />}
              Lưu lại
            </button>
          </div>
        )}
      </div>

      <div className="grid grid-cols-1 gap-5 lg:grid-cols-2">
        <div>
          <FormInput
            label="Họ và tên"
            value={editing ? form.name : displayName}
            onChange={setField("name")}
            placeholder="Nhập họ và tên"
            disabled={!editing}
            icon={<User size={16} />}
          />
          {errors.name && <p className="text-[10px] text-red-500 mt-1 font-semibold">{errors.name}</p>}
        </div>
        <FormInput
          label="Địa chỉ email"
          value={email}
          disabled
          placeholder={EMPTY_VALUE}
          icon={<Mail size={16} />}
          rightElement={<Lock size={15} className="text-[#6B7C8F]" />}
        />
        <div>
          <FormInput
            label="Số điện thoại"
            value={editing ? form.phone : displayPhone}
            onChange={setField("phone")}
            placeholder="Nhập số điện thoại"
            disabled={!editing}
            icon={<Phone size={16} />}
          />
          {errors.phone && <p className="text-[10px] text-red-500 mt-1 font-semibold">{errors.phone}</p>}
        </div>
        <div className="lg:col-span-2">
          <FormInput
            label="Địa chỉ"
            value={editing ? (form.address ?? "") : displayAddress}
            onChange={setField("address")}
            placeholder="Chưa cập nhật địa chỉ"
            disabled={!editing}
            icon={<MapPin size={16} />}
          />
        </div>
      </div>

      {!editing && (
        <div className="mt-6 flex items-start gap-3 rounded-2xl border border-[#4FA7A0]/20 bg-[#4FA7A0]/10 p-4">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-white text-[#243B5A] shadow-sm">
            <ShieldCheck size={17} />
          </div>
          <p className="text-sm leading-relaxed text-[#243B5A]">
            Email không thể tự thay đổi. Để cập nhật email, liên hệ chủ trọ hoặc gửi yêu cầu hỗ trợ.
          </p>
        </div>
      )}
    </div>
  );
}

// ─── Change Password ──────────────────────────────────────────────────────────
function ChangePassword() {
  const [form, setForm] = useState<PasswordForm>({ oldPassword: "", newPassword: "", confirm: "" });
  const [show, setShow] = useState({ old: false, new: false, confirm: false });
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState<Partial<Record<keyof PasswordForm, string>>>({});
  const [toast, setToast] = useState<{ msg: string; type: "success" | "error" } | null>(null);

  const handleSubmit = async () => {
    const parsed = passwordSchema.safeParse(form);
    if (!parsed.success) {
      const fieldErrors: Partial<Record<keyof PasswordForm, string>> = {};
      parsed.error.issues.forEach((e: import('zod').ZodIssue) => {
        const key = e.path[0] as keyof PasswordForm;
        if (!fieldErrors[key]) fieldErrors[key] = e.message;
      });
      setErrors(fieldErrors);
      return;
    }
    setErrors({});
    setSaving(true);
    try {
      await api.post("/api/user/change-password", {
        oldPassword: parsed.data.oldPassword,
        newPassword: parsed.data.newPassword,
      });
      setToast({ msg: "Đổi mật khẩu thành công!", type: "success" });
      setForm({ oldPassword: "", newPassword: "", confirm: "" });
    } catch (e) {
      setToast({ msg: e instanceof ApiError ? e.message : "Mật khẩu hiện tại không đúng", type: "error" });
    } finally {
      setSaving(false);
    }
  };

  const setField = (key: keyof PasswordForm) => (v: string) => {
    setForm(f => ({ ...f, [key]: v }));
    if (errors[key]) setErrors(e => ({ ...e, [key]: undefined }));
  };

  return (
    <div>
      {toast && <Toast msg={toast.msg} type={toast.type} onClose={() => setToast(null)} />}

      <SectionTitle title="Đổi mật khẩu" sub="Đặt lại mật khẩu để bảo vệ tài khoản của bạn" />

      <div className="space-y-3">
        <div>
          <FormInput
            label="Mật khẩu hiện tại"
            value={form.oldPassword}
            onChange={setField("oldPassword")}
            type={show.old ? "text" : "password"}
            placeholder="••••••••"
            rightElement={
              <button onClick={() => setShow(s => ({ ...s, old: !s.old }))} className="text-[#6B7A8C] hover:text-[#6B7A8C] cursor-pointer">
                {show.old ? <EyeOff size={15} /> : <Eye size={15} />}
              </button>
            }
          />
          {errors.oldPassword && <p className="text-[10px] text-red-500 mt-1 font-semibold">{errors.oldPassword}</p>}
        </div>
        <div>
          <FormInput
            label="Mật khẩu mới"
            value={form.newPassword}
            onChange={setField("newPassword")}
            type={show.new ? "text" : "password"}
            placeholder="Ít nhất 6 ký tự"
            rightElement={
              <button onClick={() => setShow(s => ({ ...s, new: !s.new }))} className="text-[#6B7A8C] hover:text-[#6B7A8C] cursor-pointer">
                {show.new ? <EyeOff size={15} /> : <Eye size={15} />}
              </button>
            }
          />
          {errors.newPassword && <p className="text-[10px] text-red-500 mt-1 font-semibold">{errors.newPassword}</p>}
        </div>
        <div>
          <FormInput
            label="Xác nhận mật khẩu mới"
            value={form.confirm}
            onChange={setField("confirm")}
            type={show.confirm ? "text" : "password"}
            placeholder="Nhập lại mật khẩu mới"
            rightElement={
              <button onClick={() => setShow(s => ({ ...s, confirm: !s.confirm }))} className="text-[#6B7A8C] hover:text-[#6B7A8C] cursor-pointer">
                {show.confirm ? <EyeOff size={15} /> : <Eye size={15} />}
              </button>
            }
          />
          {errors.confirm && <p className="text-[10px] text-red-500 mt-1 font-semibold">{errors.confirm}</p>}
        </div>
      </div>

      {/* Password strength hint */}
      {form.newPassword.length > 0 && (
        <div className="mt-3 flex gap-1.5 items-center">
          {[6, 10, 14].map((min, i) => (
            <div key={i} className={`h-1 flex-1 rounded-full transition-colors ${form.newPassword.length >= min
              ? i === 0 ? "bg-red-400" : i === 1 ? "bg-amber-400" : "bg-[#4FA7A0]"
              : "bg-slate-200"
              }`} />
          ))}
          <span className="text-[10px] text-[#6B7A8C] font-semibold ml-1">
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
function ContractSection({ accessToken }: { accessToken?: string }) {
  const [contracts, setContracts] = useState<HopDong[]>([]);
  const [loading, setLoading] = useState(true);
  const [expanded, setExpanded] = useState<string | null>(null);

  const fetchContracts = useCallback(() => {
    setLoading(true);
    fetch("/api/tenant/hop-dong?limit=5", {
      headers: { 'Authorization': `Bearer ${accessToken}` }
    })
      .then(r => r.json())
      .then(d => {
        const items = d?.data?.items || d?.data?.data || d?.data || [];
        setContracts(Array.isArray(items) ? items : []);
      })
      .catch(() => setContracts([]))
      .finally(() => setLoading(false));
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) fetchContracts();
  }, [accessToken, fetchContracts]);

  const handlePayDeposit = async (id: string) => {
    if (!accessToken) return;
    if (!confirm("Xác nhận thanh toán cọc cho hợp đồng này?")) return;
    try {
      const res = await fetch(`/api/tenant/hop-dong/${id}/thanh-toan-coc`, {
        method: "PUT",
        headers: { 'Authorization': `Bearer ${accessToken}` }
      });
      const data = await res.json();
      if (data.success) {
        alert("Thanh toán cọc thành công!");
        fetchContracts();
      } else {
        alert("Lỗi: " + data.message);
      }
    } catch (err: any) {
      alert("Đã xảy ra lỗi khi thanh toán: " + err.message);
    }
  };

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
              <div key={hd._id} className="rounded-2xl border border-[#E8DED2] bg-white overflow-hidden shadow-sm">
                <button
                  onClick={() => setExpanded(isOpen ? null : hd._id)}
                  className="w-full flex items-center gap-3 px-4 py-3.5 text-left hover:bg-[#F8F3EC] transition-colors cursor-pointer"
                >
                  <div className={`w-8 h-8 rounded-xl flex items-center justify-center shrink-0 ${isActive ? "bg-[#4FA7A0]/15 text-[#267D76]" : "bg-slate-100 text-[#6B7A8C]"}`}>
                    <FileText size={15} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-bold text-[#243B5A] truncate">{hd.maHopDong || "Hợp đồng thuê nhà"}</p>
                    <p className="text-xs text-[#6B7A8C] mt-0.5">
                      Phòng {hd.phong?.maPhong || "—"} · {fmtDate(hd.ngayBatDau)} → {fmtDate(hd.ngayKetThuc)}
                    </p>
                  </div>
                  <Badge label={st.label} cls={st.cls} />
                  <ChevronDown size={14} className={`text-slate-300 shrink-0 transition-transform ${isOpen ? "rotate-180" : ""}`} />
                </button>

                {isOpen && (
                  <div className="border-t border-slate-50 px-4 py-4 space-y-4 bg-[#F8F3EC]/40">
                    <div className="grid grid-cols-2 gap-2.5">
                      <Stat label="Giá thuê / tháng" value={fmt(hd.giaThue)} accent />
                      <Stat label="Tiền cọc" value={fmt(hd.tienCoc)} />
                      <Stat label="Ngày bắt đầu" value={fmtDate(hd.ngayBatDau)} />
                      <Stat label="Ngày kết thúc" value={fmtDate(hd.ngayKetThuc)} />
                    </div>
                    {isActive && (
                      <div className="space-y-1.5">
                        <div className="flex justify-between text-xs font-semibold text-[#6B7A8C]">
                          <span>Tiến độ hợp đồng</span>
                          <span className="text-[#243B5A]">{daysLeft} ngày còn lại</span>
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
                    {hd.trangThai === "PENDING" && (
                      <button
                        onClick={() => handlePayDeposit(hd._id)}
                        className="flex items-center justify-center gap-2 w-full bg-orange-600 text-white py-2.5 rounded-xl text-xs font-bold hover:bg-orange-700 transition-colors shadow-sm"
                      >
                        <Receipt size={13} /> Thanh toán cọc ngay
                      </button>
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
    <div className="bg-white rounded-xl border border-[#E8DED2] p-3">
      <p className="text-[9px] font-bold text-[#6B7A8C] uppercase tracking-wider">{label}</p>
      <p className={`text-sm font-black mt-1 ${accent ? "text-indigo-600" : "text-[#243B5A]"}`}>{value}</p>
    </div>
  );
}

// ─── Invoices Section ─────────────────────────────────────────────────────────
function InvoicesSection({ accessToken }: { accessToken?: string }) {
  const [invoices, setInvoices] = useState<HoaDon[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!accessToken) return;
    fetch("/api/tenant/hoa-don?limit=10", {
      headers: { 'Authorization': `Bearer ${accessToken}` }
    })
      .then(r => r.json())
      .then(d => {
        const items = d?.data?.items || d?.data?.data || d?.data || [];
        setInvoices(Array.isArray(items) ? items : []);
      })
      .catch(() => setInvoices([]))
      .finally(() => setLoading(false));
  }, [accessToken]);

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
            const st = invoiceStatusMap[hd.trangThai || ""] || { label: hd.trangThai || "—", cls: "text-[#6B7A8C] bg-[#F8F3EC] border-[#E8DED2]" };
            const isPaid = hd.trangThai === "PAID";

            return (
              <div key={hd._id} className="rounded-2xl border border-[#E8DED2] bg-white p-4 shadow-sm">
                <div className="flex items-center gap-3">
                  <div className={`w-9 h-9 rounded-xl flex items-center justify-center shrink-0 ${isPaid ? "bg-[#4FA7A0]/15 text-[#267D76]" : "bg-red-100 text-red-500"}`}>
                    <Receipt size={16} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between gap-2">
                      <p className="text-sm font-bold text-[#243B5A]">Tháng {hd.thang}/{hd.nam}</p>
                      <Badge label={st.label} cls={st.cls} />
                    </div>
                    <p className="text-[10px] text-[#6B7A8C] mt-0.5">{hd.maHoaDon} · Hạn: {fmtDate(hd.hanThanhToan)}</p>
                  </div>
                </div>

                <div className="mt-3 pt-3 border-t border-slate-50 flex items-center justify-between">
                  <div className="flex gap-3">
                    {hd.tienPhong != null && (
                      <span className="text-[10px] text-[#6B7A8C] flex items-center gap-0.5 font-semibold">
                        <Home size={9} className="text-[#6B7A8C]" /> {fmt(hd.tienPhong)}
                      </span>
                    )}
                    {hd.tienDien != null && (
                      <span className="text-[10px] text-[#6B7A8C] flex items-center gap-0.5 font-semibold">
                        <Zap size={9} className="text-amber-400" /> {fmt(hd.tienDien)}
                      </span>
                    )}
                    {hd.tienNuoc != null && (
                      <span className="text-[10px] text-[#6B7A8C] flex items-center gap-0.5 font-semibold">
                        <Droplets size={9} className="text-[#4FA7A0]" /> {fmt(hd.tienNuoc)}
                      </span>
                    )}
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-black text-[#243B5A]">{fmt(hd.tongTien)}</p>
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
function IncidentsSection({ accessToken }: { accessToken?: string }) {
  const [incidents, setIncidents] = useState<SuCo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!accessToken) return;
    fetch("/api/tenant/su-co?limit=10", {
      headers: { 'Authorization': `Bearer ${accessToken}` }
    })
      .then(r => r.json())
      .then(d => {
        const items = d?.data?.items || d?.data?.data || d?.data || [];
        setIncidents(Array.isArray(items) ? items : []);
      })
      .catch(() => setIncidents([]))
      .finally(() => setLoading(false));
  }, [accessToken]);

  if (loading) return <Loader />;

  return (
    <div>
      <SectionTitle title="Báo cáo sự cố" sub="Lịch sử yêu cầu sửa chữa và bảo trì" />
      {incidents.length === 0 ? (
        <Empty icon={<AlertTriangle size={26} />} title="Không có sự cố" desc="Bạn chưa gửi yêu cầu sửa chữa hay báo cáo sự cố nào." />
      ) : (
        <div className="space-y-3">
          {incidents.map(sc => {
            const st = incidentStatusMap[sc.trangThai || ""] || { label: sc.trangThai || "—", cls: "text-[#6B7A8C] bg-slate-100 border-[#E8DED2]" };
            const isDone = sc.trangThai === "RESOLVED" || sc.trangThai === "CLOSED";
            const pri = sc.mucDoUuTien || "";
            return (
              <div key={sc._id} className="rounded-2xl border border-[#E8DED2] bg-white p-4 shadow-sm">
                <div className="flex items-start gap-3">
                  <div className={`w-8 h-8 rounded-xl flex items-center justify-center shrink-0 ${isDone ? "bg-[#4FA7A0]/15 text-[#267D76]" : "bg-amber-100 text-amber-600"}`}>
                    <AlertTriangle size={14} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-2">
                      <p className="text-sm font-bold text-[#243B5A] leading-snug flex-1">{sc.tieuDe || "Sự cố"}</p>
                      <Badge label={st.label} cls={st.cls} />
                    </div>
                    <div className="flex items-center gap-3 mt-1 flex-wrap">
                      {pri && (
                        <span className={`text-[10px] font-bold ${priorityCls[pri] || "text-[#6B7A8C]"}`}>
                          {priorityLabel[pri] || pri}
                        </span>
                      )}
                      <span className="text-[10px] text-[#6B7A8C]">Báo cáo: {fmtDate(sc.ngayBaoCao)}</span>
                      {sc.ngayHoanThanh && (
                        <span className="text-[10px] text-[#267D76] font-semibold">Xong: {fmtDate(sc.ngayHoanThanh)}</span>
                      )}
                    </div>
                    {sc.moTa && <p className="text-xs text-[#6B7A8C] mt-2 leading-relaxed line-clamp-2">{sc.moTa}</p>}
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
type Section = "profile" | "password" | "contract" | "bills" | "incidents" | "roommates";

const NAV: { section: Section; icon: ReactNode; label: string }[] = [
  { section: "profile", icon: <User size={16} />, label: "Thông tin cá nhân" },
  { section: "password", icon: <Lock size={16} />, label: "Đổi mật khẩu" },
  { section: "contract", icon: <FileText size={16} />, label: "Hợp đồng thuê nhà" },
  { section: "bills", icon: <Receipt size={16} />, label: "Hóa đơn phòng" },
  { section: "incidents", icon: <AlertTriangle size={16} />, label: "Báo cáo sự cố" },
  { section: "roommates", icon: <User size={16} />, label: "Yêu cầu ở ghép" },
];

function SideNavItem({ item, active, onClick }: { item: typeof NAV[0]; active: Section; onClick: (s: Section) => void }) {
  const isActive = item.section === active;
  return (
    <button
      onClick={() => onClick(item.section)}
      className={`group flex w-full items-center gap-3 rounded-2xl border px-4 py-3 text-sm font-extrabold transition-all
        ${isActive
          ? "border-[#4FA7A0]/25 bg-[#4FA7A0]/10 text-[#243B5A] shadow-sm"
          : "border-transparent text-[#526477] hover:bg-[#F8F3EC] hover:text-[#243B5A]"}`}
    >
      <span className={isActive ? "text-[#243B5A]" : "text-[#4FA7A0]"}>{item.icon}</span>
      <span className="flex-1 text-left truncate">{item.label}</span>
      <ChevronRight size={15} className={isActive ? "text-[#243B5A]/45" : "text-[#526477]/25 group-hover:text-[#243B5A]/45"} />
    </button>
  );
}

// ─── Main Component ───────────────────────────────────────────────────────────
export function ProfileScreen({ onOpenChat, onBack }: { onOpenChat: () => void; onBack?: () => void }) {
  const router = useRouter();
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
      <div className="flex flex-col h-full bg-[#F8F3EC] overflow-y-auto items-center justify-center px-6 py-20">
        <div className="w-20 h-20 rounded-full bg-indigo-50 flex items-center justify-center mb-6">
          <User size={36} className="text-indigo-400" />
        </div>
        <h2 className="text-xl font-black text-[#243B5A] text-center">Bạn chưa đăng nhập</h2>
        <p className="text-[#6B7A8C] text-sm text-center mt-2 max-w-sm leading-relaxed">
          Đăng nhập để xem thông tin hợp đồng, hóa đơn và nhận hỗ trợ từ quản lý nhà trọ.
        </p>
        <Link href="/dang-nhap"
          className="mt-8 w-full max-w-xs py-3.5 bg-indigo-600 text-white text-center font-bold rounded-2xl shadow-lg shadow-indigo-200 hover:bg-indigo-700 transition-all text-sm">
          Đăng nhập ngay
        </Link>
        <Link href="/dang-ky"
          className="mt-3 w-full max-w-xs py-3.5 bg-white border border-[#E8DED2] text-[#243B5A] text-center font-bold rounded-2xl hover:bg-[#F8F3EC] transition-all text-sm shadow-sm">
          Đăng ký tài khoản
        </Link>
      </div>
    );
  }

  // ── Loading ──
  if (status === "loading" || (status === "authenticated" && profileLoading)) {
    return (
      <div className="flex h-full items-center justify-center gap-2.5 text-[#6B7A8C]">
        <RefreshCw size={18} className="animate-spin text-indigo-500" />
        <span className="font-semibold text-sm">Đang tải hồ sơ...</span>
      </div>
    );
  }

  const displayName = userProfile?.name || session?.user?.name || EMPTY_VALUE;
  const displayAvatar = userProfile?.avatar || session?.user?.avatar || null;
  const displayEmail = userProfile?.email || session?.user?.email || EMPTY_VALUE;
  const roleLabel = getRoleLabel(userProfile?.role || session?.user?.role);
  const statusLabel = getStatusLabel(userProfile);
  const initials = getInitials(displayName);

  return (
    <div className="flex min-h-full flex-col overflow-y-auto bg-[#F8F3EC] px-4 pb-20 pt-5 text-[#243B5A] sm:px-6 md:px-8 md:pb-12">
      <div className="mx-auto w-full max-w-[1180px] space-y-6">
        <section className="relative overflow-hidden rounded-[2rem] bg-[radial-gradient(circle_at_80%_18%,rgba(79,167,160,0.42),transparent_28%),linear-gradient(135deg,#0F1F3D_0%,#243B5A_38%,#3741B6_72%,#1A73E8_100%)] px-5 py-6 text-white shadow-[0_22px_70px_rgba(36,59,90,0.28)] sm:px-7 md:px-8 md:py-8">
          <div className="pointer-events-none absolute inset-0 opacity-[0.13] [background-image:linear-gradient(rgba(255,255,255,.7)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,.7)_1px,transparent_1px)] [background-size:36px_36px]" />
          <div className="pointer-events-none absolute -right-8 bottom-0 hidden h-44 w-[360px] opacity-25 md:block">
            <div className="absolute bottom-0 left-4 h-28 w-24 rounded-t-[1.8rem] border border-white/45" />
            <div className="absolute bottom-0 left-28 h-40 w-28 rounded-t-[2rem] border border-white/45" />
            <div className="absolute bottom-0 left-64 h-32 w-24 rounded-t-[1.8rem] border border-white/45" />
            <div className="absolute bottom-20 left-44 h-px w-10 bg-white/45" />
            <div className="absolute bottom-28 left-44 h-px w-10 bg-white/45" />
            <div className="absolute bottom-16 left-[19rem] h-px w-10 bg-white/45" />
          </div>

          <div className="relative z-20 mb-5 sm:absolute sm:left-6 sm:top-6 sm:mb-0">
            <button
              onClick={() => {
                if (onBack) {
                  onBack();
                } else {
                  router.push("/");
                }
              }}
              className="flex h-10 w-10 items-center justify-center rounded-full border border-white/20 bg-white/10 text-white shadow-sm backdrop-blur transition hover:bg-white/20"
              title="Quay lại"
            >
              <ArrowLeft size={18} />
            </button>
          </div>

          <div className="relative z-10 flex flex-col gap-7 sm:pl-16 lg:flex-row lg:items-center lg:justify-between">
            <div className="flex flex-col gap-5 sm:flex-row sm:items-center">
              {displayAvatar ? (
                <img
                  src={displayAvatar}
                  alt={displayName}
                  className="h-24 w-24 shrink-0 rounded-[1.6rem] border-4 border-white/55 bg-white/10 object-cover shadow-2xl md:h-28 md:w-28"
                />
              ) : (
                <div className="flex h-24 w-24 shrink-0 items-center justify-center rounded-[1.6rem] border-4 border-white/55 bg-white/12 text-3xl font-extrabold text-white shadow-2xl backdrop-blur md:h-28 md:w-28">
                  {initials || <User size={34} className="text-white/80" />}
                </div>
              )}
              <div className="min-w-0">
                <p className="mb-2 text-xs font-extrabold uppercase tracking-[0.22em] text-white/70">
                  {roleLabel ? `Tài khoản ${roleLabel}` : "Tài khoản EasyHouse"}
                </p>
                <h1 className="max-w-full truncate text-3xl font-extrabold tracking-tight text-white md:text-4xl">
                  {displayName}
                </h1>
                <div className="mt-2 flex min-w-0 items-center gap-2 text-sm font-medium text-white/80">
                  <Mail size={15} className="shrink-0" />
                  <span className="truncate">{displayEmail}</span>
                </div>
                <div className="mt-4 flex flex-wrap gap-2">
                  {roleLabel && (
                    <span className="inline-flex items-center rounded-full bg-white px-4 py-1.5 text-xs font-extrabold uppercase tracking-wide text-[#243B5A] shadow-sm">
                      {roleLabel}
                    </span>
                  )}
                  {statusLabel && (
                    <span className="inline-flex items-center gap-1.5 rounded-full border border-[#4FA7A0]/30/70 bg-[#4FA7A0]/10 px-4 py-1.5 text-xs font-extrabold text-[#267D76] shadow-sm">
                      <ShieldCheck size={13} />
                      {statusLabel}
                    </span>
                  )}
                </div>
              </div>
            </div>

            <div className="w-full max-w-sm rounded-[1.6rem] border border-white/20 bg-white/12 p-4 shadow-2xl shadow-black/10 backdrop-blur-md">
              <div className="flex items-center gap-4">
                <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-white/15 text-white ring-1 ring-white/20">
                  <Home size={27} />
                </div>
                <div>
                  <p className="text-xs font-extrabold uppercase tracking-[0.2em] text-white/70">EasyHouse</p>
                  <p className="text-lg font-extrabold leading-tight text-white">Quản lý thuê phòng</p>
                </div>
              </div>
            </div>
          </div>
        </section>

        <div className="grid gap-6 md:grid-cols-[290px_minmax(0,1fr)] md:items-start">
          <aside className="overflow-hidden rounded-[1.6rem] border border-[#E8DED1] bg-white/95 shadow-[0_18px_55px_rgba(36,59,90,0.12)] max-md:pr-14 md:pr-0">
            <div className="px-5 pb-2 pt-5">
              <p className="text-xs font-extrabold uppercase tracking-[0.18em] text-[#243B5A]/55">Điều hướng</p>
            </div>
            <div className="space-y-2 px-3 pb-3">
              {NAV.map(item => (
                <SideNavItem key={item.section} item={item} active={activeSection} onClick={setActiveSection} />
              ))}
            </div>

            <div className="mx-4 my-1 h-px bg-[#E8DED1]" />

            <div className="space-y-2 px-3 pb-4 pt-2">
              <button
                onClick={onOpenChat}
                className="flex w-full items-center gap-3 rounded-2xl border border-transparent px-4 py-3 text-sm font-extrabold text-[#526477] transition hover:bg-[#F8F3EC] hover:text-[#243B5A]"
              >
                <Bot size={16} className="text-[#4FA7A0]" />
                <span className="flex-1 text-left">AI Trợ Lý</span>
                <span className="rounded-full bg-[#4FA7A0]/10 px-2 py-0.5 text-[9px] font-extrabold text-[#267D76]">Mới</span>
              </button>
              <button
                onClick={() => signOut({ callbackUrl: '/dang-nhap' })}
                className="flex w-full items-center gap-3 rounded-2xl border border-[#F2A45B]/20 bg-[#F2A45B]/10 px-4 py-3 text-sm font-extrabold text-[#A13C33] transition hover:bg-[#F2A45B]/20"
              >
                <LogOut size={16} />
                <span className="flex-1 text-left">Đăng xuất</span>
              </button>
            </div>
          </aside>

          <main className="min-w-0 overflow-hidden rounded-[1.6rem] border border-[#E8DED1] bg-white/95 shadow-[0_18px_55px_rgba(36,59,90,0.12)]">
            <div className="min-h-96 p-5 sm:p-7">
              {activeSection === "profile" && <ProfileInfo profile={userProfile} session={session} onRefresh={loadProfile} />}
              {activeSection === "password" && <ChangePassword />}
              {activeSection === "contract" && <ContractSection accessToken={session?.accessToken as string | undefined} />}
              {activeSection === "bills" && <InvoicesSection accessToken={session?.accessToken as string | undefined} />}
              {activeSection === "incidents" && <IncidentsSection accessToken={session?.accessToken as string | undefined} />}
            </div>
          </main>
        </div>
      </div>
    </div>
  );
}
