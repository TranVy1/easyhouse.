import sys

file_path = r"F:\qlyphongtro\be\src\main\java\com\example\quanlyphongtro\controller\HoaDonController.java"
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

target = """    @GetMapping("/latest-reading")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getLatestReading(
            @RequestParam String hopDong,
            @RequestParam int thang,
            @RequestParam int nam) {
        UUID hopDongId = UUID.fromString(hopDong);"""

replacement = """    @GetMapping("/latest-reading")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getLatestReading(
            @RequestParam(required = false) String hopDong,
            @RequestParam(required = false, name = "hopDongId") String hopDongIdParam,
            @RequestParam int thang,
            @RequestParam int nam) {
        String finalId = hopDong != null ? hopDong : hopDongIdParam;
        if (finalId == null) throw new IllegalArgumentException("Required request parameter 'hopDong' is not present");
        UUID hopDongId = UUID.fromString(finalId);"""

if target in content:
    content = content.replace(target, replacement)
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
    print("Success")
else:
    print("Target not found")
