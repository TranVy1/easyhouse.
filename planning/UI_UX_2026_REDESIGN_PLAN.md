# EasyHouse UI/UX 2026 Redesign Plan

Last updated: 2026-06-01

## Scope

Danh gia va lap planning cai tien UX/UI cho EasyHouse, tap trung vao dashboard quan ly nha tro quy mo lon:

- Layout chung dashboard va sidebar.
- Man hinh `Toa nha`.
- Man hinh chi tiet toa nha / so do phong.
- Form tao toa nha thong minh.
- Import toa nha/phong.
- Workflow hop dong preview/confirm.

## Overall Score

**72/100**

| Criterion | Score | Assessment |
|---|---:|---|
| Visual Hierarchy | 7/10 | Co header, metric cards va tabs; nhung CTA, bang du lieu va form dang can uu tien lai theo tac vu chinh. |
| Usability | 7/10 | Luong nghiep vu da dung, nhung dialog tao toa nha/import qua dai va thieu preview ro rang. |
| Accessibility | 6/10 | Co button/input semantic tu Radix/shadcn, nhung mau trang thai can them icon/text pattern va focus/contrast can chuan hoa. |
| Consistency | 7/10 | Dung chung Card, Button, Badge, Sidebar; nhung spacing, radius, tone mau va text size chua co design-token ro. |
| Spacing & Layout | 7/10 | Layout responsive co san, nhung mot so card qua chat tren mobile va form co nhieu section trong mot dialog. |
| Typography | 6/10 | Co hierarchy co ban; nhung font size nho, label/text phu can he thong hoa. File hien co bi mojibake nen doc hieu bi anh huong nghiem trong. |
| Color System | 7/10 | Mau status phong kha ro; can bo sung neutral scale, semantic token va khong phu thuoc chi vao mau. |
| User Flow | 7/10 | Flow toa nha -> so do -> phong da tot; flow tao/import/hop dong can tach thanh wizard va confirmation ro hon. |
| Mobile Responsiveness | 7/10 | Co mobile cards va grid responsive; can toi uu touch target, sticky action va bang du lieu tren mobile. |
| Modern Design Standards | 7/10 | Nen tang shadcn/Radix phu hop; can tang muc polish, density control, empty/error/loading state va command-style actions. |

## Strengths

- Navigation theo nhom nghiep vu trong sidebar dung voi mental model: tai san, thu tien, cham soc, phan tich, he thong.
- Man hinh chi tiet toa nha da chuyen tu CRUD sang operational view: metric, tab, heatmap phong, side sheet phong.
- Trang thai phong co mapping mau truc quan: trong, dang thue, sap het han, bao tri.
- Component stack tot: Next.js App Router, Radix/shadcn, lucide icons, tabs, sheet, dialog.
- Da co responsive layout rieng cho desktop table va mobile card.
- Flow tao nhanh va import giup giam thao tac thu cong, dung huong san pham quan ly quy mo lon.

## Weaknesses

- Text tieng Viet dang bi mojibake trong nhieu UI string, lam giam niem tin va kha nang su dung.
- Header cua cac man hinh CRUD con giong nhau, chua lam ro tac vu uu tien theo ngu canh.
- Dialog tao toa nha gom qua nhieu field, tien nghi, dia chi, cau truc phong, custom floors trong mot luong dai.
- Import dang la textarea paste thuan, thieu table preview co cot, loi theo dong va mapping cot.
- Metric cards hien tai thieu context: ty le lap day, doanh thu, phong can hanh dong, hop dong sap het han.
- Mot so icon chua dung dung nghia nghiep vu, vi du `Users` cho phong trong/dang thue.
- Heatmap phu thuoc mau nhieu; nguoi mu mau hoac man hinh kem chat luong se kho phan biet.
- Mobile co nhieu nut icon an label, co nguy co giam discoverability.
- Tab chi tiet toa nha moi co tong quan/so do/danh sach phong; chua co Hop dong, Khach thue, Hoa don ngay trong context toa nha.
- Chua co he thong density: cung mot UI luc thi compact, luc thi card/padding lon.

## UX Risks

- Nguoi dung moi co the khong hieu import format neu chi doc mo ta text, nhat la khi copy Excel co dau phay/dinh dang tien.
- Tao toa nha nhanh trong dialog dai de gay bo sot truong hoac submit nham cau truc phong.
- Neu backend loi do DB/schema/API, UI hien tai de roi vao state trong hoac toast ngan, kho tu sua.
- Mau do cho phong da thue co the tao cam giac loi/canh bao, trong khi day la trang thai binh thuong.
- Nut preview/confirm hop dong nam o trang hop dong chi tiet nhung can feedback manh hon ve viec du lieu se bi khoa.

## Target UX Direction 2026

Phong cach: **quiet operational SaaS**, toi gian, chuyen nghiep, mat do thong tin vua-cao, uu tien quet nhanh va thao tac lap lai.

Design principles:

- Context first: moi man hinh can noi ro dang quan ly doi tuong nao va hanh dong tiep theo la gi.
- Progressive disclosure: form dai tach thanh buoc, phan nang cao an sau.
- Data-action proximity: thong tin nao can thao tac thi CTA nam gan thong tin do.
- Accessible status: moi trang thai co mau + icon + label + tooltip, khong chi dua vao mau.
- Stable layout: cards, room tiles, toolbar, tabs co kich thuoc on dinh, khong nhay khi data thay doi.

## Proposed New Information Architecture

Sidebar:

- Tong quan
- Van hanh nha tro
  - Toa nha
  - So do phong
  - Phong
  - Khach thue
  - Hop dong
- Thu tien
  - Chi so dien nuoc
  - Hoa don
  - Cong no
  - Thanh toan
  - Cau hinh gia
- Cham soc
  - Su co
  - Lich hen
  - Thong bao
- Phan tich
  - Bao cao
  - Doi soat VietQR
- He thong
  - Tai khoan
  - Media
  - Cai dat
  - Nhat ky

Rationale:

- Dua `So do phong` len thanh entry rieng vi day la man hinh van hanh hang ngay.
- Gom cac module theo workflow, khong chi theo entity CRUD.
- Giam do sau dieu huong cho tac vu thu tien va van hanh phong.

## Updated Screen Design

### 1. Dashboard Shell

Keep:

- Sidebar collapsible.
- Sticky top bar.
- Breadcrumb.
- Theme toggle.

Improve:

- Top bar cao 56px, nen `bg-background/95`, border subtle.
- Breadcrumb rut gon tren mobile, hien route hien tai + back action.
- Quick actions tren header: `Tao hop dong`, `Ghi chi so`, `Tao hoa don`, `Import`.
- Global search/command palette sau nay: tim phong, khach thue, hop dong.

### 2. Building List

New layout:

- Header:
  - Title: `Toa nha`
  - Subtitle: tong so toa, tong phong, ty le lap day.
  - Primary CTA: `Them toa nha`
  - Secondary CTA: `Import`
  - Icon-only refresh with tooltip.
- KPI strip:
  - Tong toa
  - Tong phong
  - Phong trong
  - Sap het hop dong
  - Doanh thu du kien
- Main content:
  - Desktop: data table with sticky toolbar.
  - Mobile: building cards with occupancy bar and quick actions.

Table columns:

- Ten toa nha + dia chi short.
- Tong phong.
- Phong trong.
- Dang thue.
- Ty le lap day.
- Doanh thu du kien.
- Can hanh dong.
- Actions.

Remove/noise:

- Khong lap lai `Tim thay` card neu da co table count.
- Khong dung icon `Users` cho phong trong.

### 3. Building Detail / Room Map

New layout:

- Header band:
  - Back button.
  - Building name.
  - Address.
  - Status summary.
  - Actions: `Them phong`, `Clone toa`, `Import phong`, `Tao hop dong`.
- KPI row:
  - Tong phong.
  - Trong.
  - Dang thue.
  - Sap het han.
  - Bao tri.
  - Doanh thu.
- Content tabs:
  - So do
  - Phong
  - Khach thue
  - Hop dong
  - Hoa don
  - Bao tri

Room map:

- Toolbar:
  - Floor filter.
  - Status filter.
  - Search room code/tenant.
  - Toggle: compact / comfortable.
- Floor sections:
  - Floor title left.
  - Floor occupancy right.
  - Stable tile grid.
- Room tile:
  - Room code large.
  - Status icon + short label.
  - Tenant name one line.
  - Contract end indicator if <= 30 days.
  - Price optional in comfortable mode.

Status color proposal:

- Vacant: emerald, label `Trong`.
- Rented: blue, label `Dang thue`.
- Expiring: amber, label `Sap het han`.
- Maintenance: neutral/slate, label `Bao tri`.
- Reserved/Pending if used later: violet or cyan, label `Giu cho`.

### 4. Room Detail Sheet

Current sheet should become an action panel:

- Top: room code, status badge, price.
- Sections:
  - Tenant/current contract.
  - Payment state.
  - Latest electricity/water readings.
  - Maintenance/open incidents.
- Actions:
  - `Tao hop dong` if vacant.
  - `Xem hop dong` if rented.
  - `Tao hoa don`.
  - `Bao tri`.
  - `Sua phong`.

### 5. Smart Building Creation

Replace long dialog with wizard/drawer full height:

Step 1: Thong tin toa nha

- Ten toa nha.
- Dia chi with dependent province/district/ward.
- Mo ta optional collapsed.

Step 2: Cau truc phong

- Segmented control:
  - Chi tao toa
  - Co dinh
  - Tuy chinh
  - Import tu Excel
- Fixed mode:
  - So tang.
  - Phong moi tang.
  - Preview generated codes.
- Custom mode:
  - Editable floor table.
  - Add/remove floor.
  - Duplicate floor config.

Step 3: Gia & mac dinh

- Dien tich.
- Gia thue.
- Tien coc.
- So nguoi toi da.
- Dich vu mac dinh if available later.

Step 4: Review

- Summary: floors, rooms, price range.
- Preview room code grid.
- Warnings: duplicate room code, missing price, unusual floor 0.

### 6. Import UX

Replace raw textarea-only with:

- Upload `.xlsx/.csv` and paste option.
- Column mapping screen:
  - Excel column -> system field.
- Preview table:
  - Row number.
  - Building.
  - Floor.
  - Room.
  - Area.
  - Price.
  - Validation status.
- Error panel:
  - Count by error type.
  - Jump to first error.
  - Download error rows later.

Primary CTA states:

- `Kiem tra du lieu`.
- `Import X phong`.
- Disabled until zero blocking errors.

### 7. Contract Preview/Confirm UX

Current:

- Preview/confirm exists but needs stronger irreversible-state communication.

Improve:

- Contract status stepper:
  - Draft
  - Previewed
  - Confirmed
  - Active
- Preview area:
  - Contract content/PDF preview.
  - Tenant/room summary side panel.
- Confirm modal:
  - Explicit effects:
    - Khoa hop dong.
    - Chuyen phong sang dang thue.
    - Tao lich thanh toan.
  - Checkbox: `Toi da kiem tra thong tin hop dong`.
- After confirm:
  - Show success summary and next actions: print, create invoice, view room map.

## Typography System

Use a restrained operational scale:

- Page title: 24-30px, semibold.
- Section title: 16-18px, semibold.
- Card metric: 24px desktop, 20px mobile.
- Body: 14px.
- Secondary text: 13px.
- Table dense text: 13-14px.
- Label: 13-14px, medium.

Rules:

- Letter spacing 0.
- Avoid viewport-scaled font size.
- No hero-size typography inside dashboard cards.
- Vietnamese text must be fixed to UTF-8 before final UX QA.

## Color System

Recommended semantic palette:

- Primary: indigo/blue for main actions.
- Success/vacant: emerald.
- Active/rented: blue.
- Warning/expiring: amber.
- Danger/destructive: red only for delete/errors.
- Maintenance/disabled: slate.
- Neutral backgrounds: white, zinc/slate 50, border slate 200.

Rules:

- Do not use red for normal `dang thue`; use blue to avoid false alarm.
- Every status needs label/icon, not color alone.
- Maintain contrast >= 4.5:1 for text.

## Accessibility Requirements

- All icon-only buttons need accessible label/tooltip.
- Focus ring visible on room tiles, table rows, dialog actions.
- Room status available through text and icon.
- Minimum touch target 40x40px.
- Form errors inline near fields, not only toast.
- Dialog/wizard must support keyboard navigation.
- Tables need row/column semantics and non-color status labels.

## Mobile Requirements

- Sticky bottom action bar for primary actions in long forms.
- Building cards show only high-signal data:
  - Name, address, occupancy, available rooms, action menu.
- Room map:
  - 2-3 columns on small screens.
  - Floor accordion.
  - Filter chips horizontally scrollable.
- Import:
  - Paste is secondary on mobile; file upload preferred.

## Implementation Plan

### Pending Approval - Public Home Mobile/Desktop App Pass

Status: In Progress

Started: 2026-06-03 — Work in progress (tracked via TODO list)

- [ ] Chinh trang giao dien khi moi vao `/` thanh full man hinh that su: main app chiem tron viewport, khong bi khoang trang/thanh cuon ngoai y muon, van giu bottom navigation mobile dung vung an toan.
- [ ] Can bang khu `Phong noi bat` voi `Danh sach phong`: cung chieu rong container, card khong lech mat do thong tin, spacing va ty le anh dong nhat giua featured cards va room list cards tren mobile/desktop.
- [ ] Them phan trang cho danh sach phong theo tung man hinh: moi trang hien toi da 9 card phong; neu nguoi dung muon xem them thi bam sang trang moi bang pagination prev/next va so trang hien tai.
- [ ] Dam bao chuyen tab trong app khong lam vo pagination/state quan trong: `home`, `saved`, `bills`, `profile` phai render on dinh, quay lai `home` khong bi layout nhay bat thuong.
- [ ] Kiem tra lai luong luu phong va danh sach phong da luu sau khi them pagination, tranh mat du lieu `localStorage` hoac sai ID phong.
- [ ] Chay QA bang AI agent cho ca mobile app va desktop app: desktop toi thieu 1440px/1280px, mobile toi thieu 390px/360px; chup/kiem tra layout khong overlap, text khong tran nut/card, tab va pagination bam duoc.
- [ ] Neu can chay dev server de test, dung frontend local `npm run dev`; neu port mac dinh ban, dung port khac va ghi lai URL test.

Technical tasks discovered during code review (frontend):

- Fix duplication between `Phòng nổi bật` and `Danh sách phòng`: remove featured items from the paginated list source so items are not shown twice. See `frontend/src/components/mobile-app/HomeScreen.tsx`.
- Update pagination UI to support a 9-page window (user requested "thêm phân trang đủ 9 trang") instead of the current 5-window `getVisiblePages` behavior.
- Correct mojibake fallback and initial filter text in `getInitialHomeViewState()` (replace `PhÃ²ng trá»` with `Phòng trọ`).
- Ensure full-viewport fallback in `page.tsx`: confirm `h-dvh` support or provide `h-screen` fallback to guarantee full-screen layout on all devices.
- Preserve correct `showingFrom` / `showingTo` numbers after removing featured items from the paginated source.
- Implement behavior for the `Xem thêm` button in the featured section (scroll to list or open a filtered view).
- Verify `sessionStorage` and `localStorage` usage for pagination and saved rooms persists across tab switches and remounts (tests + small fixes if needed).
- Add automated and manual QA steps: run frontend dev server, check desktop at 1440/1280 and mobile at 390/360, capture failures and layout screenshots.

Reference files to edit: `frontend/src/components/mobile-app/HomeScreen.tsx`, `frontend/src/app/page.tsx`.

### Phase 1 - UX Foundation

Status: In Progress

- [x] Fix UTF-8/mojibake UI strings in building list/detail components touched in this pass.
- [ ] Fix UTF-8/mojibake UI strings across all dashboard components.
- [x] Define first-pass operational status colors for room map: vacant emerald, rented blue, expiring amber, maintenance slate.
- [x] Standardize first-pass page header pattern on building list/detail.
- [x] Standardize first-pass metric card pattern on building list/detail.
- [ ] Extract reusable page header / metric card components after second screen family adopts the same pattern.
- [ ] Add tooltip/accessibility wrapper for all icon-only buttons.

### Phase 2 - Building List Redesign

Status: In Progress

- [x] Redesign header and action hierarchy.
- [x] Replace noisy stats with operational KPI strip.
- [x] Add occupancy bar to desktop table and mobile cards.
- [ ] Improve mobile action menu.
- [x] Use semantic room icons: room/door/home instead of generic users.

### Phase 3 - Building Detail Redesign

Status: In Progress

- [x] Add contextual operational header.
- [ ] Add address and contextual actions to header.
- [ ] Add tabs: Hop dong, Khach thue, Hoa don, Bao tri.
- [x] Add room map toolbar: search and status filter.
- [ ] Add floor filter and density toggle.
- [x] Update room tile status color and accessible label.
- [ ] Add contract end indicator on room tile.
- [ ] Improve room detail sheet actions.

### Phase 4 - Smart Creation Wizard

Status: Pending

- [ ] Replace create-building dialog with wizard/drawer.
- [ ] Add review step with generated room preview.
- [ ] Add inline validation and duplicate room warnings.
- [ ] Add sticky footer actions.
- [ ] Keep simple edit-building form separate from create-building wizard.

### Phase 5 - Import UX

Status: In Progress

- [ ] Support paste and file upload entry.
- [ ] Add column mapping step.
- [x] Improve paste entry with clearer column guidance.
- [ ] Add preview table with row-level errors.
- [x] Add first-pass error summary in import dialog.
- [ ] Add blocking/non-blocking classification.
- [ ] Confirm with clear count: buildings/floors/rooms to create.

### Phase 6 - Contract Workflow UX

Status: In Progress

- [x] Add contract lifecycle stepper.
- [x] Add locked-state badge and read-only action treatment after confirmation.
- [x] Add confirmation warning that explains lock, room status update and payment schedule creation.
- [ ] Improve preview panel and room/tenant summary.
- [ ] Add confirm modal listing database effects.
- [ ] Add post-confirm next actions.
- [x] Add first-pass locked contract read-only treatment.

### Phase 7 - QA And Design Review

Status: In Progress

- [x] Production build passed after building UX pass.
- [x] Production build passed after contract workflow UX pass.
- [ ] Desktop QA at 1440px, 1280px.
- [ ] Tablet QA at 768px.
- [ ] Mobile QA at 390px and 360px.
- [ ] Keyboard navigation pass.
- [ ] Color contrast pass.
- [ ] Empty/loading/error state pass.

## Success Metrics

- Create 6-floor x 10-room building in under 60 seconds.
- Find a vacant room from building detail in under 10 seconds.
- Import preview shows actionable row errors without backend log inspection.
- Confirm contract flow communicates locked-state effects before submit.
- Mobile user can inspect room status and open room detail without horizontal scrolling.

## Deferred

- Full design system documentation in Storybook.
- Command palette/global search.
- Advanced analytics dashboards.
- Real PDF contract preview polish.
- User role/permission-specific navigation.
