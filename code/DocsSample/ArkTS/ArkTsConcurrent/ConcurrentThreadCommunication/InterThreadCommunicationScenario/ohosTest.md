# InterThreadCommunicationScenario 测试用例归档

## 用例表

| 测试功能                       | 预置条件                                 | 输入            | 预期输出               | 是否自动 | 测试结果 |
| ------------------------------ | ---------------------------------------- | --------------- | ---------------------- | -------- | -------- |
| 拉起应用                       | 设备正常运行                             |                 | 成功拉起应用           | 是       | Pass     |
| 使用TaskPool执行独立的耗时任务 | 位于IndependentTimeConsumingTask.ets     | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 使用TaskPool执行多个耗时任务   | 位于MultiTimeConsumingTasks.ets          | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| TaskPool任务与宿主线程通信     | 位于TaskSendDataUsage.ets                | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| Worker同步调用宿主线程的接口   | 位于WorkerCallGlobalUsage.ets            | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| Worker和宿主线程的即时消息通信 | 位于WorkerCommunicatesWithMainthread.ets | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |