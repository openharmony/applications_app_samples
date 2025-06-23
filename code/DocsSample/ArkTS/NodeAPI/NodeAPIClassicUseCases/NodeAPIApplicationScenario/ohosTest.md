#  Node-API使用场景用例归档

## 用例表

| 测试功能                                                 | 预置条件     | 输入                                            | 预期输出                                      | 测试结果 |
| -------------------------------------------------------- | ------------ | ----------------------------------------------- | --------------------------------------------- | -------- |
| 拉起应用                                                 | 设备正常运行 |                                                 | 成功拉起应用                                  | Pass     |
| ArkTS端成功调用native侧接口createArkRuntime              | 位于主页     | 点击Call createArkRuntime的Button组件           | 成功调用函数输出日志，页面顶端文本变为success | Pass     |
| ArkTS端成功调用native侧接口   callThreadSafeWithPriority | 位于主页     | 点击Call CallThreadSafeWithPriority的Button组件 | 成功调用函数输出日志，页面顶端文本变为success | Pass     |
| ArkTS端成功调用native侧接口runEventLoop                  | 位于主页     | 点击按钮为调用runEventLoop的Button组件          | 成功调用函数输出日志，页面顶端文本变为success | Pass     |
| ArkTS端成功调用native侧接口startThread                   | 位于主页     | 点击按钮为调用startThread的Button组件           | 成功调用函数输出日志，页面顶端文本变为success | Pass     |