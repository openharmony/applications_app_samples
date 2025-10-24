# 测试用例归档

## 用例表

| 测试功能        | 预置条件   | 输入 | 预期输出                                 | 是否自动 | 测试结果 |
|-------------|--------|----|--------------------------------------|------|------|
| 发布或修改指定配置项  | 设备正常运行 |    | 日志中输出publishSharedConfig SUCCESS     | 是    | pass |
| 删除指定配置项     | 设备正常运行 |    | 日志中输出deleteSharedConfig SUCCESS      | 是    | pass |
| 获取配置项信息     | 设备正常运行 |    | 日志中输出readWriteFileWithStream SUCCESS | 是    | pass |
| 监听/取消监听配置变化 | 设备正常运行 |    | 日志中输出watchConfigChanges SUCCESS      | 是    | pass |
