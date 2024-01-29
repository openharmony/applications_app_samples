| 用例名称         | 预置条件 	              | 用例测试功能               | 输入                      | 预期输出                                       | 是否自动 | 测试结果 |
|------------------| ---------------- |---------------------------|----------------------------|-----------------------------------------------| -------- | -------- |
| VPN_sample_test001 | 位于主页 | 界面UI展示 | 打开VPNSample。| 展示启用VPN和停用VPN的按钮，以及Toy VPN标题。| 是 | Pass |
| VPN_sample_test002 | 位于主页 | 选择启用VPN | 打开VPNSample，点击启用VPN按钮。| 1.正常跳转到启动VPN页面。<br/>2.正常显示VPN配置，创建对象、隧道保护以及启动vpn按钮正常显示和可用。| 否 | Pass |
| VPN_sample_test003 | 位于启动VPN界面 | 创建VPN隧道 | 打开VPNSample，点击启用VPN按钮，点击创建对象按钮。| 和已经配置IP地址和端口的VpnServer发起Tcp建联，返回隧道的Fd。| 否 | Pass |
| VPN_sample_test004 | 位于启动VPN界面 | 开启隧道保护 | 打开VPNSample，点击启用VPN按钮，点击隧道保护按钮。| 提示开启隧道保护成功。| 否 | Pass |
| VPN_sample_test005 | 位于启动VPN界面 | 启动VPN连接 | 打开VPNSample，点击启用VPN按钮，点击启动vpn按钮。| 提示通过隧道进行VPN连接。| 否 | Pass |
| VPN_sample_test006 | 位于主页 | 选择停用VPN | 打开VPNSample，点击停用VPN按钮。| 1.正常跳转到关闭vpn页面。<br/>2.正常显示关闭vpn按钮且按钮可用。| 否 | Pass |
| VPN_sample_test007 | 位于停用VPN界面 | 选择关闭VPN | 打开VPNSample，点击停用VPN按钮，点击关闭vpn按钮。| 1.正常跳转到关闭vpn页面。<br/>2.提示关闭VPN隧道和连接。| 否 | Pass |
