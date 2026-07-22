'use client';

import { Users } from 'lucide-react';

/**
 * Ảnh đại diện dùng chung cho mọi chỗ trong chat: danh sách hội thoại, đầu khung
 * chat, bảng thông tin, và bong bóng tin trong nhóm.
 *
 * Gom về một chỗ vì trước đây mỗi nơi tự vẽ một kiểu — chỗ thì chữ cái đầu, chỗ thì
 * biểu tượng nhóm, và không chỗ nào chịu dùng ảnh thật của người dùng.
 *
 * Có ảnh thì hiện ảnh; không có thì mới rơi về chữ cái đầu (hoặc biểu tượng nhóm).
 * Ảnh hỏng link cũng rơi về chữ cái đầu chứ không để ô vỡ.
 */
export function AnhDaiDien({
  ten,
  anh,
  laNhom = false,
  co = 36,
  className = '',
}: {
  ten?: string;
  anh?: string | null;
  laNhom?: boolean;
  /** Cạnh của ô vuông, tính bằng px. */
  co?: number;
  className?: string;
}) {
  const chuDau = (ten ?? '?').trim().charAt(0).toUpperCase() || '?';
  const kieuNen = laNhom
    ? 'bg-amber-500/15 text-amber-600 dark:text-amber-400'
    : 'bg-primary/10 text-primary';

  return (
    <span
      style={{ width: co, height: co }}
      className={`relative inline-flex shrink-0 items-center justify-center overflow-hidden rounded-full text-xs font-semibold ${kieuNen} ${className}`}
    >
      {/* Chữ cái / biểu tượng nằm dưới, ảnh phủ lên. Làm vậy thì lúc ảnh đang tải
          hoặc tải hỏng vẫn luôn có thứ gì đó để nhìn, không bị ô trống nhấp nháy. */}
      {laNhom ? <Users size={Math.round(co * 0.45)} /> : chuDau}

      {anh && (
        // eslint-disable-next-line @next/next/no-img-element
        <img
          src={anh}
          alt=""
          className="absolute inset-0 h-full w-full object-cover"
          // Link hỏng thì gỡ ảnh đi để lộ lớp chữ cái bên dưới.
          onError={(e) => {
            e.currentTarget.style.display = 'none';
          }}
        />
      )}
    </span>
  );
}
