# 背景模糊效果的自定义TabBar实现案例

### 介绍

在一些主页的场景中，为了实现更好的视觉体验，会给TabBar加上透明的背景模糊效果。本示例主要讲解如何使用系统提供的背景设置的能力，实现背景模糊的效果；

### 效果预览

效果如下所示：

|背景模糊效果的自定义TabBar实现案例|
|--------------------------------|
|![Alt text](entry/src/main/resources/base/media/background_blur.gif)|

使用说明

在一些主页的场景中，为了实现更好的视觉体验，会给TabBar加上透明的背景模糊效果。本示例主要讲解如何使用系统提供的背景设置的能力，实现背景模糊的效果。

### 工程目录

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets
|---model
|   |---backgroundblur
|   |   |---TabInfo.ets
|---pages
|   |---backgroundblur
|   |   |---CustomTabsComponent.ets
|   |   |---TabsSample.ets
|   |---Index.ets
```

### 具体实现

* 背景模糊，源码参考：[CustomTabsComponent.ets](entry/src/main/ets/pages/CustomTabsComponent.ets)

### 相关权限

无

### 依赖

无

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：Phone;
2. 本示例为Stage模型，支持API20版本SDK，SDK版本号(API Version 20),镜像版本号(6.0.0.31)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0.6)版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/ArkTS1.2/BackgroundblurSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull
```