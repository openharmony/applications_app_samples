# 不规则网格布局容器

## 介绍

ArkUI开发框架在NDK接口提供了自定义UI组件的能力，开发者通过注册相关自定义回调事件接入ArkUI开发框架的布局渲染流程。本示例展示了如何创建不规则网格布局容器。示例创建了一个不规则网格布局容器，支持不同大小的网格单元，实现类似瀑布流的布局效果。

本示例为[构建自定义组件-实现不规则网格状自定义布局策略](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ndk-build-custom-components.md#实现不规则网格状自定义布局策略)的配套示例工程。

## 效果预览

| 预览                                                   |
| ------------------------------------------------------ |
| <img src="./screenshots/irregularGrid.jpg" width="300" /> |

## 使用说明
1. 安装编译生成的hap包，并打开应用。
2. 进入首页，可以看到不规则网格布局效果。
3. 网格项具有不同的大小（1x1、1x2、2x1、2x2等）。
4. 网格项自动寻找最矮列放置，形成瀑布流效果。
5. 每个网格项具有不同的颜色、圆角和边框。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets (获取导航页面)

entry/src/main/cpp/
├── types
│   └── libentry
│       └── Index.d.ts (函数对应的js映射)
├── ArkUIBaseNode.h
├── ArkUICustomContainerNode.h
├── ArkUIIrregularGridNode.h
├── ArkUICustomNode.h
├── ArkUINode.h
├── ArkUITextNode.h
├── CMakeLists.txt
├── napi_init.cpp
├── NativeEntry.cpp
├── NativeEntry.h
├── NativeModule.h
└── UITimer.h
```

## 具体实现

1. 按照[自定义布局容器](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ndk-build-custom-components.md#自定义布局容器)章节准备前置工程。
2. 创建自定义绘制组件封装对象。
3. 使用自定义绘制组件和自定义容器创建示例界面。
4. 修改CMakeList.txt，添加链接库。

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568。

2. 本示例支持API22版本SDK，版本号：6.0.2.54。

3. 本示例已支持使用DevEco Studio 5.1.1 Release（构建版本：5.1.1.840，构建日期：2025年10月18日）编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NativeType/CustomDrawSample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
