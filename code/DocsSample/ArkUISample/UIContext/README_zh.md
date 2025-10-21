# 使用UI上下文接口操作界面（UIContext）指南文档示例

### 介绍

本文主要介绍了多UI实例涉及的概念，以及使用UIContext的方法替换全局接口的原因，并提供了相应的替换方案。

基本概念
1.UI实例： UI实例是用于管理用户界面的对象，主要负责组件、布局、动画以及交互事件等UI功能的管理。每个窗口对象都会创建并管理一个UI实例。

2.UI上下文： UI上下文是指UI实例运行环境的抽象概念，UI功能在UI上下文中运行，其效果最终反映在相应的UI实例中。

3.全局接口： ArkUI提供的一系列全局接口，这些接口在调用时无需显式指定UI实例或组件。它们会根据调用发生时所在的UI上下文，自动作用于相应的UI实例。

UI上下文不明确

UI上下文不明确是指调用ArkUI全局接口时，调用点无法明确指认UI实例的问题。

当前的系统支持两种应用模型——FA模型和Stage模型。在FA模型中，每个UI实例拥有独立的ArkTS引擎，全局接口可以通过ArkTS引擎跟踪到对应的UI实例上，因此不存在UI上下文不明确的问题。

在Stage模型中，一个ArkTS引擎中可运行多个ArkUI实例。全局接口通过分析调用链中的上下文信息来确定当前UI上下文，异步接口和非UI接口可能导致UI上下文跟踪失败。

为了保证全局接口的相关功能正常，开发者应当使用UIContext的接口替换全局接口。

### 效果预览

| index.ets                 |      LocalStoragePage.ets                 |
|---------------------------|---------------------------|
| ![](pictures/image01.png) | ![](pictures/image02.png) |

### 使用说明

1. 在主界面，可以点击对应卡片，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---Common
|   |---ContextUtils.ets
|   |---UIContext.ets
|---entryability
|---pages
|   |---Index.ets       
|   |---LocalStoragePage.ets                     
entry/src/ohosTest/
|---ets
|   |---index.test.ets                      // 示例代码测试代码
|   |---LocalStoragePage.test.ets
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：Mate 70 Pro、开发板。

2.本示例为Stage模型，支持API18版本full-SDK，版本号：5.1.0.107，镜像版本号：OpenHarmony_5.1.0 Release。

3.本示例需要使用DevEco Studio 5.0.5 Release (Build Version: 5.0.13.200， built on May 13, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUIDocSample/ScrollableComponent > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````