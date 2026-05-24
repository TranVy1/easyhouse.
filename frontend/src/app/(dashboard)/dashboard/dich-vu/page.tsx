"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { DichVuClient } from "./dich-vu-client";
import { TienIchClient } from "./tien-ich-client";

export default function DichVuPage() {
  return (
    <div className="flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <div className="flex flex-col justify-between items-start gap-3 md:gap-4">
          <div>
            <h1 className="text-xl md:text-2xl font-bold text-gray-900">Dịch vụ & Tiện ích</h1>
            <p className="text-xs md:text-sm text-gray-600">Quản lý danh sách dịch vụ và tiện ích cho hệ thống.</p>
          </div>
        </div>
        
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
    </div>
  );
}
