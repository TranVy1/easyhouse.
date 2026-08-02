"use client"

import * as React from "react"
import {
  closestCenter,
  DndContext,
  KeyboardSensor,
  MouseSensor,
  TouchSensor,
  useSensor,
  useSensors,
  type DragEndEvent,
  type UniqueIdentifier,
} from "@dnd-kit/core"
import { restrictToVerticalAxis } from "@dnd-kit/modifiers"
import {
  arrayMove,
  SortableContext,
  useSortable,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable"
import { CSS } from "@dnd-kit/utilities"
import {
  Edit,
  Trash2,
  Eye,
  MapPin,
  Building2,
  GripVertical,
  MoreVertical,
  Columns,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  ChevronsLeft,
  ChevronsRight,

  Search,
} from "lucide-react"
import {
  ColumnDef,
  ColumnFiltersState,
  flexRender,
  getCoreRowModel,
  getFacetedRowModel,
  getFacetedUniqueValues,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  Row,
  SortingState,
  useReactTable,
  VisibilityState,
} from "@tanstack/react-table"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Checkbox } from "@/components/ui/checkbox"
import { cn } from "@/lib/utils"
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import type { ToaNha } from '@/types'

// Helper functions
const formatAddress = (diaChi: ToaNha['diaChi']) => {
  return `${diaChi.soNha} ${diaChi.duong}, ${diaChi.phuong}, ${diaChi.quan}, ${diaChi.thanhPho}`
}

// Create a separate component for the drag handle
function DragHandle({ id }: { id: string }) {
  const { attributes, listeners } = useSortable({
    id,
  })

  return (
    <Button
      {...attributes}
      {...listeners}
      variant="ghost"
      size="icon"
      className="text-muted-foreground size-7 hover:bg-transparent"
    >
      <GripVertical className="text-muted-foreground size-3" />
      <span className="sr-only">Kéo để sắp xếp</span>
    </Button>
  )
}

type ToaNhaTableProps = {
  onView?: (toaNha: ToaNha) => void
  onEdit: (toaNha: ToaNha) => void
  onDelete: (id: string) => void
}

const createColumns = (props: ToaNhaTableProps): ColumnDef<ToaNha>[] => [
  {
    id: "select",
    header: ({ table }) => (
      <div className="flex items-center justify-center p-2">
        <Checkbox
          checked={
            table.getIsAllPageRowsSelected() ||
            (table.getIsSomePageRowsSelected() && "indeterminate")
          }
          onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
          aria-label="Chọn tất cả"
        />
      </div>
    ),
    cell: ({ row }) => (
      <div className="flex items-center justify-center p-2">
        <Checkbox
          checked={row.getIsSelected()}
          onCheckedChange={(value) => row.toggleSelected(!!value)}
          aria-label="Chọn hàng"
        />
      </div>
    ),
    enableSorting: false,
    enableHiding: false,
  },
  {
    id: "ma",
    header: () => <div className="font-semibold text-gray-700 text-sm">Mã</div>,
    cell: ({ row }) => {
      const id = String(row.original.id || row.original._id || "");
      const ma = id ? "CH" + id.substring(0, 6).toUpperCase() : "CH007588";
      return (
        <span className="font-medium text-emerald-600">
          {ma}
        </span>
      );
    },
    enableSorting: false,
    enableHiding: false,
  },
  {
    id: "actions",
    header: () => <div className="font-semibold text-gray-700 text-sm">Thao tác</div>,
    cell: ({ row }) => (
      <div className="flex gap-2">
        <Button
          variant="outline"
          size="icon"
          className="h-7 w-7 bg-gray-100 hover:bg-gray-200 border-0"
          onClick={(e) => { e.stopPropagation(); props.onEdit(row.original); }}
        >
          <Edit className="h-3.5 w-3.5 text-gray-600" />
        </Button>
        <Button
          variant="outline"
          size="icon"
          className="h-7 w-7 bg-red-600 hover:bg-red-700 text-white border-0"
          onClick={(e) => { e.stopPropagation(); props.onDelete(row.original._id!); }}
        >
          <Trash2 className="h-3.5 w-3.5" />
        </Button>
      </div>
    ),
    enableHiding: false,
  },
  {
    accessorKey: "tenToaNha",
    header: () => <div className="font-semibold text-gray-700 text-sm">Tên tòa nhà</div>,
    cell: ({ row }) => (
      <span className="font-medium">{row.original.tenToaNha}</span>
    ),
    enableHiding: false,
  },
  {
    accessorKey: "diaChi",
    header: () => <div className="font-semibold text-gray-700 text-sm">Địa chỉ</div>,
    cell: ({ row }) => (
      <span className="text-sm">{formatAddress(row.original.diaChi)}</span>
    ),
  },
  {
    accessorKey: "tongSoPhong",
    header: () => <div className="font-semibold text-gray-700 text-sm">Số căn hộ</div>,
    cell: ({ row }) => (
      <div className="text-sm">
        {row.original.tongSoPhong} căn hộ{" "}
        {props.onView && (
          <span 
            className="text-emerald-600 cursor-pointer hover:underline ml-1 font-medium" 
            onClick={(e) => { e.stopPropagation(); props.onView!(row.original); }}
          >
            (Xem)
          </span>
        )}
      </div>
    ),
  },
  {
    id: "ngayTT",
    header: () => <div className="font-semibold text-gray-700 text-sm">Ngày TT</div>,
    cell: ({ row }) => (
      <span className="text-sm">Ngày 0</span>
    ),
  },
  {
    id: "hoatDong",
    header: () => <div className="font-semibold text-gray-700 text-sm whitespace-nowrap">Hoạt động</div>,
    cell: ({ row }) => (
      <div className="flex items-center" onClick={(e) => e.stopPropagation()}>
        <div className="relative inline-flex h-5 w-9 cursor-pointer items-center rounded-full bg-emerald-500">
          <span className="inline-block h-4 w-4 transform rounded-full bg-white transition translate-x-4 shadow-sm" />
        </div>
      </div>
    ),
  },
]

function DraggableRow({ row, onDoubleClick }: { row: Row<ToaNha>, onDoubleClick?: () => void }) {
  const { transform, transition, setNodeRef, isDragging } = useSortable({
    id: row.original._id!,
  })

  return (
    <TableRow
      data-state={row.getIsSelected() && "selected"}
      data-dragging={isDragging}
      ref={setNodeRef}
      onDoubleClick={onDoubleClick}
      className="relative z-0 data-[dragging=true]:z-10 data-[dragging=true]:opacity-80 cursor-pointer hover:bg-[#F8F3EC]/50 transition-colors py-1"
      style={{
        transform: CSS.Transform.toString(transform),
        transition: transition,
      }}
    >
      {row.getVisibleCells().map((cell) => (
        <TableCell key={cell.id}>
          {flexRender(cell.column.columnDef.cell, cell.getContext())}
        </TableCell>
      ))}
    </TableRow>
  )
}

type ToaNhaDataTableProps = ToaNhaTableProps & {
  data: ToaNha[]
  searchTerm?: string
  onSearchChange?: (value: string) => void
  pageCount?: number
  totalElements?: number
  pagination?: { pageIndex: number; pageSize: number }
  onPaginationChange?: (pagination: { pageIndex: number; pageSize: number }) => void
}

export function ToaNhaDataTable(props: ToaNhaDataTableProps) {
  const { data: initialData, searchTerm, onSearchChange, pageCount, totalElements, pagination: externalPagination, onPaginationChange, ...tableProps } = props
  const [data, setData] = React.useState(() => initialData)
  const [rowSelection, setRowSelection] = React.useState({})
  const [columnVisibility, setColumnVisibility] =
    React.useState<VisibilityState>({})
  const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>(
    []
  )
  const [sorting, setSorting] = React.useState<SortingState>([])
  const [internalPagination, setInternalPagination] = React.useState({
    pageIndex: 0,
    pageSize: 10,
  })
  
  const pagination = externalPagination || internalPagination
  
  const handlePaginationChange = React.useCallback(
    (updater: import("@tanstack/react-table").PaginationState | ((old: import("@tanstack/react-table").PaginationState) => import("@tanstack/react-table").PaginationState)) => {
      const newPagination = typeof updater === 'function' ? updater(pagination) : updater
      if (onPaginationChange) {
        onPaginationChange(newPagination)
      } else {
        setInternalPagination(newPagination)
      }
    },
    [pagination, onPaginationChange]
  )
  
  // Sync data when prop changes
  React.useEffect(() => {
    setData(initialData)
  }, [initialData])
  
  const columns = React.useMemo(() => createColumns(tableProps), [tableProps])
  
  const sortableId = React.useId()
  const sensors = useSensors(
    useSensor(MouseSensor, {}),
    useSensor(TouchSensor, {}),
    useSensor(KeyboardSensor, {})
  )

  const dataIds = React.useMemo<UniqueIdentifier[]>(
    () => data?.map(({ _id }) => _id!) || [],
    [data]
  )

  const table = useReactTable({
    data,
    columns,
    state: {
      sorting,
      columnVisibility,
      rowSelection,
      columnFilters,
      pagination,
    },
    getRowId: (row) => row._id!,
    enableRowSelection: true,
    manualPagination: pageCount !== undefined,
    pageCount: pageCount,
    onRowSelectionChange: setRowSelection,
    onSortingChange: setSorting,
    onColumnFiltersChange: setColumnFilters,
    onColumnVisibilityChange: setColumnVisibility,
    onPaginationChange: handlePaginationChange,
    getCoreRowModel: getCoreRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFacetedRowModel: getFacetedRowModel(),
    getFacetedUniqueValues: getFacetedUniqueValues(),
  })

  function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event
    if (active && over && active.id !== over.id) {
      setData((data) => {
        const oldIndex = dataIds.indexOf(active.id)
        const newIndex = dataIds.indexOf(over.id)
        return arrayMove(data, oldIndex, newIndex)
      })
    }
  }

  const selectedCount = table.getFilteredSelectedRowModel().rows.length

  return (
    <div className="w-full space-y-4">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        {/* Tìm kiếm bên trái */}
        <div className="flex-1 w-full sm:max-w-sm">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Tìm theo tên tòa nhà, địa chỉ..."
              value={searchTerm || ''}
              onChange={(e) => onSearchChange?.(e.target.value)}
              className="pl-10"
            />
          </div>
        </div>
        
        {/* Tùy chỉnh cột bên phải */}
        <div className="flex items-center gap-2">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="outline" size="sm">
                <Columns className="mr-2 h-4 w-4" />
                <span className="hidden lg:inline">Tùy chỉnh cột</span>
                <span className="lg:hidden">Cột</span>
                <ChevronDown className="ml-2 h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-56">
              {table
                .getAllColumns()
                .filter(
                  (column) =>
                    typeof column.accessorFn !== "undefined" &&
                    column.getCanHide()
                )
                .map((column) => {
                  return (
                    <DropdownMenuCheckboxItem
                      key={column.id}
                      className="capitalize"
                      checked={column.getIsVisible()}
                      onCheckedChange={(value) =>
                        column.toggleVisibility(!!value)
                      }
                    >
                      {column.id}
                    </DropdownMenuCheckboxItem>
                  )
                })}
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
      
      <div className="overflow-hidden rounded-lg border">
        <DndContext
          collisionDetection={closestCenter}
          modifiers={[restrictToVerticalAxis]}
          onDragEnd={handleDragEnd}
          sensors={sensors}
          id={sortableId}
        >
          <Table>
            <TableHeader className="bg-[#F8F3EC] sticky top-0 z-10 shadow-sm">
              {table.getHeaderGroups().map((headerGroup) => (
                <TableRow key={headerGroup.id} className="border-b-border/50 hover:bg-[#F8F3EC]">
                  {headerGroup.headers.map((header) => {
                    return (
                      <TableHead key={header.id} colSpan={header.colSpan}>
                        {header.isPlaceholder
                          ? null
                          : flexRender(
                              header.column.columnDef.header,
                              header.getContext()
                            )}
                      </TableHead>
                    )
                  })}
                </TableRow>
              ))}
            </TableHeader>
            <TableBody className="**:data-[slot=table-cell]:first:w-8">
              {table.getRowModel().rows?.length ? (
                <SortableContext
                  items={dataIds}
                  strategy={verticalListSortingStrategy}
                >
                  {table.getRowModel().rows.map((row) => (
                    <DraggableRow 
                      key={row.id} 
                      row={row} 
                      onDoubleClick={() => props.onView?.(row.original)} 
                    />
                  ))}
                </SortableContext>
              ) : (
                <TableRow>
                  <TableCell
                    colSpan={columns.length}
                    className="h-24 text-center"
                  >
                    Không có dữ liệu
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </DndContext>
      </div>
      
      <div className="flex items-center justify-between px-4">
        <div className="text-muted-foreground hidden flex-1 text-sm lg:flex">
          {selectedCount > 0 ? (
            <>Đã chọn {selectedCount} trong {totalElements !== undefined ? totalElements : table.getFilteredRowModel().rows.length} hàng</>
          ) : (
            <>Hiển thị {totalElements !== undefined ? totalElements : table.getFilteredRowModel().rows.length} hàng</>
          )}
        </div>
        <div className="flex w-full items-center gap-8 lg:w-fit">
          <div className="hidden items-center gap-2 lg:flex">
            <Label htmlFor="rows-per-page" className="text-sm font-medium">
              Số hàng mỗi trang
            </Label>
            <Select
              value={`${table.getState().pagination.pageSize}`}
              onValueChange={(value) => {
                table.setPageSize(Number(value))
              }}
            >
              <SelectTrigger size="sm" className="w-20" id="rows-per-page">
                <SelectValue
                  placeholder={table.getState().pagination.pageSize}
                />
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
            Trang {table.getState().pagination.pageIndex + 1} /{" "}
            {table.getPageCount()}
          </div>
          <div className="ml-auto flex items-center gap-2 lg:ml-0">
            <Button
              variant="outline"
              className="hidden h-8 w-8 p-0 lg:flex"
              onClick={() => table.setPageIndex(0)}
              disabled={!table.getCanPreviousPage()}
            >
              <span className="sr-only">Trang đầu</span>
              <ChevronsLeft className="h-4 w-4" />
            </Button>
            <Button
              variant="outline"
              className="size-8"
              size="icon"
              onClick={() => table.previousPage()}
              disabled={!table.getCanPreviousPage()}
            >
              <span className="sr-only">Trang trước</span>
              <ChevronLeft className="h-4 w-4" />
            </Button>
            <Button
              variant="outline"
              className="size-8"
              size="icon"
              onClick={() => table.nextPage()}
              disabled={!table.getCanNextPage()}
            >
              <span className="sr-only">Trang sau</span>
              <ChevronRight className="h-4 w-4" />
            </Button>
            <Button
              variant="outline"
              className="hidden size-8 lg:flex"
              size="icon"
              onClick={() => table.setPageIndex(table.getPageCount() - 1)}
              disabled={!table.getCanNextPage()}
            >
              <span className="sr-only">Trang cuối</span>
              <ChevronsRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}

