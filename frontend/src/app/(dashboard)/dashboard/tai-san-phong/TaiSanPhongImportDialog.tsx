"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { AlertCircle, CheckCircle2, FileUp, Loader2 } from "lucide-react"
import { toast } from "sonner"
import * as XLSX from "xlsx"

interface ImportRow {
  phongId: string
  tenPhong: string
  tenTaiSan: string
  soLuong: number
  giaTri: number
  tinhTrang: string
  ghiChu?: string
  anhTaiSan?: string
  valid: boolean
  errorReason?: string
}

interface TaiSanPhongImportDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSuccess: () => void
  accessToken: string
}

export function TaiSanPhongImportDialog({ open, onOpenChange, onSuccess, accessToken }: TaiSanPhongImportDialogProps) {
  const [file, setFile] = useState<File | null>(null)
  const [previewData, setPreviewData] = useState<{
    rows: ImportRow[]
    totalRows: number
    validRows: number
    errorRows: number
  } | null>(null)
  const [loading, setLoading] = useState(false)
  const [committing, setCommitting] = useState(false)

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      setFile(e.target.files[0])
      setPreviewData(null)
    }
  }

  const handlePreview = async () => {
    if (!file) {
      toast.error("Vui lòng chọn file CSV")
      return
    }

    setLoading(true)
    const formData = new FormData()
    let uploadFile = file
    if (/\.(xlsx|xls)$/i.test(file.name)) {
      const workbook = XLSX.read(await file.arrayBuffer(), { type: "array" })
      const sheet = workbook.Sheets[workbook.SheetNames[0]]
      const csv = XLSX.utils.sheet_to_csv(sheet)
      uploadFile = new File([csv], file.name.replace(/\.(xlsx|xls)$/i, ".csv"), { type: "text/csv" })
    }
    formData.append("file", uploadFile)

    try {
      const res = await fetch("/api/tai-san-phong/import/preview", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`
        },
        body: formData
      })
      const json = await res.json()
      if (json.success) {
        setPreviewData(json.data)
      } else {
        toast.error(json.message || "Lỗi khi preview file")
      }
    } catch (e) {
      toast.error("Lỗi kết nối khi preview file")
    } finally {
      setLoading(false)
    }
  }

  const handleCommit = async () => {
    if (!previewData || previewData.validRows === 0) {
      toast.error("Không có dữ liệu hợp lệ để import")
      return
    }

    if (!window.confirm(`Bạn có chắc muốn import ${previewData.validRows} tài sản hợp lệ?`)) {
      return
    }

    setCommitting(true)
    try {
      const res = await fetch("/api/tai-san-phong/import/commit", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`
        },
        body: JSON.stringify({ rows: previewData.rows.filter(r => r.valid) })
      })
      const json = await res.json()
      if (json.success) {
        toast.success("Import thành công")
        onSuccess()
      } else {
        toast.error(json.message || "Lỗi khi import")
      }
    } catch (e) {
      toast.error("Lỗi kết nối khi import")
    } finally {
      setCommitting(false)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-hidden flex flex-col">
        <DialogHeader>
          <DialogTitle>Import Tài Sản Phòng (CSV)</DialogTitle>
          <DialogDescription>
            Tải lên file CSV chứa danh sách tài sản phòng. File cần đúng định dạng cột.
          </DialogDescription>
        </DialogHeader>

        <div className="flex-1 overflow-auto py-4">
          <div className="flex items-center gap-4 mb-6">
            <div className="grid w-full max-w-sm items-center gap-1.5">
              <Label htmlFor="csv_file">Chọn file CSV</Label>
              <Input id="csv_file" type="file" accept=".xlsx,.xls,.csv" onChange={handleFileChange} />
            </div>
            <Button onClick={handlePreview} disabled={!file || loading} className="mt-5">
              {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              {!loading && <FileUp className="mr-2 h-4 w-4" />}
              Xem trước
            </Button>
          </div>

          {previewData && (
            <div className="space-y-4">
              <div className="flex items-center gap-4 text-sm">
                <div className="font-semibold">Tổng: {previewData.totalRows}</div>
                <div className="text-green-600 font-semibold flex items-center">
                  <CheckCircle2 className="w-4 h-4 mr-1" /> Hợp lệ: {previewData.validRows}
                </div>
                <div className="text-red-600 font-semibold flex items-center">
                  <AlertCircle className="w-4 h-4 mr-1" /> Lỗi: {previewData.errorRows}
                </div>
              </div>

              <div className="border rounded-md">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Trạng thái</TableHead>
                      <TableHead>Mã phòng / Tên phòng</TableHead>
                      <TableHead>Tên tài sản</TableHead>
                      <TableHead>Số lượng</TableHead>
                      <TableHead>Giá trị</TableHead>
                      <TableHead>Tình trạng</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {previewData.rows.map((row, idx) => (
                      <TableRow key={idx} className={!row.valid ? "bg-red-50" : ""}>
                        <TableCell>
                          {row.valid ? (
                            <CheckCircle2 className="text-green-500 w-5 h-5" />
                          ) : (
                            <div className="flex flex-col">
                              <AlertCircle className="text-red-500 w-5 h-5 mb-1" />
                              <span className="text-xs text-red-600 font-medium line-clamp-2" title={row.errorReason}>
                                {row.errorReason}
                              </span>
                            </div>
                          )}
                        </TableCell>
                        <TableCell>
                          <div className="font-medium">{row.tenPhong || "-"}</div>
                          <div className="text-xs text-muted-foreground truncate w-[100px]" title={row.phongId}>{row.phongId}</div>
                        </TableCell>
                        <TableCell>{row.tenTaiSan}</TableCell>
                        <TableCell>{row.soLuong}</TableCell>
                        <TableCell>{row.giaTri?.toLocaleString()} đ</TableCell>
                        <TableCell>{row.tinhTrang}</TableCell>
                      </TableRow>
                    ))}
                    {previewData.rows.length === 0 && (
                      <TableRow>
                        <TableCell colSpan={6} className="text-center text-muted-foreground h-24">
                          Không có dữ liệu
                        </TableCell>
                      </TableRow>
                    )}
                  </TableBody>
                </Table>
              </div>
            </div>
          )}
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>Hủy</Button>
          <Button 
            onClick={handleCommit} 
            disabled={committing || !previewData || previewData.validRows === 0}
          >
            {committing && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            Xác nhận Import ({previewData?.validRows || 0})
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
