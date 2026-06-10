"use client";

import { useEffect, useState, Suspense } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { Card, CardContent, CardHeader, CardTitle, CardDescription, CardFooter } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { CheckCircle, XCircle } from "lucide-react";
import Link from "next/link";

function VNPayReturnContent() {
  const searchParams = useSearchParams();
  const router = useRouter();
  
  const [status, setStatus] = useState<"success" | "error" | "loading">("loading");
  const [message, setMessage] = useState("");
  const [amount, setAmount] = useState(0);

  useEffect(() => {
    const vnp_ResponseCode = searchParams.get("vnp_ResponseCode");
    const vnp_Amount = searchParams.get("vnp_Amount");
    
    if (vnp_Amount) {
      setAmount(parseInt(vnp_Amount) / 100);
    }

    if (vnp_ResponseCode === "00") {
      setStatus("success");
      setMessage("Giao dịch thanh toán thành công.");
    } else {
      setStatus("error");
      if (vnp_ResponseCode === "24") {
        setMessage("Giao dịch bị hủy bỏ bởi khách hàng.");
      } else {
        setMessage("Giao dịch thất bại hoặc có lỗi xảy ra (Mã lỗi: " + vnp_ResponseCode + ").");
      }
    }
  }, [searchParams]);

  return (
    <Card className="w-full max-w-md mx-auto mt-12 shadow-lg border-t-4 border-t-primary">
      <CardHeader className="text-center">
        <div className="mx-auto mb-4">
          {status === "loading" && <div className="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto" />}
          {status === "success" && <CheckCircle className="w-16 h-16 text-green-500 mx-auto" />}
          {status === "error" && <XCircle className="w-16 h-16 text-red-500 mx-auto" />}
        </div>
        <CardTitle className="text-2xl font-bold">
          {status === "loading" ? "Đang xử lý..." : status === "success" ? "Thanh toán thành công" : "Thanh toán thất bại"}
        </CardTitle>
        <CardDescription>Kết quả giao dịch qua cổng VNPay</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="bg-slate-50 p-4 rounded-lg border">
          <p className="text-center text-slate-700">{message}</p>
          {amount > 0 && status === "success" && (
            <p className="text-center font-bold text-lg mt-2 text-primary">
              {new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(amount)}
            </p>
          )}
        </div>
      </CardContent>
      <CardFooter className="flex flex-col gap-3">
        <Button asChild className="w-full">
          <Link href="/khach-thue/dashboard/hoa-don">Xem hóa đơn của tôi</Link>
        </Button>
        <Button variant="outline" asChild className="w-full">
          <Link href="/">Về trang chủ</Link>
        </Button>
      </CardFooter>
    </Card>
  );
}

export default function VNPayReturnPage() {
  return (
    <div className="min-h-screen bg-slate-50 p-4 flex items-center justify-center">
      <Suspense fallback={<div className="text-center p-8">Đang tải...</div>}>
        <VNPayReturnContent />
      </Suspense>
    </div>
  );
}
