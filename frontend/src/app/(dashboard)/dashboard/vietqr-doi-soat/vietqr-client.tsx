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

import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { toast } from "sonner";
import { BankTransaction, ApiResponse, HoaDon, PaginatedResponse } from "@/types";
import { unwrapPageData } from "@/lib/api-response";
import { useSession } from "next-auth/react";

interface PageData {
  content: BankTransaction[];
  pageable: unknown;
  totalPages: number;
  totalElements: number;
  last: boolean;
  size: number;
  number: number;
  sort: unknown;
  numberOfElements: number;
  first: boolean;
  empty: boolean;
}

export function VietQRClient() {
  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const [transactions, setTransactions] = useState<BankTransaction[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [daDoiSoatFilter, setDaDoiSoatFilter] = useState<boolean | null>(null);
  
  const [selectedTx, setSelectedTx] = useState<BankTransaction | null>(null);
  const [isMatchOpen, setIsMatchOpen] = useState(false);
  const [hoaDons, setHoaDons] = useState<HoaDon[]>([]);
  const [isHoaDonLoading, setIsHoaDonLoading] = useState(false);
  const [selectedHoaDonId, setSelectedHoaDonId] = useState<string>("");

  const fetchTransactions = useCallback(async (currentPage: number, filter: boolean | null = null) => {
    try {
      setIsLoading(true);
      let url = `/api/bank-transaction?page=${currentPage}&size=20`;
      if (filter !== null) {
        url += `&daDoiSoat=${filter}`;
      }
      
      const res = await fetch(url, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const data: ApiResponse<PageData> = await res.json();
      
      if (data.success && data.data) {
        setTransactions(data.data.content);
        setTotalPages(data.data.totalPages);
        setPage(data.data.number);
      }
    } catch (error) {
      console.error("Lỗi khi tải giao dịch:", error);
      toast.error("Không thể tải danh sách giao dịch");
    } finally {
      setIsLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) fetchTransactions(0, daDoiSoatFilter);
  }, [accessToken, daDoiSoatFilter, fetchTransactions]);

  const handlePrevPage = () => {
    if (page > 0) {
      fetchTransactions(page - 1, daDoiSoatFilter);
    }
  };

  const handleNextPage = () => {
    if (page < totalPages - 1) {
      fetchTransactions(page + 1, daDoiSoatFilter);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount);
  };

  const openMatchDialog = async (tx: BankTransaction) => {
    setSelectedTx(tx);
    setIsMatchOpen(true);
    setSelectedHoaDonId("");
    
    // Fetch unpaid bills (hoá đơn chưa thanh toán đủ)
    try {
      setIsHoaDonLoading(true);
      const res = await fetch('/api/hoa-don?page=1&limit=100', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const data: ApiResponse<PaginatedResponse<HoaDon>> = await res.json();
      if (data.success && data.data) {
        // Chỉ lấy những hóa đơn có tổng tiền > đã trả
        const unpaidBills = unwrapPageData(data.data).filter(h => (h.tongTien || 0) > (h.daTra || 0));
        setHoaDons(unpaidBills);
      }
    } catch (error) {
      console.error("Lỗi khi tải hóa đơn:", error);
      toast.error("Không thể tải danh sách hóa đơn nợ");
    } finally {
      setIsHoaDonLoading(false);
    }
  };

  const handleManualMatch = async () => {
    if (!selectedTx || !selectedHoaDonId) {
      toast.error("Vui lòng chọn hóa đơn để đối soát");
      return;
    }

    try {
      const payload = {
        transactionId: selectedTx.id || selectedTx._id,
        hoaDonId: selectedHoaDonId
      };

      const res = await fetch('/api/bank-transaction/manual-match', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(payload)
      });
      const data: ApiResponse<BankTransaction> = await res.json();
      
      if (data.success) {
        toast.success("Đối soát thành công!");
        setIsMatchOpen(false);
        fetchTransactions(page, daDoiSoatFilter);
      } else {
        toast.error(data.message || "Đối soát thất bại");
      }
    } catch (error) {
      console.error("Lỗi khi đối soát:", error);
      toast.error("Đã xảy ra lỗi");
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
        <div>
          <h1 className="text-xl md:text-2xl font-bold text-gray-900">Đối soát VietQR</h1>
          <p className="text-xs md:text-sm text-gray-600">Quản lý giao dịch chuyển khoản và đối soát hóa đơn.</p>
        </div>
      </div>

      <div className="flex gap-2">
        <Button 
          variant={daDoiSoatFilter === null ? "default" : "outline"} 
          onClick={() => setDaDoiSoatFilter(null)}
        >
          Tất cả
        </Button>
        <Button 
          variant={daDoiSoatFilter === false ? "default" : "outline"} 
          onClick={() => setDaDoiSoatFilter(false)}
        >
          Chưa đối soát
        </Button>
        <Button 
          variant={daDoiSoatFilter === true ? "default" : "outline"} 
          onClick={() => setDaDoiSoatFilter(true)}
        >
          Đã đối soát
        </Button>
      </div>

      <div className="border rounded-md bg-white overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Thời gian</TableHead>
              <TableHead>Mã GD</TableHead>
              <TableHead>Nội dung CK</TableHead>
              <TableHead>Số tiền</TableHead>
              <TableHead>Trạng thái</TableHead>
              <TableHead className="text-right">Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-gray-500">Đang tải dữ liệu...</TableCell>
              </TableRow>
            ) : transactions.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-10 text-gray-500">Không tìm thấy giao dịch nào</TableCell>
              </TableRow>
            ) : (
              transactions.map((tx) => (
                <TableRow key={tx.id || tx._id}>
                  <TableCell className="whitespace-nowrap">
                    {tx.thoiGianGiaoDich ? format(new Date(tx.thoiGianGiaoDich), "dd/MM/yyyy HH:mm") : "-"}
                  </TableCell>
                  <TableCell className="font-mono text-xs">
                    {tx.maGiaoDich || "-"}
                  </TableCell>
                  <TableCell className="max-w-xs truncate" title={tx.noiDungChuyenKhoan}>
                    {tx.noiDungChuyenKhoan || "-"}
                  </TableCell>
                  <TableCell className="font-medium text-green-600">
                    +{formatCurrency(tx.soTien)}
                  </TableCell>
                  <TableCell>
                    {tx.daDoiSoat ? (
                      <Badge className="bg-green-100 text-green-800 hover:bg-green-100">Đã đối soát</Badge>
                    ) : (
                      <Badge variant="outline" className="text-orange-600 border-orange-200 bg-orange-50">Chưa đối soát</Badge>
                    )}
                  </TableCell>
                  <TableCell className="text-right">
                    {!tx.daDoiSoat && (
                      <Button variant="outline" size="sm" onClick={() => openMatchDialog(tx)}>
                        Đối soát
                      </Button>
                    )}
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

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

      <Dialog open={isMatchOpen} onOpenChange={setIsMatchOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Đối soát thủ công</DialogTitle>
            <DialogDescription>
              Gán giao dịch này cho một hóa đơn đang nợ
            </DialogDescription>
          </DialogHeader>
          
          {selectedTx && (
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4 text-sm bg-gray-50 p-4 rounded-md">
                <div>
                  <span className="font-semibold text-gray-500">Số tiền:</span> <br />
                  <span className="text-lg font-bold text-green-600">{formatCurrency(selectedTx.soTien)}</span>
                </div>
                <div>
                  <span className="font-semibold text-gray-500">Nội dung CK:</span> <br />
                  <span className="font-medium">{selectedTx.noiDungChuyenKhoan}</span>
                </div>
              </div>

              <div>
                <h4 className="font-semibold mb-2">Chọn hóa đơn thanh toán:</h4>
                <div className="border rounded-md max-h-60 overflow-y-auto">
                  {isHoaDonLoading ? (
                    <div className="p-4 text-center text-sm text-gray-500">Đang tải hóa đơn...</div>
                  ) : hoaDons.length === 0 ? (
                    <div className="p-4 text-center text-sm text-gray-500">Không có hóa đơn nào đang nợ</div>
                  ) : (
                    <Table>
                      <TableBody>
                        {hoaDons.map(hd => {
                          const n = (hd.tongTien || 0) - (hd.daTra || 0);
                          return (
                            <TableRow 
                              key={hd._id || hd.id} 
                              className={`cursor-pointer ${selectedHoaDonId === (hd._id || hd.id) ? "bg-blue-50" : ""}`}
                              onClick={() => setSelectedHoaDonId((hd._id || hd.id) as string)}
                            >
                              <TableCell>
                                <div className="font-medium">HĐ Tháng {hd.thang}/{hd.nam}</div>
                                <div className="text-xs text-gray-500">{hd.ghiChu || "Hóa đơn tiền nhà"}</div>
                              </TableCell>
                              <TableCell className="text-right">
                                <div className="text-sm font-semibold text-red-600">Nợ: {formatCurrency(n)}</div>
                                <div className="text-xs text-gray-500">Tổng: {formatCurrency(hd.tongTien || 0)}</div>
                              </TableCell>
                            </TableRow>
                          );
                        })}
                      </TableBody>
                    </Table>
                  )}
                </div>
              </div>

              <div className="flex justify-end gap-2 pt-4">
                <Button variant="outline" onClick={() => setIsMatchOpen(false)}>Hủy</Button>
                <Button onClick={handleManualMatch} disabled={!selectedHoaDonId}>
                  Xác nhận đối soát
                </Button>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
