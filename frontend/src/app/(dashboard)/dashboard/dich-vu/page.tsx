"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { DichVuClient } from "./dich-vu-client";
import { TienIchClient } from "./tien-ich-client";
import { DashboardHero } from "@/components/dashboard/shared-ui";
import { Settings2 } from "lucide-react";

export default function DichVuPage() {
  return (
    <div className="space-y-4 md:space-y-6">
      <DashboardHero
        icon={Settings2}
        title="Dịch vụ & Tiện ích"
        description="Quản lý danh sách dịch vụ và tiện ích cho hệ thống."
      />
        
      <Tabs defaultValue="dich-vu" className="space-y-4">
        <TabsList>
          <TabsTrigger value="dich-vu">Dịch vụ</TabsTrigger>
          <TabsTrigger value="tien-ich">Tiện ích</TabsTrigger>
        </TabsList>
        <TabsContent value="dich-vu" className="space-y-4">
          <DichVuClient />
        </TabsContent>
        <TabsContent value="tien-ich" className="space-y-4">
          <TienIchClient />
        </TabsContent>
      </Tabs>
    </div>
  );
}
