# 测试用例归档

## 用例表

| 测试功能                  | 预置条件                                            | 输入 | 预期输出                   | 是否自动 | 测试结果 |
|-----------------------|-------------------------------------------------| ---- | -------------------------- | -------- | -------- |
| 拉起应用                  | 设备正常运行                                          |      | 成功拉起应用，主页元素齐备 | 是       | Pass     |
| 获取公共目录路径  | 使用PC/2in1设备                                        |      | getUserDirExample SUCCESS                   | 是       | Pass     |
| 访问 Download 目录下的文件      | 使用PC/2in1设备且成功获取READ_WRITE_DOWNLOAD_DIRECTORY权限 |      | readUserDownloadDirExample SUCCESS                  | 是       | pass     |
| 保存文件到 Download 目录 | PC/2in1设备且成功获取READ_WRITE_DOWNLOAD_DIRECTORY权限      |      | writeUserDownloadDirExample SUCCESS                   | 是       | pass     |