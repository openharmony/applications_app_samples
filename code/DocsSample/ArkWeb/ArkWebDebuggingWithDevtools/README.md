# 使用DevTools工具调试前端页面

### 介绍

1. Web组件支持使用DevTools工具调试前端页面。DevTools是Web前端开发调试工具，支持在电脑上调试移动设备前端页面。开发者通过[setWebDebuggingAccess()](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkweb/arkts-apis-webview-WebviewController.md#setwebdebuggingaccess)接口开启Web组件前端页面调试能力，使用DevTools在电脑上调试移动前端网页，设备需为4.1.0及以上版本。
2. 本工程主要实现了对以下指南文档中[使用DevTools工具调试前端页面](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/web/web-debugging-with-devtools.md)示例代码片段的工程化，主要目标是帮助开发者如何使用Chrome浏览器调试Web页面。
3. 调试网页前，需要应用侧代码调用setWebDebuggingAccess()接口开启Web调试开关。
如果没有开启Web调试开关，则DevTools无法发现被调试的网页。

#### 效果预览
不涉及。

##### 使用说明

1. 在应用代码中开启Web调试开关，应用需要调用setWebDebuggingAccess20+接口，设置TCP Socket端口号并启用Web调试功能。
2. 开启调试功能需要在DevEco Studio应用工程hap模块的module.json5文件中增加如下权限。
3. 在Chrome浏览器上打开调试工具页面,端口需要配置成接口中指定的port端口。

### 工程目录

```
├── entry
│   └── src
│       └── main
│           ├── ets                                 // ArkTS代码区
│           │   ├── entryability
│           │   │   └── EntryAbility.ets            // 入口类
│           │   ├── entrybackupability
│           │   │   └── EntryBackupAbility.ets      // 备份恢复框架
│           │   └── pages
│           │       └── Index.ets                   // 主页
│           │       └── WebDebuggingWithWiFi.ets    // 无线调试
│           │       └── WebDebuggingWithUSB.ets     // USB连接调试
│           └── resources                           // 应用资源文件
```

### 具体实现
* 使用DevTools工具调试前端页面。
* 在应用代码中开启Web调试开关，应用需要调用[setWebDebuggingAccess20+](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkweb/arkts-apis-webview-WebviewController.md#setwebdebuggingaccess20)接口，设置TCP Socket端口号并启用Web调试功能。
* 无线调试直接通过接口设置端口号。
* USB连接调试。ArkWeb内核将启动一个domain socket的监听，以此实现DevTools对网页的调试功能。
  Chrome浏览器无法直接访问到设备上的domain socket， 因此需要将设备上的domain socket转发到电脑上。
* 在Chrome浏览器上打开调试工具页面，配置ip和端口号。
* Chrome的调试页面将显示待调试的网页。
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行。
2. 本示例支持API14版本SDK，SDK版本号(API Version 20 Release)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0Release)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/ArkWebDebuggingWithDevtools > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```