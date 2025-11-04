# 声明式UI描述

## 介绍

ArkTS以声明方式组合和扩展组件来描述应用程序的UI，同时还提供了基本的属性、事件和子组件配置方法，帮助开发者实现应用交互逻辑

本示例为[声明式UI描述](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-declarative-ui-description.md)的配套示例工程。

本示例展示了声明式UI描述的基本步骤及开发过程中需要注意的事项。

## 使用说明
1. 在智能穿戴设备上安装编译生成的hap包，并打开应用。
2. 阅读具体源码结合文档来理解声明式UI描述

## 工程目录

```
entry/src/main/ets/
└─── pages
    └── Index.ets(声明式UI描述)
```

## 具体实现

1. 使用无参或有参方式创建组件，链式调用.属性()配置样式或行为，例如 Text('Hello').fontSize(20)。

2. 在容器组件中添加子组件，通过.on事件()配置交互逻辑，例如 Button('Click').onClick(() => {...})。

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API20版本SDK，版本号：6.0.0.36;

3. 本示例已支持使用DevEco Studio 6.0.0 Release (构建版本：6.0.0.858，构建 2025年9月24日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/DeclarativeUIDescription > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```