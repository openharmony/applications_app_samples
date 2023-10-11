# VPN连接

**介绍**
本示例使用@ohos.net.vpn接口创建VPN 隧道，建立vpn网络，vpn隧道保护，销毁VPN网络等功能。
实现了VPN的进行服务器连接，发送数据的功能

**预览效果:**
![main.jpeg](sceenshots%2Fmain.jpeg)
![start.jpeg](sceenshots%2Fstart.jpeg)
![stop.jpeg](sceenshots%2Fstop.jpeg)

**使用说明**

1.搭建服务器环境，服务端配置
方法一
`iptables -I FORWARD -j ACCEPT`
在iptables防火墙的FORWARD链中添加规则，允许网络数据包的转发。

`echo 1 > /proc/sys/net/ipv4/ip_forward`
启用IP转发

`iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eho1 -j MASQUERADE`
命令用于配置iptables防火墙的网络地址转换（NAT）规则

`sudo ./server`
创建服务器

方法二
可以使用/server文件夹下的setserver.sh

`chmod +x setup.sh`
`./setserver.sh`

2.运行服务器后会有创建tun成功提示

3.打开vpn应用。用户点击创建对象，隧道保护，启动vpn等按钮，vpn启动后尝试用别的hap包访问百度

4.访问成功后返回选在关闭vpn按钮，断开vpn连接

**工程目录**
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
**相关权限**
网络权限: ohos.permission.INTERNET
VPN权限: ohos.permission.MANAGE_VPN

**约束与限制**
1.本示例仅支持标准系统上运行。

2.本示例为Stage模型，已适配API version 10版本SDK，版本号：4.0.9.6，镜像版本号: Openharmony 4.0.9.6。

3.本示例需要使用DevEco Studio 3.1.1 Release (Build Version: 3.1.0.501, built on June 20, 2023)及以上版本进行编译。

4.本示例在启动前需搭建服务端环境，成功启动相应服务端后再运行客户端，服务端脚本（server_python）需要在Python 3.8.5版本下运行（需与客户端处于同一局域网）。

5.该示例运行测试完成后，再次运行需要重新启动服务端和客户端

**下载本工程**
如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Connectivity/VPN/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```