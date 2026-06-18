const fs = require('fs');
const filePath = 'f:/qlyphongtro/frontend/src/app/(dashboard)/dashboard/toa-nha/[id]/page.tsx';
let content = fs.readFileSync(filePath, 'utf-8');

// 1. Add imports
if (!content.includes("import { PhongForm }")) {
    content = content.replace(
        "import { cn } from '@/lib/utils';",
        "import { cn } from '@/lib/utils';\nimport { PhongForm } from '@/components/ui/phong-form';\nimport { Plus } from 'lucide-react';"
    );
}

// 2. Add state
if (!content.includes("const [isAddRoomOpen")) {
    content = content.replace(
        "const [roomSearch, setRoomSearch] = useState('');",
        "const [roomSearch, setRoomSearch] = useState('');\n  const [isAddRoomOpen, setIsAddRoomOpen] = useState(false);"
    );
}

// 3. Add button
const oldButtons = `<Button variant="outline" onClick={fetchSoDo}>
          <RefreshCw className="mr-2 h-4 w-4" />
          Tải mới
        </Button>`;
const newButtons = `<div className="flex gap-2">
          <Button variant="outline" onClick={fetchSoDo}>
            <RefreshCw className="mr-2 h-4 w-4" />
            Tải mới
          </Button>
          <Button onClick={() => setIsAddRoomOpen(true)}>
            <Plus className="mr-2 h-4 w-4" />
            Thêm phòng
          </Button>
        </div>`;
content = content.replace(oldButtons, newButtons);

// 4. Add Dialog
const dialogCode = `
      <Dialog open={isAddRoomOpen} onOpenChange={setIsAddRoomOpen}>
        <DialogContent className="max-w-5xl max-h-[90vh] overflow-y-auto w-[95vw] md:w-full">
          <DialogHeader>
            <DialogTitle className="text-base md:text-lg">Thêm phòng mới</DialogTitle>
            <DialogDescription className="text-xs md:text-sm">
              Nhập thông tin phòng mới cho tòa nhà {data?.tenToaNha}
            </DialogDescription>
          </DialogHeader>
          {data && (
            <PhongForm
              phong={null}
              toaNhaList={[{ _id: params.id, tenToaNha: data.tenToaNha } as any]}
              onClose={() => setIsAddRoomOpen(false)}
              onSuccess={() => {
                setIsAddRoomOpen(false);
                fetchSoDo();
                toast.success('Thêm phòng thành công!');
              }}
            />
          )}
        </DialogContent>
      </Dialog>
`;

if (!content.includes("isAddRoomOpen} onOpenChange")) {
    content = content.replace(
        "      <div className=\"grid grid-cols-2 gap-3 lg:grid-cols-5\">",
        dialogCode + "\n      <div className=\"grid grid-cols-2 gap-3 lg:grid-cols-5\">"
    );
}

fs.writeFileSync(filePath, content, 'utf-8');
console.log('Updated toa-nha/[id]/page.tsx');
