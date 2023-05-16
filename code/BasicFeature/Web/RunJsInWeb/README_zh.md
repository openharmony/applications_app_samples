# JS注入与执行

### 介绍

本示例基于H5游戏，通过arkui的button实现对游戏实现基本控制，展示webview的JS注入与执行能力，及native应用与H5的通信能力。

### 效果预览

![](screenshots/device/main.jpg)

使用说明

1.设备连接热点，可访问互联网。

2.打开应用，通过界面中按钮进行游戏控制。

### 工程目录
```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ts                    // 弹窗组件
|---model
|   |---Logger.ts                      // 日志工具
|---pages
|   |---Index.ets                      // 首页
```

### 具体实现

本例的H5游戏页面，由https://yangyunhe369.github.io/h5-game-blockBreaker/ 提供

### 相关概念

NA

### 相关权限

网络访问权限: ohos.permission.INTERNET

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100, built on November 3, 2022)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Telephony/RunJsInWeb/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```