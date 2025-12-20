# 资源使用示例

## 用例表

| 测试功能         | 预置条件  | 输入                 | 预期输出                     | 是否自动 | 测试结果 |
| ---------------- |-------| -------------------- | ---------------------------- | -------- | -------- |
| 获取媒体资源         |用户给应用授权ohos.permission.READ_IMAGEVIDEO| 1.启动指定的Ability。<br>2.等待 5 秒。 | 测试成功运行                 | 是       | Pass     |
| 获取媒体缩略图         |用户给应用授权ohos.permission.READ_IMAGEVIDEO| 1.启动指定的Ability。<br>2.等待 5 秒。 | 测试成功运行                 | 是       | Pass     |
| 将媒体移动到回收站         | 用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。| 1.启动指定的Ability。<br>2.等待 5 秒。| 测试成功运行    | 是       | Pass     |
| 重命名媒体         |  用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。| 1.启动指定的Ability。<br>2.等待 5 秒。| 测试成功运行 | 是       | Pass     |