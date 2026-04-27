# ArkTS静态模式分布式协作示例

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 设备连接 | 1. 需在两台真机测试 <br/> 2. 两台设备登录同一华为账号 <br/> 3. 构建并安装测试hap | 点击"Connect"按钮 | 显示连接成功状态，sessionId有效 | 否 | Pass |
| 发送消息 | 1. 两台设备已连接 <br/> 2. 构建并安装测试hap | 点击"Send Message"按钮 | 远程设备收到消息 "Hello from peer" | 否 | Pass |
| 发送数据 | 1. 两台设备已连接 <br/> 2. 构建并安装测试hap | 点击"Send Data"按钮 | 远程设备收到数据 "Data from peer" | 否 | Pass |
| 断开连接 | 1. 两台设备已连接 <br/> 2. 构建并安装测试hap | 点击"Disconnect"按钮 | 连接状态变为断开 | 否 | Pass |
| 销毁会话 | 1. 会话已创建 <br/> 2. 构建并安装测试hap | 点击"Destroy Session"按钮 | 会话被销毁，sessionId重置为-1 | 否 | Pass |
| 无设备连接 | 1. 单台设备测试 <br/> 2. 构建并安装测试hap | 点击"Connect"按钮 | 显示 "No remote device found" | 否 | Pass |
