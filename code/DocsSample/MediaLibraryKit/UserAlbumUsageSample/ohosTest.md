# 用户相册使用示例

## 用例表

| 测试功能       | 预置条件  | 输入                 | 预期输出                     | 是否自动 | 测试结果 |
|------------|-------| -------------------- | ---------------------------- | -------- | -------- |
| 将媒体添加到用户相册 |  1. 创建用户相册“test”<br>2. 用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。  | 1. 启动指定的Ability。<br>2. 等待 5 秒                     | 测试成功运行                 | 是       | Pass     |
| 从用户相册获取媒体  |   1. 创建用户相册“test”并将图片添加到其中<br>2. 用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。   | 1. 启动指定的Ability。<br>2. 等待 5 秒          | 测试成功运行                 | 是       | Pass     |
| 获取用户相册     |    1. 创建用户相册“test”<br>2. 用户给应用授权ohos.permission.READ_IMAGEVIDEO  | 1. 启动指定的Ability。<br>2. 等待 5 秒         | 测试成功运行                 | 是       | Pass     |
| 从用户相册中移除媒体 |  1. 创建用户相册“test”并将图片添加到其中<br>2. 用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。    | 1. 启动指定的Ability。<br>2. 等待 5 秒         | 测试成功运行                 | 是       | Pass     |
| 重命名用户相册    |    1. 创建用户相册“test”<br>2. 用户给应用授权ohos.permission.READ_IMAGEVIDEO<br>ohos.permission.WRITE_IMAGEVIDEO。  |1. 启动指定的Ability。<br>2. 等待 5 秒         | 测试成功运行                 | 是       | Pass     |