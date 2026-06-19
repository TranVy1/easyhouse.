/**
 * Shared StatusBadge component - dung chung cho Dashboard va Mobile App.
 * Map tu backend enum strings -> label tieng Viet + mau sac EasyHouse.
 */

interface BadgeConfig {
  label: string;
  cls: string;
}

const badgeTone = {
  success: 'bg-[#4FA7A0]/10 text-[#267D76] border-[#4FA7A0]/25',
  neutral: 'bg-[#F8F3EC] text-[#6B7A8C] border-[#E8DED2]',
  warning: 'bg-[#F2A45B]/15 text-[#9A5A1B] border-[#F2A45B]/30',
  danger: 'bg-[#C75345]/10 text-[#A13C33] border-[#C75345]/25',
  dangerStrong: 'bg-[#C75345]/15 text-[#8F3028] border-[#C75345]/30',
  info: 'bg-[#243B5A]/10 text-[#243B5A] border-[#243B5A]/20',
};

const STATUS_MAP: Record<string, BadgeConfig> = {
  // Hop dong
  ACTIVE:      { label: 'Đang hiệu lực',    cls: badgeTone.success },
  hoatDong:    { label: 'Đang hiệu lực',    cls: badgeTone.success },
  DRAFT:       { label: 'Nháp',             cls: badgeTone.neutral },
  nhap:        { label: 'Nháp',             cls: badgeTone.neutral },
  PENDING:     { label: 'Chờ kích hoạt',    cls: badgeTone.warning },
  choKichHoat: { label: 'Chờ kích hoạt',    cls: badgeTone.warning },
  EXPIRED:     { label: 'Hết hạn',          cls: badgeTone.danger },
  hetHan:      { label: 'Hết hạn',          cls: badgeTone.danger },
  TERMINATED:  { label: 'Đã kết thúc',      cls: badgeTone.neutral },
  daKetThuc:   { label: 'Đã kết thúc',      cls: badgeTone.neutral },
  CANCELLED:   { label: 'Đã hủy',           cls: badgeTone.danger },
  daHuy:       { label: 'Đã hủy',           cls: badgeTone.danger },

  // Hoa don
  UNPAID:      { label: 'Chưa thanh toán',        cls: badgeTone.danger },
  PARTIAL:     { label: 'Thanh toán một phần',    cls: badgeTone.warning },
  PAID:        { label: 'Đã thanh toán',          cls: badgeTone.success },
  OVERDUE:     { label: 'Quá hạn',                cls: badgeTone.dangerStrong },
  OVERPAID:    { label: 'Thanh toán dư',          cls: badgeTone.info },

  // Su co
  IN_PROGRESS: { label: 'Đang xử lý',      cls: badgeTone.info },
  RESOLVED:    { label: 'Đã xử lý',        cls: badgeTone.success },
  CLOSED:      { label: 'Đã đóng',         cls: badgeTone.neutral },

  // Phong
  AVAILABLE:   { label: 'Còn trống',       cls: badgeTone.success },
  RENTED:      { label: 'Đang thuê',       cls: badgeTone.info },
  MAINTENANCE: { label: 'Bảo trì',         cls: badgeTone.warning },
  RESERVED:    { label: 'Đã đặt',          cls: badgeTone.warning },

  // Nguoi dung
  INACTIVE:    { label: 'Chưa kích hoạt',  cls: badgeTone.neutral },
  BANNED:      { label: 'Bị khóa',         cls: badgeTone.danger },
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
    cls: badgeTone.neutral,
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
