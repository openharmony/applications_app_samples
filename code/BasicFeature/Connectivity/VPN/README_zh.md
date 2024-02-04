# VPN连接

### 介绍
本示例使用@ohos.net.vpn接口创建VPN 隧道，建立vpn网络，vpn隧道保护，销毁VPN网络以及使用@ohos.net.vpnExtension接口创建三方vpn等功能。
实现了VPN的进行服务器连接，发送数据的功能

### 效果预览
| 主页                             | vpn启动                              | vpn关闭                                     | 
| ------------------------------ | --------------------------------- | --------------------------------------- |
| ![main.jpeg](sceenshots%2Fmain.jpeg) | ![start.jpeg](sceenshots%2Fstart.jpeg) | ![stop.jpeg](sceenshots%2Fstop.jpeg) |

 使用说明
1. 进入应用前请先安装[VPNFoundation](./lib/VPNFoundation-1.0.0.hap)。
2. 进入应用后，主界面有启用VPN和停用VPN的选项。分别对应开启和关闭VPN功能。
3. 在主界面，可以点击启用VPN来创建VPN连接。
4. 在VPN启动界面，可以配置VPN服务器IP地址/隧道IP地址/使用VPN的应用程序。
5. 在VPN启动界面，点击创建对象可以创建VPN隧道，点击隧道保护可以开启隧道保护，点击启动VPN可以进行网络连接。
6. 在主界面，可以点击停用VPN来断开和关闭VPN连接。

7. 以上演示系统vpn，如果使用三方vpn，点击启动vpnExt按钮，弹窗提示vpn使用许可，同意后三方vpn启动并自动连接，尝试用浏览器等hap包访问百度

| 三方vpn弹窗                             |
| ------------------------------ |
| ![vpnextension.jpeg](sceenshots%2Fvpnextension.jpeg)|

8 .访问成功后返回主页面，点击关闭vpnExt按钮，断开三方vpn连接

### 工程目录

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ts            // 项目入口，请求相关权限
|---pages
|   |---Index.ets                  // 首页
|   |---StartVpn.ets               // 打开vpn
|   |---StopVpn.ets                // 关闭vpn
|---model
|   |---Logger.ets                 // 日志
|---serviceextability
|   |---MyVpnExtAbility.ts         // 三方vpn能力

```

### 具体实现

创建VPN隧道，建立VPN网络，VPN隧道保护，销毁VPN网络，接口封装在StartVpn和StopVpn，源码参考：StartVpn.ets和StopVpn.ets。

    * 创建VPN隧道：调用StartVpn.CreateTunnel()来创建VPN隧道；
    * 建立VPN网络：调用StartVpn.SetupVpn()来建立VPN网络；
    * 销毁VPN网络：调用StopVpn.Destroy()来销毁VPN网络;
    * VPN隧道保护：调用StartVpn.Protect()来开启VPN隧道保护;

### 相关权限
允许系统应用获取网络权限: ohos.permission.INTERNET，允许系统应用获取VPN权限: ohos.permission.MANAGE_VPN。

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API11版本SDK，SDK版本号(API Version 4.1 Beta1),镜像版本号(4.1 Beta1)

3.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

4.本示例在启动前需搭建服务端环境，成功启动相应服务端后再运行客户端，服务端脚本（server_python）需要在Python 3.8.5版本下运行（需与客户端处于同一局域网）。

5.该示例运行测试完成后，再次运行需要重新启动服务端和客户端。

6.本示例使用了system_basic级别的权限（相关权限级别请查看[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md) ），需要手动配置高级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/) ) 。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Connectivity/VPN/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
