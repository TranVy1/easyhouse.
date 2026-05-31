/**
 * Shared StatusBadge component — dùng chung cho Dashboard và Mobile App.
 * Map từ backend enum strings → label tiếng Việt + màu sắc.
 */

interface BadgeConfig {
  label: string;
  cls: string;
}

const STATUS_MAP: Record<string, BadgeConfig> = {
  // ── Hợp đồng ──────────────────────────────────────────────
  ACTIVE:      { label: 'Đang hiệu lực',    cls: 'bg-emerald-50 text-emerald-700 border-emerald-200' },
  hoatDong:    { label: 'Đang hiệu lực',    cls: 'bg-emerald-50 text-emerald-700 border-emerald-200' },
  DRAFT:       { label: 'Nháp',             cls: 'bg-slate-50  text-slate-600   border-slate-200' },
  nhap:        { label: 'Nháp',             cls: 'bg-slate-50  text-slate-600   border-slate-200' },
  PENDING:     { label: 'Chờ kích hoạt',    cls: 'bg-amber-50  text-amber-700   border-amber-200' },
  choKichHoat: { label: 'Chờ kích hoạt',    cls: 'bg-amber-50  text-amber-700   border-amber-200' },
  EXPIRED:     { label: 'Hết hạn',          cls: 'bg-red-50   text-red-700     border-red-200' },
  hetHan:      { label: 'Hết hạn',          cls: 'bg-red-50   text-red-700     border-red-200' },
  TERMINATED:  { label: 'Đã kết thúc',      cls: 'bg-slate-50  text-slate-600   border-slate-200' },
  daKetThuc:   { label: 'Đã kết thúc',      cls: 'bg-slate-50  text-slate-600   border-slate-200' },
  CANCELLED:   { label: 'Đã hủy',           cls: 'bg-red-50   text-red-700     border-red-200' },
  daHuy:       { label: 'Đã hủy',           cls: 'bg-red-50   text-red-700     border-red-200' },

  // ── Hóa đơn ───────────────────────────────────────────────
  UNPAID:      { label: 'Chưa thanh toán',        cls: 'bg-red-50   text-red-700    border-red-200' },
  PARTIAL:     { label: 'Thanh toán một phần',     cls: 'bg-amber-50 text-amber-700  border-amber-200' },
  PAID:        { label: 'Đã thanh toán',           cls: 'bg-emerald-50 text-emerald-700 border-emerald-200' },
  OVERDUE:     { label: 'Quá hạn',                 cls: 'bg-red-100  text-red-800    border-red-300' },
  OVERPAID:    { label: 'Thanh toán dư',            cls: 'bg-blue-50  text-blue-700   border-blue-200' },

  // ── Sự cố ─────────────────────────────────────────────────
  IN_PROGRESS: { label: 'Đang xử lý',      cls: 'bg-blue-50  text-blue-700   border-blue-200' },
  RESOLVED:    { label: 'Đã xử lý',        cls: 'bg-emerald-50 text-emerald-700 border-emerald-200' },
  CLOSED:      { label: 'Đã đóng',         cls: 'bg-slate-50  text-slate-600  border-slate-200' },

  // ── Phòng ─────────────────────────────────────────────────
  AVAILABLE:   { label: 'Còn trống',        cls: 'bg-emerald-50 text-emerald-700 border-emerald-200' },
  RENTED:      { label: 'Đang thuê',        cls: 'bg-blue-50  text-blue-700   border-blue-200' },
  MAINTENANCE: { label: 'Bảo trì',          cls: 'bg-amber-50 text-amber-700  border-amber-200' },
  RESERVED:    { label: 'Đã đặt',           cls: 'bg-purple-50 text-purple-700 border-purple-200' },

  // ── Người dùng ─────────────────────────────────────────────
  INACTIVE:    { label: 'Chưa kích hoạt',   cls: 'bg-slate-50  text-slate-500  border-slate-200' },
  BANNED:      { label: 'Bị khóa',          cls: 'bg-red-50   text-red-700    border-red-200' },
};

interface StatusBadgeProps {
  status: string;
  /** Override display label */
  label?: string;
  size?: 'xs' | 'sm';
}

export function StatusBadge({ status, label, size = 'xs' }: StatusBadgeProps) {
  const config = STATUS_MAP[status] ?? {
    label: label || status,
    cls: 'bg-slate-100 text-slate-600 border-slate-200',
  };

  const textSize = size === 'xs' ? 'text-[10px]' : 'text-xs';

  return (
    <span
      className={`inline-flex items-center ${textSize} font-bold px-2.5 py-1 rounded-full border whitespace-nowrap ${config.cls}`}
    >
      {label || config.label}
    </span>
  );
}
