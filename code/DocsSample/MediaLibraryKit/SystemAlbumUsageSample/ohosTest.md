# 系统相册使用示例

## 用例表

| 测试功能       | 预置条件  | 输入                 | 预期输出                     | 是否自动 | 测试结果 |
|------------|-------| -------------------- | ---------------------------- | -------- | -------- |
| 获取收藏对象 | 用户给应用授权ohos.permission.READ_IMAGEVIDEO      | 1. 启动指定的Ability。<br>2. 等待 5 秒                      | 测试成功运行                 | 是       | Pass     |
| 从收藏中获取媒体  |    1. 收藏一张图片<br>2. 用户给应用授权ohos.permission.READ_IMAGEVIDEO    | 1. 启动指定的Ability。<br>2. 等待 5 秒          | 测试成功运行                 | 是       | Pass     |
| 获取视频相册    | 用户给应用授权ohos.permission.READ_IMAGEVIDEO       | 1. 启动指定的Ability。<br>2. 等待 5 秒         | 测试成功运行                 | 是       | Pass     |
| 从视频相册中获取视频 | 用户给应用授权ohos.permission.READ_IMAGEVIDEO    | 1. 启动指定的Ability。<br>2. 等待 5 秒          | 测试成功运行                 | 是       | Pass     |