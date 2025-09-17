# 自定义视图实现Tab效果

### 介绍

本示例介绍使用Text、List等组件，添加点击、动画等事件 onClick animateTo 自定义视图实现类似Tab效果。；

### 效果预览

效果如下所示：

![main.jpg](entry/src/main/resources/base/media/main.jpg)

使用说明

1. 自定义视图实现Tab效果
    * 点击页签进行切换，选中态页签字体放大加粗，颜色由灰变黑，起到强调作用。
    * 底部颜色条横线位移到当前选中页签下方，内容区翻页到当前选中页签对应区域。

### 工程目录

```
entry/src/main/ets/
|---pages
|   |---Index.ets
```

### 具体实现

* 自定义视图实现Tab效果案例，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)
    * 使用ForEach和List组件循环渲染构造Tabs。
    * List添加滑动手势来进行页面的切换，手势响应后，使用scrollToIndex方法来实现平滑的滑动到相应index。

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
echo code/ArkTS1.2/CustomviewSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull
```