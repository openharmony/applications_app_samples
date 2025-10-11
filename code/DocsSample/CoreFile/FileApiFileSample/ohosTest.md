# 测试用例归档

## 用例表

| 测试功能                  | 预置条件     | 输入   | 预期输出                    | 是否自动 | 测试结果 |
| --------------------- | ------------ | ------ | --------------------------- | -- | ---- |
| 新建并读写一个文件             | 设备正常运行 |        | 日志中输出createFile SUCCESS | 是 | pass |
| 读取文件内容并写入到另一个文件       | 设备正常运行 |        | 日志中输出readWriteFile SUCCESS | 是 | pass |
| 以流的形式读写文件             | 设备正常运行 | 文件名 | 日志中输出readWriteFileWithStream SUCCESS | 是 | pass |
| 查看文件列表                | 设备正常运行 |        | 日志中输出getListFileSUCCESS | 是 | pass |
| 使用文件流暂停模式拷贝文件         | 设备正常运行 |        | 日志中输出copyFileWithReadable SUCCESS | 是 | pass |
| 使用文件流流动模式拷贝文件         | 设备正常运行 |        | 日志中输出copyFileWithData SUCCESS | 是 | pass |
| 使用文件哈希流               | 设备正常运行 |        | 日志中输出hashFileWithStream SUCCESS| 是 | pass |
| 设置分布式文件数据等级           | 设备正常运行 |        | 日志中输出setSecurityLabel SUCCESS | 是 | pass |