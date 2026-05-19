# Xem web page note

- Route: `/dashboard/xem-web`
- Frontend: `frontend/src/app/(dashboard)/dashboard/xem-web/page.tsx`
- Router links: sidebar -> `/dashboard/xem-web`.
- API: external URL in iframe only
- Backend: none
- DB: none
- Logic:
  - Adds `https://` if user enters URL without protocol.
  - Loads iframe and marks error after 10 seconds if not loaded.
  - Quick links include Wikipedia, VNExpress, Dan Tri, Example.
  - Can open current URL in new tab.
- Can luu y:
  - Many sites block iframe via CSP/X-Frame-Options.
  - Iframe sandbox allows same-origin, scripts, forms, popups.
