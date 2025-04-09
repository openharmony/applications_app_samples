# 测试用例归档

## 用例表

| 测试功能                 | 预置条件     | 输入                  | 预期输出                          | 是否自动 | 测试结果 |
| ------------------------ | ------------ | --------------------- | --------------------------------- | -------- | -------- |
| StartVPN按钮点击事件     | 设备正常运行 |                       | 进入StartVPN界面                  | 是       | pass     |
| CreateTunnel按钮点击事件 | 设备正常运行 | vpnServerIp           | 弹出Toast：“CreateTunnel Success” | 是       | pass     |
| Protect按钮点击事件      | 设备正常运行 | vpnServerIp           | 弹出Toast：“vpn Protect Success”  | 是       | pass     |
| SetupVpn 按钮点击事件    | 设备正常运行 | tunIp、blockedAppName | 弹出Toast：“vpn Protect Success”  | 是       | pass     |
| StartVpnExt 按钮点击事件 | 设备正常运行 | tunIp、blockedAppName | 弹出对话框                        | 是       | pass     |
| StopVpn按钮点击事件      | 设备正常运行 |                       | 进入StopVpn界面                   | 是       | pass     |
| StopVpn按钮点击事件      | 设备正常运行 |                       | 弹出Tosat：”Stop Success“         | 是       | pass     |
| StopVPN按钮点击事件      | 设备正常运行 |                       | 弹出Tosat：”Stop Success“         | 是       | pass     |

