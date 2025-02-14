# PracticalCases 测试用例归档

## 用例表

| 测试功能                         | 预置条件                              | 输入                                                         | 预期输出               | 是否自动 | 测试结果 |
| -------------------------------- | ------------------------------------- | ------------------------------------------------------------ | ---------------------- | -------- | -------- |
| 拉起应用                         | 设备正常运行                          |                                                              | 成功拉起应用           | 是       | Pass     |
| 使用TaskPool进行频繁数据库操作   | 位于UsingTaskPool.ets                 | 点击Hello World                                              | 1秒后页面显示“success” | 是       | Pass     |
| 使用Sendable进行大容量数据库操作 | 位于UsingSendable.ets                 | 点击Hello World                                              | 1秒后页面显示“success” | 是       | Pass     |
| 业务模块并发加载场景             | 位于ConcurrentLoadingModulesGuide.ets | 点击calculate add,show history,countdown                     | 1秒后页面显示“success” | 是       | Pass     |
| 全局配置项功能场景               | 位于GlobalConfigurationGuide.ets      | 点击change name,task                                         | 1秒后页面显示“success” | 是       | Pass     |
| ArkUI数据更新场景                | 位于MakeobservedSendable.ets          | 滑动屏幕                                                     | 瀑布流形式加载信息     | 是       | Pass     |
| ArkUI瀑布流渲染场景              | 位于WaterfallRendering.ets            | 点击wifi on,download,在输入框输入信息,点击login显示信息,点击not login清除信息 | 输入信息显示上方       | 是       | Pass     |