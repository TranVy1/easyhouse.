// Vietnamese formatting helpers.
// NOTE: We format manually instead of using Intl / toLocaleString, because the
// Hermes engine (RN default) has incomplete Intl support and can silently drop
// locale grouping. Manual formatting is deterministic across platforms.

/** Group an integer string with "." thousands separators: 1000000 -> "1.000.000". */
function groupThousands(intStr: string): string {
  return intStr.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
}

export function formatCurrency(value?: number | string | null): string {
  const n = typeof value === "string" ? Number(value) : value;
  if (n === undefined || n === null || Number.isNaN(n)) return "0 ₫";
  const negative = n < 0;
  const rounded = Math.round(Math.abs(n));
  return `${negative ? "-" : ""}${groupThousands(String(rounded))} ₫`;
}

export function formatDate(value?: string | null): string {
  if (!value) return "—";
  // Date-only strings (LocalDate "2026-07-22") must be split manually so a
  // negative UTC offset doesn't roll them back a day.
  const dateOnly = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value);
  if (dateOnly) {
    const [, y, m, d] = dateOnly;
    return `${d}/${m}/${y}`;
  }
  const dt = new Date(value);
  if (Number.isNaN(dt.getTime())) return "—";
  const dd = String(dt.getDate()).padStart(2, "0");
  const mm = String(dt.getMonth() + 1).padStart(2, "0");
  return `${dd}/${mm}/${dt.getFullYear()}`;
}

/** Maps invoice/room status codes to Vietnamese labels + a semantic tone. */
export type Tone = "success" | "warning" | "danger" | "info" | "muted";

export function invoiceStatus(code?: string): { label: string; tone: Tone } {
  switch (code) {
    case "PAID":
    case "daThanhToan":
      return { label: "Đã thanh toán", tone: "success" };
    case "PARTIAL":
    case "daThanhToanMotPhan":
      return { label: "Thanh toán một phần", tone: "warning" };
    case "UNPAID":
    case "chuaThanhToan":
      return { label: "Chưa thanh toán", tone: "danger" };
    default:
      return { label: code ?? "—", tone: "muted" };
  }
}

export function incidentStatus(code?: string): { label: string; tone: Tone } {
  switch (code) {
    case "OPEN":
    case "PENDING":
      return { label: "Đang mở", tone: "danger" };
    case "IN_PROGRESS":
      return { label: "Đang xử lý", tone: "warning" };
    case "RESOLVED":
    case "DONE":
    case "CLOSED":
      return { label: "Đã xử lý", tone: "success" };
    default:
      return { label: code ?? "—", tone: "muted" };
  }
}

export function roomStatus(code?: string): { label: string; tone: Tone } {
  switch (code) {
    case "AVAILABLE":
    case "trong":
      return { label: "Còn trống", tone: "success" };
    case "RENTED":
    case "dangThue":
      return { label: "Đang thuê", tone: "info" };
    case "MAINTENANCE":
    case "baoTri":
      return { label: "Bảo trì", tone: "warning" };
    default:
      return { label: code ?? "—", tone: "muted" };
  }
}
