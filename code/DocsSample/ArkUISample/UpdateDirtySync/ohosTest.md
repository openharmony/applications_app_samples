# 同步刷新接口测试用例归档

## 用例表

根据提供的测试用例，以下是整理出的测试用例表格：

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---------|---------|------|---------|:-------:|:-------:|
| applySync接口使用规则 | 设备正常运行 | 点击按钮 | 方框尺寸先跳变再产生动画 | 是 | Pass |
| flushUpdates接口使用规则 | 设备正常运行 | 点击按钮 | 方框尺寸先跳变再产生动画 | 是 | Pass |
| flushUIUpdates接口使用规则 | 设备正常运行 | 点击按钮 | 打印一条日志 | 是 | Pass |
| applySync嵌套applySync | 设备正常运行 | 点击按钮 | 打印出警告信息UIUtils.applySync will be skipped when called within another UIUtils.applySync. The inner UIUtils.applySync will return undefined | 是 | Pass |
| applySync嵌套flushUpdates/flushUIUpdates | 设备正常运行 | 点击按钮 | 打印出对应警告信息UIUtils.flushUpdates will be skipped when called within UIUtils.applySync/UIUtils.flushUIUpdates will be skipped when called within UIUtils.applySync | 是 | Pass |
| 不允许在@Computed中调用同步刷新接口 | 设备正常运行 | 执行用例 | 运行时报错，错误信息为The function is not allowed to be called in @Computed | 是 | Pass |
| 不允许在@Computed中调用flushUpdates/flushUIUpdates | 设备正常运行 | 点击按钮 | 运行时报错，错误信息为The function is not allowed to be called in @Monitor | 是 | Pass |
| 动画场景 | 设备正常运行 | 点击图标 | 产生动画 | 是 | Pass |
| 路由场景 | 设备正常运行 | 点击图标 | 从PageOne到PageTwo无动画，从PageTwo到PageOne有动画 | 是 | Pass |