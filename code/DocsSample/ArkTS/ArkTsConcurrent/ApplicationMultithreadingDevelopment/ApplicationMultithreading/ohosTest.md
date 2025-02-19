# ApplicationMultithreading 测试用例归档

## 用例表

| 测试功能              | 预置条件                            | 输入                                      | 预期输出               | 是否自动 | 测试结果 |
| --------------------- | ----------------------------------- | ----------------------------------------- | ---------------------- | -------- | -------- |
| 拉起应用              | 设备正常运行                        |                                           | 成功拉起应用           | 是       | Pass     |
| CPU密集型任务开发指导 | 位于CpuIntensiveTaskDevelopment.ets | 点击Hello World                           | 1秒后页面显示“success” | 是       | Pass     |
| I/O密集型任务开发指导 | 位于IoIntensiveTaskDevelopment.ets  | 点击Hello World                           | 1秒后页面显示“success” | 是       | Pass     |
| 同步任务开发指导      | 位于SyncTaskDevelopment.ets         | 点击Hello World                           | 1秒后页面显示“success” | 是       | Pass     |
| 长时任务开发指导      | 位于LongTimeTaskGuide.ets           | 点击Add listener，然后点击Delete listener | 1秒后页面显示“success” | Pass     | Pass     |
| 常驻任务开发指导      | 位于ResidentTaskGuide.ets           | 点击Listener task                         | 1秒后页面显示“success” | Pass     | Pass     |