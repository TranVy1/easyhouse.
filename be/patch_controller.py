import os

controller_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\controller\HopDongController.java'
with open(controller_file, 'rb') as f:
    data = f.read()

append_code = """
    @PutMapping("/{id}/ket-thuc")
    public ResponseEntity<com.example.quanlyphongtro.dto.ApiResponse<com.example.quanlyphongtro.dto.HopDongResponse>> terminateContract(
            @PathVariable java.util.UUID id,
            @RequestBody com.example.quanlyphongtro.dto.KetThucHopDongRequest req) {
        return ResponseEntity.ok(com.example.quanlyphongtro.dto.ApiResponse.success(hopDongService.terminateContract(id, req), "Ket thuc hop dong thanh cong"));
    }
}
"""
last_brace_idx = data.rfind(b'}')
if last_brace_idx != -1:
    new_data = data[:last_brace_idx] + append_code.encode('utf-8')
    with open(controller_file, 'wb') as f:
        f.write(new_data)
    print('Modified HopDongController.java')
