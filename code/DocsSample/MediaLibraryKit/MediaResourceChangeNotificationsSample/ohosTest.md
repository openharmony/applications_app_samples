# 媒体资源更改通知示例

## 用例表

| 测试功能         | 预置条件   | 输入                 | 预期输出                     | 是否自动 | 测试结果 |
| ---------------- | -------- | -------------------- | ---------------------------- | -------- | -------- |
| 取消 URI 监听         | 用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。 | 1.启动指定的Ability。<br>2.等待 5 秒。| 测试成功运行                 | 是       | Pass     |
| 注册所有资产的监听器         |  用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。| 1.启动指定的Ability。<br>2.等待 5 秒。| 测试成功运行                 | 是       | Pass     |
| 注册相册的监听器         | 1. 创建用户相册“test”<br>2. 用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。 | 1.启动指定的Ability。<br>2.等待 5 秒。| 测试成功运行                 | 是       | Pass     |
| 注册照片资产的监听器         |  用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。|  1.启动指定的Ability。<br>2.等待 5 秒。| 测试成功运行                 | 是       | Pass     |