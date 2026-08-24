'use client';

import { useState, useRef } from 'react';
import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { Upload, X, Image as ImageIcon, Loader2 } from 'lucide-react';
import { toast } from 'sonner';
import { useSession } from 'next-auth/react';

interface ImageUploadProps {
  imageUrl: string;
  onImageChange: (imageUrl: string) => void;
  className?: string;
  previewClassName?: string;
  label?: string;
  placeholder?: string;
}

export function ImageUpload({ 
  imageUrl, 
  onImageChange, 
  className = '',
  previewClassName = 'h-48 w-full',
  label = 'Ảnh',
  placeholder = 'Chọn ảnh'
}: ImageUploadProps) {
  const { data: session } = useSession();
  const [uploading, setUploading] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  const handleFileSelect = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files || files.length === 0) return;

    const file = files[0];
    if (!file.type.startsWith('image/')) {
      toast.error('Vui lòng chọn file ảnh');
      return;
    }

    setUploading(true);

    try {
      if (!session?.accessToken) {
        throw new Error('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại');
      }
      const formData = new FormData();
      formData.append('file', file);

      const response = await fetch('/api/upload', {
        method: 'POST',
        headers: { Authorization: `Bearer ${session.accessToken}` },
        body: formData,
      });

      if (!response.ok) {
        throw new Error('Tải ảnh lên thất bại');
      }

      const result = await response.json();
      if (result.success && result.data.url) {
        onImageChange(result.data.url);
        toast.success('Tải ảnh lên thành công');
      } else {
        throw new Error('Tải ảnh lên thất bại');
      }
    } catch (error) {
      console.error('Upload error:', error);
      toast.error('Có lỗi xảy ra khi tải ảnh lên');
    } finally {
      setUploading(false);
      // Reset input
      if (inputRef.current) {
        inputRef.current.value = '';
      }
    }
  };

  const handleRemove = () => {
    onImageChange('');
  };

  return (
    <div className={`space-y-2 ${className}`}>
      {label && (
        <label className="text-sm font-medium leading-none text-foreground peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
          {label}
        </label>
      )}
      
      <div className="space-y-2">
        {imageUrl ? (
          <div className={`relative overflow-hidden rounded-lg border border-border bg-muted ${previewClassName}`}>
            <Image
              src={imageUrl}
              alt="Ảnh đã tải lên"
              fill
              sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
              className="object-cover"
            />
            <Button
              type="button"
              variant="destructive"
              size="sm"
              className="absolute top-2 right-2 h-7 w-7 p-0"
              onClick={handleRemove}
            >
              <X className="h-4 w-4" />
            </Button>
          </div>
        ) : (
          <div 
            className={`flex flex-col items-center justify-center rounded-lg border-2 border-dashed border-border/60 bg-muted/30 cursor-pointer transition-colors hover:border-primary/50 hover:bg-muted/50 ${previewClassName}`}
            onClick={() => inputRef.current?.click()}
          >
            {uploading ? (
              <>
                <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
                <p className="mt-2 text-sm text-muted-foreground">Đang tải lên...</p>
              </>
            ) : (
              <>
                <ImageIcon className="h-8 w-8 text-muted-foreground/50" />
                <p className="mt-2 text-sm text-muted-foreground font-medium">{placeholder}</p>
                <p className="text-xs text-muted-foreground/70">Click để chọn ảnh</p>
              </>
            )}
          </div>
        )}
        
        <input
          ref={inputRef}
          type="file"
          accept="image/*"
          onChange={handleFileSelect}
          className="hidden"
          disabled={uploading}
        />
        
        {!imageUrl && (
          <Button
            type="button"
            variant="outline"
            onClick={() => inputRef.current?.click()}
            className="w-full"
            disabled={uploading}
            isLoading={uploading}
          >
            {!uploading && <Upload className="h-4 w-4 mr-2" />}
            {uploading ? 'Đang tải lên...' : 'Chọn ảnh'}
          </Button>
        )}
      </div>
    </div>
  );
}
