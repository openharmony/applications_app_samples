# 测试用例归档

## 用例表

| 测试功能                         | 预置条件     | 输入   | 预期输出                       | 是否自动 | 测试结果 |
| -------------------------------- | ------------ | ------ | ------------------------------ | -------- | -------- |
| 文件创建并写入                   | 设备正常运行 |        | test.txt文件内容               | 是       | pass     |
| 文件内容复制                     | 设备正常运行 |        |                                | 是       | pass     |
| 读取文件内容                     | 设备正常运行 | 文件名 | 对应文件的内容                 | 是       | pass     |
| 获取文件列表                     | 设备正常运行 |        | 文件列表                       | 是       | pass     |
| 获取文件系统数据分区剩余空间大小 | 设备正常运行 |        | 数字字符串，表示空间大小       | 是       | pass     |
| 获取当前应用的存储空间大小       | 设备正常运行 |        | 数字字符串，表示空间大小       | 是       | pass     |
| 文件哈希计算                     | 设备正常运行 |        | 日志中输出hashResult和fileHash | 是       | pass     |

