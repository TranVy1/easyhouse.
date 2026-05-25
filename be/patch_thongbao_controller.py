import os

controller_file = r'd:\DATN_TMDT\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\controller\ThongBaoController.java'
with open(controller_file, 'rb') as f:
    data = f.read()

append_code = """
    @GetMapping("/my")
    public ApiResponse<List<ThongBaoResponse>> getMyThongBao() {
        try { return ApiResponse.success(thongBaoService.getMyThongBao()); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }
}
"""
last_brace_idx = data.rfind(b'}')
if last_brace_idx != -1:
    new_data = data[:last_brace_idx] + append_code.encode('utf-8')
    with open(controller_file, 'wb') as f:
        f.write(new_data)
    print('Added getMyThongBao to ThongBaoController.java')
