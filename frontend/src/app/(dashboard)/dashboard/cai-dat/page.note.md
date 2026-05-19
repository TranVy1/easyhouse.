# Cai dat page note

- Route: `/dashboard/cai-dat`
- Frontend: `frontend/src/app/(dashboard)/dashboard/cai-dat/page.tsx`
- Router links: sidebar -> `/dashboard/cai-dat`.
- API: none
- Backend: none
- DB: none
- Storage:
  - `localStorage.fontSettings`
  - `localStorage.uiSettings`
- Logic:
  - Applies font family/size/line-height/font-weight to document/body.
  - Applies theme by toggling `dark` class.
  - Applies density by body class and CSS variables.
- Can luu y:
  - Settings are per browser only, not per user.
  - Code loops through all DOM elements when applying font; could be expensive on large pages.
