const fs = require('fs');
const filePath = 'f:/qlyphongtro/frontend/src/app/(dashboard)/dashboard/toa-nha/[id]/page.tsx';
let content = fs.readFileSync(filePath, 'utf-8');

// 1. Add Plus icon to lucide-react imports if missing
if (!content.includes('Plus,')) {
    content = content.replace('RefreshCw,', 'RefreshCw,\n  Plus,');
}

// 2. Add PhongForm import if missing
if (!content.includes('PhongForm')) {
    content = content.replace("import { cn } from '@/lib/utils';", "import { cn } from '@/lib/utils';\nimport { PhongForm } from '@/components/ui/phong-form';");
}

// 3. Add state
if (!content.includes('isAddRoomOpen')) {
    content = content.replace(
        "const [roomSearch, setRoomSearch] = useState('');",
        "const [roomSearch, setRoomSearch] = useState('');\n  const [isAddRoomOpen, setIsAddRoomOpen] = useState(false);"
    );
}

// 4. Replace Button group
const targetBtn = `        <Button variant="outline" onClick={fetchSoDo}>`;
if (content.includes(targetBtn) && !content.includes('Thêm phòng')) {
    // Find the exact Button block
    const buttonBlock = content.match(/<Button variant="outline" onClick=\{fetchSoDo\}>[\s\S]*?<\/Button>/)[0];
    const newButtonBlock = `        <div className="flex gap-2">
          ${buttonBlock}
          <Button onClick={() => setIsAddRoomOpen(true)}>
            <Plus className="mr-2 h-4 w-4" />
            Thêm phòng
          </Button>
        </div>`;
    content = content.replace(buttonBlock, newButtonBlock);
}

// 5. Add Dialog
const targetGrid = `      <div className="grid grid-cols-2 gap-3 lg:grid-cols-5">`;
if (content.includes(targetGrid) && !content.includes('<PhongForm')) {
    const dialogCode = `      <Dialog open={isAddRoomOpen} onOpenChange={setIsAddRoomOpen}>
        <DialogContent className="max-w-5xl max-h-[90vh] overflow-y-auto w-[95vw] md:w-full">
          <DialogHeader>
            <DialogTitle className="text-base md:text-lg">Thêm phòng mới</DialogTitle>
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
    content = content.replace(targetGrid, dialogCode + targetGrid);
}

fs.writeFileSync(filePath, content, 'utf-8');
console.log('Update successful');
