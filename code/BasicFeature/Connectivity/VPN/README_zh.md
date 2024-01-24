# VPN连接

### 介绍
本示例主要展示了VPN连接相关功能，使用 [@ohos.net.vpn](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-net-vpn.md)接口，实现了包括创建VPN隧道，建立VPN网络，VPN隧道保护，销毁VPN网络。根据配置的VPN网络参数，实现了VPN服务器连接和发送数据的功能。

### 效果预览
| 主页                             | vpn启动                              | vpn关闭                                     | 
| ------------------------------ | --------------------------------- | --------------------------------------- |
| ![main.jpeg](sceenshots%2Fmain.jpeg) | ![start.jpeg](sceenshots%2Fstart.jpeg) | ![stop.jpeg](sceenshots%2Fstop.jpeg) |

 使用说明
1. 进入应用后，主界面有启用VPN和停用VPN的选项。分别对应开启和关闭VPN功能。
2. 在主界面，可以点击启用VPN来创建VPN连接。
3. 在VPN启动界面，可以配置VPN服务器IP地址/隧道IP地址/使用VPN的应用程序。
4. 在VPN启动界面，点击创建对象可以创建VPN隧道，点击隧道保护可以开启隧道保护，点击启动VPN可以进行网络连接。
5. 在主界面，可以点击停用VPN来断开和关闭VPN连接。

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

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)。

3.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

4.本示例在启动前需搭建服务端环境，成功启动相应服务端后再运行客户端，服务端脚本（server_python）需要在Python 3.8.5版本下运行（需与客户端处于同一局域网）。

5.该示例运行测试完成后，再次运行需要重新启动服务端和客户端。

6.本示例需要使用 [@ohos.net.vpn](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-net-vpn.md) 系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEcoStudio中替换，具体操作可参考 [替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/) 。

7.本示例使用了system_basic级别的权限（相关权限级别请查看[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md) ），需要手动配置高级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/) ) 。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Connectivity/VPN/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
