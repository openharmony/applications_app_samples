# 测试用例归档

## 用例表

| 测试功能                  | 预置条件                                       | 输入 | 预期输出                   | 是否自动 | 测试结果 |
|-----------------------|--------------------------------------------| ---- | -------------------------- | -------- | -------- |
| 拉起应用                  | 设备正常运行                                     |      | 成功拉起应用，主页元素齐备 | 是       | Pass     |
| 获取用户 Download 目录沙箱路径  | 使用PC/2in1设备                                     |      | GetUserDownloadDirExample SUCCESS                   | 是       | Pass     |
| 查看Download目录下的文件      | 使用PC/2in1设备且成功获取READ_WRITE_DOWNLOAD_DIRECTORY权限 |      | ScanUserDownloadDirPathExample SUCCESS                  | 是       | pass     |
| 保存 temp.txt 到 Download 目录 | 使用PC/2in1设备且成功获取READ_WRITE_DOWNLOAD_DIRECTORY权限 |      | WriteUserDownloadDirPathExample SUCCESS                   | 是       | pass     |
| 获取用户Download目录沙箱路径    | 使用PC/2in1设备                                   |      | GetUserDownloadDirPathExample SUCCESS                  | 是       | pass     |
| 获取用户Desktop目录沙箱路径     | 使用PC/2in1设备                                     |      | GetUserDesktopDirPathExample SUCCESS                   | 是       | pass     |
| 获取用户Document目录沙箱路径    | 使用PC/2in1设备                                     |      | GetUserDocumentDirPathExample SUCCESS                    | 是       | pass     |

