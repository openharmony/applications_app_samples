# VPN 应用

### 介绍

VPN 即虚拟专网（VPN-Virtual Private Network）在公用网络上建立专用网络的技术。整个 VPN 网络的任意两个节点之间的连接并没有传统专网所需的端到端的物理链路，而是架构在公用网络服务商所提供的网络平台（如 Internet）之上的逻辑网络，用户数据在逻辑链路中传输。本项目展示了一个管理的示例应用，它实现了通过按钮实现建立VPN 网络隧道、保护建立的 UDP 隧道以及建立一个 VPN 网络等功能，使用了[@ohos.net.vpn](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/reference/apis-network-kit/js-apis-net-connection.md)接口。

### 效果预览

| 程序启动                            | 创建隧道                                | 启动vpnExt                             | 关闭VPN                             |
| ----------------------------------- | --------------------------------------- | -------------------------------------- | ----------------------------------- |
| <img src="screenshots/Vpn_Index.jpg" width="300" /> | <img src="screenshots/Create_Tunnel.jpg" width="300" /> | <img src="screenshots/Start_VpnExt.jpg" width="300" /> | <img src="screenshots/Stop_Vpn.jpg" width="300" /> |

使用说明

1. 在设备上启动应用。

2. 在界面上输入 VPN 服务器 IP 地址、虚拟网卡 IP 地址和需要阻止的应用包名。

3. 点击 `CreateTunnel` 按钮以建立 UDP 隧道。

4. 点击 `Protect` 按钮以将隧道与虚拟网卡绑定。

5. 点击 `SetupVpn` 按钮配置 VPN 并启动 VPN 服务。

6. 点击 `Stop vpn` 按钮以停止 VPN 连接。

7. 点击 `Stop vpnExt` 按钮以停止 VPN 扩展能力。

   

### 工程目录

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets            // 请求相关权限
|---notification
|   |---NotificationContentUtil.ets			// 初始化通知内容，提供基本通知内容创建功能
|   |---NotificationManagementUtil.ets			// 管理通知，包括分类、统计、取消和设置角标
|   |---NotificationOperations.ets			// 操作通知，支持发布可点击跳转的通知
|   |---NotificationRequestUtil.ets			// 创建通知请求，支持基本和 WantAgent 类型的通知请求
|   |---NotificationUtil.ets			// 提供通知发布、取消等功能，管理通知状态
|   |---WantAgentUtil.ets			// 创建 WantAgent，用于启动能力或发送通用事件
|---pages
|   |---Index.ets                  // 首页
|   |---StartVpn.ets               // 打开vpn
|   |---StopVpn.ets                // 关闭vpn
|---model
|   |---Logger.ets                 // 日志
|   |---ShowToast.ets              // 输出气泡
|   |---component.ets              // 标题栏组件
|       |---CommonConstant.ets     // 字符串常量
|---serviceextability
|   |---MyVpnExtAbility.ts         // 三方vpn能力

entry/src/main/cpp/
|---types
|   |---libentry
|   |   |---index.d.ts             // C++ 导出接口
|---napi_init.cpp                  // 业务底层实现
```

### 具体实现

1. 创建 VPN 隧道

   - 创建 VPN 隧道的过程是通过 UDP 隧道与指定的 VPN 服务器建立连接。该过程是通过调用 `vpn_client.udpConnect()` 方法实现的，传入目标服务器的 IP 地址和端口号进行连接。成功连接后，可以使用该隧道进行数据传输。
     - 通过 `vpn_client.udpConnect()` 函数与指定的 VPN 服务器建立 UDP 隧道。
     - 如果连接成功，调用 `showToast()` 弹出成功提示，并记录日志。
     - 如果连接失败，弹出失败提示，并记录错误日志。

2. 保护 VPN 连接

   - VPN 连接需要通过保护措施来确保数据安全性。`VpnConnection.protect()` 方法用于为已建立的隧道创建保护，防止数据泄漏。
     - 使用 `VpnConnection.protect()` 方法为 VPN 隧道添加保护。
     - 如果保护成功，显示成功提示并记录日志。
     - 如果保护失败，显示失败提示，并记录错误信息。

3. 启动 VPN 连接

   - 启动 VPN 连接涉及创建一个 VPN 配置并启用连接。我们通过 `VpnConnection.create()` 创建配置，并通过 `vpn_client.startVpn()` 启动 VPN 服务。
     - 创建一个 `Config` 对象，配置包括虚拟网卡的 IP 地址、MTU 大小、DNS 地址等。
     - 调用 `VpnConnection.create()` 来建立 VPN 配置。
     - 调用 `vpn_client.startVpn()` 启动 VPN 服务。

4. 停止 VPN 连接

   - 停止 VPN 连接的实现通过 `vpn_client.stopVpn()` 停止当前的 VPN 隧道连接，并清理相关资源。
       - 使用 `vpn_client.stopVpn()` 停止 VPN 连接。
       - 调用 `VpnConnection.destroy()` 销毁 VPN 连接对象。
       - 销毁操作成功后，弹出成功提示；失败则弹出错误信息。

5. 扩展 VPN 功能

   - 通过 `vpnext.startVpnExtensionAbility()` 和 `vpnext.stopVpnExtensionAbility()` 方法，可以启动和停止 VPN 扩展能力，实现自定义的 VPN 功能。
       - 调用 `vpnext.startVpnExtensionAbility()` 启动自定义 VPN 扩展功能。
       - 启动成功后，显示提示并记录日志。
       - 启动失败时，显示错误信息并记录日志。

### 相关权限

[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)
[ohos.permission.MANAGE_VPN](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionmanage_vpn)
[ohos.permission.NOTIFICATION_CONTROLLER](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionnotification_controller)

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例为Stage模型，支持API14版本SDK，版本号：5.0.2。
3. 本示例需要使用DevEco Studio Release（5.0.5.306）及以上版本才可编译运行。
4. 本示例在启动前需搭建服务端环境，成功启动相应服务端后再运行客户端，服务端脚本（server/UDP_server.py）需要在Python 3.8.5版本下运行（需与客户端处于同一局域网,如连接同一热点）。
5. 该示例运行测试完成后，再次运行需要重新启动服务端和客户端。
6. 本示例使用了system_basic级别的权限（相关权限级别请查看[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md) ），需要手动配置高级别的权限签名(具体操作可查看[自动化签名方案](https://gitee.com/link?target=https%3A%2F%2Fdeveloper.harmonyos.com%2Fcn%2Fdocs%2Fdocumentation%2Fdoc-guides%2Fohos-auto-configuring-signature-information-0000001271659465) ) 。

### 下载

如需单独下载本工程，执行如下命令：

``` 
git init
git config core.sparsecheckout true
echo code/DocsSample/NetWork_Kit/NetWorkKit_NetManager/VPNControl_Case/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```