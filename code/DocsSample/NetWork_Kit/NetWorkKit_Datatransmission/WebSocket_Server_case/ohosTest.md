# 测试用例归档

## 用例表

| 测试功能      | 预置条件    | 输入 | 预期输出                                                     | 是否自动 | 测试结果 |
| --------- | ------- | ---- |----------------------------------------------------------|------|------|
| 启动服务、监听连接并发送消息 | 设备正常运行 |      | 显示“message send successfully”状态，表示WebSocket成功连接，并成功发送消息  | 是    | pass |
| 所有已连接的客户信息 | 设备正常运行 |      | 显示“client list 客户信息”状态，表示消息发送成功                          | 是    | pass |
| 关闭指定连接    | 设备正常运行 |      | 显示“close client connections success”状态，表示WebSocket连接断开成功 | 是    | pass |
| 停止服务      | 设备正常运行  |      | 显示“server stop service successfully”状态，表示WebSocket停止连接成功 | 是    | pass |
