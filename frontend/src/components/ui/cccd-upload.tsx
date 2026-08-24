'use client';

import { Badge } from '@/components/ui/badge';
import { CreditCard } from 'lucide-react';
import { ImageUpload } from '@/components/ui/image-upload';

interface CCCDUploadProps {
  anhCCCD: {
    matTruoc: string;
    matSau: string;
  };
  onCCCDChange: (anhCCCD: { matTruoc: string; matSau: string }) => void;
  className?: string;
}

export function CCCDUpload({ 
  anhCCCD, 
  onCCCDChange, 
  className = '' 
}: CCCDUploadProps) {

  return (
    <div className={`space-y-6 ${className}`}>
      <div className="flex items-center gap-2 mb-4">
        <CreditCard className="h-5 w-5 text-primary" />
        <h3 className="text-lg font-medium text-foreground">Ảnh CCCD</h3>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Mặt trước */}
        <ImageUpload
          imageUrl={anhCCCD.matTruoc}
          onImageChange={(url) => onCCCDChange({ ...anhCCCD, matTruoc: url })}
          label="Mặt trước CCCD"
          placeholder="Chưa có ảnh CCCD mặt trước"
          previewClassName="aspect-[3/2] w-full"
        />

        {/* Mặt sau */}
        <ImageUpload
          imageUrl={anhCCCD.matSau}
          onImageChange={(url) => onCCCDChange({ ...anhCCCD, matSau: url })}
          label="Mặt sau CCCD"
          placeholder="Chưa có ảnh CCCD mặt sau"
          previewClassName="aspect-[3/2] w-full"
        />
      </div>

      {/* Status badge */}
      <div className="flex justify-center">
        <Badge variant={anhCCCD.matTruoc && anhCCCD.matSau ? "soft-success" : "soft-warning"} className="text-xs">
          {anhCCCD.matTruoc && anhCCCD.matSau 
            ? 'Đã tải lên đầy đủ ảnh CCCD'
            : `Còn thiếu ${!anhCCCD.matTruoc && !anhCCCD.matSau ? '2' : '1'} ảnh CCCD`
          }
        </Badge>
      </div>
    </div>
  );
}
