# SendableObjectRelated 测试用例归档

## 用例表

| 测试功能         | 预置条件                             | 输入                                                         | 预期输出               | 是否自动 | 测试结果 |
| ---------------- | ------------------------------------ | ------------------------------------------------------------ | ---------------------- | -------- | -------- |
| 拉起应用         | 设备正常运行                         |                                                              | 成功拉起应用           | 是       | Pass     |
| 异步锁           | 位于ArktsAsyncLockIntroduction.ets   | 点击Hello World                                              | 1秒后页面显示“success” | 是       | Pass     |
| ASON解析与生成   | 位于AsonParsingGeneration.ets        | 点击Hello World                                              | 1秒后页面显示“success” | 是       | Pass     |
| 共享容器         | 位于ArktsCollectionsIntroduction.ets | 点击Hello World                                              | 1秒后页面显示“success” | 是       | Pass     |
| 共享模块         | 位于ArktsSendableModule.ets          | 点击MainThread print count；<br />点击Taskpool print count；<br />点击MainThread increase count<br />点击Taskpool increase count | 1秒后页面显示“success” | 是       | Pass     |
| Sendable对象冻结 | 位于SendableFreeze.ets               | 点击Sendable freezeObj Test                                  | 1秒后页面显示“success” | 是       | Pass     |