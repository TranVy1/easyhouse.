import type {
  HopDong,
  KhachThue,
  Phong,
  TrangThaiHoaDon,
  TrangThaiHopDong,
  TrangThaiPhong,
} from '@/types';
import {
  hoaDonStatusFromDb,
  hoaDonStatusToDb,
  hopDongStatusFromDb,
  hopDongStatusToDb,
  phongStatusFromDb,
  phongStatusToDb,
} from '@/lib/domain-mappers';

export {
  hoaDonStatusFromDb,
  hoaDonStatusToDb,
  hopDongStatusFromDb,
  hopDongStatusToDb,
  phongStatusFromDb,
  phongStatusToDb,
};

const toDate = (value: string | Date | undefined): Date | null => {
  if (!value) return null;
  const date = value instanceof Date ? value : new Date(value);
  return Number.isNaN(date.getTime()) ? null : date;
};

const getId = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (typeof value === 'object' && value !== null) {
    const record = value as { id?: string; _id?: string };
    return record.id || record._id || '';
  }
  return '';
};

export function isHopDongActive(status: TrangThaiHopDong): boolean {
  return status === 'ACTIVE' || status === 'hoatDong';
}

export function isPhongAvailable(status: TrangThaiPhong): boolean {
  return status === 'AVAILABLE' || status === 'trong';
}

export function isHoaDonPaid(status: TrangThaiHoaDon): boolean {
  return status === 'PAID' || status === 'daThanhToan';
}

export function calculatePhongStatusFromContracts(
  phongId: string,
  hopDongList: Pick<HopDong, 'phong' | 'phongId' | 'trangThai' | 'ngayBatDau' | 'ngayKetThuc'>[],
): TrangThaiPhong {
  const now = new Date();

  const hasActiveContract = hopDongList.some((hopDong) => {
    const sameRoom = (hopDong.phongId || getId(hopDong.phong)) === phongId;
    const start = toDate(hopDong.ngayBatDau);
    const end = toDate(hopDong.ngayKetThuc);
    return sameRoom && isHopDongActive(hopDong.trangThai) && (!start || start <= now);
  });

  if (hasActiveContract) return 'dangThue';

  const hasReservedContract = hopDongList.some((hopDong) => {
    const sameRoom = (hopDong.phongId || getId(hopDong.phong)) === phongId;
    const start = toDate(hopDong.ngayBatDau);
    return sameRoom && isHopDongActive(hopDong.trangThai) && Boolean(start && start > now);
  });

  return hasReservedContract ? 'daDat' : 'trong';
}

export function calculateKhachThueStatusFromContracts(
  khachThueId: string,
  hopDongList: Pick<HopDong, 'khachThueId' | 'khachThueDaiDienId' | 'nguoiDaiDien' | 'trangThai' | 'ngayBatDau' | 'ngayKetThuc'>[],
): KhachThue['trangThai'] {
  const now = new Date();

  const hasAnyContract = hopDongList.some((hopDong) => {
    const tenantIds = new Set([
      ...(hopDong.khachThueId || []),
      hopDong.khachThueDaiDienId || '',
      getId(hopDong.nguoiDaiDien),
    ]);
    return tenantIds.has(khachThueId);
  });

  const hasActiveContract = hopDongList.some((hopDong) => {
    const tenantIds = new Set([
      ...(hopDong.khachThueId || []),
      hopDong.khachThueDaiDienId || '',
      getId(hopDong.nguoiDaiDien),
    ]);
    const start = toDate(hopDong.ngayBatDau);
    const end = toDate(hopDong.ngayKetThuc);
    return tenantIds.has(khachThueId) && isHopDongActive(hopDong.trangThai) && (!start || start <= now) && (!end || end >= now);
  });

  if (hasActiveContract) return 'dangThue';
  return hasAnyContract ? 'daTraPhong' : 'chuaThue';
}

export function withCalculatedPhongStatus(phong: Phong, hopDongList: HopDong[]): Phong {
  return {
    ...phong,
    trangThai:
      phong.trangThai === 'MAINTENANCE' || phong.trangThai === 'baoTri'
        ? phong.trangThai
        : calculatePhongStatusFromContracts(phong.id || phong._id || '', hopDongList),
  };
}

export function withCalculatedKhachThueStatus(khachThue: KhachThue, hopDongList: HopDong[]): KhachThue {
  return {
    ...khachThue,
    trangThai: calculateKhachThueStatusFromContracts(khachThue.id || khachThue._id || '', hopDongList),
  };
}
