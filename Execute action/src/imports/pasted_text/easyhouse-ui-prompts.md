rompt Thiết Kế Figma - Giao Diện Người Dùng (Mobile-First WebView)
Dựa trên các chức năng của hệ thống EasyHouse từ mã nguồn Backend và Frontend (không bao gồm Dashboard), đây là bộ Prompt được tối ưu để bạn dán vào các AI sinh UI (như v0.dev, Midjourney) hoặc gửi cho UI/UX Designer trên Figma.

Ngôn ngữ thiết kế chung (Design System Prompt):

"Design a modern, mobile-first web application interface tailored for a mobile WebView environment. The style should be clean, minimalist, and highly intuitive. Use a color palette of soft whites, light grays for backgrounds, primary brand color (e.g., vibrant blue #2563EB or deep green #10B981) for interactive elements, and dark charcoal for text. Employ large, touch-friendly touch targets (min 48x48px), card-based layouts with subtle drop shadows, smooth rounded corners (border-radius 12px-16px), and modern sans-serif typography (e.g., Inter or Outfit). Ensure excellent micro-interactions and skeleton loaders for async states."

1. Màn Hình Trang Chủ & Khám Phá (Home & Explore)
Mục đích: Cho phép khách thuê tìm kiếm phòng trống, xem nổi bật.

Prompt:

"Design a 'Home/Explore' screen for a mobile rental app.

Top: A sticky header with a welcoming greeting, user avatar, and a smart search bar with filter icons (Price, Location, Room Type).
Body: A horizontal scrollable section for 'Featured Rooms' (large image cards with price tag overlapping, room name, location, and a quick 'heart' save button). Below that, a vertical list of 'Available Rooms' using horizontal cards (thumbnail on the left, details on the right: price, area, number of bedrooms, and amenities icons like Wifi, AC).
Bottom: A standard iOS-style bottom navigation bar with icons for Home, Saved, Bills, and Profile. Make the layout feel airy with generous white space and soft card shadows."
2. Màn Hình Chi Tiết Phòng & Đặt Lịch (Room Details & Booking)
Mục đích: Khách xem kỹ thông tin phòng và book lịch xem.

Prompt:

"Design a 'Room Detail' screen for a mobile rental app.

Header: A full-width image gallery carousel of the room with a pagination indicator (dots). A floating back button and share button at the top corners.
Content: Room title, prominent monthly price, and a badge showing 'Available Now'. A section for 'Amenities' using a grid of small icons + labels (e.g., Air Conditioner, Free Wifi, Parking). A text description area with a 'Read More' expand toggle. Location map snippet.
Bottom (Sticky): A sticky bottom bar with the total price on the left and a large, prominent primary button on the right saying 'Book a Viewing' (Đặt lịch xem phòng). The design should be highly visual, drawing attention to the room photos and the call-to-action button."
3. Màn Hình Hóa Đơn & Thanh Toán VietQR (Billing & Payments)
Mục đích: Khách thuê xem hóa đơn hàng tháng và quét mã VietQR để thanh toán.

Prompt:

"Design a 'Billing and Payment' screen for a tenant mobile app.

Header: Simple title 'My Bills' with a toggle switch between 'Unpaid' and 'Paid'.
Current Bill Card (Highlight): A prominent card showing the current month's bill total. Includes a breakdown: Rent, Electricity, Water, Services. Status badge: 'Overdue' (Red) or 'Pending' (Orange).
Payment Section: Below the breakdown, a clean, centered VietQR code for instant payment. Text saying 'Scan to pay via any banking app'. A button below the QR code to 'Download Invoice PDF' or 'Copy Account Number'.
Style: Use a receipt-like aesthetic for the bill breakdown (dashed divider lines). The QR code area should be framed nicely to encourage scanning."
4. Màn Hình Báo Cáo Sự Cố (Incident Reporting)
Mục đích: Khách thuê chụp ảnh hư hỏng, báo cáo cho chủ nhà.

Prompt:

"Design an 'Incident Report / Support' screen for a tenant mobile app.

Top: A progress tracker or status tabs (Open, In Progress, Resolved).
New Report Section: A clear form to create a new ticket. Input fields for 'Issue Title' (e.g., Broken AC), 'Description'.
Image Upload: A large dashed-border dropzone area saying 'Tap to upload photos from camera roll' with a camera icon. Below it, show horizontal thumbnail previews of uploaded images.
Action: A sticky primary 'Submit Report' button at the bottom.
Style: The form inputs should have floating labels and soft borders. Focus on ease of use so a tenant can report an issue in less than 30 seconds."
5. Màn Hình Hợp Đồng Điện Tử (E-Contract & Profile)
Mục đích: Quản lý hợp đồng số và thông tin cá nhân.

Prompt:

"Design a 'My Profile & Contract' screen for a tenant app.

Profile Header: Circular avatar, tenant name, room number, and phone number. An 'Edit Profile' button.
Contract Card: A dedicated card showing the active lease agreement. Includes: Start Date, End Date, Deposit Amount. A visual progress bar showing how much time is left on the lease.
Actions: A button to 'View E-Contract (PDF)'. A warning banner if the contract is expiring in less than 30 days, with a quick action button 'Renew Contract'.
Bottom section: List of menu items (Settings, AI Chat Assistant, Logout) with right-facing chevron arrows.
Style: Clean, organized list format. Use subtle background colors to differentiate the contract card from the standard menu items."
6. Tiện Ích: Chatbot AI Trợ Lý (Floating AI Chat)
Mục đích: Giao diện trò chuyện nhanh với AI.

Prompt:

"Design a 'Smart AI Assistant Chat' overlay for a mobile app.

Layout: A bottom-sheet style chat window that slides up over the main app.
Header: Bot avatar (friendly robot face), name 'EasyHouse AI', and a 'Close' icon.
Chat Area: iOS iMessage-style chat bubbles. Bot messages on the left (light gray), user messages on the right (primary color). Include quick-reply suggestion chips above the input field (e.g., 'What is my wifi password?', 'How to read electricity meter?').
Input Area: Text input field with a microphone icon for voice-to-text and a send button. Ensure the interface feels conversational, modern, and non-intrusive."