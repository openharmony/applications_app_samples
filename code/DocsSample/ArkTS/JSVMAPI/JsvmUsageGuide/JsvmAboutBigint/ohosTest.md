# JsvmAboutBigint 测试用例归档

## 用例表

| 测试功能                                                         | 预置条件     | 输入            | 预期输出               | 是否自动 | 测试结果 |
| ---------------------------------------------------------------- | ------------ | --------------- | ---------------------- | -------- | -------- |
| 拉起应用                                                         | 设备正常运行 |                 | 成功拉起应用           | 是       | Pass     |
| 将C int64_t类型的值转换为JavaScript BigInt类型                   | 位于首页     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 将C uint64_t类型的值转换为JavaScript BigInt类型                  | 位于首页     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 将一组无符号64位字转换为单个BigInt值                             | 位于首页     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 返回给定JavaScript BigInt的C int64_t基础类型等价值               | 位于首页     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 返回给定JavaScript BigInt的C uint64_t基础类型等价值              | 位于首页     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 将单个BigInt值转换为一个符号位、一个64位的小端数组和该数组的长度 | 位于首页     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
