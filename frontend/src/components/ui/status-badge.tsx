import { Badge } from "@/components/ui/badge";

/**
 * Shared StatusBadge component - dung chung cho Dashboard va Mobile App.
 * Map tu backend enum strings -> label tieng Viet + mau sac EasyHouse.
 */

type BadgeVariant = "soft-success" | "soft-neutral" | "soft-warning" | "soft-danger" | "soft-info";

interface BadgeConfig {
  label: string;
  variant: BadgeVariant;
}

const STATUS_MAP: Record<string, BadgeConfig> = {
  // Hop dong
  ACTIVE:      { label: 'Đang hiệu lực',    variant: 'soft-success' },
  hoatDong:    { label: 'Đang hiệu lực',    variant: 'soft-success' },
  DRAFT:       { label: 'Nháp',             variant: 'soft-neutral' },
  nhap:        { label: 'Nháp',             variant: 'soft-neutral' },
  PENDING:     { label: 'Chờ kích hoạt',    variant: 'soft-warning' },
  choKichHoat: { label: 'Chờ kích hoạt',    variant: 'soft-warning' },
  EXPIRED:     { label: 'Hết hạn',          variant: 'soft-danger' },
  hetHan:      { label: 'Hết hạn',          variant: 'soft-danger' },
  TERMINATED:  { label: 'Đã kết thúc',      variant: 'soft-neutral' },
  daKetThuc:   { label: 'Đã kết thúc',      variant: 'soft-neutral' },
  CANCELLED:   { label: 'Đã hủy',           variant: 'soft-danger' },
  daHuy:       { label: 'Đã hủy',           variant: 'soft-danger' },

  // Hoa don
  UNPAID:      { label: 'Chưa thanh toán',        variant: 'soft-danger' },
  PARTIAL:     { label: 'Thanh toán một phần',    variant: 'soft-warning' },
  PAID:        { label: 'Đã thanh toán',          variant: 'soft-success' },
  OVERDUE:     { label: 'Quá hạn',                variant: 'soft-danger' },
  OVERPAID:    { label: 'Thanh toán dư',          variant: 'soft-info' },

  // Su co
  IN_PROGRESS: { label: 'Đang xử lý',      variant: 'soft-info' },
  RESOLVED:    { label: 'Đã xử lý',        variant: 'soft-success' },
  CLOSED:      { label: 'Đã đóng',         variant: 'soft-neutral' },

  // Phong
  AVAILABLE:   { label: 'Còn trống',       variant: 'soft-success' },
  RENTED:      { label: 'Đang thuê',       variant: 'soft-info' },
  MAINTENANCE: { label: 'Bảo trì',         variant: 'soft-warning' },
  RESERVED:    { label: 'Đã đặt',          variant: 'soft-warning' },

  // Nguoi dung
  INACTIVE:    { label: 'Chưa kích hoạt',  variant: 'soft-neutral' },
  BANNED:      { label: 'Bị khóa',         variant: 'soft-danger' },
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
    variant: 'soft-neutral',
  };

  const px = size === 'xs' ? 'px-2 py-[2px] text-[10px]' : 'px-2.5 py-0.5 text-xs';

  return (
    <Badge variant={config.variant} className={px}>
      {label || config.label}
    </Badge>
  );
}
