# 分布式软总线会话

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 拉起应用 | 设备正常运行 | | 成功拉起应用，显示主界面 | 是 | Pass |
| 页面标题显示 | 成功拉起应用 | | 页面显示"Distributed SoftBus Conversation Test"标题 | 是 | Pass |
| 获取可信设备列表 | 成功拉起应用，已授权分布式权限 | 点击"Get Trusted Devices"按钮 | 调用conversation.getTrustedDevices()，不出现异常 | 是 | Pass |
| 注册会话监听器 | 成功拉起应用，已授权分布式权限 | 点击"Register Listener"按钮 | 调用conversation.registerConversationListener()，不出现异常 | 是 | Pass |
| 注销会话监听器 | 成功拉起应用，已注册监听器 | 点击"Unregister Listener"按钮 | 调用conversation.unregisterConversationListener()，不出现异常 | 是 | Pass |
| 发送消息 | 成功拉起应用，已授权分布式权限 | 点击"Send Message"按钮 | 调用conversation.postConversationData()，不出现异常 | 是 | Pass |
