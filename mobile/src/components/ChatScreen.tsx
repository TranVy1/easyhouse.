import { useEffect, useMemo, useRef, useState } from 'react';
import {
  ActivityIndicator,
  FlatList,
  KeyboardAvoidingView,
  Platform,
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useChat } from '@/lib/useChat';
import { gioPhut, nhanNgan, nhanPhanCach, viTriTrongCum } from '@/lib/chat-time';
import { colors, radius, spacing } from '@/theme';
import { EmptyState, Loading } from '@/components/ui';
import type { CuocTroChuyen, TinNhan } from '@/types';

/**
 * Nhãn ngắn cạnh tên. Chat 1-1 cố tình không có nhãn vì đó là mặc định.
 *
 * Mỗi loại một màu riêng để quét mắt qua danh sách là phân biệt được ngay,
 * không phải đọc chữ. Dùng cùng hệ màu với web (sky/violet/amber/emerald)
 * cho người dùng chuyển qua lại giữa hai nền tảng không bị lạ.
 */
function nhanNganLoai(loai?: string): { chu: string; nen: string; mauChu: string } | null {
  switch (loai) {
    case 'BUILDING': return { chu: 'Cả nhà', nen: '#e0f2fe', mauChu: '#0369a1' };
    case 'FLOOR': return { chu: 'Tầng', nen: '#ede9fe', mauChu: '#6d28d9' };
    case 'GROUP': return { chu: 'Nhóm', nen: '#fef3c7', mauChu: '#b45309' };
    case 'SUPPORT': return { chu: 'Ban quản lý', nen: '#d1fae5', mauChu: '#047857' };
    default: return null;
  }
}

function laLoaiNhom(loai?: string): boolean {
  return loai === 'GROUP' || loai === 'BUILDING' || loai === 'FLOOR';
}

/**
 * Bỏ dấu tiếng Việt để so khớp khi lọc — gõ "ca nha" vẫn tìm ra "Cả nhà".
 * "đ/Đ" phải xử lý tay vì là chữ cái độc lập, NFD không tách ra được.
 */
function boDau(chuoi: string): string {
  return chuoi
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/đ/g, 'd')
    .replace(/Đ/g, 'D')
    .toLowerCase();
}

/**
 * Màn hình chat dùng chung cho cả cổng khách thuê và cổng quản lý.
 *
 * Mobile không đủ chỗ cho bố cục hai cột như web, nên dùng một màn hình hai trạng
 * thái: chưa chọn thì hiện danh sách, chọn rồi thì hiện khung chat kèm nút quay lại.
 */
export function ChatScreen({ hienNutHoTro = false }: { hienNutHoTro?: boolean }) {
  const {
    hoiThoais,
    hoiThoaiDangMo,
    tinNhans,
    dangTai,
    trangThaiKetNoi,
    aiDangGo,
    loi,
    nguoiDungId,
    moHoiThoai,
    dongHoiThoai,
    guiTin,
    danhDauDaDoc,
    baoDangGo,
    moKenhHoTro,
    xoaLoi,
  } = useChat();

  const [noiDung, setNoiDung] = useState('');
  const [boLoc, setBoLoc] = useState('');
  const danhSachRef = useRef<FlatList<TinNhan>>(null);
  const timerGo = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Đánh dấu đã đọc tới tin cuối đang hiển thị.
  useEffect(() => {
    const cuoi = tinNhans[tinNhans.length - 1];
    if (cuoi && !cuoi.dangGui) danhDauDaDoc(cuoi.soThuTu);
  }, [tinNhans, danhDauDaDoc]);

  const doiPhuong = useMemo(
    () => hoiThoaiDangMo?.thanhVien?.filter((tv) => tv._id !== nguoiDungId) ?? [],
    [hoiThoaiDangMo, nguoiDungId],
  );

  const tenAiDangGo = aiDangGo
    .map((id) => doiPhuong.find((tv) => tv._id === id)?.hoTen)
    .filter(Boolean);

  const laNhom = laLoaiNhom(hoiThoaiDangMo?.loai);

  const hoiThoaiHienThi = useMemo(() => {
    const tuKhoa = boDau(boLoc.trim());
    if (!tuKhoa) return hoiThoais;
    return hoiThoais.filter((h) => {
      const tenThanhVien = (h.thanhVien ?? []).map((tv) => tv.hoTen ?? '').join(' ');
      return boDau(`${h.ten ?? ''} ${h.xemTruoc ?? ''} ${tenThanhVien}`).includes(tuKhoa);
    });
  }, [hoiThoais, boLoc]);

  const xuLyGo = (giaTri: string) => {
    setNoiDung(giaTri);
    baoDangGo(true);
    if (timerGo.current) clearTimeout(timerGo.current);
    timerGo.current = setTimeout(() => baoDangGo(false), 2000);
  };

  const xuLyGui = () => {
    if (!noiDung.trim()) return;
    guiTin(noiDung);
    setNoiDung('');
    baoDangGo(false);
  };

  // ── Danh sách hội thoại ────────────────────────────────────────────────
  if (!hoiThoaiDangMo) {
    return (
      <View style={styles.man}>
        <BangTrangThaiKetNoi trangThai={trangThaiKetNoi} />
        {hienNutHoTro && (
          <Pressable style={styles.nutHoTro} onPress={() => moKenhHoTro()}>
            <Ionicons name="headset-outline" size={16} color={colors.brand} />
            <Text style={styles.nutHoTroChu}>Liên hệ ban quản lý</Text>
          </Pressable>
        )}
        {/* Lọc trên danh sách đã tải nên phản hồi tức thì, không gọi API. Đây là lọc
            theo TÊN — tìm theo nội dung tin nhắn là việc của P4. */}
        <View style={styles.oLoc}>
          <Ionicons name="search" size={15} color={colors.textMuted} />
          <TextInput
            value={boLoc}
            onChangeText={setBoLoc}
            placeholder="Tìm cuộc trò chuyện…"
            placeholderTextColor={colors.textMuted}
            style={styles.oLocNhap}
          />
          {!!boLoc && (
            <Pressable onPress={() => setBoLoc('')} hitSlop={8}>
              <Ionicons name="close-circle" size={16} color={colors.textMuted} />
            </Pressable>
          )}
        </View>

        <FlatList
          data={hoiThoaiHienThi}
          keyExtractor={(h) => h._id}
          ListEmptyComponent={
            <EmptyState
              text={boLoc ? `Không có cuộc trò chuyện nào khớp "${boLoc}".` : 'Chưa có cuộc trò chuyện nào.'}
            />
          }
          renderItem={({ item }) => <MucHoiThoai hoiThoai={item} onPress={() => moHoiThoai(item)} />}
        />
        <ThanhLoi loi={loi} onDong={xoaLoi} />
      </View>
    );
  }

  // ── Khung chat ─────────────────────────────────────────────────────────
  return (
    <KeyboardAvoidingView
      style={styles.man}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 90 : 0}
    >
      <View style={styles.dauKhung}>
        <Pressable onPress={dongHoiThoai} hitSlop={10}>
          <Ionicons name="chevron-back" size={22} color={colors.text} />
        </Pressable>
        <View style={{ flex: 1 }}>
          <Text style={styles.tenHoiThoai} numberOfLines={1}>
            {hoiThoaiDangMo.ten}
          </Text>
          <Text style={styles.phuDe} numberOfLines={1}>
            {tenAiDangGo.length > 0
              ? `${tenAiDangGo.join(', ')} đang nhập…`
              : hoiThoaiDangMo.loai === 'SUPPORT'
                ? 'Kênh liên hệ ban quản lý'
                : laNhom
                  ? `${hoiThoaiDangMo.thanhVien?.length ?? 0} thành viên`
                  : `${doiPhuong.length} người`}
          </Text>
        </View>
      </View>

      <BangTrangThaiKetNoi trangThai={trangThaiKetNoi} />

      {dangTai ? (
        <Loading />
      ) : (
        <FlatList
          ref={danhSachRef}
          data={tinNhans}
          keyExtractor={(t) => t._id}
          contentContainerStyle={{ padding: spacing.md }}
          onContentSizeChange={() => danhSachRef.current?.scrollToEnd({ animated: true })}
          renderItem={({ item, index }) => {
            const viTri = viTriTrongCum(item, tinNhans[index - 1], tinNhans[index + 1]);
            return (
              <View>
                {viTri.hienPhanCach && <PhanCachThoiGian iso={item.ngayTao} />}
                <BongBongTin
                  tin={item}
                  cuaToi={item.nguoiGuiId === nguoiDungId}
                  dauCum={viTri.dauCum}
                  cuoiCum={viTri.cuoiCum}
                />
              </View>
            );
          }}
        />
      )}

      <View style={styles.khungSoan}>
        <TextInput
          value={noiDung}
          onChangeText={xuLyGo}
          placeholder="Nhập tin nhắn…"
          placeholderTextColor={colors.textMuted}
          style={styles.oNhap}
          multiline
        />
        <Pressable
          onPress={xuLyGui}
          disabled={!noiDung.trim()}
          style={[styles.nutGui, !noiDung.trim() && { opacity: 0.4 }]}
        >
          <Ionicons name="send" size={16} color="#fff" />
        </Pressable>
      </View>

      <ThanhLoi loi={loi} onDong={xoaLoi} />
    </KeyboardAvoidingView>
  );
}

/** Người dùng cần biết mình đang xem dữ liệu có thể đã cũ, thay vì tưởng không ai nhắn. */
function BangTrangThaiKetNoi({ trangThai }: { trangThai: string }) {
  if (trangThai === 'connected') return null;
  return (
    <View style={styles.bangTrangThai}>
      <Text style={styles.bangTrangThaiChu}>
        {trangThai === 'connecting' ? 'Đang kết nối…' : 'Mất kết nối — sẽ tự nối lại'}
      </Text>
    </View>
  );
}

function MucHoiThoai({ hoiThoai, onPress }: { hoiThoai: CuocTroChuyen; onPress: () => void }) {
  const chuaDoc = hoiThoai.soTinChuaDoc ?? 0;
  const laNhom = laLoaiNhom(hoiThoai.loai);
  const nhanLoai = nhanNganLoai(hoiThoai.loai);
  const soThanhVien = hoiThoai.thanhVien?.length ?? 0;

  return (
    <Pressable style={styles.mucHoiThoai} onPress={onPress}>
      {/* Nhóm dùng biểu tượng người + màu khác; chat 1-1 giữ chữ cái đầu tên.
          Nhìn lướt là phân biệt được ngay mà không cần đọc chữ. */}
      <View style={[styles.anhDaiDien, laNhom && styles.anhDaiDienNhom]}>
        {laNhom ? (
          <Ionicons name="people" size={18} color="#b45309" />
        ) : (
          <Text style={styles.anhDaiDienChu}>{(hoiThoai.ten ?? '?').charAt(0).toUpperCase()}</Text>
        )}
      </View>

      <View style={{ flex: 1, minWidth: 0 }}>
        <View style={styles.hangTen}>
          <Text style={styles.tenMuc} numberOfLines={1}>
            {hoiThoai.ten}
          </Text>
          {!!nhanLoai && (
            <View style={[styles.nhanLoai, { backgroundColor: nhanLoai.nen }]}>
              <Text style={[styles.nhanLoaiChu, { color: nhanLoai.mauChu }]}>{nhanLoai.chu}</Text>
            </View>
          )}
          <Text style={styles.gioMuc}>{nhanNgan(hoiThoai.tinNhanCuoiLuc)}</Text>
        </View>
        <Text style={styles.xemTruoc} numberOfLines={1}>
          {laNhom && soThanhVien > 0 ? `${soThanhVien} người · ` : ''}
          {hoiThoai.xemTruoc ?? 'Chưa có tin nhắn'}
        </Text>
      </View>

      {chuaDoc > 0 && (
        <View style={styles.huyHieu}>
          <Text style={styles.huyHieuChu}>{chuaDoc > 99 ? '99+' : chuaDoc}</Text>
        </View>
      )}
    </Pressable>
  );
}

function PhanCachThoiGian({ iso }: { iso?: string }) {
  const nhan = nhanPhanCach(iso);
  if (!nhan) return null;
  return (
    <View style={styles.phanCach}>
      <Text style={styles.phanCachChu}>{nhan}</Text>
    </View>
  );
}

function BongBongTin({
  tin,
  cuaToi,
  dauCum,
  cuoiCum,
}: {
  tin: TinNhan;
  cuaToi: boolean;
  dauCum: boolean;
  cuoiCum: boolean;
}) {
  if (tin.loai === 'SYSTEM') {
    return <Text style={styles.tinHeThong}>{tin.noiDung}</Text>;
  }

  return (
    <View style={[styles.hangTin, { alignItems: cuaToi ? 'flex-end' : 'flex-start' }, dauCum && { marginTop: spacing.sm }]}>
      {/* Tên người gửi chỉ ở đầu cụm, và không hiện với tin của chính mình. */}
      {!cuaToi && dauCum && !!tin.tenNguoiGui && (
        <Text style={styles.tenNguoiGui}>{tin.tenNguoiGui}</Text>
      )}

      <View style={[styles.bongBong, cuaToi ? styles.bongBongCuaToi : styles.bongBongCuaHo, tin.dangGui && { opacity: 0.6 }]}>
        {tin.daThuHoi ? (
          <Text style={[styles.chuTin, cuaToi && { color: '#fff' }, { fontStyle: 'italic', opacity: 0.75 }]}>
            Tin nhắn đã được thu hồi
          </Text>
        ) : (
          <Text style={[styles.chuTin, cuaToi && { color: '#fff' }]}>{tin.noiDung}</Text>
        )}
      </View>

      {/* Giờ chỉ ở tin cuối cụm — đủ để định vị mà không làm rối màn hình. */}
      {cuoiCum && !tin.dangGui && !tin.loiGui && !!tin.ngayTao && (
        <Text style={styles.gioTin}>{gioPhut(new Date(tin.ngayTao))}</Text>
      )}
      {tin.dangGui && <Text style={styles.gioTin}>Đang gửi…</Text>}
      {tin.loiGui && <Text style={[styles.gioTin, { color: colors.danger }]}>Gửi lỗi</Text>}
    </View>
  );
}

function ThanhLoi({ loi, onDong }: { loi: string | null; onDong: () => void }) {
  if (!loi) return null;
  return (
    <Pressable style={styles.thanhLoi} onPress={onDong}>
      <Ionicons name="alert-circle-outline" size={15} color={colors.danger} />
      <Text style={styles.thanhLoiChu}>{loi}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  man: { flex: 1, backgroundColor: colors.bg },

  bangTrangThai: { backgroundColor: '#fef3c7', paddingVertical: 6, paddingHorizontal: spacing.md },
  bangTrangThaiChu: { color: colors.warning, fontSize: 12 },

  nutHoTro: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.sm,
    padding: spacing.md, backgroundColor: colors.surface,
    borderBottomWidth: 1, borderBottomColor: colors.border,
  },
  nutHoTroChu: { color: colors.brand, fontWeight: '600', fontSize: 14 },

  mucHoiThoai: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.md,
    paddingHorizontal: spacing.md, paddingVertical: spacing.md,
    backgroundColor: colors.surface, borderBottomWidth: 1, borderBottomColor: colors.border,
  },
  anhDaiDien: {
    width: 40, height: 40, borderRadius: radius.full,
    backgroundColor: colors.brandLight, alignItems: 'center', justifyContent: 'center',
  },
  anhDaiDienNhom: { backgroundColor: '#fef3c7' },
  anhDaiDienChu: { color: colors.brandDark, fontWeight: '700' },
  nhanLoai: {
    backgroundColor: colors.border, borderRadius: radius.sm,
    paddingHorizontal: 5, paddingVertical: 1,
  },
  nhanLoaiChu: { fontSize: 10, color: colors.textMuted, fontWeight: '600' },
  oLoc: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.sm,
    paddingHorizontal: spacing.md, paddingVertical: spacing.sm,
    backgroundColor: colors.surface, borderBottomWidth: 1, borderBottomColor: colors.border,
  },
  oLocNhap: { flex: 1, color: colors.text, fontSize: 14, padding: 0 },
  hangTen: { flexDirection: 'row', alignItems: 'center', gap: spacing.sm },
  tenMuc: { flexShrink: 1, fontWeight: '600', color: colors.text, fontSize: 15 },
  gioMuc: { color: colors.textMuted, fontSize: 11 },
  xemTruoc: { color: colors.textMuted, fontSize: 13, marginTop: 2 },
  huyHieu: {
    minWidth: 20, paddingHorizontal: 6, paddingVertical: 2,
    borderRadius: radius.full, backgroundColor: colors.brand, alignItems: 'center',
  },
  huyHieuChu: { color: '#fff', fontSize: 11, fontWeight: '700' },

  dauKhung: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.md,
    padding: spacing.md, backgroundColor: colors.surface,
    borderBottomWidth: 1, borderBottomColor: colors.border,
  },
  tenHoiThoai: { fontWeight: '700', color: colors.text, fontSize: 15 },
  phuDe: { color: colors.textMuted, fontSize: 12 },

  phanCach: { alignItems: 'center', paddingVertical: spacing.md },
  phanCachChu: {
    color: colors.textMuted, fontSize: 11, fontWeight: '500',
    backgroundColor: colors.border, paddingHorizontal: 10, paddingVertical: 3,
    borderRadius: radius.full, overflow: 'hidden',
  },

  hangTin: { marginBottom: 2 },
  tenNguoiGui: { color: colors.textMuted, fontSize: 11, marginBottom: 2, paddingHorizontal: 4 },
  bongBong: { maxWidth: '78%', paddingHorizontal: spacing.md, paddingVertical: spacing.sm, borderRadius: radius.lg },
  bongBongCuaToi: { backgroundColor: colors.brand, borderBottomRightRadius: radius.sm },
  bongBongCuaHo: { backgroundColor: colors.surface, borderBottomLeftRadius: radius.sm, borderWidth: 1, borderColor: colors.border },
  chuTin: { color: colors.text, fontSize: 14.5, lineHeight: 20 },
  gioTin: { color: colors.textMuted, fontSize: 10, marginTop: 2, paddingHorizontal: 4 },
  tinHeThong: { textAlign: 'center', color: colors.textMuted, fontSize: 12, paddingVertical: spacing.sm },

  khungSoan: {
    flexDirection: 'row', alignItems: 'flex-end', gap: spacing.sm,
    padding: spacing.md, backgroundColor: colors.surface,
    borderTopWidth: 1, borderTopColor: colors.border,
  },
  oNhap: {
    flex: 1, maxHeight: 110, paddingHorizontal: spacing.md, paddingVertical: spacing.sm,
    backgroundColor: colors.bg, borderRadius: radius.lg, color: colors.text, fontSize: 14.5,
  },
  nutGui: {
    width: 40, height: 40, borderRadius: radius.full,
    backgroundColor: colors.brand, alignItems: 'center', justifyContent: 'center',
  },

  thanhLoi: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.sm,
    padding: spacing.md, backgroundColor: '#fee2e2',
  },
  thanhLoiChu: { color: colors.danger, fontSize: 13, flex: 1 },
});
