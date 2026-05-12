# 缓存下载测试用例归档

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 拉起应用 | 设备正常运行 | 无 | 成功拉起应用，显示首页四个功能入口 | 是 | Pass |
| 进入RetryOptions页面 | 位于首页 | 点击RetryOptions Demo按钮 | 进入重试配置页面，显示URL输入框、重试次数滑块、下载按钮 | 是 | Pass |
| RetryOptions参数调整 | 位于RetryOptions页面 | 调整maxRetryCount滑块 | 滑块值在0-10范围内变化，显示当前值 | 是 | Pass |
| RetryOptions下载启动 | 位于RetryOptions页面，已输入URL | 点击Start Download按钮 | 开始下载任务，状态显示下载进度 | 是 | Pass |
| RetryOptions取消下载 | 下载任务进行中 | 点击Cancel Download按钮 | 取消下载任务，状态显示"下载取消" | 是 | Pass |
| 进入TimeoutOptions页面 | 位于首页 | 点击TimeoutOptions Demo按钮 | 进入超时配置页面，显示URL输入框、超时参数滑块 | 是 | Pass |
| TimeoutOptions参数调整 | 位于TimeoutOptions页面 | 调整networkCheckTimeout和httpTotalTimeout滑块 | 滑块值在范围内变化，显示当前值 | 是 | Pass |
| TimeoutOptions下载启动 | 位于TimeoutOptions页面，已输入URL | 点击Start Download按钮 | 开始下载任务，状态显示下载进度 | 是 | Pass |
| TimeoutOptions取消下载 | 下载任务进行中 | 点击Cancel Download按钮 | 取消下载任务，状态显示"下载取消" | 是 | Pass |
| 进入GlobalRetryOptions页面 | 位于首页 | 点击setGlobalRetryOptions Demo按钮 | 进入全局重试配置页面，显示参数滑块 | 是 | Pass |
| 设置全局重试配置 | 位于GlobalRetryOptions页面 | 点击Set Global Retry Options按钮 | 全局配置设置成功，显示当前配置状态 | 是 | Pass |
| 全局重试配置下载测试 | 已设置全局重试配置 | 点击Start Test Download按钮 | 开始测试下载，使用全局配置 | 是 | Pass |
| 进入GlobalTimeoutOptions页面 | 位于首页 | 点击setGlobalTimeoutOptions Demo按钮 | 进入全局超时配置页面，显示参数滑块 | 是 | Pass |
| 设置全局超时配置 | 位于GlobalTimeoutOptions页面 | 点击Set Global Timeout Options按钮 | 全局配置设置成功，显示当前配置状态 | 是 | Pass |
| 全局超时配置下载测试 | 已设置全局超时配置 | 点击Start Test Download按钮 | 开始测试下载，使用全局配置 | 是 | Pass |

## 测试环境

- 设备类型：标准系统设备
- API版本：API 26
- SDK版本：API Version 26
- DevEco Studio版本：5.0.5 Release及以上
- 网络状态：全程联网