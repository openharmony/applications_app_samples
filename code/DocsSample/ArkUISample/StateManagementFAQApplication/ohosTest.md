# 应用内状态管理常见问题测试用例归档

## 用例表

根据提供的测试用例，以下是整理出的测试用例表格：

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---------|---------|------|---------|:-------:|:-------:|
| 并发线程中未调用包含装饰器的文件导致appfreeze | 设备正常运行 | 点击“new worker”创建并发线程 | 出现`ReferenceError: Observed is not defined` | 是 | Pass |
| 懒加载包含装饰器的文件 | 设备正常运行 | 点击“new worker”创建并发线程 | 不会出现appfreeze，日志正常打印 | 是 | Pass |
| 并发线程中调用了包含装饰器的文件导致appfreeze | 设备正常运行 | 点击“new worker”创建并发线程 | 出现`ReferenceError: Observed is not defined` | 是 | Pass |
| 状态变量装饰器使用隔离 | 设备正常运行 | 点击“new worker”创建并发线程 | 不会出现appfreeze，日志正常打印 | 是 | Pass |