# 使用场景

### 介绍
本示例通过使用[剪贴板指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/basic-services/pasteboard)中NDK场景的开发示例，展示在工程中，帮助开发者更好地理解剪贴板模块代码合理使用。该工程中展示的代码详细描述可查如下链接：

1. [使用剪贴板进行复制粘贴 (C/C++)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/pasteboard/native-use-pasteboard.md)。

2. [使用剪贴板进行延迟复制粘贴](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/pasteboard/pasteboard-time-lapse-copy-and-paste.md)。

### 工程目录

```
entry/src/main
 │── cpp
 │   ├── types
 │       ├── libentry
 │           ├── Index.d.ts
 │           ├── oh-package.json5
 │   ├── CMakeLists.txt            // 添加动态链接库
 │   ├── napi_init.cpp             // 开发步骤示例代码
 │── ets
 │   ├── entryability
 │   ├── entrybackupability
 │   ├── pages
 │       ├── Index.ets
 ├── module.json5
 │   └── resources

```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568，Phone;

2. 本示例支持API20版本SDK，版本号：6.0.0.49;

3. 本示例需要使用DevEco Studio 5.1.1 Release（5.1.1.840）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/NodeAPI/NodeAPIClassicUseCases/NodeAPIApplicationScenario > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
