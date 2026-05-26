"use client";

import { useState, useEffect } from "react";
import { format } from "date-fns";
import { vi } from "date-fns/locale";
import { Upload, Trash2, File, Image as ImageIcon, Video, FileText, Download, ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { FileMedia, ApiResponse } from "@/types";

export function MediaClient() {
  const [mediaList, setMediaList] = useState<FileMedia[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isUploadOpen, setIsUploadOpen] = useState(false);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [selectedMedia, setSelectedMedia] = useState<FileMedia | null>(null);
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  
  const [formData, setFormData] = useState({
    doiTuong: "OTHER",
    doiTuongId: "",
  });

  // Client-side pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });

  const fetchData = async () => {
    try {
      setIsLoading(true);
      const res = await fetch("/api/media");
      const data: ApiResponse<FileMedia[]> = await res.json();
      
      if (data.success) {
        setMediaList(data.data || []);
      }
    } catch (error) {
      console.error("Lỗi khi tải dữ liệu media:", error);
      toast.error("Không thể tải danh sách file");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      setSelectedFile(e.target.files[0]);
    }
  };

  const handleUpload = async () => {
    if (!selectedFile) {
      toast.error("Vui lòng chọn file");
      return;
    }
    if (!formData.doiTuongId && formData.doiTuong !== "OTHER") {
      toast.error("Vui lòng nhập ID đối tượng hoặc chọn đối tượng OTHER");
      return;
    }

    try {
      const uploadData = new FormData();
      uploadData.append("file", selectedFile);
      uploadData.append("doiTuong", formData.doiTuong);
      
      // Nếu không có doiTuongId, sử dụng UUID tạm thời (hoặc user id)
      // Tùy theo logic nghiệp vụ, đối tượng OTHER có thể gán ID tạm.
      const idToUse = formData.doiTuongId || "00000000-0000-0000-0000-000000000000";
      uploadData.append("doiTuongId", idToUse);

      const res = await fetch("/api/media", {
        method: "POST",
        body: uploadData,
      });

      const data = await res.json();

      if (data.success) {
        toast.success("Tải tệp lên thành công");
        setIsUploadOpen(false);
        setSelectedFile(null);
        setFormData({ ...formData, doiTuongId: "" });
        fetchData();
      } else {
        toast.error(data.message || "Tải tệp lên thất bại");
      }
    } catch (error) {
      console.error("Lỗi khi upload:", error);
      toast.error("Đã xảy ra lỗi khi tải tệp lên");
    }
  };

  const handleDelete = async () => {
    if (!selectedMedia) return;
    try {
      const res = await fetch(`/api/media/${selectedMedia._id || selectedMedia.id}`, {
        method: "DELETE",
      });
      const data: ApiResponse<void> = await res.json();
      
      if (data.success) {
        toast.success(data.message);
        setIsDeleteDialogOpen(false);
        fetchData();
      } else {
        toast.error(data.message);
      }
    } catch (error) {
      console.error("Lỗi khi xóa file:", error);
      toast.error("Đã xảy ra lỗi khi xóa file");
    }
  };

  const getFileIcon = (loaiFile: string) => {
    if (loaiFile?.startsWith("image/")) return <ImageIcon className="h-5 w-5 text-blue-500" />;
    if (loaiFile?.startsWith("video/")) return <Video className="h-5 w-5 text-red-500" />;
    if (loaiFile?.includes("pdf") || loaiFile?.includes("document")) return <FileText className="h-5 w-5 text-green-500" />;
    return <File className="h-5 w-5 text-gray-500" />;
  };

  const formatBytes = (bytes: number) => {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  // Pagination calculation
  const totalElements = mediaList.length;
  const totalPages = Math.ceil(totalElements / pagination.pageSize);
  const paginatedMediaList = mediaList.slice(
    pagination.pageIndex * pagination.pageSize,
    (pagination.pageIndex + 1) * pagination.pageSize
  );

  return (
    <div className="space-y-4">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
        <div>
          <h1 className="text-xl md:text-2xl font-bold text-gray-900">Quản lý File & Media</h1>
          <p className="text-xs md:text-sm text-gray-600">Quản lý hình ảnh, hợp đồng, tài liệu trong hệ thống.</p>
        </div>
        <Button onClick={() => setIsUploadOpen(true)}>
          <Upload className="mr-2 h-4 w-4" /> Tải lên
        </Button>
      </div>

      <div className="border rounded-md bg-white overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>File</TableHead>
              <TableHead>Đối tượng</TableHead>
              <TableHead>Kích thước</TableHead>
              <TableHead>Ngày tải lên</TableHead>
              <TableHead className="text-right">Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-10 text-gray-500">Đang tải dữ liệu...</TableCell>
              </TableRow>
            ) : mediaList.length === 0 ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-10 text-gray-500">Chưa có file nào</TableCell>
              </TableRow>
            ) : (
              paginatedMediaList.map((media) => (
                <TableRow key={media._id || media.id}>
                  <TableCell>
                    <div className="flex items-center space-x-3">
                      {getFileIcon(media.loaiFile || "")}
                      <div className="max-w-[200px] truncate" title={media.url}>
                        <a href={media.url} target="_blank" rel="noreferrer" className="font-medium text-blue-600 hover:underline">
                          {media.publicId ? media.publicId.split("/").pop() : "File"}
                        </a>
                        <div className="text-xs text-gray-500 truncate">{media.loaiFile}</div>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline">{media.doiTuong}</Badge>
                    <div className="text-xs text-gray-500 mt-1 truncate max-w-[150px]" title={media.doiTuongId as string}>
                      {media.doiTuongId}
                    </div>
                  </TableCell>
                  <TableCell>
                    {media.kichThuocBytes ? formatBytes(media.kichThuocBytes) : "-"}
                  </TableCell>
                  <TableCell>
                    <div className="text-sm">
                      {media.taoLuc ? format(new Date(media.taoLuc), "dd/MM/yyyy HH:mm") : "-"}
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="flex space-x-2 justify-end">
                      <Button variant="ghost" size="icon" asChild>
                        <a href={media.url} target="_blank" rel="noreferrer" download>
                          <Download className="h-4 w-4 text-gray-500" />
                        </a>
                      </Button>
                      <Button variant="ghost" size="icon" onClick={() => { setSelectedMedia(media); setIsDeleteDialogOpen(true); }}>
                        <Trash2 className="h-4 w-4 text-red-500" />
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      <div className="flex items-center justify-between px-2">
        <div className="text-muted-foreground hidden flex-1 text-sm lg:flex">
          Hiển thị {paginatedMediaList.length} / {totalElements} file
        </div>
        <div className="flex w-full items-center gap-8 lg:w-fit">
          <div className="hidden items-center gap-2 lg:flex">
            <Label htmlFor="rows-per-page" className="text-sm font-medium">
              Số hàng mỗi trang
            </Label>
            <Select
              value={`${pagination.pageSize}`}
              onValueChange={(value) => {
                setPagination(prev => ({ ...prev, pageSize: Number(value), pageIndex: 0 }))
              }}
            >
              <SelectTrigger size="sm" className="w-20" id="rows-per-page">
                <SelectValue placeholder={pagination.pageSize} />
              </SelectTrigger>
              <SelectContent side="top">
                {[10, 20, 30, 40, 50].map((pageSize) => (
                  <SelectItem key={pageSize} value={`${pageSize}`}>
                    {pageSize}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="flex w-fit items-center justify-center text-sm font-medium">
            Trang {pagination.pageIndex + 1} / {totalPages || 1}
          </div>
          <div className="ml-auto flex items-center gap-2 lg:ml-0">
            <Button
              variant="outline"
              className="hidden h-8 w-8 p-0 lg:flex"
              onClick={() => setPagination(prev => ({ ...prev, pageIndex: 0 }))}
              disabled={pagination.pageIndex === 0}
            >
              <span className="sr-only">Trang đầu</span>
              <ChevronsLeft className="h-4 w-4" />
            </Button>
            <Button
              variant="outline"
              className="size-8 p-0"
              onClick={() => setPagination(prev => ({ ...prev, pageIndex: Math.max(0, prev.pageIndex - 1) }))}
              disabled={pagination.pageIndex === 0}
            >
              <span className="sr-only">Trang trước</span>
              <ChevronLeft className="h-4 w-4" />
            </Button>
            <Button
              variant="outline"
              className="size-8 p-0"
              onClick={() => setPagination(prev => ({ ...prev, pageIndex: Math.min(totalPages - 1, prev.pageIndex + 1) }))}
              disabled={pagination.pageIndex >= totalPages - 1}
            >
              <span className="sr-only">Trang sau</span>
              <ChevronRight className="h-4 w-4" />
            </Button>
            <Button
              variant="outline"
              className="hidden h-8 w-8 p-0 lg:flex"
              onClick={() => setPagination(prev => ({ ...prev, pageIndex: totalPages - 1 }))}
              disabled={pagination.pageIndex >= totalPages - 1}
            >
              <span className="sr-only">Trang cuối</span>
              <ChevronsRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>

      <Dialog open={isUploadOpen} onOpenChange={setIsUploadOpen}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Tải tệp lên</DialogTitle>
            <DialogDescription>
              Chọn tệp để tải lên hệ thống và gắn với đối tượng tương ứng.
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="file">Chọn file <span className="text-red-500">*</span></Label>
              <Input 
                id="file" 
                type="file" 
                onChange={handleFileChange}
              />
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="doiTuong">Loại đối tượng</Label>
              <Select 
                value={formData.doiTuong} 
                onValueChange={(value) => setFormData({...formData, doiTuong: value})}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Chọn loại đối tượng" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="USER">Người dùng</SelectItem>
                  <SelectItem value="TENANT">Khách thuê</SelectItem>
                  <SelectItem value="ROOM">Phòng</SelectItem>
                  <SelectItem value="CONTRACT">Hợp đồng</SelectItem>
                  <SelectItem value="INVOICE">Hóa đơn</SelectItem>
                  <SelectItem value="PAYMENT">Thanh toán</SelectItem>
                  <SelectItem value="INCIDENT">Sự cố</SelectItem>
                  <SelectItem value="METER_READING">Chỉ số điện nước</SelectItem>
                  <SelectItem value="APPOINTMENT">Lịch hẹn</SelectItem>
                  <SelectItem value="OTHER">Khác</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="doiTuongId">ID Đối tượng {formData.doiTuong !== "OTHER" && <span className="text-red-500">*</span>}</Label>
              <Input 
                id="doiTuongId" 
                value={formData.doiTuongId}
                onChange={(e) => setFormData({...formData, doiTuongId: e.target.value})}
                placeholder="Ví dụ: b38e92..."
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsUploadOpen(false)}>Hủy</Button>
            <Button onClick={handleUpload}>Tải lên</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Xác nhận xóa</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn xóa tệp này? 
              Tệp sẽ bị xóa vĩnh viễn khỏi Cloudinary và hệ thống.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDeleteDialogOpen(false)}>Hủy</Button>
            <Button variant="destructive" onClick={handleDelete}>Xóa</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
