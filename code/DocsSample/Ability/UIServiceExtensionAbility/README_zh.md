# 使用通过UIServiceExtensionAbility实现的系统悬浮窗

### 介绍

UIServiceExtensionAbility扩展能力是OpenHarmony中用于提供用户界面服务的扩展能力。系统应用可以通过该扩展能力实现特定的UI服务功能，并将其开放给其它应用调用。

1.[使用通过UIServiceExtensionAbility实现的系统悬浮窗](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/uiserviceextension.md)

### 效果预览
 不涉及。
### 使用说明

1. 通过UIExtensionContext调用startUIServiceExtensionAbility()方法启动UIServiceExtensionAbility。
2. 通过UIAbilityContext、UIExtensionContext调用connectUIServiceExtensionAbility()方法连接UIServiceExtensionAbility。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability

 │   │   ├── pages
 │   │       ├── Index.ets                   // 首页
 │   │       ├── Connect.ets                 //客户端连接服务
 │   │       ├── Start.ets                   // 启动
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```

### 具体实现

1.启动UIServiceExtensionAbility组件

应用通过startUIServiceExtensionAbility()方法启动一个UIServiceExtensionAbility组件。UIServiceExtensionAbility组件启动后，其生命周期独立于客户端，即使客户端已经销毁，该后台服务仍可继续运行，窗口创建失败或销毁后该服务会被销毁。

2.客户端连接服务端

客户端通过connectUIServiceExtensionAbility()连接服务端，获取并保存UIServiceProxy对象。通过该proxy对象的sendData()方法发送数据给服务端。服务端通过UIServiceExtensionAbility类onData()（系统接口）方法接收客户端数据。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持2in1设备。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/UIServiceExtensionAbility > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
