# AppServiceExtensionAbility简介

### 介绍

[使用AppServiceExtensionAbility组件实现后台服务](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/app-service-extension-ability.md) 从 API version 20 开始支持的组件，旨在为应用程序提供后台服务。其它应用可以通过启动或连接该组件获取相应服务，界面的长期运行任务（例如数据监控、文件操作监听等）。

### 效果预览

不涉及。
### 使用说明

1. 应用在启动后展示首页，首页展示相关按钮，点击进入相应功能界面。
2. 点击对应按钮触发相关回调，并打印相关信息
3. 示例将被启动或被连接的AppServiceExtensionAbility组件称为服务端，将启动或连接AppServiceExtensionAbility组件的应用组件（当前仅支持UIAbility）称为客户端。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── myappserviceextability
 │   │       ├── MyAppServiceExtAbility.ets   
 │   │   ├── myappserviceextabilityfour
 │   │       ├── MyAppServiceExtAbility.ets            
 │   │   ├── myappserviceextabilitythree
 │   │       ├── MyAppServiceExtAbility.ets            
 │   │   ├── myappserviceextabilitytwo
 │   │       ├── MyAppServiceExtAbility.ets            
 │   │   ├── pages
 │   │       ├── ClientServerExt.ets                   // 客户端与服务端通信
 │   │       ├── ConnectAppServiceExt.ets                   // 连接一个后台服务
 │   │       ├── DisConnectAppServiceExt.ets                   // 使用disconnectAppServiceExtensionAbility()断开与后台服务的连接
 │   │       ├── Index.ets                   // 首页
 │   │       ├── StartAppServiceExt.ets                   // 启动一个后台服务
 │   │       ├── StopAppServiceExt.ets                   // 停止一个已启动的AppServiceExtensionAbility组件
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现

1. 在MyAppServiceExtAbility目录，右键选择“New > ArkTS File”，新建一个文件并命名为MyAppServiceExtAbility.ets。
2. 在应用中启动一个新的AppServiceExtensionAbility组件。
3. 在应用中停止一个已启动的AppServiceExtensionAbility组件。
4. 已启动的AppServiceExtensionAbility组件停止自身。
5. 使用connectAppServiceExtensionAbility()建立与后台服务的连接。
6. 使用disconnectAppServiceExtensionAbility()断开与后台服务的连接。
7. 客户端在onConnect()中获取到rpc.IRemoteObject对象后便可与服务端进行通信。

### 相关权限

应用集成AppServiceExtensionAbility组件需要申请ACL权限（ohos.permission.SUPPORT_APP_SERVICE_EXTENSION）。该ACL权限当前只对企业普通应用开放申请。

### 依赖

不涉及。

### 约束与限制

1.本示例AppServiceExtensionAbility组件当前仅支持2in1设备。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/AppServiceExtensionAbility > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
