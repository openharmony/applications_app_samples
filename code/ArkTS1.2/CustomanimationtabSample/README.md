# 自定义动效tab实现案例

### 介绍

本示例介绍使用List、Text等组件，以及animateTo等接口实现自定义Tab效果。

### 效果预览

效果如下所示：

| 主界面                                                         |
|-------------------------------------------------------------|
| ![Alt text](entry/src/main/resources/base/media/tbas.png) |

使用说明

1. 在主界面，左右滑动页签条。
    * 向左右滑动，背景条随之滚动。
2.  在主界面，左右滑动内容区域。
    * 向左右滑动，背景条随之滚动。
3.  在主界面，点击蓝色按钮"修改背景条颜色"。
    * 背景条颜色进行切换。


### 工程目录

```
entry/src/main/ets/
|---pages
|   |---SkeletonLayout.ets                     // 内容区域组件定义
|   |---index.ets                              // 首页
```

### 具体实现

* 选中页签，字体放大加粗且后面有背景条，起到强调作用。
* 手势触摸tab内容滑动，背景条跟随手势一起滑动。用户手指在屏幕上横向滑动Swiper内容区域，Swiper组件检测到滑动手势，触发onChang回调获取最新下标根据下标开始页面切换动画，并同步页签条内容区域下标。
* 点击页签，可以进行页签切换。用户手指在屏幕上点击页签条内容区域，onClick回调检测到点击操作，获取最新下标根据下标开始页面切换动画并同步更新Swiper组件下标。
* 滑动页签条，背景条也会随之一起滑动，然后滑动tab内容，页签条会滑动到原处，使背景条处于可视范围内，之后背景条开始跟随手势滑动。
通过Scroll组件的onDidScroll回调实时获取滚动偏移量，将xOffset反向赋值给背景条偏移量实现视觉同步。

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
echo code/ArkTS1.2/CustomanimationtabSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull
```