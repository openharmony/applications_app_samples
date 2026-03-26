# 显示图片（Image）

### 介绍

本示例为开发指南中图片组件开发章节示例代码的完整工程。该工程展示了如何在应用底层创建图片组件，加载并展示多种来源的图像资源，同时实现多样化的图像调整与显示效果，帮助开发者快速掌握高性能图片展示功能的实现方法。
本工程配套的开发指南文档，详细描述了相关的开发流程与核心代码，可查阅如下链接：[显示图片 (Image)](arkts-graphics-display.md)。

### 效果图预览

![imageCapiExample](entry/src/main/ets/common/imageCapiExample.png)

### 使用说明

1.  启动应用，点击界面上的 **"Show Native UI"** 按钮，配置好的图片会立即显示在应用界面中。
2.  界面将以垂直布局依次展示三张图片，从上到下按预设顺序排列，呈现清晰的上下堆叠效果。
3.  点击 **"Hide Native UI"** 按钮，界面上展示的图片会随之隐藏，实现 Native UI 组件的动态控制。
  
### 工程目录
```
.
|—— cpp
|    |—— types
|    |      |—— libentry
|    |      |       |—— index.d.ts       // 提供Native和ArkTS侧的桥接方法
|    |—— napi_init.cpp                   // NAPI初始化，与index.d.ts对应的桥接方法
|    |—— NativeEntry.h                   // Native入口定义
|    |—— NativeEntry.cpp                 // Native入口实现
|    |—— ImageExample.h                  // 图片示例定义
|    |—— ImageExample.cpp                // 图片示例实现
|    |—— CMakeLists.txt                  // CMake配置
|
|—— ets
|    |—— pages
|         |—— Index.ets                  // 应用启动页，加载承载Native的容器
|
|—— resources
|    |—— rawfile
|         |—— startIcon.png              // 图片资源文件
```
### 具体实现
以下示例展示了如何创建一个包含多种图片属性的完整UI界面
#### 在ArkTS页面上声明占位组件
在ArkTS页面上声明用于Native页面挂载的占位组件，并在页面创建时通知Native侧创建图片界面，[源码参考](entry/src/main/ets/pages/Index.ets)。
#### 提供NAPI桥接方法
1、声明Native模块的ArkTS接口，[源码参考](entry/src/main/cpp/types/libentry/Index.d.ts)。

2、在NAPI层实现与Native侧的桥接，使ArkTS层能够调用Native代码创建和管理图片组件，[源码参考](entry/src/main/cpp/types/libentry/napi_init.cpp)。
#### 实现Native入口
实现Native模块的入口函数，处理来自ArkTS侧的NodeContent和节点操作请求，包括创建图片界面和销毁界面的逻辑，[源码参考](entry/src/main/cpp/types/libentry/NativeEntry.cpp)，[头文件参考](entry/src/main/cpp/types/libentry/NativeEntry.h)。
#### 显示并设置图片
实现Image组件的具体功能，创建包含多个Image组件的示例界面，演示图片源设置、缩放类型、插值效果、填充颜色、占位图等属性的配置方法，[源码参考](entry/src/main/cpp/types/libentry/ImageExample.cpp)，[头文件参考](entry/src/main/cpp/types/libentry/ImageExample.h)。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.  本示例仅支持标准系统上运行。
2.  本示例支持API版本 **API Version 12 Beta5**，SDK版本号：**OpenHarmony SDK Ohos_sdk_public 5.0.0.60**。
3.  本示例需要使用DevEco Studio **5.0.3.700 Beta5** 及以上版本才可编译运行。
   
### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/ArkTS-Sta/ImageCAPIGuide > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```