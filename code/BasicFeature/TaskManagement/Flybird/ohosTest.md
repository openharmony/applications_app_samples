# ScreenDetector 测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|拉起应用|	设备正常运行|		|成功拉起应用|Pass|
|验证input输入  |              |在input输入flybird  |本文框内显示flybird |Pass|
|连接服务器  |              |点击Connect service  |显示成功连接 |Pass|
|设置提醒，游戏进程在收到闹铃通知时不被拉起 |          |点击set game alarm | |Pass|
|设置日历，游戏进程在收到日历通知时不被拉起 |          |点击set game calendar | |Pass|
|进入游戏，选择关卡，开始游戏 |已经连接服务器 |点击start game, 点击关卡，小鸟降落后返回 |成功进入关卡选择页面，进入游戏，正确返回 |Pass|

本示例使用了ServiceExtensionAbility，需要在签名证书UnsignedReleasedProfileTemplate.json中配置“app-privilege-capabilities”:["AllowAppUsePrivilegeExtension"]，否则安装失败。具体操作指南可参考[应用特权配置指南](https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md/#https://gitee.com/openharmony/vendor_hihope/tree/master/rk3568/preinstall-config))。