"use client";

import { useState, useEffect, useCallback } from "react";
import { format } from "date-fns";
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
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Search, History, Eye, User, FileText, ChevronLeft, ChevronRight, ActivitySquare } from "lucide-react";
import { DashboardHero, DashboardCard } from "@/components/dashboard/shared-ui";
import { toast } from "sonner";
import { AuditLog, ApiResponse } from "@/types";
import { useSession } from "next-auth/react";

interface PageData {
  content: AuditLog[];
  pageable: Record<string, unknown>;
  totalPages: number;
  totalElements: number;
  last: boolean;
  size: number;
  number: number;
  sort: Record<string, unknown>;
  numberOfElements: number;
  first: boolean;
  empty: boolean;
}

export function AuditLogClient() {
  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [bangTacDong, setBangTacDong] = useState("");
  const [searchTerm, setSearchTerm] = useState("");
  
  const [selectedLog, setSelectedLog] = useState<AuditLog | null>(null);
  const [isDetailOpen, setIsDetailOpen] = useState(false);

  const fetchLogs = useCallback(async (currentPage: number, tableFilter: string = "") => {
    try {
      setIsLoading(true);
      let url = `/api/audit-log?page=${currentPage}&size=20`;
      if (tableFilter) {
        url += `&bangTacDong=${tableFilter}`;
      }
      
      const res = await fetch(url, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const data: ApiResponse<PageData> = await res.json();
      
      if (data.success && data.data) {
        setLogs(data.data.content);
        setTotalPages(data.data.totalPages);
        setPage(data.data.number);
      }
    } catch (error) {
      console.error("Lỗi khi tải audit log:", error);
      toast.error("Không thể tải nhật ký hệ thống");
    } finally {
      setIsLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) fetchLogs(0, bangTacDong);
  }, [accessToken, bangTacDong, fetchLogs]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchLogs(0, searchTerm);
    setBangTacDong(searchTerm);
  };

  const handlePrevPage = () => {
    if (page > 0) {
      fetchLogs(page - 1, bangTacDong);
    }
  };

  const handleNextPage = () => {
    if (page < totalPages - 1) {
      fetchLogs(page + 1, bangTacDong);
    }
  };

  const viewDetails = (log: AuditLog) => {
    setSelectedLog(log);
    setIsDetailOpen(true);
  };

  const formatJson = (jsonString?: string) => {
    if (!jsonString) return "Không có dữ liệu";
    try {
      const obj = JSON.parse(jsonString);
      return JSON.stringify(obj, null, 2);
    } catch {
      return jsonString;
    }
  };

  return (
    <div className="space-y-4">
      <DashboardHero
        icon={ActivitySquare}
        title="Nhật ký hệ thống"
        description="Theo dõi các thay đổi và thao tác trong hệ thống."
      />

      <DashboardCard className="p-4 md:p-6 mb-4">
        <div className="flex flex-col sm:flex-row items-center gap-3">
          <form onSubmit={handleSearch} className="flex w-full max-w-sm items-center space-x-2">
            <Input 
              type="text" 
              placeholder="Lọc theo bảng tác động (VD: hop_dong, hoa_don)" 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
            <Button type="submit" size="icon">
              <Search className="h-4 w-4" />
            </Button>
          </form>
          {bangTacDong && (
            <Button variant="ghost" onClick={() => { setSearchTerm(""); setBangTacDong(""); }}>
              Xóa lọc
            </Button>
          )}
        </div>
      </DashboardCard>

      <DashboardCard className="overflow-hidden border-0 shadow-sm ring-1 ring-[#E5E0D8] overflow-x-auto">
        <Table>
          <TableHeader className="bg-[#F8F3EC]">
            <TableRow>
              <TableHead className="font-semibold text-[#243B5A]">Thời gian</TableHead>
              <TableHead className="font-semibold text-[#243B5A]">Người dùng</TableHead>
              <TableHead className="font-semibold text-[#243B5A]">Hành động</TableHead>
              <TableHead className="font-semibold text-[#243B5A]">Bảng</TableHead>
              <TableHead className="font-semibold text-[#243B5A]">IP Address</TableHead>
              <TableHead className="text-right font-semibold text-[#243B5A]">Chi tiết</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-gray-500">Đang tải dữ liệu...</TableCell>
              </TableRow>
            ) : logs.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center h-24 text-gray-500">Không tìm thấy bản ghi nào</TableCell>
              </TableRow>
            ) : (
              logs.map((log) => (
                <TableRow key={log.id || log._id} className="hover:bg-[#F8F3EC]/50 transition-colors">
                  <TableCell className="whitespace-nowrap">
                    <div className="flex items-center gap-2">
                      <History className="h-4 w-4 text-gray-400" />
                      {log.taoLuc ? format(new Date(log.taoLuc), "dd/MM/yyyy HH:mm:ss") : "-"}
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="flex flex-col">
                      <span className="font-medium text-sm flex items-center gap-1">
                        <User className="h-3 w-3" /> {log.nguoiDungHoTen || "Hệ thống"}
                      </span>
                      <span className="text-xs text-gray-500">{log.nguoiDungEmail || "System"}</span>
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline" className={
                      log.hanhDong === 'CREATE' ? 'bg-green-50 text-green-700' :
                      log.hanhDong === 'UPDATE' ? 'bg-[#4FA7A0]/10 text-[#243B5A]' :
                      log.hanhDong === 'DELETE' ? 'bg-red-50 text-red-700' : 'bg-gray-50'
                    }>
                      {log.hanhDong}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-1 text-sm">
                      <FileText className="h-4 w-4 text-gray-400" />
                      {log.bangTacDong || "-"}
                    </div>
                  </TableCell>
                  <TableCell className="text-sm text-gray-500">
                    {log.ipAddress || "-"}
                  </TableCell>
                  <TableCell className="text-right">
                    <Button variant="ghost" size="icon" onClick={() => viewDetails(log)}>
                      <Eye className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </DashboardCard>

      {!isLoading && totalPages > 1 && (
        <div className="flex items-center justify-between">
          <div className="text-sm text-gray-500">
            Trang {page + 1} / {totalPages}
          </div>
          <div className="flex items-center space-x-2">
            <Button variant="outline" size="sm" onClick={handlePrevPage} disabled={page === 0}>
              <ChevronLeft className="h-4 w-4" />
            </Button>
            <Button variant="outline" size="sm" onClick={handleNextPage} disabled={page >= totalPages - 1}>
              <ChevronRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      )}

      <Dialog open={isDetailOpen} onOpenChange={setIsDetailOpen}>
        <DialogContent className="max-w-3xl max-h-[80vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Chi tiết nhật ký</DialogTitle>
            <DialogDescription>
              Thông tin chi tiết về thay đổi dữ liệu
            </DialogDescription>
          </DialogHeader>
          
          {selectedLog && (
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4 text-sm bg-gray-50 p-4 rounded-md">
                <div>
                  <span className="font-semibold">Hành động:</span> {selectedLog.hanhDong}
                </div>
                <div>
                  <span className="font-semibold">Bảng:</span> {selectedLog.bangTacDong}
                </div>
                <div>
                  <span className="font-semibold">Người thực hiện:</span> {selectedLog.nguoiDungHoTen || "Hệ thống"}
                </div>
                <div>
                  <span className="font-semibold">Thời gian:</span> {selectedLog.taoLuc ? format(new Date(selectedLog.taoLuc), "dd/MM/yyyy HH:mm:ss") : "-"}
                </div>
                <div>
                  <span className="font-semibold">ID Bản ghi:</span> {selectedLog.banGhiId || "-"}
                </div>
                <div>
                  <span className="font-semibold">IP:</span> {selectedLog.ipAddress || "-"}
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <h4 className="font-semibold text-sm">Dữ liệu cũ</h4>
                  <pre className="bg-[#172A42] text-[#FFFDF8] p-4 rounded-md text-xs overflow-auto max-h-[300px]">
                    {formatJson(selectedLog.duLieuCu)}
                  </pre>
                </div>
                <div className="space-y-2">
                  <h4 className="font-semibold text-sm">Dữ liệu mới</h4>
                  <pre className="bg-[#172A42] text-[#FFFDF8] p-4 rounded-md text-xs overflow-auto max-h-[300px]">
                    {formatJson(selectedLog.duLieuMoi)}
                  </pre>
                </div>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
