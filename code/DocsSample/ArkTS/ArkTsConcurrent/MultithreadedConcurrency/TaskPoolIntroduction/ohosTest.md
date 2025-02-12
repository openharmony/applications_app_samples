# TaskPoolIntroduction 测试用例归档

## 用例表

| 测试功能                     | 预置条件                      | 输入            | 预期输出               | 是否自动 | 测试结果 |
| ---------------------------- | ----------------------------- | --------------- | ---------------------- | -------- | -------- |
| 拉起应用                     | 设备正常运行                  |                 | 成功拉起应用           | 是       | Pass     |
| 并发函数一般使用             | 位于generaluse.ets            | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 并发函数返回Promise          | 位于returnpromise.ets         | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 并发函数中使用自定义类或函数 | 位于customclasses.ets         | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |
| 并发异步函数中使用Promise    | 位于asynchronousfunctions.ets | 点击Hello World | 1秒后页面显示“success” | 是       | Pass     |