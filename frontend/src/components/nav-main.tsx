"use client"

import * as React from "react"
import { ChevronRight, type LucideIcon } from "lucide-react"
import Link from "next/link"
import { usePathname } from "next/navigation"

import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import {
  SidebarGroup,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarMenuSub,
  SidebarMenuSubButton,
  SidebarMenuSubItem,
  useSidebar,
} from "@/components/ui/sidebar"

export function NavMain({
  items,
}: {
  items: {
    title: string
    url: string
    icon?: LucideIcon
    isActive?: boolean
    items?: {
      title: string
      url: string
    }[]
  }[]
}) {
  const pathname = usePathname()
  const { isMobile, state } = useSidebar()
  const [openDropdown, setOpenDropdown] = React.useState<string | null>(null)

  return (
    <SidebarGroup>
      <SidebarGroupLabel className="text-[10px] font-semibold uppercase tracking-widest text-[#6B7A8C]">Menu</SidebarGroupLabel>
      <SidebarMenu>
        {items.map((item) => {
          if (state === "collapsed" && !isMobile) {
            return (
              <SidebarMenuItem key={item.title}>
                <DropdownMenu 
                  open={openDropdown === item.title}
                  onOpenChange={(open) => {
                    setOpenDropdown(open ? item.title : null)
                  }}
                >
                  <DropdownMenuTrigger asChild>
                    <SidebarMenuButton
                      className="data-[state=open]:bg-[#F8F3EC] data-[state=open]:text-[#243B5A] transition-colors duration-200 hover:bg-[#F8F3EC] hover:text-[#243B5A] dark:hover:bg-slate-800 dark:data-[state=open]:bg-slate-800"
                    >
                      {item.icon && <item.icon />}
                      <span>{item.title}</span>
                    </SidebarMenuButton>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent
                    className="min-w-48 rounded-lg"
                    side="right"
                    align="start"
                    sideOffset={4}
                    onCloseAutoFocus={(e) => e.preventDefault()}
                  >
                    <DropdownMenuLabel className="flex items-center gap-2">
                      {item.icon && <item.icon className="h-4 w-4" />}
                      {item.title}
                    </DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    {item.items?.map((subItem) => {
                      const isActive = pathname === subItem.url
                      return (
                        <DropdownMenuItem 
                          key={subItem.title} 
                          asChild
                          onSelect={() => {
                            setOpenDropdown(null)
                          }}
                        >
                          <Link 
                            href={subItem.url}
                            className={isActive ? "bg-gradient-to-r from-[#4FA7A0]/10 to-transparent text-[#243B5A] font-bold shadow-[inset_3px_0_0_0_#4FA7A0] rounded-sm" : "transition-colors duration-200 hover:bg-[#F8F3EC] hover:text-[#243B5A] dark:hover:bg-slate-800"}
                          >
                            {subItem.title}
                          </Link>
                        </DropdownMenuItem>
                      )
                    })}
                  </DropdownMenuContent>
                </DropdownMenu>
              </SidebarMenuItem>
            )
          }

          // Khi sidebar expanded hoặc mobile, dùng Collapsible
          return (
            <Collapsible
              key={item.title}
              asChild
              defaultOpen={item.items?.some((subItem) => pathname.startsWith(subItem.url))}
              className="group/collapsible"
            >
              <SidebarMenuItem>
                <CollapsibleTrigger asChild>
                  <SidebarMenuButton
                    tooltip={item.title}
                    className={`transition-colors duration-200 hover:bg-[#F8F3EC] hover:text-[#243B5A] dark:hover:bg-slate-800 ${item.items?.some((subItem) => pathname.startsWith(subItem.url)) ? "text-[#243B5A] font-bold" : ""}`}
                  >
                    {item.icon && <item.icon />}
                    <span>{item.title}</span>
                    <ChevronRight className="ml-auto transition-transform duration-200 group-data-[state=open]/collapsible:rotate-90" />
                  </SidebarMenuButton>
                </CollapsibleTrigger>
                <CollapsibleContent>
                  <SidebarMenuSub>
                    {item.items?.map((subItem) => {
                      const isActive = pathname === subItem.url
                      return (
                        <SidebarMenuSubItem key={subItem.title}>
                          <SidebarMenuSubButton
                            asChild
                            isActive={isActive}
                            className={isActive ? "border-l-[2px] border-l-[#4FA7A0] bg-gradient-to-r from-[#4FA7A0]/10 to-transparent text-[#243B5A] font-bold transition-colors duration-200" : "transition-colors duration-200 hover:bg-[#F8F3EC] hover:text-[#243B5A] dark:hover:bg-slate-800"}
                          >
                            <Link href={subItem.url}>
                              <span>{subItem.title}</span>
                            </Link>
                          </SidebarMenuSubButton>
                        </SidebarMenuSubItem>
                      )
                    })}
                  </SidebarMenuSub>
                </CollapsibleContent>
              </SidebarMenuItem>
            </Collapsible>
          )
        })}
      </SidebarMenu>
    </SidebarGroup>
  )
}
