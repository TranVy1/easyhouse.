"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { DichVuClient } from "./dich-vu-client";
import { TienIchClient } from "./tien-ich-client";
import { BadgeCheck, Car, Droplets, Settings2, Wifi, Zap } from "lucide-react";

export default function DichVuPage() {
  const serviceChips = [
    { label: "Điện", icon: Zap },
    { label: "Nước", icon: Droplets },
    { label: "Internet", icon: Wifi },
    { label: "Gửi xe", icon: Car },
  ];

  return (
    <div className="space-y-4 md:space-y-6">
      <section className="dich-vu-hero">
        <div className="dich-vu-hero__content">
          <div className="dich-vu-hero__eyebrow">
            <Settings2 className="h-4 w-4" aria-hidden="true" />
            <span>DỊCH VỤ & TIỆN ÍCH</span>
          </div>

          <div className="dich-vu-hero__title-row">
            <h1>Dịch vụ & Tiện ích</h1>
            <span className="dich-vu-hero__status-badge">
              <BadgeCheck className="h-4 w-4" aria-hidden="true" />
              Dịch vụ ổn định
            </span>
          </div>

          <p>
            Quản lý điện, nước, internet, gửi xe và các tiện ích áp dụng cho từng phòng.
          </p>

          <div className="dich-vu-hero__insight">
            Theo dõi điện, nước, internet và các tiện ích đi kèm để tính phí chính xác cho từng phòng.
          </div>

          <div className="dich-vu-hero__chips" aria-label="Nhóm dịch vụ phổ biến">
            {serviceChips.map(({ label, icon: Icon }) => (
              <span className="dich-vu-hero__chip" key={label}>
                <Icon className="h-4 w-4" aria-hidden="true" />
                {label}
              </span>
            ))}
          </div>
        </div>
      </section>

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
