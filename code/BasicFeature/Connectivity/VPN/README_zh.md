# VPN连接

### 介绍
本示例使用@ohos.net.vpn接口创建VPN 隧道，建立vpn网络，vpn隧道保护，销毁VPN网络等功能。
实现了VPN的进行服务器连接，发送数据的功能

### 效果预览
| 主页                             | vpn启动                              | vpn关闭                                     | 成功                                     |
| ------------------------------ | --------------------------------- | --------------------------------------- | --------------------------------------- |
| ![main.jpeg](sceenshots%2Fmain.jpeg) | ![start.jpeg](sceenshots%2Fstart.jpeg) | ![stop.jpeg](sceenshots%2Fstop.jpeg) |![success.jpeg](sceenshots%2Fsuccess.jpeg)|

使用说明：

1.搭建服务器环境，服务端配置
命令用于配置iptables防火墙的网络地址转换（NAT）规则
其中eth1:具备网络连通性的以太网端口标识
`iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o "eth1" -j MASQUERADE`

使用/server文件夹下的setserver.sh
`chmod +x setserver.sh`
`./setserver.sh`

2.运行服务器后会有创建tun成功提示

3.打开vpn应用。用户点击创建对象，隧道保护，启动vpn等按钮，vpn启动后尝试用别的hap包访问百度

4.访问成功后返回选在关闭vpn按钮，断开vpn连接

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

### 相关权限
网络权限: ohos.permission.INTERNET
VPN权限: ohos.permission.MANAGE_VPN

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，已适配API version 10版本SDK，版本号：4.0.10.10，镜像版本号: Openharmony 4.0.10.10。

3.本示例需要使用DevEco Studio 4.0 Beta2 (Build Version: 4.0.0.400 构建 2023年8月2日)及以上版本才可编译运行。

4.本示例在启动前需搭建服务端环境，成功启动相应服务端后再运行客户端，服务端脚本（server_python）需要在Python 3.8.5版本下运行（需与客户端处于同一局域网）。

5.该示例运行测试完成后，再次运行需要重新启动服务端和客户端。

6.本示例需要使用@ohos.net.vpn系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEcoStudio中替换，具体操作可参考 [替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/) 。

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