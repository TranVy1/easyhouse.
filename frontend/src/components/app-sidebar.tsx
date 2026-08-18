"use client"

import * as React from "react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { useSession } from "next-auth/react"
import type { LucideIcon } from "lucide-react"
import {
  BarChart3,
  Building2,
  CircleDollarSign,
  ClipboardList,
  LayoutDashboard,
  Settings,
  Shield,
} from "lucide-react"

import { NavMain } from "@/components/nav-main"
import { NavUser } from "@/components/nav-user"
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarRail,
} from "@/components/ui/sidebar"

type NavigationSection = {
  title: string
  url: string
  icon: LucideIcon
  items: Array<{ title: string; url: string }>
}

const mainSections: NavigationSection[] = [
  {
    title: "Tài sản & cư trú",
    url: "#",
    icon: Building2,
    items: [
      { title: "Tòa nhà", url: "/dashboard/toa-nha" },
      { title: "Phòng", url: "/dashboard/phong" },
      { title: "Phương tiện", url: "/dashboard/phuong-tien" },
      { title: "Kho tài sản", url: "/dashboard/kho-tai-san" },
      { title: "Tài sản phòng", url: "/dashboard/tai-san-phong" },
      { title: "Đặt cọc", url: "/dashboard/dat-coc" },
      { title: "Khách thuê", url: "/dashboard/khach-thue" },
      { title: "Hợp đồng", url: "/dashboard/hop-dong" },
      { title: "Yêu cầu hủy / gia hạn", url: "/dashboard/yeu-cau-hop-dong" },
      { title: "Yêu cầu ở ghép", url: "/dashboard/yeu-cau-o-ghep" },
      { title: "Dịch vụ & tiện ích", url: "/dashboard/dich-vu" },
    ],
  },
  {
    title: "Thu tiền",
    url: "#",
    icon: CircleDollarSign,
    items: [
      { title: "Chỉ số điện nước", url: "/dashboard/chi-so-dien-nuoc" },
      { title: "Cấu hình giá", url: "/dashboard/cau-hinh-gia" },
      { title: "Biểu phí xe", url: "/dashboard/cau-hinh-phi-xe" },
      { title: "Hóa đơn", url: "/dashboard/hoa-don" },
      { title: "Công nợ", url: "/dashboard/cong-no" },
      { title: "Thanh toán", url: "/dashboard/thanh-toan" },
    ],
  },
  {
    title: "Chăm sóc",
    url: "#",
    icon: ClipboardList,
    items: [
      { title: "Tin nhắn", url: "/dashboard/tin-nhan" },
      { title: "Sự cố", url: "/dashboard/su-co" },
      { title: "Lịch hẹn", url: "/dashboard/lich-hen" },
      { title: "Xem website", url: "/dashboard/xem-web" },
    ],
  },
  {
    title: "Phân tích",
    url: "#",
    icon: BarChart3,
    items: [{ title: "Báo cáo", url: "/dashboard/bao-cao" }],
  },
  {
    title: "Hệ thống",
    url: "#",
    icon: Settings,
    items: [
      { title: "Hồ sơ", url: "/dashboard/ho-so" },
      { title: "Cài đặt", url: "/dashboard/cai-dat" },
    ],
  },
]

const adminSection: NavigationSection = {
  title: "Quản trị",
  url: "#",
  icon: Shield,
  items: [
    { title: "Tài khoản", url: "/dashboard/quan-ly-tai-khoan" },
    { title: "Thông báo", url: "/dashboard/thong-bao" },
    { title: "Đối soát VietQR", url: "/dashboard/vietqr-doi-soat" },
    { title: "Media", url: "/dashboard/media" },
    { title: "Nhật ký hệ thống", url: "/dashboard/audit-log" },
  ],
}

export function AppSidebar({ ...props }: React.ComponentProps<typeof Sidebar>) {
  const pathname = usePathname()
  const { data: session } = useSession()
  const role = session?.user?.role?.replace(/^ROLE_/, "").toUpperCase()

  const sections = React.useMemo(
    () => (role === "ADMIN" ? [...mainSections, adminSection] : mainSections),
    [role],
  )

  const userData = React.useMemo(
    () => ({
      name: session?.user?.name || "Người dùng",
      email: session?.user?.email || "",
      avatar: session?.user?.avatar || "/avatars/default.jpg",
    }),
    [session],
  )

  return (
    <Sidebar collapsible="icon" variant="inset" className="border-r border-sidebar-border" {...props}>
      <SidebarHeader className="border-b border-sidebar-border p-3 pb-4">
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton size="lg" asChild>
              <Link href="/dashboard">
                <div className="flex aspect-square size-9 items-center justify-center rounded-xl bg-gradient-to-br from-primary to-primary/70 shadow-sm">
                  <Building2 className="size-5 text-primary-foreground" />
                </div>
                <div className="grid flex-1 text-left leading-tight">
                  <span className="truncate text-lg font-bold tracking-tight text-sidebar-foreground">EasyHouse</span>
                  <span className="truncate text-xs text-muted-foreground">Quản lý nhà trọ</span>
                </div>
              </Link>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent className="py-2">
        <SidebarGroup>
          <SidebarGroupContent>
            <SidebarMenu>
              <SidebarMenuItem>
                <SidebarMenuButton
                  asChild
                  isActive={pathname === "/dashboard"}
                  tooltip="Tổng quan"
                  className={pathname === "/dashboard" ? "border-l-[3px] border-l-primary bg-gradient-to-r from-primary/10 to-transparent text-sidebar-foreground font-bold transition-colors duration-200" : "transition-colors duration-200 hover:bg-sidebar-accent hover:text-sidebar-accent-foreground"}
                >
                  <Link href="/dashboard">
                    <LayoutDashboard />
                    <span>Tổng quan</span>
                  </Link>
                </SidebarMenuButton>
              </SidebarMenuItem>
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
        <NavMain items={sections} />
      </SidebarContent>
      <SidebarFooter className="border-t border-sidebar-border px-3 py-4">
        <NavUser user={userData} />
      </SidebarFooter>
      <SidebarRail />
    </Sidebar>
  )
}
