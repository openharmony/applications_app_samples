# AudioSnapshot 测试用例归档

## 用例表

| 测试功能    | 预置条件         | 输入             | 预期输出                  | 是否自动 | 测试结果 |
|---------|--------------|----------------|-----------------------|------|------|
| 拉起应用    | 设备正常运行      |               | 成功拉起应用，弹出麦克风权限申请   | 是    | Pass |
| 允许权限    | 设备正常运行      | 点击权限弹窗允许按钮 | 授权后成功进入首页          | 是    | Pass |
| 主页展示    | 设备正常运行      |               | 展示全局参数配置和四个Tab页   | 是    | Pass |
| 配置全局参数  | 位于主页        | 设置usage、采样率、声道、格式 | 参数配置成功             | 是    | Pass |
| 主页按钮点击  | 位于主页        | 点击"TS Stream"   | 跳转TS Stream页面       | 是    | Pass |
| 创建TS采集流 | 位于TS Stream | 点击"Create"     | 成功创建TS音频采集流        | 是    | Pass |
| 启动TS采集流 | 位于TS Stream | 点击"Start"      | TS采集流启动成功          | 是    | Pass |
| TS采集快照   | TS采集流运行中    | 点击"Cap.Snap"    | 成功打印采集流快照到文件      | 是    | Pass |
| 主页按钮点击  | 位于主页        | 点击"C Stream"    | 跳转C Stream页面         | 是    | Pass |
| 创建C采集流  | 位于C Stream  | 点击"Create"     | 成功创建C音频采集流        | 是    | Pass |
| 启动C采集流  | 位于C Stream  | 点击"Start"      | C采集流启动成功           | 是    | Pass |
| C采集快照    | C采集流运行中    | 点击"Cap.Snap"    | 成功通过OHAudio C API打印快照 | 是    | Pass |
| 创建TS播放流 | 位于TS Stream | 点击"Play"       | 成功创建并启动TS音频播放流    | 是    | Pass |
| TS播放快照   | TS播放流运行中    | 点击"Play.Snap"   | 成功打印播放流快照到文件      | 是    | Pass |
| 应用级快照TS | 位于主页        | 点击"TS App Snapshot" | 成功打印应用级快照（所有TS流） | 是    | Pass |
| 应用级快照C  | 位于主页        | 点击"C App Snapshot" | 成功打印应用级快照（所有C流）  | 是    | Pass |
| 全部快照    | 位于Snapshot页  | 点击"Capture All Snapshots" | 成功打印所有可用快照 | 是    | Pass |
| 返回主页    | 位于各子页面      | 点击返回          | 回到主页                | 是    | Pass |
